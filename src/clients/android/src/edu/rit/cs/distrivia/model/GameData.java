package edu.rit.cs.distrivia.model;

/**
 *
 */
public class GameData {

    private String authToken;
    private String userName;
    private String gameID;

    private GameData() {

    }

    public String getGameID() {
        return gameID;
    }

    public String getUserName() {
        return userName;
    }

    public String getAuthToken() {
        return authToken;
    }

}
