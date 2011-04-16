package edu.rit.cs.distrivia;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.SystemClock;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import edu.rit.cs.distrivia.api.DistriviaAPI;
import edu.rit.cs.distrivia.api.Question;

/**
 * Activity for players to answer questions during a round.
 */
public class RoundActivity extends GameActivityBase {

    private long startTime = 0;
    private long stopTime = 0;
    private String selection = null;
    private TextView question;
    private Button answerA;
    private Button answerB;
    private Button answerC;
    private Button answerD;

    private final Handler loadHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if (gameData().isDone()) {
                Intent i = new Intent();
                i.setClassName("edu.rit.cs.distrivia",
                        "edu.rit.cs.distrivia.LeaderboardActivity");
                startActivity(i);
            } else {
                setupButtons(gameData().getQuestion());
            }
        }
    };

    OnClickListener answerListener = new OnClickListener() {
        @Override
        public void onClick(final View v) {
            stopTime = SystemClock.elapsedRealtime();

            deselectAll();
            final Button answer = (Button) v;
            answer.setSelected(true);
            answer.setTextColor(Color.BLUE);
            if (answer == answerA)
                selection = "a";
            else if (answer == answerB)
                selection = "b";
            else if (answer == answerC)
                selection = "c";
            else if (answer == answerD)
                selection = "d";
        }
    };

    /** Called when the activity is first created. */
    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.round);

        question = (TextView) findViewById(R.id.question);
        answerA = (Button) findViewById(R.id.answer1_button);
        answerB = (Button) findViewById(R.id.answer2_button);
        answerC = (Button) findViewById(R.id.answer3_button);
        answerD = (Button) findViewById(R.id.answer4_button);
        Button submit = (Button) findViewById(R.id.answer_submit_button);
        submit.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (selection != null) {
                    submitAndLoad();

                } else {
                    Toast.makeText(v.getContext(), "Please select an answer",
                            10).show();
                }
            }
        });

        answerA.setOnClickListener(answerListener);
        answerB.setOnClickListener(answerListener);
        answerC.setOnClickListener(answerListener);
        answerD.setOnClickListener(answerListener);

        setupButtons(gameData().getQuestion());

        // Store time which the screen stopped rendering.
        startTime = SystemClock.elapsedRealtime();
    }

    private void submitAndLoad() {
        final long decisionTime = stopTime - startTime;
        new Thread() {
            @Override
            public void run() {
                try {
                    setGameData(DistriviaAPI.answer(gdata, selection,
                            decisionTime));
                } catch (final Exception e) {
                    e.printStackTrace();
                    return;
                }
                // Signal UI thread to reload
                loadHandler.sendEmptyMessage(0);
            }
        }.start();
    }

    /**
     * Fill out the button's with question data
     */
    private void setupButtons(final Question q) {
        question.setText(q.getQuestion());
        answerA.setText("A: " + q.getChoiceA());
        answerB.setText("B: " + q.getChoiceB());
        answerC.setText("C: " + q.getChoiceC());
        answerD.setText("D: " + q.getChoiceD());
        deselectAll();
    }

    /**
     * Reset all buttons to normal state.
     */
    private void deselectAll() {
        answerA.setSelected(false);
        answerB.setSelected(false);
        answerC.setSelected(false);
        answerD.setSelected(false);

        answerA.setTextColor(Color.BLACK);
        answerB.setTextColor(Color.BLACK);
        answerC.setTextColor(Color.BLACK);
        answerD.setTextColor(Color.BLACK);
        selection = null;
    }

}