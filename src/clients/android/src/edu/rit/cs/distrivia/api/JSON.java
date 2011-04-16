package edu.rit.cs.distrivia.api;

import java.util.Comparator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Stores response information from a server request
 */
public class JSON {

    public static final String STARTED = "started";
    public static final String WAITING = "waiting";
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
     * @return
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
     * Gets an array of leaderboard data
     */
    @SuppressWarnings("unchecked")
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
     * Gets the question text
     */
    public String question() throws JSONException {
        return json.getString("question");
    }

    /**
     * Gets the first response option
     */
    public String a() throws JSONException {
        return json.getString("a");
    }

    /**
     * Gets the second response option
     */
    public String b() throws JSONException {
        return json.getString("b");
    }

    /**
     * Gets the third response option
     */
    public String c() throws JSONException {
        return json.getString("c");
    }

    /**
     * Gets the fourth response option
     */
    public String d() throws JSONException {
        return json.getString("d");
    }

    /**
     * Gets all the response options, in order
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
     */
    public String qid() throws JSONException {
        return json.getString("qid");
    }

    /**
     * Gets the game status
     */
    public String gamestatus() throws JSONException {
        return json.getString("gamestatus");
    }

    /**
     * Gets the game's id
     */
    public String gameid() throws JSONException {
        return json.getString("id");
    }

    public static void main(final String args[]) {
        try {
            final JSON b = new JSON(
                    "{\"a\": \"You can't see when it's dry.\", \"status\": 1, \"c\": \"Paint needs sunlight to dry.\", \"b\": \"This may cause a thin film of oil to rise to the surface, yellowing it.\", \"qid\": \"art-1\", \"question\": \"In oil painting, why shouldn't you dry your paintings in the dark?\", \"gamestatus\": \"started\", \"id\": \"59a54bc6-63f4-11e0-8cba-12313b0a1c71\", \"leaderboard\": {\"bob\": 0, \"sam\": 0}, \"d\": \"It will stay wet and eventually go mouldy.\"}");
            System.out.println(b.status());
            final String[][] board = b.leaderboard();
            for (int i = 0; i < board.length; i++) {
                for (int k = 0; k < 2; k++) {
                    System.out.print(board[i][k] + "\t");
                }
                System.out.println();
            }
            System.out.println(b.question());
            final String[] ans = b.answers();
            for (final String an : ans) {
                System.out.println(an);
            }
            System.out.println(b.gameid());
        } catch (final JSONException e) {
            e.printStackTrace();
        }
    }
}