<?php
session_start();

if( !isset( $_POST['post'] ) ){
   die();
}
$login = array(
   'srm2997'=>'sam',
   'bgianfo'=>'brian',
   'sfg6126'=>'sticky'
   );

$private = array(
   'distrivia'=>'bob'
   );

$qs = array(
   "What's Dr. Seuss' real last name?",
   "The computer Hal from 2001 name stands for",
   "GCCIS stands for",
   "1 + 1 ="
   );

$as = array(
   array( "Seus", "Geisel", "Martinez", "Smith" ),
   array( "Highly Advanced Laboratory", "Heuristically Programmed Algorithmic", "IBM", "Help All Living" ),
   array( "Jesus", "Games Computing Creativity Interactive Session", "Golisano College of Computing and Information Sciences", "Gregory Chris Chelsea Intellectual Services" ),
   array( "T_T", "42", "11", "2" )
   );

$rs = array(
   1,
   1,
   2,
   3,
   );

$game = array();

if( $_POST['post'] === 'login' ){
   $uname = get('u');
   $pass = get('p');
   if( $uname != null && $login[$uname] === $pass ){
      $_SESSION['id'] = base_convert( rand( 10e16, 10e40 ), 10, 36 );
      echo $_SESSION['id'];
      $_SESSION['score'] = 0;
   }else{
      session_destroy();
      echo "null";
   }
   die();
}

if( $_POST['post'] === 'join' ){
   // Join public game
   $login = validate();
   if( $login ){
      echo rand( 1, 19 ) . "";
   }else{
      echo "null";
   }
}

if( $_POST['post'] === 'joinp' ){
   // Join private game
   if( validate() ){
      $name = get('n');
      $pass = get('p');
      if( isset( $private[$name] ) && $private[$name] === $pass ){
         // Good log in
         echo "ok";
      }else{
         // Bad log in
         echo "null";
      }
   }
}

if( $_POST['post'] == 'check' ){
   if( validate() ){
      $num = rand(15,20);
      if( $num < 20 ){
         echo "n=$num";
      }else{
         // Set up the 'game' they're in
         $_SESSION['q'] = 1; // On question number 0
         echo "start" . question() . $_SESSION['score'];
      }
   }
}

if( $_POST['post'] == 'next' ){
   if( validate() && isset( $_SESSION['q'] ) && isset( $_POST['a'] ) ){
      // Check answer
      $a = $_POST['a'] - 1;
      if( $a == $rs[$_SESSION['game']] ){
         $_SESSION['score'] += 1;
      }

      // Send new question
      $q = $_SESSION['q'] + 1;
      if( $q <= 5 ){
         $_SESSION['q'] = $q;
         echo 'next' . question() . $_SESSION['score'];
      }else{
         echo 'done' . $_SESSION['score'];
      }
   }

   /*
   $game = game();
   if( validate() && $game !== false && isset( $_POST['ans'] ) ){
      // Check answer
      if( $rs 

      // Feed next question
      $q = $_SESSION['q'];
      if( $q > 4 ){
         echo "done";
      }else{
         $_SESSION['q'] = $q + 1;
         $q = rand( 0, count( $qs ) - 1 );
         echo $qs[$q] + "\n" +
            $as[$q][0] + "\n" +
            $as[$q][1] + "\n" +
            $as[$q][2] + "\n" +
            $as[$q][3] + "\n" + 
            $_SESSION['score'];
      }
   }
   */
}

function question(){
   global $qs, $as;
   $new = rand( 0, count( $qs ) - 1 );
   $_SESSION['game'] = $new;
   $outp = $qs[$new] . "\n";
   foreach( $as[$new] as $ans ){
      $outp .= $ans . "\n";
   }
   
   return $outp;
}

function game(){
   if( isset( $_SESSION['game'] ) ){
      return $_SESSION['game'];
   }
   return false;
}

function q(){
   if( isset( $_SESSION['q'] ) ){
      return $_SESSION['q'];
   }
   return false;
}


function validate(){
   if( isset( $_SESSION['id'] ) && isset( $_POST['i'] ) ){
      return $_SESSION['id'] === $_POST['i'];
   }
   return false;
}

function get( $s ){
   if( isset( $_POST[$s] ) && trim( $_POST[$s] ) !== '' ){
      return trim( $_POST[$s] );
   }else{
      return null;
   }
}

?>
