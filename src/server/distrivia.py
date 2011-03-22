#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
    Flaskr
    ~~~~~~

    A microblog example application written as Flask tutorial with
    Flask and sqlite3.

    :copyright: (c) 2011 by Brian Gianforcaro, Steven Glazer, Sam Milton.
    :license: BSD, see LICENSE for more details.
"""

from flask import Flask
from flask import json
from flask import request
from flask import session
from flask import g

import riak

app = Flask(__name__)
app.config['DEBUG'] = True
app.config['SECRET_KEY'] = 'secret'

API_ERROR   = "err"
API_SUCCESS = "suc"

#
# Before and after request handlers
#

@app.before_request
def before_request():
    """ Connect to Riak before each request """
    client = riak.RiakClient()
    g.db = client

@app.after_request
def after_request(response):
    """ Closes Riak connection after each request """
    g.db = None
    return response

#
# Application routes
#

@app.route('/register')
def register():
    """ Register a new user """

    user = request.form['uname']
    users_bucket = g.db.bucket( "users" )

    if users_bucket.get( user ).exists():
        return API_ERROR
    else:
        newUser = users_bucket.new( user, data={} )
        newUser.store()
        return API_SUCCESS


@app.route('/game/new')
def new_game():
    """GET /game/new

    Create a new game"""
    return "NOT IMPLEMEMTED"

@app.route('/game/join')
def join_game():
    """GET /game/join

    Join a currently open game if available,
    otherwise create a new one"""
    return "NOT IMPLEMEMTED"

@app.route('/game/<id>/next')
def next_question(id):
    """GET /game/<id>/next

    Get the next question for this game ID"""
    return "NOT IMPLEMENTED"

@app.route('/game/<id>/leaderboard')
def get_leaderboard(id):
    """GET /game/<id>/leaderboard

    Get the leaderboard for this game ID"""
    return "NOT IMPLEMENTED"


# Run the webserver
if __name__ == '__main__':
    app.run(port=80)
