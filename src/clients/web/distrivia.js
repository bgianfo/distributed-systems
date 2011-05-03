// Game variables
var gid = null;    // Game id
var qid = "0";     // Question id
var startTime = 0; // Question started
var stopTime = 0;  // Answer picked

// Constants
var API_ERROR   = "err";
var API_SUCCESS = 1;

// Session variables
var session = null; // Auth token
var username = null;// User name

// Error system variables
var MSG = new Array(); // List of messages
var MSG_N = 0;         // Next message id number
var MSG_C = 0;         // Number of currently displayed messages

// Misc vars
var updater = null; // Auto updated for leaderboard
var answer = -1;    // Currently picked answer
var board_n = 0;    // Number of users displayed on main leaderboard
var xr_n = 0;       // Current POST message id
var xr_n_check = 0; // Last CheckStatus POST id
var board_shown = false; // True == ingame leaderboard is shown


// References to DOM objects
var error;
var join;
var board;
var wait;
var game;
var login;
var ans;
var load;

Object.size = function(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) {
            size++;
        }
    }
    return size;
};


/*
 * Adds an error message to the error section
 */
function errMsg( message ){

   if( MSG.length == 0 ){
      // No displayed messages, add message and display message area
      error.innerHTML += "<li class='error_item' onclick='ER(this)' >" + message + "</li>";
      $(error).fadeIn("fast");
   }else{
      // Messages already displayed, add new one to list
      var div = $("<div />");
      var li = $("<li class='error_item' onclick='ER(this)'>" + message + "</li>" );
      div.append(li);
      div.hide();

      $(error).append(div);
      div.fadeIn("slow");
      div.slideDown("slow");
   }

   // Update message counters
   MSG[MSG_N++] = message;
   MSG_C++;
}
// End errMsg()


/*
 * Hides the ingame leaderboard
 */
function Hide(){
   // If it's displayed hide it
   if( board_shown ){
      $( id('game_board') ).animate({width:'hide'});
      board_shown = false;
      id('game_list').innerHTML = "";
   }

   // Clear any auto-updater for leaderboard
   window.clearInterval(updater);
}
// End Hide()


/*
 * Removes an error message
 */
function ER( ref ){
   MSG_C--;
   if( MSG_C == 0 ){
      // No messages left, hide whole message section
      errClear();
   }else{
      // Still messages left, hide only specified message
      $(ref).slideUp("fast");
   }
}
// End ER()


/*
 * Removes all error messages
 */
function errClear(){
   $(error).fadeOut("slow", function(){
      error.innerHTML = "";
   });
   MSG = new Array();
   MSG_N = 0;
}
// End errClear()


/*
 * Cancels joining a game
 */
function Cancel(){
   var xr = XML();
   xr_n_check = xr_n

   // Send POST informing server of cancel (ignore any reply)
   var param = "authToken=" + session;
   xr.open( "POST", erl( "/cancel/" + gid ), true );
   xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xr.send(param);

   // Return to join screen
   swap( id('wait'), id('join') );
   Hide();

   return false;
}
// End Cancel()


/*
 * Polls the server while waiting to join a game
 */
function CheckStatus( postgame ){
   var xr = XML();
   var xml_n = ++xr_n;
   // Note: This method uses the xr_n slightly differently
   // In order to keep a flow of leaderboard updates, it will act on all
   // messages that come back as long as its more recent than the last one
   // it parsed.

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xml_n > xr_n_check && xr.status == 200 ){
         xr_n_check = xml_n;

         var data = jsonify(xr.responseText);
         var list = id("game_list");
      
         if( true || data.status == API_SUCCESS ){

            // Always update game leaderboard
            var scores = "";
            for( key in data.leaderboard ){
               scores += "<li class='board_item'><span class='board_left'>" + key + "</span>";
               scores += "<span class='board_right'>" + data.leaderboard[key] + "</span></li>";
            }
            list.innerHTML = scores;
               
            if( postgame ){
               // Do nothing at postgame
            }else if( data.gamestatus == 'waiting' ){
               // Game hasn't started
               // TODO (probably nothing)

            }else if( data.gamestatus == 'started' ){
               // Game has started
               xr_n_check = xr_n; // Disable all other CheckStatus from parsing

               if( $( id('wait') ).is(":visible") ){
                  swap( id('wait'), id('game') );
               }else{
                  swap( id('host'), id('game') );
               }

               UpdateGame( data );
               window.clearInterval(updater);

            }else if( data.gamestatus == 'done' ){
               // Game is finished
               window.clearInterval(updater);
            }

            // Update main screen score
            id('score').innerHTML = data.leaderboard[username];
         }else{
            errMsg( "Server connection failure" );
         }
      };
   }

   var param = "authToken=" + session;
   var URI = erl("/game/" + gid );

   xr.open( "POST", URI, true );
   xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xr.send(param);
}
// End CheckStatus()


/*
 * Updates the game screen
 */
function UpdateGame( question ){
   id('game_question').innerHTML = question.question;
   qid = question.qid;
   ans[0].innerHTML = question.a;
   ans[1].innerHTML = question.b;
   ans[2].innerHTML = question.c;
   ans[3].innerHTML = question.d;

   for( var i = 0; i < ans.length; i++ ){
      $(ans[i]).removeClass('selected');
   }
   answer = -1;
   ans[0].focus();

   startTime = stopTime = new Date().getTime();
}
// End UpdateGame()


/*
 * Submits an answer and sets up the next question
 */
function Next( ref ){
   var func = "next";
   if( disabled(func, ref) ){
      return false;
   }else{
      disable(func, ref);
   }

   var xr = XML();
   var xml_n = ++xr_n;

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xml_n == xr_n ){
         if( xr.status == 200 ){

            try{
               var data = jsonify( xr.responseText );

               if( data.status == API_SUCCESS ){
                  if( data.gamestatus == 'started' ){
                     UpdateGame(data);
                     // Always update game leaderboard
                     var scores = "";
                     for( key in data.leaderboard ){
                        scores += "<li class='board_item'><span class='board_left'>" + key + "</span>";
                        scores += "<span class='board_right'>" + data.leaderboard[key] + "</span></li>";
                     }
                     byId('game_list').innerHTML = scores;
                  }else if( data.gamestatus == 'done' ){
                     swap( game, join );
                     var scores = "";
                     for( key in data.leaderboard ){
                        scores += "<li class='board_item'><span class='board_left'>" + key + "</span>";
                        scores += "<span class='board_right'>" + data.leaderboard[key] + "</span></li>";
                     }
                     byId('game_list').innerHTML = scores;
                     updater = window.setInterval("CheckStatus(true)",5000);
                  }
               }else{
                  // TODO Check status code
                  errMsg( "Next() Status Code: " + data.status );
               }
            }catch( err ){
               errMsg( "Question loading failed" );
            }
         }else{
            errMsg( "Could not load next question" );
         }

         enable( func, ref );
      }
   };

   if( answer != -1 ){
      var time = stopTime - startTime;
      var param = "authToken=" + session + "&a=" + answer + "&user=" + username + "&time=" + time;
      var URI = erl("/game/" + gid + "/question/" + qid );
      xr.open( "POST", URI, true );
      xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      xr.send(param);
      errClear();
   }else{
      enable( func, ref );
      errMsg( "Please select an answer." );
   }

   return false;
}
// End Next()


/*
 * Selects ans answer
 */
function Answer( num ){

   // Store the selection time
   stopTime = new Date().getTime();

   for( var i = 0; i < 4; i++ ){
      if( num == i + 1 ){
         $( ans[i] ).addClass('selected');
      }else{
         $( ans[i] ).removeClass('selected');
      }
   }

   var answers = ["a","b","c","d"];

   answer = answers[num-1];

//   id('next').focus();
   return false;
}
// End Answer


/*
 * Gets universal leaderboard scores
 */
function More(ref){
   var func = "more";
   if( disabled(func, ref) ){
      return false;
   }else{
      disable(func, ref);
   }

   var xr = XML();
   var xml_n = ++xr_n;

   var bl = byId('board_list');
   addClass( bl, 'board_load' );

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xml_n == xr_n ){
         if( xr.status == 200 ){
            removeClass( bl, 'board_load' );

            var data = xr.responseText;
            var board = jsonify( data );

            var sortedboard = [];
            for ( key in board ) {
               if( key != 'status' ){
                  sortedboard.push( [ key, board[key] ] );
               }
            }

            // Sort by score
            sortedboard = sortedboard.sort( function(a,b){ return b[1] - a[1]; } );

            var more = "";
            for( var i = 0; i < sortedboard.length; i++ ) {
               more += "<li class='board_item'><span class='board_left'>";
               more += sortedboard[i][0];
               more += "</span><span class='board_right'>";
               more += sortedboard[i][1];
               more += "</span></li>";
               board_n++;
            }
            bl.innerHTML = bl.innerHTML + more;
            bl.scrollTop = bl.scrollHeight;
            $(bl).animate({scrollTop: bl.scrollHeight - $(bl).height() }, 800);
            enable( func, ref );
         }
      }
   }

   var param = "authToken=" + session;
   xr.open( "POST", erl("/leaderboard/"+board_n), true );
   xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xr.send(param);

   return false;
}
// End More()


/*
 * Shows universal leaderboard
 */
function Scores(){
   board_n = 0;
   byId('board_list').innerHTML = "";
   swap(join,board);
   More();
   return false;
}
// End Scores()


/*
 * Goes to join screen from leaderboard
 */
function Home(){
   swap( board, join );

   return false;
}
// End Home()


/*
 * Starts a private game
 */
function Start(ref){
   var func = "start";
   if( disabled(func, ref) ){
      return false;
   }else{
      disable(func, ref);
   }

   var xr = XML();
   var xml_n = ++xr_n;

   var bl = byId('board_list');
   addClass( bl, 'board_load' );

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xml_n == xr_n ){
         if( xr.status == 200 ){
            CheckStatus(false);
         }
      }
   };

   
   var param = "authToken=" + session;
   xr.open( "POST", erl("/private/start/" + gid), true );
   xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xr.send(param);

   return false;
}

/*
 * Creates a private game
 */
function Make(ref){
   var func = "start";
   if( disabled(func, ref) ){
      return false;
   }else{
      disable(func, ref);
   }

   var xr = XML();
   var xml_n = ++xr_n;

   var bl = byId('board_list');
   addClass( bl, 'board_load' );

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xml_n == xr_n ){
         if( xr.status == 200 ){
            try{
            var data = jsonify( xr.responseText );
                           
               if( data.status == -1 ){
                  errClear();
                  swap( id('join'), id('login') );
                  errMsg( "Your session expired." );
               }else if( data.status == API_SUCCESS ){
                  gid = data.id;
                  $( byId('num_q') ).hide("slow");
                  $( byId('gconfirm') ).hide("slow");
                  swap( id('join'), id('host') );
                  $(id('game_board')).animate({width:'show'});
                  board_shown = true;
                  updater = window.setInterval("CheckStatus(false)",2500);
                  CheckStatus(false);
                  errClear();
               }

           }catch(err){
               errMsg( "Couldn't create game, server error." );

           }
         }
      }
   };

   var gname = document.forms.join_form.name.value.trim();
   var gpas1 = document.forms.join_form.pass.value.trim();
   var gpas2 = document.forms.join_form.cpass.value.trim();
   var gnum = document.forms.join_form.num.value.trim();

   var valid = true;

   if( gpas1 == "" ){
      errMsg( "Please give a password." );
      valid = false;
   }

   if( !$(document.forms.join_form.cpass).is(":visible") ){
      // Display hidden fields
      reveal( byId('gconfirm') );
      reveal( byId('num_q') );
      valid = false;
   }else if( gpas1 != gpas2 ){
      errMsg( "Passwords don't match." );
      valid = false;
   }

   var num = parseInt( gnum );
   if( isNaN( num ) ){
      errMsg( "Please give the number of questions to generate." );
      valid = false;
   }else{
      gnum = num;
   }

   if( valid ){
      // Clear any previous updater
      window.clearInterval(updater);

      var param = "authToken=" + session + "&name=" + gname + "&password=" + gpas1 + "&user=" + username;
      xr.open( "POST", erl("/private/create/" + gnum), true );
      xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      xr.send(param);
   }else{
      enable(func, ref);
   }

   return false;
}
// End Make()

/*
 * Joins a public game
 */
function Public(ref){
   var func = "joinpub";
   if( disabled(func, ref) ){
      return false;
   }else{
      disable(func, ref);
   }

   // Clear any previous updater
   window.clearInterval(updater);

   var xr = XML();
   xr_n++;
   var xml_n = xr_n;

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xml_n == xr_n ){
         if( xr.status == 200 ){

            try{
               var data = jsonify(xr.responseText);
               if( data.status == API_SUCCESS ){
                  // Save the game id ( global )
                  gid = data.id;

                  var scoreb = byId('game_board');
                  byId('game_list').innerHTML = "";
                  $(scoreb).animate({width:'show'});
                  board_shown = true;

                  // Waiting to join
                  byId('wait_message').innerHTML = "Joining game...";
                  swap( join, wait );
                  updater = window.setInterval("CheckStatus(false)",2500);
               }else{
                  // Invalid login
                  swap( join, login );
                  errMsg( "Login session expired. Please log back in" );
               }
            }catch(err){
               errMsg( "Did not recieve JSON object" );
            }
         }else{
            errMsg( "Server error, please try again in a few minutes" );
         }
         unload();
         enable( func, ref );
      }
      
   }

   loading();

   var param = "authToken=" + session + "&user=" + username;
   var URI = erl( "/public/join" );

   xr.open( "POST", URI, true );
   xr.setRequestHeader( "Content-type", "application/x-www-form-urlencoded" );
   xr.send( param );

   return false;
}
// End Public()


/*
 * Registers a new user
 */
function Register(ref){
   var func = 'register'; // Method name (for enabling/disable use
   if( disabled(func) ){  // Check if method has been disabled
      return false;       // Do nothing if disabled
   }else{                 
      disable(func, ref); // If not disabled, disable it
   }

   var xr = XML();     // Start an xmlhttprequest object
   var xml_n = ++xr_n; // Get a POST message number

   // Callback for POST reply
   xr.onreadystatechange = function(){
      // Check if message is fully recieved
      // and that the current message number is the same as local one
      if( xr.readyState == 4 && xml_n == xr_n ){

         if( xr.status == 200 ){
            if( xr.responseText == API_ERROR ){
               errMsg( "Username '" + username + "' already taken" );
            }else{
               // Registration successfull, auto log in
               Login();
            }

         }else{
            // Server connection failure
            errMsg("Could not connect to server. Please wait a minute and try again");
         }

         unload(); // Hide loading icon
         enable(func, ref); // Re-enable register button
      }
   };


   // Get input fields
   username = document.forms.login_form.username.value.trim(); // username
   var pass = document.forms.login_form.password.value.trim(); // password
   var conf = document.forms.login_form.confirm.value.trim();  // confirm password

   // Check if username has been input
   if( username == "" ){
      errMsg( "Please provide the username you would like to register" );
   }

   // Check if password has been input
   if( pass == "" ){
      errMsg( "Please choose a password for your account" );
   }

   // Check confirmation password
   if( !$(document.forms.login_form.confirm).is(":visible") ){
      // Confirm field not visible, show it
      reveal( byId('confirm') );
      enable(func, ref); // Re-enable register button

   }else if( conf != pass ){
      // Passwords don't match, show error
      errMsg( "Passwords don't match" );
      enable(func, ref); // Re-enable register button

   }else{
      // Field checks succeeded, send POST
      var URI = erl( "/register/" + username );

      var param = "password=" + pass;
      xr.open( "POST", URI, true );
      xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      xr.send(param);

      loading(); // Show loading icon
   }

   return false;
}
// End Register()


/*
 * Processes a log in attempt
 */
function Login(ref){
   var func = "login";
   if( disabled(func, ref) ){
      return false;
   }else{
      disable(func, ref);
   }

   var xr = XML();
   xr_n++;
   var xml_n = xr_n;

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xml_n == xr_n ){

         if( xr.status == 200 ){
            // Good to go
            if( xr.responseText == API_ERROR ){
               // Invalid login
               errMsg("Invalid username / password");
            }else{
               // Valid login
               session = xr.responseText;
               swap( login, join );
               errClear();
            }
         }else{
            // Server connection failure
            errMsg("Could not connect to server. Please wait a minute and try again");
         }
         unload();
         enable( func, ref );
      }
   }


   username = document.forms.login_form.username.value.trim();
   if( username == "" )
      return false;
   var pass = document.forms.login_form.password.value;
   var param = "password=" + pass;

   var URI = erl( "/login/" + username );
   xr.open( "POST", URI, true );
   xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xr.send(param);

   loading();

   return false;
}
// End Login()

function Private(ref){
   var func = 'private'; // Method name (for enabling/disable use
   if( disabled(func) ){  // Check if method has been disabled
      return false;       // Do nothing if disabled
   }else{                 
      disable(func, ref); // If not disabled, disable it
   }

   var xr = XML();     // Start an xmlhttprequest object
   var xml_n = ++xr_n; // Get a POST message number

   // Clear any previous upater
   window.clearInterval(updater);

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xml_n == xr_n ){
         if( xr.status == 200 ){
            try{
               var data = jsonify( xr.responseText );

               if( data.status == API_SUCCESS ){
                  swap( id('join'), id('wait') );

                  // Save the game id ( global )
                  gid = data.id;

                  byId('game_list').innerHTML = "";
                  $( id('game_board') ).animate({width:'show'});
                  board_shown = true;

                  // Waiting to join
                  byId('wait_message').innerHTML = "Joining game...";
                  swap( id('join'), id('wait') );
                  updater = window.setInterval("CheckStatus(false)",1000);

               }else if( data.status == -2 ){
                  errMsg( "That game has already started." );
               }else if( data.status == -3 ){
                  errMsg( "Invalid game name and/or password." );
               }else if( data.status == -1 ){
                  swap( join, login );
                  errMsg( "Your login session expired." );
               }else{
                  errMsg( "Server returned an invalid status code: " + data.status + "." );
               }

            }catch(err){
               errMsg( "Server connection error" );
            }
            enable( func, ref );
         }
      }
   }

   var gname = document.forms.join_form.name.value.trim();
   var gpass = document.forms.join_form.pass.value.trim();

   var go = true;
   if( gname == "" ){
      errMsg( "Please provide a game name." );
      go = false;
   }
   if( gpass == "" ){
      errMsg( "Please provide the game password." );
      go = false;
   }

   if( go ){
      var param = "authToken=" + session + "&user=" + username + "&password=" + gpass + "&name=" + gname;
//      var URI = erl( "/private/join/" + gname );
      var URI = erl( "/private/join/" );

      xr.open( "POST", URI, true );
      xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

      xr.send( param );
   }else{
      enable( func, ref );
   }

   return false;
}

function Join_Key(e){
   if( e.keyCode == 13 ){
      Private( id('priv_join') );
   }
}

function Login_Key(e){
   if( e.keyCode == 13 ){
      Login( id('login_btn') );
   }
}

function Register_Key(e){
   if( e.keyCode == 13 ){
      Register( id('reg_btn') );
   }
}

function Make_Key(e){
   if( e.keyCode == 13 ){
      Make( id('priv_create') );
   }
}

function Load(){
   if( document.forms.login_form.username.value != "" ){
      document.forms.login_form.password.focus();
   }else{
      document.forms.login_form.username.focus();
   }

   error = byId('error');
   login = byId('login');
   join = byId('join');
   game = byId('game');
   board = byId('board');
   wait = byId('wait');
   ans = byId('answers').getElementsByTagName('a');
   load = byId('load');
}
