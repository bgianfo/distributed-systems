package edu.rit.cs.distrivia;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View.OnKeyListener;
import android.view.KeyEvent;
import android.util.Log;
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
    private EditText pass;
    private Button loginBut;
    private Button registerBut;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.main);

        loginBut = (Button) findViewById(R.id.login_button);
        registerBut = (Button) findViewById(R.id.register_button);
        uname = (EditText) findViewById(R.id.login_input_username);
        pass = (EditText) findViewById(R.id.login_input_password);

        SharedPreferences settings = getPreferences(MODE_PRIVATE);
        String userName = settings.getString("uname", "");
        uname.setText(userName);

        // Listener for login button
        loginBut.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(final View v) {
                final String name = uname.getText().toString().trim();
                final String passwd = pass.getText().toString().trim();
                if (!name.equals("") && !passwd.equals("")) {
                    login(name, passwd);
                } else {
                    Toast.makeText(getApplicationContext(),
                            "Missing username or password", 10).show();
                }
            }
        });

        // Listener for register button
        registerBut.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(final View v) {
                final String name = uname.getText().toString().trim();
                final String passwd = pass.getText().toString().trim();
                if (!name.equals("") && !passwd.equals("")) {
                    register(name, passwd);
                } else {
                    Toast.makeText(getApplicationContext(),
                            "Missing username or password", 10).show();
                }
            }
        });
        
        // Listener for enter key on password field
        pass.setOnKeyListener(new OnKeyListener() {
        	public boolean onKey(View v, int keyCode, KeyEvent event) {
        		if ((event.getAction() == KeyEvent.ACTION_DOWN) && 
        				(keyCode == KeyEvent.KEYCODE_ENTER)) {
        			final String name = uname.getText().toString().trim();
                    final String passwd = pass.getText().toString().trim();
                    if (!name.equals("") && !passwd.equals("")) {
                        login(name, passwd);
                    } else {
                        Toast.makeText(getApplicationContext(),
                                "Missing username or password", 10).show();
                    }
        			return true;
                }
        		return false;
        	}
        });
    }

    private void login(String name, String passwd) {
        Context context = getApplicationContext();
        loginBut.setEnabled(false);
        registerBut.setEnabled(false);

        String authToken = null;
        try {
            authToken = DistriviaAPI.login(name, passwd);
        } catch (Exception e) {
            Log.d("Exception:", e.getMessage());
            Toast.makeText(context, "Service is down, please try again later",
                    10).show();
            loginBut.setEnabled(true);
            registerBut.setEnabled(true);
            return;
        }

        boolean loginSuccessful = authToken != null;
        loginSuccessful &= (!authToken.equals(DistriviaAPI.API_ERROR));

        if (loginSuccessful) {
            SharedPreferences settings = getPreferences(MODE_PRIVATE);
            SharedPreferences.Editor editor = settings.edit();
            editor.putString("uname", name);
            editor.commit();

            Toast.makeText(context, "Welcome " + name, 10).show();
            GameData gd = new GameData(authToken, name);
            Intent joinIntent = new Intent(context, JoinActivity.class);
            // Make sure to pass session/game data to the next view
            joinIntent.putExtra("game_data", gd);
            startActivity(joinIntent);

        } else {
            Toast.makeText(getApplicationContext(), "Login failure", 10).show();
            loginBut.setEnabled(true);
            registerBut.setEnabled(true);
        }
    }

    private void register(String name, String passwd) {
        Context context = getApplicationContext();
        loginBut.setEnabled(false);
        registerBut.setEnabled(false);
        
        String authToken = null;
        try {
            authToken = DistriviaAPI.register(name, passwd);
        } catch (Exception e) {
            Toast.makeText(context, "Service is down, please try again later",
                    10).show();
            loginBut.setEnabled(true);
            registerBut.setEnabled(true);
            return;
        }

        boolean registerSuccessful = authToken != null;
        registerSuccessful &= (!authToken.equals(DistriviaAPI.API_ERROR));

        if (registerSuccessful) {
            SharedPreferences settings = getPreferences(MODE_PRIVATE);
            SharedPreferences.Editor editor = settings.edit();
            editor.putString("uname", name);
            editor.commit();

            Toast.makeText(context, "Welcome " + name, 10).show();
            GameData gd = new GameData(authToken, name);
            Intent joinIntent = new Intent(context, JoinActivity.class);
            // Make sure to pass session/game data to the next view
            joinIntent.putExtra("game_data", gd);
            startActivity(joinIntent);

        } else {
            Toast.makeText(getApplicationContext(), "Register failure", 10)
                    .show();
            loginBut.setEnabled(true);
            registerBut.setEnabled(true);
        }
    }
}
