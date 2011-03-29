package edu.rit.cs.distrivia;

import android.app.Activity;
import android.os.Bundle;
import android.view.Window;


/**
 * Activity for players to answer questions during a round.
 */
public class LeaderboardActivity extends Activity {

    //private String authToken;
    //private String gameId;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.leaderboard);
    }

}