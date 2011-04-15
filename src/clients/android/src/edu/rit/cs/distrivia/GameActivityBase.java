package edu.rit.cs.distrivia;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import edu.rit.cs.distrivia.model.GameData;

/**
 *
 */
public class GameActivityBase extends Activity {

    private GameData gd;
    private final String GAME_DATA = "game_data";

    @Override
    public void onCreate(final Bundle savedInstance) {
        super.onCreate(savedInstance);
        this.gd = (GameData) getIntent().getExtras().getSerializable(GAME_DATA);
    }

    @Override
    public void startActivity(final Intent i) {
        i.putExtra(GAME_DATA, gd);
        super.startActivity(i);
    }

}
