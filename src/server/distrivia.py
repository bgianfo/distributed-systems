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
from flask import send_file

from werkzeug import SharedDataMiddleware
from werkzeug.contrib.fixers import ProxyFix

import os
import riak    # Database client
import uuid    # Unique Identifier generator
import bcrypt  # Password hashing library
import socket
import urllib2


app = Flask(__name__)
app.debug = True
app.config["DEBUG"] = True
app.config['SECRET_KEY'] = 'secret'
app.wsgi_app = ProxyFix(app.wsgi_app)

API_ERROR = "err"
API_SUCCESS = "suc"
QUESTION_LIMIT = 20


# Add middle ware to server the web app client
app.wsgi_app = SharedDataMiddleware(app.wsgi_app, {
  '/': os.path.abspath("../clients/web")
})


#
# Utility functions
#

def getport():
    """ Return the internal IP of this machine """
    try:
        myurl = "http://169.254.169.254/latest/meta-data/local-ipv4"
        hostname = urllib2.urlopen(url=myurl, timeout=1).read()
        return 80
    except:
        return 8080


def getip():
    """ Return the internal IP of this machine """
    try:
        myurl = "http://169.254.169.254/latest/meta-data/local-ipv4"
        hostname = urllib2.urlopen(url=myurl, timeout=1).read()
        return hostname
    except:
        return "127.0.0.1"


def gethost():
    """ Return the outward facing hostname on EC2, or just the localhost
        if we arn't no EC2
    """
    try:
        myurl = "http://169.254.169.254/latest/meta-data/public-hostname"
        hostname = urllib2.urlopen(url=myurl, timeout=1).read()
        return hostname
    except:
        return "127.0.0.1"


def isAuthed():
    """
    Read the request and automatically check if he auth
    token is valid and "logged-in".

    Return True if so, False if not.
    """
    token = str(request.form['authToken'])
    loggedIn = g.db.bucket("users").get("logged_in")
    if loggedIn.exists():
        data = loggedIn.get_data()
        return (token in data["users"])
    else:
        return False


def initializeGame(user, passwd=None):
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
      sorted = values.sort(r);
      // Pick off the first 20
      return sorted.slice(0,19)
    }
    """

    query = client.add("questions")
    query.map(mapfn)
    query.reduce(reducefn)

    questions = []
    for key in query.run():
        questions.append(key)

    gameBucket = client.bucket("games")

    gid = str(uuid.uuid1())

    gameData = {
        "questions": questions,
        "id": gid,
        "users": [user],
        "status": "waiting",
        "leaderboard": {user: 0}
    }

    game = gameBucket.new(gid, data=gameData)
    game.store()

    return gid

#
# Before and after request handlers
#


@app.before_request
def beforeRequest():
    """ Connect to Riak before each request """
    client = riak.RiakClient(host=getip(), port=8087,
            transport_class=riak.RiakPbcTransport)
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


@app.route('/register/<user_name>', methods=["POST"])
def register(user_name):
    """
    Register a new user

    API_SUCCESS on success, API_ERROR on failure
    """

    # Make sure no bad/forbidden user's get through
    if user_name == "logged_in" or user_name == "":
        return API_ERROR

    if request.form["password"] is None:
        return API_ERROR

    user_name = str(user_name)
    password = str(request.form["password"])

    users_bucket = g.db.bucket("users")

    # The user already exists, so they can't register this name
    if users_bucket.get(user_name).exists():
        return API_ERROR

    # Awesome, let's register this bad boy
    else:
        # Hash the password with a random salt
        hashed = bcrypt.hashpw(password, bcrypt.gensalt())
        # Clear out password's we no longer need
        password = ""

        # Create a uuid for this user
        uid = str(uuid.uuid1())

        udata =  { "uuid": uid, "hash": hashed, "score": 0 }
        newUser = users_bucket.new(user_name, data=udata)
        newUser.store()
        return API_SUCCESS


@app.route('/login/<user_name>', methods=["POST"])
def login(user_name):
    """
    Attempt to authenticate a user, return a auth token on success.

    Note: The auth token will look something like:

     '7e43860a-55da-11e0-ae43-001f5bba6fae'

    otherwise return API_ERROR
    """

    # Make sure no bad/forbidden user's get through
    if user_name == "logged_in" or user_name == "":
        return API_ERROR

    if request.form["password"] is None:
        return API_ERROR

    user_name = str(user_name)
    password = str(request.form["password"])
    users = g.db.bucket("users")
    user = users.get(user_name)

    # Can't log a non-existent user in
    if user.exists():
        user_data = user.get_data()

        # Check to make sure the hashed password matches stored hash
        if bcrypt.hashpw(password, user_data["hash"]) == user_data["hash"]:
            unique_id = user_data["uuid"]
            logged_in = users.get("logged_in")
            if logged_in.exists():
                vdata = logged_in.get_data()
                if unique_id in vdata["users"]:
                    return unique_id
                else:
                    vdata["users"].append(unique_id)
                    logged_in = users.new("logged_in", data=vdata)
                    logged_in.store()
            else:
                ldata = { "users": [ unique_id ] }
                logged_in = users.new("logged_in", data=ldata)
                logged_in.store()

            return unique_id

    return API_ERROR

@app.route('/leaderboard/<int:position>', methods=["POST"])
def global_leaderbord(position = 0):
    """
    Get the global leader board for all ove distrivia
    """

    size  = 10
    client = g.db

    if not isAuthed():
        return API_ERROR

    # Map function to inspect grab all users and their score's
    mapfn = """
    function(value, keyData, arg) {
        var data = Riak.mapValuesJson(value)[0];
        if ( value.key !== "logged_in" ) {
          return [[value.key, data.score]];
        }
        return [];
    }
    """

    reducefn = """
    function(values) {
      function cmp(a,b) { a[1]-b[1]; };
      // Sort by user score
      sorted = values.sort(cmp);
      return sorted.slice( %s, %s );
    }
    """ % ( str(position), str(position + size) )


    query = client.add("users")
    query.map(mapfn)
    query.reduce(reducefn)

    board = {}

    query_results = query.run()

    print query_results
    #  Pack users into the board
    for result in query_results:
        user  = result[0]
        score = result[1]
        board[user] = score

    return json.dumps(board)



@app.route('/public/join', methods=["POST"])
def public_join_game():
    """
    URL /public/join

    Join a currently open game if available, otherwise create a new one.
    """

    # Failure on authentication error
    if not isAuthed():
        return API_ERROR

    # Initialize arguments, riak variables and buckets
    client = g.db
    token = str(request.form['authToken'])

    gamesBucket = client.bucket("games")

    # Map function to inspect tables and grab non full games
    mapfn = """
    function(value, keyData, arg) {
        var data = Riak.mapValuesJson(value)[0];
        if (data.users.length < 20) {
            return [value.key];
        }
        return [];
    }
    """
    query = client.add("games")
    query.map(mapfn)

    query_result = query.run()

    if query_result != None:
      for key in query_result:
          key = str(key)
          # Add user to the game
          game = gamesBucket.get(key)

          vdata = game.get_data()
          if token in vdata["users"]:
              continue
          vdata["users"].append(token)
          # Add user to the leader board
          vdata["leaderboard"][user] = 0
          game = gamesBucket.new(key, data=vdata)
          game.store()
          return key
      gid = initializeGame(user)
    else:
      gid = initializeGame(user)

    return gid

@app.route('/private/join', methods=["POST"])
def private_join_game():
    """
    URL /private/join

    Join a not started private game if available, otherwise error.
    """

    # Failure on authentication error
    if not isAuthed():
        return API_ERROR

    # Initialize arguments, riak variables and buckets
    client = g.db
    user   = str(request.form['user']);
    token  = str(request.form['authToken'])
    passwd = str(request.form['password'])

    # Map function to inspect tables and grab not started, private games
    mapfn = """
    function(value, keyData, arg) {
        var game = Riak.mapValuesJson(value)[0];
        if (game.type == "private" && data.status != "waiting") {
            // Get the key and password hash, that's all we need!
            return [[value.key, data.hash]];
        }
        return [];
    }
    """

    query = client.add("games")
    query.map(mapfn)
    query_result = query.run()

    if query_result != None:

      games = client.bucket("games")
      for key, gpwhash in query_result:
          key    = str(key)
          pwhash = str(pwhash)

          if bcrypt.hashpw(passwd,gpwhash) == gpwhash:
              game = games.get(key)
              vdata = game.get_data()
              if token in vdata["users"]:
                 return key
              vdata["users"].append(token)
              # Add user to the leader board
              vdata["leaderboard"][user] = 0
              game = gamesBucket.new(key, data=vdata)
              game.store()
              return key

      return API_ERROR
    else:
      return API_ERROR



@app.route('/game/<gid>/next/<prevId>', methods=["POST"])
def nextQuestion(gid,prevId):
    """GET /game/<id>/next

    Get the next question for this game ID"""

    # Failure on authentication error
    if not isAuthed():
        return API_ERROR

    gid = str(gid)
    prevId = str(prevId)
    gamesBucket = g.db.bucket("games")
    game = gamesBucket.get(gid)

    # Failure on bogus game ID
    if not game.exists():
        return API_ERROR
    else:
        # Get the list of questions for this game
        gameData = game.get_data();
        questions = gameData["questions"]

        qIndex = None
        nextQuestion = None
        if prevId == "0":
            nextQuestion = questions[0]
            qIndex = 0
        else:
            try:
                qIndex = questions.index(prevId)
            except:
                return API_ERROR

            # Failure on this game being over
            if (qIndex+1 >= len(questions)):
                return API_ERROR

            # Fetch and construct the next question object
            nextQuestion = questions[qIndex+1]

        questionBucket = g.db.bucket("questions")
        question = questionBucket.get(str(nextQuestion))
        # Add id into the question
        qdata = question.get_data()
        qdata["id"] = nextQuestion
        qdata["status"] = "next"
        if (qIndex+1 == len(questions)-1):
            qdata["status"] = "done"
        # TODO: Add a status and score field
        return json.dumps(qdata)

@app.route('/private/create/<int:numqestions>', methods=["POST"])
def private_new_create(numquestions):
    """
    URL /private/create
    POST:

    Create a new private game
    """

    if not isAuthed():
        return API_ERROR

    name   = str(request.form["name"])
    user   = str(request.form["user"])
    passwd = str(request.form["password"])
    token  = str(request.form["authToken"])

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
      sorted = values.sort(r);
      // Pick off the correct number of quesitons
      return sorted.slice(0,%s)
    }
    """ % str(numquestions)

    query = client.add("questions")
    query.map(mapfn)
    query.reduce(reducefn)

    questions = []
    for key in query.run():
        questions.append(key)

    games = client.bucket("games")

    gid = str(uuid.uuid1())

    gameData = {
        "questions": questions,
        "gamestatus": "waiting",
        "id": gid,
        "hash" : bcrypt.hashpw(passwd, bcrypt.gensalt()),
        "users": [token],
        "leaderboard": {user: 0}
    }

    game = games.new(gid, data=gameData)
    game.store()

    return gid

@app.route('/private/start/<gid>', methods=["POST"])
def private_new_create(gid):
    """
    URL /private/start/<gid>
    POST: authToken=<session id>

    Start a private game
    """

    if not isAuthed():
        return API_ERROR

    client = g.db
    games = client.bucket(games)

    game = games.get(qid)

    if game.exists():
        game_data = game.get_data();
        game_data["gamestatus"] = "started"
        game = games.new(gid, data=game_data)
        game.store()
        return 'ok'
    else:
        # TODO: Figure out which error code to return
        return API_ERROR


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

    gid = str(gid)
    qid = str(qid)
    answer = str(answer)
    user = str(request.form["user"])
    if user is None:
        return API_ERROR

    # Make sure answer is sane
    if answer not in ["a","b","c","d"]:
        return API_ERROR

    # Failure on bogus game ID
    gamesBucket = g.db.bucket("games")
    game = gamesBucket.get(gid)
    if not game.exists():
        return API_ERROR
    # TODO: Make sure user is a member of this game.

    # Failure on bogus question ID
    questionBucket = g.db.bucket("questions")
    question = questionBucket.get(qid)
    if not question.exists():
        return API_ERROR

    qdata = question.get_data()

    if qdata["answer"] != answer:
        print "Wrong: " + qdata["answer"]
        return "wrong"

    SEC_TO_MS =  1000

    points = 0
    if time_ms > 10*SEC_TO_MS:
        # After ten seconds no points
        point = 0
    elif time_ms > 9 * SEC_TO_MS:
        points = 50
    elif time_ms > 8 * SEC_TO_MS:
        points = 100
    elif time_ms > 7 * SEC_TO_MS:
        points = 150
    elif time_ms > 6 * SEC_TO_MS:
        points = 200
    elif time_ms > 5 * SEC_TO_MS:
        points = 250
    elif time_ms > 4 * SEC_TO_MS:
        points = 300
    elif time_ms > 3 * SEC_TO_MS:
        points = 350
    elif time_ms > 2 * SEC_TO_MS:
        points = 400
    elif time_ms > 1 * SEC_TO_MS:
        points = 500
    else:
        # Time is too fast, not counting it.
        return API_ERROR

    userBucket = g.db.bucket("users")
    userObj = userBucket.get(user)
    if not userObj.exists():
        return API_ERROR

    udata = userObj.get_data()
    gdata = game.get_data()

    gdata["leaderboard"][user] += points
    udata["score"] += points

    game = gamesBucket.new(gid, data = gdata)
    game.store()
    userObj = userBucket.new(user, data = udata)
    userObj.store()

    return "correct"


@app.route('/game/<gid>', methods=["POST"])
def game_status(gid):
    """
    URL: /game/<gid>
    Get the status for this game ID
    """
    # Failure on authentication error
    if not isAuthed():
        return API_ERROR

    gid = str(gid)
    client = g.db

    games = client.bucket("games")
    game = games.get(gid)

    # Failure on bogus game ID
    if not game.exists():
        return API_ERROR
    else:
        # Get the list of questions for this game
        gdata = game.get_data();

        if gdata["status"] is "started":
            # Merge first question with game data
            qid = gdata.questions[0]
            questions = client.bucket("questions")
            ques = questions.get(qid)
            qdata = ques.get_data()

            gdata["question"] = qdata["question"]
            gdata["qid"] = qid
            gdata["a"] = qdata["a"]
            gdata["b"] = qdata["b"]
            gdata["c"] = qdata["c"]
            gdata["d"] = qdata["d"]

        return json.dumps(gdata)


# Run the webserver
if __name__ == '__main__':
    app.run(host=gethost(), port=getport())
