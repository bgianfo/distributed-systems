package edu.rit.cs.distrivia.api;

import org.json.JSONException;
import org.json.JSONObject;

public class Question {
    
    private String question;
    private String choiceA;
    private String choiceB;
    private String choiceC;
    private String choiceD;
    
    // Prevent construction without factory
    private Question() {}
    
    /**
     * Factory method to create a question from JSON. 
     * @param arr The JSON object from the server.
     * @return A properly initialized question
     */
    public static Question create( JSONObject arr ) {
        Question q = new Question();
        try {
            q.setQuestion( arr.getString("question") );
            q.setChoiceA( arr.getString("a") );
            q.setChoiceB( arr.getString("b") );
            q.setChoiceC( arr.getString("c") );
            q.setChoiceD( arr.getString("d") );
        } catch (JSONException e) {
        }
        return q;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getChoiceA() {
        return choiceA;
    }

    public void setChoiceA(String choiceA) {
        this.choiceA = choiceA;
    }

    public String getChoiceB() {
        return choiceB;
    }

    public void setChoiceB(String choiceB) {
        this.choiceB = choiceB;
    }

    public String getChoiceC() {
        return choiceC;
    }

    public void setChoiceC(String choiceC) {
        this.choiceC = choiceC;
    }

    public String getChoiceD() {
        return choiceD;
    }

    public void setChoiceD(String choiceD) {
        this.choiceD = choiceD;
    }
}