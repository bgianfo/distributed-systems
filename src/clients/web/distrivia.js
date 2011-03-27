
var session = null;
var updater = null;
var answer = -1;

function XML(){
   var xr;
   if( window.XMLHttpRequest ){
      xr = new XMLHttpRequest();
   }else{
      xr = new ActiveXObject( "Microsoft.XMLHTTP" );
   }
   return xr;
}

function Cancel(){
   var xr = XML();

   var param = "post=cancel&id=" + session;
   xr.open( "POST", "ajax.php", true );
   xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xr.setRequestHeader("Content-length", param.length);
   xr.setRequestHeader("Connection", "close");
   xr.send(param);

   document.getElementById('wait').classList.add('hidden');
   document.getElementById('join').classList.remove('hidden');
   document.getElementById('wait_message').innerHTML = "";

   window.clearInterval( updater );

   return false;
}

function CheckStatus(){
   var xr = XML();

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xr.status == 200 ){
         if( xr.responseText.indexOf("n=") == 0 ){
            document.getElementById('wait_message').innerHTML =
               xr.responseText.substr(2) + " / 20 people";
         }else if( xr.responseText.indexOf("start") == 0 ){
            document.getElementById('wait').classList.add('hidden');
            document.getElementById('game').classList.remove('hidden');
            window.clearInterval( updater );
            UpdateGame( xr.responseText.substr(5) );
         }else{
            document.getElementById('wait').classList.add('hidden');
            document.getElementById('join').classList.remove('hidden');
            window.clearInterval( updater );
         }
      }
   }

   var param = "post=check&i=" + session;
   xr.open( "POST", "ajax.php", true );
   xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xr.setRequestHeader("Content-length", param.length);
   xr.setRequestHeader("Connection", "close");
   xr.send(param);
}

function UpdateGame( data ){
   var parts = data.split("\n");
   document.getElementById('game_question').innerHTML = parts[0];
   var ans = document.getElementById('answers').getElementsByTagName('div');
   for( var i = 0; i < 4; i++ ){
      ans[i].innerHTML = parts[i+1];
   }
   document.getElementById('score').innerHTML = parts[5];
}

function Next(){
   var xr = XML();

   var ans = document.getElementById('answers').getElementsByTagName('div');
   for( var i = 0; i < 4; i++ ){
      ans[i].classList.remove('selected');
   }

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xr.status == 200 ){
         if( xr.responseText.indexOf('next') == 0 ){
            UpdateGame( xr.responseText.substr(4) );
         }else if( xr.responseText.indexOf('done') == 0 ){
            document.getElementById('score').innerHTML = 
               xr.responseText.substr(4);
            document.getElementById('game').classList.add('hidden');
            document.getElementById('join').classList.remove('hidden');
         }
      }
   }

   var param = "post=next&i=" + session + "&a=" + answer;
   xr.open( "POST", "ajax.php", true );
   xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xr.setRequestHeader("Content-length", param.length);
   xr.setRequestHeader("Connection", "close");
   xr.send(param);

   return false;
}

function Answer( num ){
   var ans = document.getElementById('answers').getElementsByTagName('div');
   for( var i = 0; i < 4; i++ ){
      if( num == i + 1 ){
         ans[i].classList.add('selected');
      }else{
         ans[i].classList.remove('selected');
      }
   }

   answer = num;
}

function Play(){
   var xr = XML();

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && ex.status == 200 ){
         
      } 
   }
}

function Public(){
   var xr = XML();

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xr.status == 200 ){
         if( xr.responseText == "null" ){
            // Invalid login
            document.getElementById('join').classList.add("hidden");
            document.getElementById('login').classList.remove("hidden");
         }else{
            // Waiting to join
//            document.getElementById('join_public').innerHTML = 
//               xr.responseText + " / 20 people";
//            document.getElementById('join_header').innerHTML =
//               "Joining a game...";
            document.getElementById('wait_message').innerHTML = 
               xr.responseText + " / 20 people";
            document.getElementById('join').classList.add('hidden');
            document.getElementById('wait').classList.remove('hidden');
            updater = window.setInterval("CheckStatus()",1000);
         }
      }
   }

   var param = "post=join&i=" + session;
   xr.open( "POST", "ajax.php", true );
   xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xr.setRequestHeader("Content-length", param.length);
   xr.setRequestHeader("Connection", "close");
   
   xr.send(param);
   return false;
}

function Login(){
   var xr = XML();

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 ){
         if( xr.status == 200 ){
            // Good to go
            if( xr.responseText == "null" ){
               // Invalid login
               document.getElementById('login_invalid').classList.remove('hidden');
            }else{
               // Valid login
               session = xr.responseText;
               document.getElementById('login').classList.add("hidden");
               document.getElementById('join').classList.remove('hidden');
               document.getElementById('login_invalid').classList.add('hidden');
            }
         }else{
            // Server connection failure
         }
      }
   }

   var uname = document.forms.login_form.username.value;
   var pass = document.forms.login_form.password.value;

   var param = "post=login&u=" + uname + "&p=" + pass;
   xr.open( "POST", "ajax.php", true );
//   var param = "login=" + uname;
//   xr.open( "POST", "http://ec2-50-17-136-240.compute-1.amazonaws.com/", true );
   xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xr.setRequestHeader("Content-length", param.length);
   xr.setRequestHeader("Connection", "close");
   
   xr.send(param);
   return false;
}

function Private(){
   var xr = XML();

   xr.onreadystatechange = function(){
      if( xr.readyState == 4 && xr.status == 200 ){
         if( xr.responseText == "null" ){
            // Invalid private game
            document.getElementById("join_fail").classList.remove('hidden');
         }else{
            // Valid private game
//            document.forms.join_form.classList.add("hidden");
//            document.getElementById('join_priv_wait').classList.remove("hidden");
            document.getElementById("join_fail").classList.add('hidden');
            document.getElementById('join').classList.add('hidden');
            document.getElementById('wait').classList.remove('hidden');
            document.getElementById('wait_message').innerHTML = "Waiting for owner to start game";
         }
      }
   }

   var name = document.forms.join_form.name.value;
   var pass = document.forms.join_form.pass.value;
   var param = "post=joinp&i=" + session + "&n=" + name + "&p=" + pass;

   xr.open( "POST", "ajax.php", true );
   xr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xr.setRequestHeader("Content-length", param.length);
   xr.setRequestHeader("Connection", "close");

   xr.send( param );
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

function Load(){
   if( document.forms.login_form.username.value != "" ){
      document.forms.login_form.password.focus();
   }else{
      document.forms.login_form.username.focus();
   }
}
