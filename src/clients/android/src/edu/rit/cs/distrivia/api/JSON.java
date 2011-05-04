package edu.rit.cs.distrivia.api;

import java.util.Comparator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Stores response information from a server request
 */
public class JSON {

    /**
     * Game status constant for a started game.
     */
    public static final String STARTED = "started";

    /**
     * Game status constant for a game that is waiting to start.
     */
    public static final String WAITING = "waiting";

    /**
     * Game status constant for a completed game.
     */
    public static final String DONE = "done";

    private final JSONObject json;

    /**
     * @param server_data
     *            The string data to be parsed into json
     * @throws JSONException
     */
    public JSON(final String server_data) throws JSONException {
        json = new JSONObject(server_data);
    }

    /**
     * Gets the status code of the request
     * 
     * @return The status code
     * 
     * @throws JSONException
     */
    public int status() throws JSONException {
        return json.getInt("status");
    }

    /** Comparator for sorting the leader board */
    static class LeaderComparator implements Comparator<String[]> {
        @Override
        public int compare(final String[] o1, final String[] o2) {
            final int SCORE = 1;
            return Integer.parseInt(o2[SCORE]) - Integer.parseInt(o1[SCORE]);
        }
    }

    /**
     * Gets an array of leader board data
     * 
     * @return Sorted leader board in 2D array format. The first position is the
     *         Username, the score is the second position.
     * 
     * @throws JSONException
     */
    public String[][] leaderboard() throws JSONException {

        final String[][] board = new String[json.length()][json.length()];
        final JSONArray a = json.names();
        for (int i = 0; i < a.length(); i++) {
            final String key = a.getString(i);
            board[i][0] = key;
            board[i][1] = json.getString(key);
        }

        java.util.Arrays.sort(board, new LeaderComparator());

        return board;
    }

    /**
     * Get the score for a user in the current game.
     * 
     * @param user
     *            The user to get the user for.
     * @return The score of the user in the current game, or -1 on error
     * @throws JSONException
     */
    public int score(final String user) throws JSONException {

        final JSONObject board = json.getJSONObject("leaderboard");
        int score = -1;
        if (board.has(user)) {
            score = Integer.parseInt(board.getString(user));
        }
        return score;
    }

    /**
     * Gets an array of local leader board data
     * 
     * @return Sorted leader board in 2D array format. The first position is the
     *         Username, the score is the second position.
     * @throws JSONException
     */
    public String[][] localLeaderboard() throws JSONException {

        final JSONObject temp = json.getJSONObject("leaderboard");
        final JSONArray a = temp.names();
        final String[][] board = new String[a.length()][2];
        for (int i = 0; i < a.length(); i++) {
            final String key = a.getString(i);
            board[i][0] = key;
            board[i][1] = temp.getString(key);
        }

        java.util.Arrays.sort(board, new LeaderComparator());

        return board;
    }

    /**
     * Gets the question text
     * 
     * @return The question text
     * @throws JSONException
     */
    public String question() throws JSONException {
        return json.getString("question");
    }

    /**
     * Gets the first response option
     * 
     * @return The "A" answer for the question
     * @throws JSONException
     */
    public String a() throws JSONException {
        return json.getString("a");
    }

    /**
     * Gets the second response option
     * 
     * @return The "B" answer for the question
     * @throws JSONException
     */
    public String b() throws JSONException {
        return json.getString("b");
    }

    /**
     * Gets the third response option
     * 
     * @return The "C" answer for the question
     * @throws JSONException
     */
    public String c() throws JSONException {
        return json.getString("c");
    }

    /**
     * Gets the fourth response option
     * 
     * @return The "D" answer for the question
     * @throws JSONException
     */
    public String d() throws JSONException {
        return json.getString("d");
    }

    /**
     * Gets all the response options, in order
     * 
     * @return The array of answers
     * @throws JSONException
     */
    public String[] answers() throws JSONException {
        final String[] ans = new String[4];
        ans[0] = a();
        ans[1] = b();
        ans[2] = c();
        ans[3] = d();
        return ans;
    }

    /**
     * Gets the question id
     * 
     * @return The question id of the this question.
     * @throws JSONException
     */
    public String qid() throws JSONException {
        return json.getString("qid");
    }

    /**
     * Gets the game status
     * 
     * @return The current status of the game.
     * @throws JSONException
     */
    public String gamestatus() throws JSONException {
        return json.getString("gamestatus");
    }

    /**
     * Gets the game's id
     * 
     * @return The current uuid of the game we are in.
     * @throws JSONException
     */
    public String gameid() throws JSONException {
        return json.getString("id");
    }
}