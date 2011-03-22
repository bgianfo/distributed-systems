package edu.rit.cs.distrivia.api;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.json.JSONException;
import org.json.JSONObject;

public class DistriviaAPI {
    
    private static HttpClient httpClient = new DefaultHttpClient();
    private static HttpContext localContext = new BasicHttpContext();
           
    private static String API_URL = "http;//distrivia.com";
    
    public static Question nextQuestion( String authToken, String gameId ) {
        
        String url = new String( API_URL );
        
        url += "/game/"+gameId+"/next";
        
        url += "?authToken=" + authToken;
        
        HttpGet op = new HttpGet( url ) ;
        HttpResponse response = executeRequest( op );
        
        // Decompose JSON response into a Question object
        Question nextQ = null;
        try {
            JSONObject json = new JSONObject( responseToString( response ) );
            nextQ = Question.create( json );
        } catch (JSONException e) {
        }
        
        return nextQ;
    }
    
    public static Leaderboard leaderBoard( String authToken, String gameId ) {
        
        String url = new String( API_URL );
        
        url += "/game/"+gameId+"/leaderboard";
        
        url += "?authToken=" + authToken;
        
        HttpGet op = new HttpGet( url ) ;
        HttpResponse response = executeRequest( op );
        
        // Decompose JSON response into a Leaderboard object
        Leaderboard board = null;
        try {
            JSONObject json = new JSONObject( responseToString( response ) );
            board = Leaderboard.create( json );
        } catch (JSONException e) {
        }
        
        return board;
    }
   
    public static boolean register( String username ) {
        String url = new String( API_URL );
       
        url += "/register/" + username;
         
        HttpGet op = new HttpGet( url ) ;
        HttpResponse response = executeRequest( op );
        
        String data = responseToString( response );
        
        return data == "suc";
    }
    
    private static HttpResponse executeRequest( HttpRequestBase op ) {
        HttpResponse response = null;
        try {
            response = httpClient.execute( op, localContext );
        } catch (ClientProtocolException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return response;
    }

    private static String responseToString( HttpResponse res ) {
        
        InputStream is = null;
        try {
            is = res.getEntity().getContent();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (is != null) {
            
            Writer writer = new StringWriter();
            char[] buffer = new char[1024];
            
            try {
                Reader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                int n;
                while ((n = reader.read(buffer)) != -1) {
                    writer.write(buffer, 0, n);
                }
            } catch (UnsupportedEncodingException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            } finally {
                try {
                    is.close();
                } catch (IOException e) {
                    // Nothing we can do now!
                }
            }
            return writer.toString();
        } else {        
            return "";
        }    
    }
}
