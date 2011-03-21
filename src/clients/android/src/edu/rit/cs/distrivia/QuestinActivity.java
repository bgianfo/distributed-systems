package edu.rit.cs.distrivia;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class QuestinActivity extends Activity {
	private EditText uname;
	private EditText pass;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        Button login = (Button)findViewById( R.id.login_button );
		uname = (EditText)findViewById( R.id.login_input_username );
		pass = (EditText)findViewById( R.id.login_input_password );

		login.setOnClickListener( new OnClickListener(){
			@Override
			public void onClick( View v ){
				String name = uname.getText().toString().trim();
				String paswd = pass.getText().toString().trim();

				if( !name.equals( "" ) && !paswd.equals( "" ) ){
					Toast.makeText( getApplicationContext(), "Welcome back, " + uname.getText().toString(), 10 ).show();
				}else{
					Toast.makeText( getApplicationContext(), "Incorrect Login", 10 ).show();
				}
			}
		} );
    }
}