package edu.rit.cs.distrivia;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.widget.Toast;
import edu.rit.cs.distrivia.model.GameData;

/**
 *
 */
public class GameActivityBase extends Activity {

    /**  */
    public final String LOGIN_ACTIVITY = "LoginActivity";
    /**  */
    public final String JOIN_ACTIVITY = "JoinActivity";
    /**  */
    public final String ROUND_ACTIVITY = "RoundActivity";
    /**  */
    public final String LEADERBOARD_ACTIVITY = "LeaderboardActivity";
    /**  */
    public final String ACTIVITY_ROOT = "edu.rit.cs.distrivia";

    /** Game data storage for this activity */
    public GameData gdata = null;
    private final String GAME_DATA = "game_data";
    
    /** Handler to move onto the next Activity on successful login. */
    private final Handler startHandler = new Handler() {
        @Override
        public void handleMessage(final Message msg) {
            String className = msg.getData().getString("class");
            Intent intent = new Intent();
            intent.setClassName(ACTIVITY_ROOT, ACTIVITY_ROOT + "." + className);
            startActivity(intent);
        }
    };

    /** Handler to make toast notifications from the Networking thread. */
    private final Handler toastHandler = new Handler() {
        @Override
        public void handleMessage(final Message msg) {
            // Cancel the loading dialog since something obviously happened.
            String txtmsg = msg.getData().getString("msg");
            Toast.makeText(getApplicationContext(), txtmsg, 10).show();
        }
    };

    /**
     * Start the next activity
     * 
     * @param className
     *            The class name to launch.
     */
    public void startActivity(final String className) {
        Bundle data = new Bundle();
        data.putString("class", className);
        Message msg = new Message();
        msg.setData(data);
        startHandler.sendMessage(msg);
    }

    @Override
    public void onCreate(final Bundle savedInstance) {
        super.onCreate(savedInstance);
        this.gdata = (GameData) getIntent().getExtras().getSerializable(
                GAME_DATA);
    }

    @Override
    public void startActivity(final Intent i) {
        i.putExtra(GAME_DATA, gdata);
        super.startActivity(i);
    }

    /**
     * Toast the given text to the user, in the UI thread.
     * 
     * @param txtMsg
     *            text text to toast.
     */
    public void makeToast(final String txtMsg) {
        Bundle data = new Bundle();
        data.putString("msg", txtMsg);
        Message msg = new Message();
        msg.setData(data);
        toastHandler.sendMessage(msg);
    }

    /**
     * @return The current GameData for this Activity.
     */
    public GameData gameData() {
        return gdata;
    }

    /**
     * Set the current game data.
     * 
     * @param gd
     *            The game data to set.
     */
    public void setGameData(GameData gd) {
        this.gdata = gd;
    }
}
