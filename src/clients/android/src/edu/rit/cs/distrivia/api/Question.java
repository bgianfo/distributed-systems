package edu.rit.cs.distrivia.api;

import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 */
public class Question {

    private String question;
    private String choiceA;
    private String choiceB;
    private String choiceC;
    private String choiceD;

    // Prevent construction without factory
    private Question() {
    }

    /**
     * Factory method to create a question from JSON.
     * 
     * @param arr
     *            The JSON object from the server.
     * @return A properly initialized question
     */
    public static Question create(final JSONObject arr) {
        final Question q = new Question();
        try {
            q.question = arr.getString("question");
            q.choiceA = arr.getString("a");
            q.choiceB = arr.getString("b");
            q.choiceC = arr.getString("c");
            q.choiceD = arr.getString("d");
        } catch (final JSONException e) {
        }
        return q;
    }

    /**
     * Getter for the question text.
     * 
     * @return A String containing the question text
     */
    public String getQuestion() {
        return question;
    }

    /**
     * Getter for the "A" choice for this question.
     * 
     * @return This choices text String.
     */
    public String getChoiceA() {
        return choiceA;
    }

    /**
     * Getter for the "B" choice for this question.
     * 
     * @return This choices text String.
     */
    public String getChoiceB() {
        return choiceB;
    }

    /**
     * Getter for the "C" choice for this question.
     * 
     * @return This choices text String.
     */
    public String getChoiceC() {
        return choiceC;
    }

    /**
     * Getter for the "D" choice for this question.
     * 
     * @return This choices text String.
     */
    public String getChoiceD() {
        return choiceD;
    }
}