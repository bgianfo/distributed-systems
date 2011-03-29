#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
     Distrivia
    ~~~~~~~~~~~
    A webservice backend which implements a RESTFUL trivia game API.

    :copyright: (c) 2011 by Brian Gianforcaro, Steven Glazer, Sam Milton.
"""

from flask import g
from flask import Flask
from flask import json
from flask import request
from flask import session
from flask import send_file
from werkzeug import SharedDataMiddleware

import os
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


# Add middle ware to server the web app client
app.wsgi_app = SharedDataMiddleware(app.wsgi_app, {
  '/': os.path.abspath("../clients/web")
})


#
# Utility functions
#

def getip():
    """ Return the internal IP of this machine """
    try:
        url = "http://169.254.169.254/latest/meta-data/local-ipv4"
        hostname = urllib2.urlopen(url).read()
        return hostname
    except:
        return "127.0.0.1"

def gethost():
    """ Return the outward facing hostname on EC2, or just the localhost
        if we arn't no EC2
    """
    try:
        url = "http://169.254.169.254/latest/meta-data/public-hostname"
        hostname = urllib2.urlopen(url).read()
        return hostname
    except:
        return "0.0.0.0"

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

@app.route("/")
def indexer():
    """ Default render-er for the client """
    index = os.path.abspath("../clients/web") + "/distrivia.html"
    return send_file(index)

@app.route('/register/<user>', methods=["POST"])
def register(user):
    """
    Register a new user

    API_SUCCESS on success, API_ERROR on failure
    """

    # TODO: Take a passwd as a argument, SHA1 hash it + a salt
    #       and store the hash in the user object.

    users_bucket = g.db.bucket( "users" )

    # The user already exists, so they can't register this name
    if users_bucket.get( user ).exists():
        return API_ERROR

    # Awesome, let's register this bad boy
    else:
        uid = str(uuid.uuid1())
        newUser = users_bucket.new( user, data= { "uuid" : uid, "score" : 0 } )
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

    # TODO: Take a passwd as a argument, SHA1 hash it + a salt
    #       and check if it matches the hash in the user object.


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

    # TODO: Add ability to create a specific game

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

    # TODO: Add ability to join a specific game

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
            qIndex = None
            try:
                qIndex = questions.index( prevId )
            except:
                return API_ERROR

            # Failure on this game being over
            if qIndex >= QUESTION_LIMIT or (qIndex+1 >= len(questions)):
                return API_ERROR

            # Fetch and construct the next question object
            nextQuestion = questions[qIndex+1]

        questionBucket = g.db.bucket( "questions" )
        question = questionBucket.get(nextQuestion)
        # Add id into the question
        qdata = question.get_data()
        qdata["id"] = nextQuestion
        # TODO: Add a status and score field
        return json.dumps(qdata)

@app.route('/game/<gid>/answer/<qid>/<answer>/<int:time_ms>', methods=["POST"])
def answerQuestion(gid,qid,answer,time_ms):
    """POST /game/<gid>/next/<qid>/<answer>/<time_ms>

    URL Params:

        gid - The game id
        qid - The current question id
        answer - The clients answer to the question: "a","b","c" or "d"
        time_ms - The time it took the client to answer in milliseconds

    Post Params:

        authToken - The clients authorization token
        user      - The clients user name (makes querying easier)

    Answer a given question"""

    # Failure on authentication error
    if not isAuthed():
        return API_ERROR

    user = request.form["user"]
    if user is None:
        return API_ERROR

    # Make sure answer is sane
    if answer not in ["a","b","c","d"]:
        return API_ERROR

    # Failure on bogus game ID
    gamesBucket = g.db.bucket( "games" )
    game = gamesBucket.get( gid )
    if not game.exists():
        return API_ERROR
    # TODO: Make sure user is a member of this game.

    # Failure on bogus question ID
    questionBucket = g.db.bucket( "questions" )
    question = questionBucket.get( qid )
    if not question.exists():
        return API_ERROR

    qdata = question.get_data()

    if qdata["answer"] != answer:
        return "wrong"

    SEC_TO_MS =  1000

    points = 0
    if time_ms > 10*SEC_TO_MS:
        # After ten seconds no points
        return "correct"
    elif time_ms > 9*SEC_TO_MS:
        points = 50
    elif time_ms > 8*SEC_TO_MS:
        points = 100
    elif time_ms > 7*SEC_TO_MS:
        points = 150
    elif time_ms > 6*SEC_TO_MS:
        points = 200
    elif time_ms > 5*SEC_TO_MS:
        points = 250
    elif time_ms > 4*SEC_TO_MS:
        points = 300
    elif time_ms > 3*SEC_TO_MS:
        points = 350
    elif time_ms > 2*SEC_TO_MS:
        points = 400
    elif time_ms > 1*SEC_TO_MS:
        points = 500
    else:
        # Time is too fast, not counting it.
        return API_ERROR

    userBucket = g.db.bucket( "users" )
    userObj = userBucket.get( user )
    if not userObj.exists():
        return API_ERROR

    udata = userObj.get_data()
    gdata = game.get_data()

    gdata["leaderboard"][user] += points
    udata["score"] += points

    game = gamesBucket.new( gid, data = gdata )
    game.store()
    userObj = userBucket.new( user, data = udata )
    userObj.store()

    return "correct"

@app.route('/game/<gid>/leaderboard', methods=["POST"])
def getLeaderBoard(gid):
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
    game = gamesBucket.get( gid )

    # Failure on bogus game ID
    if not game.exists():
        return API_ERROR
    else:
        # Get the list of questions for this game
        gameData = game.get_data();
        return json.dumps(gameData)


# Run the webserver
if __name__ == '__main__':
    app.run( host=gethost(), port=80 )
