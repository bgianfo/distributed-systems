/*
 * This file contains helper functions
 * for distrivia
 */

// Configuration for server
var url = "", php = false; // Use local server
//var url = "loop.php", php = true; // User loop.php ajax server with &a=b notation


/*
 * Gets an document element
 */
function byId( paramId ) {
   return document.getElementById( paramId );
}


/*
 * Converts data into a JSON object
 */
function jsonify( buffer ) {
    return eval( "(" + buffer + ")" );
}


/*
 * 
 */
function erl( param ){
   if( php ){
      var params = "";
      if( param.charAt(0) == '/' )
         param = param.substr(1);
      var split = param.split("/");
      for( var i = 0; i < split.length; i++ ){
         if( i % 2 == 0 )
            params += "&" + split[i] + "=";
         else
            params += split[i];
      }
      params = "?" + params.substring(1);
      return url + params;
   }else{
      return url + param;
   }
}
// End erl()


/*
 * Adds a class to an element
 */
function addClass( ref, cls ){
   var classes = ref.className.split(' ');
   var add = true;
   for( c in classes ){
      if( c == cls )
         add = false
   }
   if( add )
      ref.className += " " + cls
}
// End addClass()


/*
 * Removes a class from an element
 */
function removeClass( ref, cls ){
   var classes = ref.className.split(' ');
   var list = "";
   for( var i = 0; i < classes.length; i++ ){
      if( classes[i] != cls ){
         list += " " + classes[i];
      }
   }
   list = list.substr(1);
   ref.className = list;
}
// End removeClass()



/*
 * Hides an element
 */
function hide( ref ){
   $(ref).slideUp("slow");
}


/*
 * Shows an element
 */
function reveal( ref ){
   $(ref).slideDown("slow");
}


/*
 * Hides one, shows another element
 */
function swap( from, to ){
   $(from).slideUp( "slow", function(){
      $(to).slideDown( "slow" );
   });
}


/*
 * Creates an AJAX object
 */
function XML(){
   var xr;
   if( window.XMLHttpRequest ){
      xr = new XMLHttpRequest();
   }else{
      xr = new ActiveXObject( "Microsoft.XMLHTTP" );
   }
   return xr;
}
// End XML()


