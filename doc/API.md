API Proposal
============

Status Codes:
-------------
 - Everything was ok = 1

Logging in:
-----------
 - URL: /login/<username>
 - POST: password=<password>
 - Return:
   * Valid: s=<session id>
   * Invalid: Error Code?
 - Status: Fully implemented


Register:
---------
 - URL: /register/<username>
 - POST: password=<password>
 - Return:
   *  Valid: register=true
   * Invalid: Error Code?  (invalid pass, name taken, invalid name)
 - Status: Fully implemented

Universal Leaderboard:
----------------------
 - URL: /leaderboard/<starting position>
 - POST: authToken=<session id>
 - Return:
   * Valid: A set of names and scores (zero or more)
   * Invalid: Error Code?  (invalid auth token)
 - Status: Fully implemented

Join Public Games:
------------------
 - Server Notes:
   * Game created and users added to until full, then it starts

 - URL: /public/join
 - POST: authToken=<session id>&user=<username>
 - Returned JSON:
   * Always:
     + obj.gamestatus 
   * On success:
     + obj.id
 - Status: Fully implemented

Join Private Games:
-------------------
 - Server Notes:
   * Game crated and users added until creator starts it
 - URL: /private/join/<game name>
 - POST: authToken=<session id>&password=<password>&user=<user name>
 - Return:
   *  Valid: game id
   * Invalid: Error Code (invalid auth token, invalid credentials, already started)
 - Status: Implemented, haven't fully tested yet

Game Actions (public & private):
================================

All start with:
---------------
 - URL: /game/<game id>
 - POST: authToken=<session id>
 - Returned JSON:
   * obj.status
   * If status == 1
     + .gamestatus == 'waiting' or 'started' or 'done'
     + .leaderboard
   * If gamestatus == 'started'
     + .question
     + .qid
     + .a
     + .b
     + .c
     + .d
 - Status: Implemented, haven't fully tested yet

Submit an Answer:
-----------------
 - Add to URL: /question/<question id>
 - Add to Post: a=<answer>&time=<time>
 - Add to Returned JSON:
   * See above
 - Status: Not implemented

Create a Private Game:
----------------------
 - URL: /private/create/<num questions>
 - POST: authToken=<session id>&name=<game name>&password=<game password>&user=<username>
 - Return:
   * Valid: game id
   * Invalid: Error Code (invalid auth token, game name in use)
 - Status: Implemented, haven't fully tested yet

Start a private Game:
---------------------
 - URL: /private/start/<game id>
 - POST: authToken=<session id>
 - Return:
   * Valid: 'ok'
   * Invalid: Error Code? (invalid auth token)
 - Status: Implemented, haven't fully tested yet

