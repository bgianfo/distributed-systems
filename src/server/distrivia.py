#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
     Distrivia
    ~~~~~~~~~~~
    A webservice backend which implements a RESTFUL trivia game API.

    :copyright: (c) 2011 by Brian Gianforcaro, Steven Glazer, Sam Milton.
"""

from flask import Flask
from flask import json
from flask import request
from flask import session
from flask import g

import riak
import uuid

app = Flask(__name__)
app.config['DEBUG'] = True
app.config['SECRET_KEY'] = 'secret'

API_ERROR   = "err"
API_SUCCESS = "suc"
QUESTION_LIMIT = 20


#
# Utility functions
#

def isAuthed():
    """
    Read the request and automatically check if he auth
    token is valid and "logged-in".

    Return True if so, False if not.
    """
    token = request.form['authToken']
    loggedIn = g.db.bucket("users").get("logged_in")
    users = loggedIn.get_data()["users"]
    return token in users

#
# Before and after request handlers
#

@app.before_request
def beforeRequest():
    """ Connect to Riak before each request """
    client = riak.RiakClient()
    g.db = client

@app.after_request
def afterRequest(response):
    """ Closes Riak connection after each request """
    g.db = None
    return response

#
# Application routes
#

@app.route('/register/<user>', methods=["POST"])
def register(user):
    """
    Register a new user

    API_SUCCESS on success, API_ERROR on failure
    """

    users_bucket = g.db.bucket( "users" )

    # The user already exists, so they can't register this name
    if users_bucket.get( user ).exists():
        return API_ERROR

    # Awesome, let's register this bad boy
    else:
        newUser = users_bucket.new( user, data= { "uuid" : "" } )
        newUser.store()
        return API_SUCCESS

@app.route('/login/<userName>', methods=["POST"])
def login( userName ):
    """
    Attempt to authenticate a user, return a auth token on success.

    Note: The auth token will look something like:

     '7e43860a-55da-11e0-ae43-001f5bba6fae'

    otherwise return API_ERROR
    """

    users = g.db.bucket( "users" )
    user = users.get( userName )

    if user.exists():
        # Create a new auth token for this user
        # UUID's are pretty much guaranteed to be unique
        uniqueId = str(uuid.uuid1())
        user.set_data( { "uuid" : uniqueId } )
        user.store()

        loggedIn = users.get("logged_in")
        if loggedIn.exists():
            data = loggedIn.get_data()
            data["users"].append( uniqueId )
            loggedIn.set_data(data)
            loggedIn.store()
        else:
            ldata = { "users": [] }
            new = users.new("logged_in", data=ldata)
            new.store()
        return uniqueId
    else:
        return API_ERROR

@app.route('/game/new')
def newGame():
    """GET /game/new

    Create a new game"""
    return "NOT IMPLEMEMTED"

@app.route('/game/join')
def joinGame():
    """GET /game/join

    Join a currently open game if available,
    otherwise create a new one"""

    # Failure on authentication error
    if not isAuthed():
        return API_ERROR

    user  = request.form['user']
    if user == "":
        return API_ERROR

    # Initialize arguments, riak variables and buckets
    token = request.form['authToken']
    client = g.db
    gamesBucket = client.bucket("games")


    # Map function to inspect tables and grab non full games
    mapfn = """ function(iterm) {
                    var data = JSON.parse( item.values[0].data );
                    if ( data.users.length < 20 ) {
                        return [[item.key, data]];
                    }
                    return [];
                }
            """
    query = client.add("games")
    query.map( mapfn )

    for result in query.run():
        key, data  = result[0], result[1]

        # Add user to the game
        data["users"].append( token )
        # Add user to the leader board
        data["leaderboard"][user] = 0

        game = gamesBucket.get(key)
        game.set_data( data );
        game.store()
        return key

    return API_ERROR

@app.route('/game/<id>/next/<prevId>')
def nextQuestion(id,prevId):
    """GET /game/<id>/next

    Get the next question for this game ID"""

    # Failure on authentication error
    if not isAuthed():
        return API_ERROR

    gamesBucket = g.db.bucket( "games" )
    game = gamesBucket.get( id )

    # Failure on bogus game ID
    if game.empty():
        return API_ERROR
    else:
        # Get the list of questions for this game
        gameData = game.get_data();
        questions = gameData["questions"]

        nextQuestion = None
        if prevId == "0":
            nextQuestion = questions[0]
        else:
            qIndex = questions.index( prevId )

            # Failure on this game being over
            if qIndex == QUESTION_LIMIT:
                return API_ERROR
            # Fetch and construct the next question object
            nextQuestion = questions[qIndex+1]

        questionBucket = g.db.bucket( "questions" )
        question = questionBucket.get( nextQuestion );
        question["id"] = nextQuestion
        return str(question)



@app.route('/game/<id>/leaderboard')
def getLeaderBoard(id):
    """
    Get the leaderboard for this game ID

    Note: The leader board should be a simple JSON object.
    {
        <username> : <points>
        "user1"    : 1000
        "user2"    : 3000
        "user2"    : 5000
    }
    """
    # Failure on authentication error
    if not isAuthed():
        return API_ERROR

    gamesBucket = g.db.bucket( "games" )
    game = gamesBucket.get( id )

    # Failure on bogus game ID
    if game.empty():
        return API_ERROR
    else:
        # Get the list of questions for this game
        gameData = game.get_data();
        return str(gameData["leaderboard"])

# Run the webserver
if __name__ == '__main__':
    app.run(port=80)
