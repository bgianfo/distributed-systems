package edu.rit.cs.distrivia;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import edu.rit.cs.distrivia.api.DistriviaAPI;
import edu.rit.cs.distrivia.model.GameData;

/**
 * Main activity to provide login functionality to the Application.
 */
public class LoginActivity extends Activity {

    private EditText uname;

    // private EditText pass;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.main);

        final Button login = (Button) findViewById(R.id.login_button);
        uname = (EditText) findViewById(R.id.login_input_username);
        // pass = (EditText) findViewById(R.id.login_input_password);

        login.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(final View v) {
                final String name = uname.getText().toString().trim();
                // String passwd = pass.getText().toString().trim();

                final String authToken = "";// DistriviaAPI.login(name);
                final boolean loginSuccessful = authToken != null;

                if (loginSuccessful) {
                    Toast.makeText(getApplicationContext(),
                            "Welcome back, " + name, 10).show();
                    Intent joinIntent = new Intent();
                    joinIntent.setClassName("edu.rit.cs.distrivia",
                            "edu.rit.cs.distrivia.JoinActivity");
                    startActivity(joinIntent);
                } else {
                    Toast.makeText(getApplicationContext(), "Login failure", 10)
                            .show();
                }
            }
        });
    }

    private void login(String name, String pass) {

        Context context = getApplicationContext();

        String authToken = null;
        try {
            authToken = DistriviaAPI.login(name);
        } catch (Exception e) {
            Toast.makeText(context, "Service is down, please try gain later",
                    10).show();
            return;
        }

        boolean loginSuccessful = authToken != null;
        loginSuccessful &= (!authToken.equals(DistriviaAPI.API_ERROR));

        if (loginSuccessful) {

            Toast.makeText(context, "Welcome " + name, 10).show();
            GameData gd = new GameData(authToken, name);
            Intent joinIntent = new Intent(context, JoinActivity.class);
            // Make sure to pass session/game data to the next view
            joinIntent.putExtra(GameData.class.getName(), gd);
            startActivity(joinIntent);

        } else {
            Toast.makeText(getApplicationContext(), "Login failure", 10).show();
        }
    }
}