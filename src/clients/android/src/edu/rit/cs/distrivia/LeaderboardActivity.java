package edu.rit.cs.distrivia;

import android.graphics.Color;
import android.os.Bundle;
import android.os.SystemClock;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;
import edu.rit.cs.distrivia.api.DistriviaAPI;
import edu.rit.cs.distrivia.model.GameData;

/**
 * Activity for players to answer questions during a round.
 */
public class LeaderboardActivity extends GameActivityBase {
    final int USER = 0;
    final int SCORE = 1;
    final int NAME_WIDTH = 200;
    private final int UPDATE_MS = 5000;
    TableLayout leaderTable;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.leaderboard);

        final Button okBut = (Button) findViewById(R.id.lead_complete);
        leaderTable = (TableLayout) findViewById(R.id.leader_table);
        leaderTable.setStretchAllColumns(true);
        loadTable(gameData().loadLocal());
        if (gameData().loadLocal()) {
        	updateTable();
        }
        
        okBut.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                GameData gd = gameData();
                gd.setLoadLocal(false);
                setGameData(gd);
                startActivity(JOIN_ACTIVITY);
            }
        });
    }

    /**
     * loads the leaderboard table with user/score data
     * 
     * @param loadLocal - grab local data if true, global if false
     */
    private void loadTable(boolean loadLocal) {
    	String[][] board = null;
    	String userName = gameData().getUserName();
    	if (loadLocal) {
    		board = gameData().getLeaderboard();
    	}
    	else {
    		try {
    			board = DistriviaAPI.leaderBoard(gameData());
    		} catch (Exception e) {
    			Log.d("Load leaderboard: ", e.getMessage());
    			makeToast("The network is DOWN!");
    			return;
    		}
    	}
        for (int i = 0; i < board.length; i++) {
            if (!board[i][USER].equals("status")) {
                TableRow row = new TableRow(getApplicationContext());
                TextView name = new TextView(getApplicationContext());
                TextView score = new TextView(getApplicationContext());

                name.setText(board[i][USER]);
                name.setWidth(NAME_WIDTH);
                score.setText(board[i][SCORE]);
                if (board[i][USER].equals(userName)) {
                	name.setTextColor(Color.GREEN);
                	score.setTextColor(Color.GREEN);
                }

                row.addView(name);
                row.addView(score);
                leaderTable.addView(row);
            }
        }
    }
    
    private void updateTable() {
        new Thread() {
            @Override
            public void run() {
            	SystemClock.sleep(UPDATE_MS);
                try {
                    while (true) {
                        setGameData(DistriviaAPI.status(gameData()));
                        loadTable(true);
                        SystemClock.sleep(UPDATE_MS);
                    }
                } catch (Exception e) {
                    makeToast("Service is down, please try again later");
                    return;
                }
            }
        }.start();
    }
}