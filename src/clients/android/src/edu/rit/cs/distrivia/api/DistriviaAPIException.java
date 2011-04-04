package edu.rit.cs.distrivia.api;

/**
 *
 */
public class DistriviaAPIException extends Exception {

    /**
	 * 
	 */
	private static final long serialVersionUID = 2837222363918046817L;

	/**
     * 
     */
    public DistriviaAPIException() {
        // TODO Auto-generated constructor stub
    }

    /**
     * @param detailMessage
     */
    public DistriviaAPIException(String detailMessage) {
        super(detailMessage);
        // TODO Auto-generated constructor stub
    }

    /**
     * @param throwable
     */
    public DistriviaAPIException(Throwable throwable) {
        super(throwable);
    }

    /**
     * @param detailMessage
     * @param throwable
     */
    public DistriviaAPIException(String detailMessage, Throwable throwable) {
        super(detailMessage, throwable);
    }

}
