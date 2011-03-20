#!/usr/bin/env python

from flask import Flask
from flask import json
from flask import request

app = Flask("Distrivia")
app.config['DEBUG'] = True
app.config['SECRET_KEY'] = 'secret'

@app.route('/game/new')
def new_game():
    """GET /game/new

    Create a new game"""
    return "NOT IMPLEMEMTED"

@app.route('/game/join')
def join_game():
    """GET /game/join

    Join a currently open a new game if available,
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
    app.run()
