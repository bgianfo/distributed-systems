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

        print rv.data
        assert rv.data != self.err

    def test_join_failure(self):
        """ Make sure joining a game fails on bad token """
        rv = self.app.post('/game/join',
        data=dict( authToken = "crap", user="join" ),
        follow_redirects=True)
        assert rv.data == self.err


if __name__ == '__main__':
    unittest.main()
