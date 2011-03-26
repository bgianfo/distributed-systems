package edu.rit.cs.distrivia;

import android.app.Activity;
import android.graphics.Color;
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
	
	OnClickListener answerListener = new OnClickListener() {
		@Override
		public void onClick(final View v) {
			final Button answer = (Button)v;
			if (!answer.isSelected()) {
				answer.setSelected(true);
				answer.setTextColor(Color.BLUE);
			}
			else {
				answer.setSelected(false);
				answer.setTextColor(Color.BLACK);
			}
		}
	};

    /** Called when the activity is first created. */
    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.round);

        final Button answer1 = (Button) findViewById(R.id.answer1_button);
        final Button answer2 = (Button) findViewById(R.id.answer2_button);
        final Button answer3 = (Button) findViewById(R.id.answer3_button);
        final Button answer4 = (Button) findViewById(R.id.answer4_button);

        answer1.setOnClickListener(answerListener);
        answer2.setOnClickListener(answerListener);
        answer3.setOnClickListener(answerListener);
        answer4.setOnClickListener(answerListener);
    }
}