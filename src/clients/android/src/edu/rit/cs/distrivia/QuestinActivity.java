package edu.rit.cs.distrivia;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

/**
 * Main activity to provide login functionality to the Application.
 */
public class QuestinActivity extends Activity {

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
}