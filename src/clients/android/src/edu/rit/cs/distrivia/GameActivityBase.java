package edu.rit.cs.distrivia;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import edu.rit.cs.distrivia.model.GameData;

/**
 *
 */
public class GameActivityBase extends Activity {

    public GameData gdata;
    private final String GAME_DATA = "game_data";

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

    public GameData gameData() {
        return gdata;
    }

    public void setGameData(GameData gd) {
        this.gdata = gd;
    }
}
