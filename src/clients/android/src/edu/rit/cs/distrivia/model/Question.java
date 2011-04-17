package edu.rit.cs.distrivia.model;

import java.io.Serializable;

import org.json.JSONException;

import edu.rit.cs.distrivia.api.JSON;

/**
 *
 */
public class Question implements Serializable {

    /**
     * Serializeable UID
     */
    private static final long serialVersionUID = 2103199974823935456L;

    private String id;
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
     * @param parser
     *            The JSON object from the server.
     * @return A properly initialized question
     */
    public static Question create(final JSON parser) {
        final Question q = new Question();
        try {
            q.question = parser.question();
            q.choiceA = parser.a();
            q.choiceB = parser.b();
            q.choiceC = parser.c();
            q.choiceD = parser.d();
            q.id = parser.qid();
        } catch (final JSONException e) {
            e.printStackTrace();
        }
        return q;
    }

    /**
     * Generate a dummy question object.
     * 
     * @return A dummy question
     */
    public static Question dummy() {
        final Question q = new Question();
        q.question = "Who is awesome?";
        q.choiceA = "Sam";
        q.choiceB = "Sticky";
        q.choiceC = "Brian";
        q.choiceD = "Raj";
        q.id = "xclkjalsdfj";
        return q;
    }

    /**
     * Getter for the question ID.
     * 
     * @return A String containing the question ID.
     */
    public String id() {
        return id;
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