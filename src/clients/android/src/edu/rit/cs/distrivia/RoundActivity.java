package edu.rit.cs.distrivia;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.Toast;
import edu.rit.cs.distrivia.api.DistriviaAPI;

/**
 * Activity for players to answer questions during a round.
 */
public class RoundActivity extends Activity {


    // private EditText pass;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.round);

        //final Button login = (Button) findViewById(R.id.login_button);
        // pass = (EditText) findViewById(R.id.login_input_password);

        /*login.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(final View v) {
                // String passwd = pass.getText().toString().trim();
            }
        });*/
    }
}