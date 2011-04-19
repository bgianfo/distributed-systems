package edu.rit.cs.distrivia.model;

import java.io.Serializable;


/**
 *
 */
public class GameData implements Serializable {

    private static final long serialVersionUID = -4175459527542039101L;
    private final String authToken;
    private final String userName;
    private String gameID;
    private String status;
    private String[][] leadboard;
    private int score;
    private Question q;
    private boolean loadLocal = false;

    /**
     * Construct a GameData object
     * 
     * @param authToken
     *            Auth token logged in with
     * @param userName
     *            Username of the current session
     */
    public GameData(String authToken, String userName) {
        this.authToken = authToken;
        this.userName = userName;
    }

    /**
     * Setter for game Id, can change in between different rounds/games.
     * 
     * @param id
     *            The current Game Id String
     */
    public void setGameId(String id) {
        this.gameID = id;
    }

    /**
     * Getter for game ID
     * 
     * @return The current game ID String
     */
    public String getGameID() {
        return gameID;
    }

    /**
     * Getter for user name
     * 
     * @return The logged in user name.
     */
    public String getUserName() {
        return userName;
    }

    /**
     * Getter for authentication token
     * 
     * @return The current session authentication token
     */
    public String getAuthToken() {
        return authToken;
    }

    /**
     * @param gamestatus
     */
    public void setStatus(final String gamestatus) {
        status = gamestatus;
    }

    /**
     * @return True if the game is just starting
     */
    public boolean hasStarted() {
        return status.equals("started");
    }

    /**
     * @return True if game is done, false other wise.
     */
    public boolean isDone() {
        return status.equals("done");
    }

    /**
     * @return true if waiting, false other wise
     */
    public boolean isWaiting() {
        return status.equals("waiting");
    }

    /**
     * @return the current question id
     */
    public String getCurrentQid() {
        if (q != null) {
            return q.id();
        } else {
            return "0";
        }
    }

    /**
     * @return The current score in the game
     */
    public int getScore() {
        return score;
    }

    /**
     * @param score
     */
    public void setScore(final int score) {
        this.score = score;
    }

    /**
     * Set the current question in the game object.
     * 
     * @param q
     *            The question to update with
     */
    public void setQuestion(final Question q) {
        this.q = q;
    }

    /**
     * Get current question
     * 
     * @return Return the question object
     */
    public Question getQuestion() {
        return this.q;
    }
    
    /**
     * Set whether to load the local leaderboard
     * 
     * @param loadLocal
     */
    public void setLoadLocal(boolean loadLocal) {
    	this.loadLocal = loadLocal;
    }
    
    /**
     * Get whether to load the local leaderboard
     * 
     * @return true if load local, false otherwise
     */
    public boolean loadLocal() {
    	return this.loadLocal;
    }
    
    /**
     * Sets the local leaderboard data
     * 
     * @param leadboard
     */
    public void setLeaderboard(String[][] leadboard) {
    	this.leadboard = leadboard;
    }
    
    /**
     * Get the local leaderboard
     * 
     * @return local leaderboard data
     */
    public String[][] getLeaderboard() {
    	return this.leadboard;
    }
}
