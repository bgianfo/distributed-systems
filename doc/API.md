API Proposal

Logging in:
 URL: /login/<username>
POST: password=<password>
Return:
   Valid: s=<session id>
   Invalid: Error Code?
Status: Fully implemented


Register:
 URL: /register/<username>
POST: password=<password>
Return:
   Valid: register=true
   Invalid: Error Code?  (invalid pass, name taken, invalid name)
Status: Fully implemented

Universal Leaderboard:
 URL: /leaderboard/<starting position>
POST: authToken=<session id>
Return:
   Valid: A set of names and scores (zero or more)
   Invalid: Error Code?  (invalid auth token)
Status: Fully implemented

Public Games:
   Server Notes:
   Game created and users added to until full, then it starts
Join Game:
 URL: /public/join
POST: authToken=<session id>
Return:
   Valid: game id
   Invalid: Error Code? (invalid auth token)
Status: Fully implemented

Private Games:
   Server Notes:
   Game crated and users added until creator starts it
Join Game:
 URL: /private/join/<game name>
POST: authToken=<session id>&password=<password>
Return:
   Valid: game id
   Invalid: Error Code (invalid auth token, invalid credentials, already started)
Status: Not implemented

Game Actions (for public and private):
All start with
 URL: /game/<game id>
POST: authToken=<session id>
The return value always contains the games leaderboard and a status
Status can equal 'waiting', 'started', or 'done'
Status: Not implemented

Submit an Answer:
   Add to URL: /question/<question id>/<answer>
   Add to Post: time=<time>
   Add to Return:
      Valid: if status == started, the next question. otherwise nothing
Status: Not implemented

Create a Private Game:
 URL: /private/create/<num questions>
POST: authToken=<session id>&name=<game name>&password=<game password>
Return:
   Valid: game id
   Invalid: Error Code (invalid auth token, game name in use)
Status: Not implemented

Start a private Game:
 URL: /private/start/<game id>
POST: authToken=<session id>
Return:
   Valid: 'ok'
   Invalid: Error Code? (invalid auth token)
Status: Not implemented

