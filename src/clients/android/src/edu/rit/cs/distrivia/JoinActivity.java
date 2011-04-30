package edu.rit.cs.distrivia;

import android.os.Bundle;
import android.os.SystemClock;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;
import edu.rit.cs.distrivia.api.DistriviaAPI;

/**
 * Activity for players to answer questions during a round.
 */
public class JoinActivity extends GameActivityBase {

    private final int UPDATE_MS = 5000;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.join);

        final Button pubButton = (Button) findViewById(R.id.join_public_button);
        final Button priJoinButton = (Button) findViewById(R.id.join_private_button);
        final Button priCreateButton = (Button) findViewById(R.id.create_private_button);
        final Button priStartButton = (Button) findViewById(R.id.start_private_button);
        final Button lbButton = (Button) findViewById(R.id.view_leaderboard_button);
        final TextView playersLabel = (TextView) findViewById(R.id.num_players_text);
        final EditText privateName = (EditText) findViewById(R.id.private_name_text);
        final EditText privatePass = (EditText) findViewById(R.id.private_pass_text);
        final LinearLayout publicLayout = (LinearLayout) findViewById(R.id.public_layout);
        final LinearLayout privateLayout = (LinearLayout) findViewById(R.id.private_layout); 
        final Spinner spinner = (Spinner) findViewById(R.id.private_qnum_spin);
        
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(
                this, R.array.qnum_array, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);
        spinner.setSelection(1);
        
        priStartButton.setVisibility(View.GONE);

        pubButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(final View v) {
                privateLayout.setVisibility(View.GONE);
                lbButton.setVisibility(View.GONE);
                v.setEnabled(false);
                playersLabel.setText("Waiting to join public game...");
                joinPublic();
            }
        });

        priJoinButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(final View v) {
                String name = privateName.getText().toString().trim();
                String pass = privatePass.getText().toString().trim();
                if (!name.equals("") && !pass.equals("")) {
                    publicLayout.setVisibility(View.GONE);
                    lbButton.setVisibility(View.GONE);
                    v.setEnabled(false);
                    priCreateButton.setEnabled(false);
                    playersLabel.setText("Waiting to join private game...");
                    joinPrivate(name, pass);
                } else {
                    makeToast("Enter name and pass");
                }
            }
        });
        
        priCreateButton.setOnClickListener(new OnClickListener() {
        	@Override
        	public void onClick(final View v) {
        		String name = privateName.getText().toString().trim();
                String pass = privatePass.getText().toString().trim();
                if (!name.equals("") && !pass.equals("")) {
                    publicLayout.setVisibility(View.GONE);
                    lbButton.setVisibility(View.GONE);
                    v.setVisibility(View.GONE);
                    priJoinButton.setVisibility(View.GONE);
                    priStartButton.setVisibility(View.VISIBLE);
                    spinner.setEnabled(false);
                    privateName.setFocusable(false);
                    privatePass.setFocusable(false);
                    playersLabel.setText("Press Start Game when you're ready to begin...");
                    int numQs = Integer.parseInt((String)spinner.getSelectedItem());
                    createPrivate(name, pass, numQs);
                } else {
                    makeToast("Enter name and pass");
                }
        	}
        });
        
        priStartButton.setOnClickListener(new OnClickListener() {
        	@Override
        	public void onClick(final View v) {
        		v.setEnabled(false);
        		playersLabel.setText("Starting...");
        		startPrivate();
        	}
        });

        lbButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(final View v) {
                startActivity(LEADERBOARD_ACTIVITY);
                finish();
            }
        });
    }

    /**
     * Join public game, start's a new thread to do network IO
     */
    private void joinPublic() {
        new Thread() {
            @Override
            public void run() {
                try {
                    setGameData(DistriviaAPI.join(gameData()));
                } catch (Exception e) {
                    makeToast("Service is down, please try again later");
                    return;
                }

                boolean joinSuccessful = gameData().getGameID() != null;
                joinSuccessful &= (!gameData().getGameID().equals(
                        DistriviaAPI.API_ERROR));
                if (!joinSuccessful) {
                    makeToast("Join failure");
                    return;
                }

                try {
                    while (true) {
                        setGameData(DistriviaAPI.status(gameData()));
                        if (!gameData().isWaiting()) {
                            break;
                        }
                        SystemClock.sleep(UPDATE_MS);
                    }
                } catch (Exception e) {
                    makeToast("Service is down, please try again later");
                    return;
                }
                startActivity(ROUND_ACTIVITY);
                finish();
            }
        }.start();
    }
    
    /**
     * Creates a private game and waits till the player chooses to start the game
     * 
     * @param name
     * @param pass
     * @param numQs
     */
    private void createPrivate(final String name, final String pass, final int numQs) {
    	new Thread() {
    		@Override
    		public void run() {
    			try {
    				setGameData(DistriviaAPI.createPrivate(gameData(), name, pass, numQs));
    			}
    			catch (Exception e) {
    				makeToast("Service is down, please try again later");
    				return;
    			}
    			boolean createSuccessful = gameData().getGameID() != null;
    			createSuccessful &= (!gameData().getGameID().equals(
                        DistriviaAPI.API_ERROR));
    			if (!createSuccessful) {
    				makeToast("Create failure");
    				return;
    			}
    		}
    	}.start();
    }
    
    private void joinPrivate(final String name, final String pass) {
    	new Thread() {
    		@Override
    		public void run() {
    			try {
    				setGameData(DistriviaAPI.joinPrivate(gameData(), name, pass));
    			}
    			catch (Exception e) {
    				makeToast("Service is down, please try again later");
    				return;
    			}
    			boolean joinSuccessful = gameData().getGameID() != null;
    			joinSuccessful &= (!gameData().getGameID().equals(
                        DistriviaAPI.API_ERROR));
    			if (!joinSuccessful) {
    				makeToast("Join failure");
    				return;
    			}
    			try {
                    while (true) {
                        setGameData(DistriviaAPI.status(gameData()));
                        if (!gameData().isWaiting()) {
                            break;
                        }
                        SystemClock.sleep(UPDATE_MS);
                    }
                } catch (Exception e) {
                    makeToast("Service is down, please try again later");
                    return;
                }
    			startActivity(ROUND_ACTIVITY);
                finish();
    		}
    	}.start();
    }
    
    private void startPrivate() {
    	new Thread() {
    		@Override
    		public void run() {
    			try {
    				if (DistriviaAPI.startPrivate(gameData())) {
    					makeToast("Game started!");
    				} else {
    					makeToast("Game could not start");
    				}
    			}
    			catch (Exception e) {
    				makeToast("Service is down, please try again later");
    				return;
    			}
    			try {
                    while (true) {
                        setGameData(DistriviaAPI.status(gameData()));
                        if (!gameData().isWaiting()) {
                            break;
                        }
                        SystemClock.sleep(UPDATE_MS);
                    }
                } catch (Exception e) {
                    makeToast("Service is down, please try again later");
                    return;
                }
    			startActivity(ROUND_ACTIVITY);
                finish();
    		}
    	}.start();
    }

}