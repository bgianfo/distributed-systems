package edu.rit.cs.distrivia;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.Window;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;
import android.widget.Toast;
import edu.rit.cs.distrivia.api.DistriviaAPI;
import edu.rit.cs.distrivia.model.GameData;

/**
 * Activity for players to answer questions during a round.
 */
public class LeaderboardActivity extends Activity {

    TableLayout leaderTable;
    GameData gd;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.leaderboard);

        gd = (GameData) getIntent().getExtras().getSerializable("game_data");

        leaderTable = (TableLayout) findViewById(R.id.leader_table);
        leaderTable.setStretchAllColumns(true);
        loadTable();
    }

    private void loadTable() {
        final int USER = 0;
        final int SCORE = 1;
        String[][] board = null;
        try {
            board = DistriviaAPI.leaderBoard(gd);
        } catch (Exception e) {
            Toast.makeText(getApplicationContext(), "The network is DOWN!", 100)
                    .show();
            Log.d("Load leaderboard: ", e.getMessage());
            return;
        }
        if (board == null) {
            return;
        }
        for (int i = 0; i < board.length; i++) {
            TableRow row = new TableRow(getApplicationContext());
            TextView name = new TextView(getApplicationContext());
            name.setText(board[i][USER]);
            name.setWidth(200);
            TextView score = new TextView(getApplicationContext());
            score.setText(board[i][SCORE]);
            row.addView(name);
            row.addView(score);
            leaderTable.addView(row);
        }
    }
}