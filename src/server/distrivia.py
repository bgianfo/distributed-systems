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
import socket
import urllib2

app = Flask(__name__)
app.debug = True
app.config['DEBUG'] = True
app.config['SECRET_KEY'] = 'secret'


API_ERROR   = "err"
API_SUCCESS = "suc"
QUESTION_LIMIT = 20


if app.config['DEBUG']:

    from werkzeug import SharedDataMiddleware
    import os
    app.wsgi_app = SharedDataMiddleware(app.wsgi_app, {
      '/': os.path.abspath("../clients/web")
    })


#
# Utility functions
#

def getip():
    """ Return the internal IP of this machine """
    if app.debug:
        return "127.0.0.1"
    else:
        return socket.gethostbyname(socket.gethostname())

def gethost():
    """ Return the outward facing hostname on EC2, or just the localhost
        if we arn't no EC2
    """
    try:
        url = "http://169.254.169.254/latest/meta-data/public-hostname"
        hostname = urllib2.urlopen(url).read()
        return hostname
    except:
        return "127.0.0.1"

def isAuthed():
    """
    Read the request and automatically check if he auth
    token is valid and "logged-in".

    Return True if so, False if not.
    """
    token = request.form['authToken']
    loggedIn = g.db.bucket("users").get("logged_in")
    if loggedIn.exists():
        data = loggedIn.get_data()
        return (token in data["users"])
    else:
        return False


def initializeGame( user, passwd = None ):
    """ Create a new game """

    client = g.db
    quesBucket = client.bucket("questions")

    # Map function to inspect tables and grab non full games
    mapfn = """
    function(item) {
      return [item.key];
    }
    """

    reducefn = """
    function(values) {
      function r(){
        return (Math.round(Math.random())-0.5);
      }
      // Randomly sort the questions
      sorted = values.sort( r );
      // Pick off the first 20
      return sorted.slice(0,19)
    }
    """

    query = client.add("questions")
    query.map( mapfn )
    query.reduce( reducefn )

    questions = []
    for key in query.run():
        questions.append( key )

    gameBucket = client.bucket("games")

    gid = str(uuid.uuid1())

    gameData = {
        "questions" : questions,
        "id" : gid,
        "users" : [ user ],
        "leaderboard" : { user : 0 }
    }

    game = gameBucket.new( gid, data = gameData )
    game.store()

    return gid

#
# Before and after request handlers
#

@app.before_request
def beforeRequest():
    """ Connect to Riak before each request """
    client = riak.RiakClient(host=getip())
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
        id = str(uuid.uuid1())
        newUser = users_bucket.new( user, data= { "uuid" : id } )
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
        uniqueId = user.get_data()["uuid"]

        loggedIn = users.get("logged_in")
        if loggedIn.exists():
            vdata = loggedIn.get_data()
            if uniqueId in vdata["users"]:
                return uniqueId
            else:
                vdata["users"].append( uniqueId )
                loggedIn = users.new("logged_in", data=vdata)
                loggedIn.store()
        else:
            ldata = { "users": [ uniqueId ] }
            loggedIn = users.new("logged_in", data=ldata)
            loggedIn.store()

        return uniqueId
    else:
        return API_ERROR

@app.route('/game/new')
def newGame():
    """GET /game/new

    Create a new game"""

    if not isAuthed():
        return API_ERROR

    user   = request.form["user"]
    passwd = request.form["passwd"]

    return initializeGame( user, passwd )

@app.route('/game/join', methods=["POST"])
def joinGame():
    """POST /game/join

    Join a currently open game if available,
    otherwise create a new one"""

    # Failure on authentication error
    if not isAuthed():
        return API_ERROR

    # Initialize arguments, riak variables and buckets
    client = g.db
    users = client.bucket("users")
    user = request.form['user']
    token = request.form['authToken']

    if user == "" or (not users.get(user).exists()):
        return API_ERROR


    gamesBucket = client.bucket("games")

    # Map function to inspect tables and grab non full games
    mapfn = """ function(value, keyData, arg) {
                    ejsLog('map_reduce.log', "Test");
                    var data = Riak.mapValuesJson( value )[0];
                    if ( data.users.length < 20 ) {
                        return [value.key];
                    }
                    return [];
                }
            """
    query = client.add("games")
    query.map( mapfn )

    for key in query.run():

        # Add user to the game
        game = gamesBucket.get( key )

        vdata = game.get_data()
        if token in vdata["users"]:
            continue
        vdata["users"].append( token )
        # Add user to the leader board
        vdata["leaderboard"][user] = 0
        game = gamesBucket.new(key, data=vdata)
        game.store()
        return key

    gid = initializeGame( user )
    return gid

@app.route('/game/<gid>/next/<prevId>', methods=["POST"])
def nextQuestion(gid,prevId):
    """GET /game/<id>/next

    Get the next question for this game ID"""

    # Failure on authentication error
    if not isAuthed():
        return API_ERROR

    gamesBucket = g.db.bucket( "games" )
    game = gamesBucket.get( gid )

    # Failure on bogus game ID
    if not game.exists():
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
        question = questionBucket.get(nextQuestion)
        # Add id into the question
        qdata = question.get_data()
        qdata["id"] = nextQuestion
        return json.dumps(qdata)

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
        return json.dumps(gameData["leaderboard"])

# Run the webserver
if __name__ == '__main__':
    app.run( host=gethost(), port=80 )
