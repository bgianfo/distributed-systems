#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
     Distrivia Tests
    ~~~~~~~~~~~~~~~~~
    Webservice unit tests for the trivia game API.

    :copyright: (c) 2011 by Brian Gianforcaro, Steven Glazer, Sam Milton.
"""

import distrivia
import unittest
import riak
from flask import json

class DistriviaTestCase(unittest.TestCase):

    def setUp(self):
        self.app = distrivia.app.test_client()
        self.err = distrivia.API_ERROR
        self.suc = distrivia.API_SUCCESS
        self.clearBucket("users")
        self.clearBucket("games")

    def tearDown(self):
        self.clearBucket("users")
        self.clearBucket("games")

    # Helper functions

    def clearBucket(self, bucketName):
        client = riak.RiakClient()
        bucket = client.bucket(bucketName)
        for key in bucket.get_keys():
            bucket.get(key).delete()

    def register(self, username):
        """Helper function to register a user"""
        return self.app.post('/register/'+username,
        follow_redirects=True)

    def login(self, username):
        """Helper function to login"""
        return self.app.post('/login/'+username,
        follow_redirects=True)

    # Test cases

    def test_register(self):
        """ Make sure registration works """
        # Registering should work the first time
        rv = self.register("brian")
        assert self.suc == rv.data
        # Registering again with the same name should fail
        rv = self.register("brian")
        assert self.err == rv.data

    def test_login(self):
        """ Make sure login works """
        self.register("brian")
        rv = self.login("brian")
        assert self.err != rv.data

    def test_join(self):
        """ Make sure joining a game works """

        rv = self.register("join")
        assert rv.data == self.suc

        rv = self.login("join")
        token = rv.data
        assert token != self.err

        rv = self.app.post('/game/join',
        data=dict( authToken = token, user="join" ),
        follow_redirects=True)

        assert rv.data != self.err

    def test_join_failure(self):
        """ Make sure joining a game fails on bad token """
        rv = self.app.post('/game/join',
        data=dict( authToken = "crap", user="join" ),
        follow_redirects=True)
        assert rv.data == self.err

    def test_initial_question(self):
        """ Make sure getting the initial question works """
        tuser= "testicle"
        self.app.post("/register/"+tuser)
        token = self.app.post("/login/"+tuser).data

        join = dict(authToken=token, user=tuser)
        gid = self.app.post("/game/join",data=join).data

        nextQ = dict(authToken=token)
        rv = self.app.post("/game/"+gid+"/next/0", data=nextQ)
        question = json.loads( rv.data )
        assert question["question"] != None
        assert question["answer"]   != None
        assert question["a"]  != None
        assert question["b"]  != None
        assert question["c"]  != None
        assert question["d"]  != None
        assert question["id"] != None


    def test_next_question(self):
        """ Make sure getting all questions after the initial one works"""
        tuser= "testicle"
        self.app.post("/register/"+tuser)
        token = self.app.post("/login/"+tuser).data

        join = dict(authToken=token, user=tuser)
        gid = self.app.post("/game/join",data=join).data

        nextQ = dict(authToken=token)
        rv = self.app.post("/game/"+gid+"/next/0", data=nextQ)
        question = json.loads( rv.data )
        assert question["question"] != None
        assert question["answer"]   != None
        assert question["a"]  != None
        assert question["b"]  != None
        assert question["c"]  != None
        assert question["d"]  != None
        assert question["id"] != None
        qid = question["id"]

        count = 0
        while count < 13: # self.app.QUESTION_LIMIT:
            rv = self.app.post("/game/"+gid+"/next/"+qid, data=nextQ)
            question = json.loads( rv.data )
            assert question["question"] != None
            assert question["answer"]   != None
            assert question["a"]  != None
            assert question["b"]  != None
            assert question["c"]  != None
            assert question["d"]  != None
            assert question["id"] != None
            qid = question["id"]
            count += 1

        rv = self.app.post("/game/"+gid+"/next/"+qid, data=nextQ)
        assert rv.data == self.err

    def test_answer_question(self):
        """ Make sure that answering questions works """

        def mkurl(gid,qid,ans):
            URI = "/game/"+gid+"/answer/"+qid+"/"+ans+"/3000"
            return URI

        tuser= "testicle"
        self.app.post("/register/"+tuser)
        token = self.app.post("/login/"+tuser).data

        join = dict(authToken=token, user=tuser)
        gid = self.app.post("/game/join",data=join).data

        nextQ = dict(authToken=token)
        rv = self.app.post("/game/"+gid+"/next/0", data=nextQ)
        question = json.loads( rv.data )
        assert question["question"] != None
        assert question["answer"]   != None
        assert question["a"]  != None
        assert question["b"]  != None
        assert question["c"]  != None
        assert question["d"]  != None
        assert question["id"] != None
        qid = question["id"]
        ans = question["answer"]

        URI = mkurl( gid, qid, ans )
        rv = self.app.post(URI, data=join)
        assert rv.data == "correct"

        # Get another question
        rv = self.app.post("/game/"+gid+"/next/"+qid, data=nextQ)
        question = json.loads( rv.data )

        # Fore a wrong answer
        answers = ["a","b","c","d"]
        answers.remove( question["answer"] )

        URI = mkurl( gid, question["id"], answers[0] )
        rv = self.app.post(URI, data=join)
        assert rv.data == "wrong"

    def test_answer_score(self):
        """ Make sure leaderboard is properly updated """

        def mkurl(gid,qid,ans):
            URI = "/game/"+gid+"/answer/"+qid+"/"+ans+"/3000"
            return URI

        tuser= "testicle"
        # Register & Login
        self.app.post("/register/"+tuser)
        token = self.app.post("/login/"+tuser).data

        # Join
        join = dict(authToken=token, user=tuser)
        gid = self.app.post("/game/join",data=join).data

        # Get first quesiton
        nextQ = dict(authToken=token)
        rv = self.app.post("/game/"+gid+"/next/0", data=nextQ)
        question = json.loads( rv.data )
        qid = question["id"]
        ans = question["answer"]

        # Force answer correctly
        URI = mkurl( gid, qid, ans )
        self.app.post(URI, data=join)

        # Check leaderboard
        rv = self.app.post( "/game/"+gid+"/leaderboard", data=nextQ )
        board = json.loads( rv.data )
        assert board["leaderboard"][tuser] != 0
        oldscore = board["leaderboard"][tuser]

        # Get another question
        rv = self.app.post("/game/"+gid+"/next/"+qid, data=nextQ)
        question = json.loads( rv.data )

        # Fore a wrong answer
        answers = ["a","b","c","d"]
        answers.remove( question["answer"] )
        URI = mkurl( gid, question["id"], answers[0] )
        self.app.post(URI, data=join)

        # Since we had a wrong answer, leaderboard should be unchanged
        rv = self.app.post( "/game/"+gid+"/leaderboard", data=nextQ )
        board = json.loads( rv.data )
        assert board["leaderboard"][tuser] == oldscore

    def test_leader_board(self):
        """ Make sure leaderboard initialization & update works """

        def mkurl(gid,qid,ans):
            URI = "/game/"+gid+"/answer/"+qid+"/"+ans+"/3000"
            return URI

        tuser= "testicle"
        # Register & Login
        self.app.post("/register/"+tuser)
        token = self.app.post("/login/"+tuser).data

        # Join
        join = dict(authToken=token, user=tuser)
        gid = self.app.post("/game/join",data=join).data

        # Check leaderboard
        nextQ = dict(authToken=token)
        rv = self.app.post( "/game/"+gid+"/leaderboard", data=nextQ )
        board = json.loads( rv.data )
        assert board["leaderboard"][tuser] == 0

        # Get first quesiton
        rv = self.app.post("/game/"+gid+"/next/0", data=nextQ)
        question = json.loads( rv.data )
        qid = question["id"]
        ans = question["answer"]

        # Force answer correctly
        URI = mkurl( gid, qid, ans )
        self.app.post(URI, data=join)

        # Check leaderboard
        rv = self.app.post( "/game/"+gid+"/leaderboard", data=nextQ )
        board = json.loads( rv.data )
        assert board["leaderboard"][tuser] != 0
        oldscore = board["leaderboard"][tuser]


if __name__ == '__main__':
    unittest.main()
