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

    /**
     * Constuct a semi-immutable GameData object
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

    public void setStatus(String gamestatus) {
        status = gamestatus;
    }

    public boolean hasStarted() {
        return status.equals("started");
    }

    public boolean isDone() {
        return status.equals("done");
    }

    public boolean isWaiting() {
        return status.equals("waiting");
    }
}
