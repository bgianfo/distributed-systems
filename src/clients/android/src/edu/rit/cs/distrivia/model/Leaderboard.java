package edu.rit.cs.distrivia.model;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Object that represents the Game's Score Board
 */
public class Leaderboard {

    private List<String> userLeader;
    private List<Integer> scoreLeader;

    // Prevent construction without factory
    private Leaderboard() {
    }

    /**
     * Factory method to create a Leader board from JSON.
     * 
     * @param json
     *            The JSON leader board object to create from.
     * 
     * @return The leader board object create from the JSON
     */
    public static Leaderboard create(final JSONObject json) {

        final Leaderboard board = new Leaderboard();

        board.userLeader = new ArrayList<String>();
        board.scoreLeader = new ArrayList<Integer>();

        try {
            final JSONArray arr = json.getJSONArray("arr");

            for (int i = 0; i < arr.length(); i++) {
                final JSONObject user = arr.getJSONObject(i);

                final String uname = user.getString("uname");
                final Integer score = user.getInt("score");

                board.userLeader.add(uname);
                board.scoreLeader.add(score);
            }

        } catch (final JSONException e) {
        }

        return board;
    }

    /**
     * Getter for individual leader board users.
     * 
     * @param i
     *            The index into the leader board to return.
     * @return The i-th position user in the leader board.
     */
    public String getUser(final int i) {
        return userLeader.get(i);
    }

    /**
     * Getter for individual leader board scores.
     * 
     * @param i
     *            The index into the leader board to return.
     * @return The i-th position score in the leader board.
     */
    public int getScore(final int i) {
        return scoreLeader.get(i).intValue();
    }

    /**
     * Getter for the size of the leader board.
     * 
     * @return an integer representing the size.
     */
    public int size() {
        return userLeader.size();
    }

}
