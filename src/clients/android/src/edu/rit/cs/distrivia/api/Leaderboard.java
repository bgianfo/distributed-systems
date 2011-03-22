package edu.rit.cs.distrivia.api;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Leaderboard {
    
    private List<String> userLeader;
    private List<Integer> scoreLeader;
    
    // Prevent construction without factory
    private Leaderboard () {}
    
    /**
     * Factory method to create a Leader board from JSON.
     * 
     * @param json The JSON leader board object to create from.
     * 
     * @return The leader board object create from the JSON
     */
    public static Leaderboard create( JSONObject json ) {
        
        Leaderboard board = new Leaderboard();
        
        board.userLeader = new ArrayList<String>();
        board.scoreLeader = new ArrayList<Integer>();
        
        try {
            JSONArray arr = json.getJSONArray("arr");
            
            for( int i = 0; i < arr.length(); i++ ) {
                JSONObject user = arr.getJSONObject(i);
                
                String uname = user.getString("uname");
                Integer score = user.getInt("score");
                
                board.userLeader.add(uname);
                board.scoreLeader.add(score);
            }
            
        } catch (JSONException e) {
        }
        
        return board;
    }
     
    /**
     * Getter for individual leader board users.
     * @param i The index into the leader board to return.
     * @return The i-th position user in the leader board.
     */   
    public String getUser( int i ) {
        return userLeader.get(i);
    }
    
    /**
     * Getter for individual leader board scores.
     * @param i The index into the leader board to return.
     * @return The i-th position score in the leader board.
     */
    public int getScore( int i ) {
        return scoreLeader.get(i).intValue();
    }
    
    /**
     * Getter for the size of the leader board.
     * @return an integer representing the size.
     */
    public int size() {
       return userLeader.size(); 
    }

}
