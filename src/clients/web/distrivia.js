// Current game id
var gid = null;

// Current question ID
var qid = "0";

// Authentication session token
var session = null;

// Session username
var username = null;

var questionState = "next";

var startTime = 0;
var stopTime = 0;

var updater = null;
var answer = -1;
var board_n = 0;

var API_ERROR   = "err";
var API_SUCCESS = 1;
var MAX_PLAYERS = 1;

var MSG = new Array();
var MSG_N = 0;
var MSG_C = 0;

// Used to prevent multiple POST requests
var xr_n = 0;
var board_shown = false;

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
      error.innerHTML += "<li class='error_item' onclick='ER(this)' >" + message + "</li>";
      //reveal( error );
      $(error).fadeIn("fast");
   }else{
      var div = $("<div />");
      var li = $("<li class='error_item' onclick='ER(this)'>" + message + "</li>" );
      div.append(li);
      div.hide();

      $(error).append(div);
      div.fadeIn("slow");
      div.slideDown("slow");
   }
   MSG[MSG_N++] = message;
   MSG_C++;
}
// End errMsg()


/*
 * Hides the ingame leaderboard
 */
function Hide(){
   if( board_shown ){
      var scoreb = byId("game_board");
      $(scoreb).animate({width:'hide'});
      board_shown = false;
      byId('game_list').innerHTML = "";
   }
   window.clearInterval(updater);
}
// End Hide()


/*
 * Removes an error message
 */
function ER( ref ){
   MSG_C--;
   if( MSG_C == 0 ){
      errClear();
   }else{
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


function Cancel(){
   var xr = XML();

   var param = "post=cancel&id=" + session;
   xr.open( "POST", "ajax.php", true );
   xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xr.send(param);

   byId('wait').classList.add('hidden');
   byId('join').classList.remove('hidden');
   byId('wait_message').innerHTML = "";
   var scoreb = byId('game_board');
   $(scoreb).animate({width:'hide'});

   window.clearInterval( updater );

   return false;
}


/*
 * Polls the server while waiting to join a game
 */
function CheckStatus( postgame ){
   var xr = XML();

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xr.status == 200 ){

         var data = jsonify(xr.responseText);
         var list = byId("game_list");
      
         if( true || data.status == 1 ){

            // Always update game leaderboard
            var scores = "";
            for( key in data.leaderboard ){
               scores += "<li class='board_item'><div class='board_left'>" + key + "</div>";
               scores += "<div class='board_right'>" + data.leaderboard[key] + "</div></li>";
            }
            list.innerHTML = scores;
               
            if( postgame ){
               // Do nothing at postgame
            }else if( data.gamestatus == 'waiting' ){
               // Game hasn't started
               // TODO (probably nothing)

            }else if( data.gamestatus == 'started' ){
               // Game has started
               swap( wait, game );
               UpdateGame( data );
               window.clearInterval(updater);

            }else if( data.gamestatus == 'done' ){
               // Game is finished
               window.clearInterval(updater);
            }

            // Update main screen score
            byId('score').innerHTML = data.leaderboard[username];
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


function UpdateGame( question ){
   byId('game_question').innerHTML = question.question;
   qid = question.qid;
   ans[0].innerHTML = question.a;
   ans[1].innerHTML = question.b;
   ans[2].innerHTML = question.c;
   ans[3].innerHTML = question.d;

   startTime = new Date().getTime();
}

/*
 * Submits an answer and sets up the next question
 */
function Next(){

   var xr = XML();
   xr.onreadystatechange = function(){
      if( xr.readyState == 4 ){
         if( xr.status == 200 ){

            try{
               var data = jsonify( xr.responseText );

               if( data.status == API_SUCCESS ){
                  if( data.gamestatus == 'started' ){
                     UpdateGame(data);
                     // Always update game leaderboard
                     var scores = "";
                     for( key in data.leaderboard ){
                        scores += "<li class='board_item'><div class='board_left'>" + key + "</div>";
                        scores += "<div class='board_right'>" + data.leaderboard[key] + "</div></li>";
                     }
                     byId('game_list').innerHTML = scores;
                  }else if( data.gamestatus == 'done' ){
                     swap( game, join );
                     var scores = "";
                     for( key in data.leaderboard ){
                        scores += "<li class='board_item'><div class='board_left'>" + key + "</div>";
                        scores += "<div class='board_right'>" + data.leaderboard[key] + "</div></li>";
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
      }
   };

   var time = stopTime - startTime;
   var param = "authToken=" + session + "&a=" + answer + "&user=" + username + "&time=" + time;
   var URI = erl("/game/" + gid + "/question/" + qid );
   xr.open( "POST", URI, true );
   xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xr.send(param);

   return false;
}
// End Next()


function Answer( num ){

   // Store the selection time
   stopTime = new Date().getTime();

   var ans = byId('answers').getElementsByTagName('a');
   for( var i = 0; i < 4; i++ ){
      if( num == i + 1 ){
         ans[i].classList.add('selected');
      }else{
         ans[i].classList.remove('selected');
      }
   }

   var answers = ["a","b","c","d"];

   answer = answers[num-1];
}


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
               more += "<li class='board_item'><div class='board_left'>";
               more += sortedboard[i][0];
               more += "</div><div class='board_right'>";
               more += sortedboard[i][1];
               more += "</div></li>";
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
 * Creates a private game
 */
function Make(){
   var xr = XML();
   var xml_n = ++xr_n;
   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xml_n == xr_n ){
         if( xr.status == 200 ){
            try{
            var data = jsonify( xr.responseText );
                           
               if( data.status == -1 ){
                  swap( join, login );
                  errMsg( "Your session expired." );
               }else if( data.status == 1 ){
                  $( byId('num_q') ).hide("slow");
                  $( byId('gconfirm') ).hide("slow");
                  errMsg( "Game is created, but nothing further is implemented on this client." );
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
      var param = "authToken=" + session + "&name=" + gname + "&password=" + gpas1 + "&user=" + username;
      xr.open( "POST", erl("/private/create/" + gnum), true );
      xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      xr.send(param);
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
                  updater = window.setInterval("CheckStatus(false)",1000);
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
   if( disabled('register') ){
      return false;
   }else{
      disable('register', ref);
   }

   var xr = XML();
   xr_n++;
   var xml_n = xr_n;
   $(ref).addClass("disable", ref);

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xml_n == xr_n ){
         if( xr.status == 200 ){
            if (  xr.responseText == API_ERROR ) {
               errMsg( "Username '" + username + "' already taken" );
            }else{
               Login();
            }
         }else{
            // Server connection failure
            errMsg("Could not connect to server. Please wait a minute and try again");
         }
         unload();
         enable('register', ref);
      }
   };


   username = document.forms.login_form.username.value.trim();
   if( username == "" ){
      errMsg( "Please provide the username you would like to register" );
   }

   var pass = document.forms.login_form.password.value.trim();
   if( pass == "" ){
      errMsg( "Please choose a password for your account" );
   }

   var conf = document.forms.login_form.confirm.value.trim();
   if( conf == "" ){
      reveal( byId('confirm') );
      enable('register', ref);
   }else if( conf != pass ){
      errMsg( "Passwords don't match" );
      enable('register', ref);
   }else{

      var URI = erl( "/register/" + username );

      if( username != "" && pass != "" ){
         var param = "password=" + pass;
         xr.open( "POST", URI, true );
         xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
         xr.send(param);
         loading();
      }
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

function Private(){
   // Clear any previous upater
   window.clearInterval(updater);

   var xr = XML();
   xr_n++;
   var xml_n = xr_n;

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xml_n == xr_n ){
         if( xr.status == 200 ){
            try{
               var data = jsonify( xr.responseText );

               if( data.status == 1 ){
                  swap( join, wait );

                  // Save the game id ( global )
                  gid = data.id;

                  var scoreb = byId('game_board');
                  byId('game_list').innerHTML = "";
                  $(scoreb).animate({width:'show'});
                  board_shown = true;

                  // Waiting to join
                  byId('wait_message').innerHTML = "Joining game...";
                  swap( join, wait );
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
      var param = "authToken=" + session + "&user=" + username + "&password=" + gpass;
//      var URI = erl( "/private/join/" + gname );
      var URI = erl( "/private/join/" );

      xr.open( "POST", URI, true );
      xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

      xr.send( param );
   }
   return false;
}

function Join_Key(e){
   if( e.keyCode == 13 ){
      Private();
   }
}

function Login_Key(e){
   if( e.keyCode == 13 ){
      Login();
   }
}

function Register_Key(e){
   if( e.keyCode == 13 ){
      Register();
   }
}

function Make_Key(e){
   if( e.keyCode == 13 ){
      Make();
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
