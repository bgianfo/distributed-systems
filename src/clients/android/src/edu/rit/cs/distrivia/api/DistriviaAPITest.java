/**
 * 
 */
package edu.rit.cs.distrivia.api;

import java.util.UUID;

import junit.framework.TestCase;

// import android.test.AndroidTestCase;

/**
 *
 */
public class DistriviaAPITest extends TestCase {

    private String username;

    /**
     * Test constructor
     * 
     * @param name
     */
    public DistriviaAPITest() {
        super("Distrivia API Test runner");
    }

    /**
     * @see junit.framework.TestCase#setUp()
     */
    @Override
    protected void setUp() throws Exception {
        super.setUp();
        username = UUID.randomUUID().toString();
    }

    @Override
    protected void tearDown() throws Exception {

    }

    /***/
    public void testRegister() throws Exception {
        String rv = DistriviaAPI.register(username);
        assertEquals(DistriviaAPI.API_SUCCESS, rv);

        String rv2 = DistriviaAPI.register(username);
        assertEquals(DistriviaAPI.API_ERROR, rv2);
    }

    /**/
    public void testLogin() throws Exception {
        DistriviaAPI.register(username);
        String token = null;
        try {
            token = DistriviaAPI.login(username);
        } catch (DistriviaAPIException e) {
            fail("Login threw exception");
        }
        assertNotNull(token);
    }

    /**
     */
    public void testJoin() throws Exception {
        DistriviaAPI.register(username);
        String token = DistriviaAPI.login(username);
        String gid = DistriviaAPI.join(token, username);
        assertNotNull(gid);
        assertTrue(!gid.equals(DistriviaAPI.API_ERROR));
    }

    public void testFirstQuestion() throws Exception {
        DistriviaAPI.register(username);
        String token = DistriviaAPI.login(username);
        String gid = DistriviaAPI.join(token, username);
        Question q = DistriviaAPI.firstQuestion(token, gid);
        assertNotNull(q);
        assertTrue(!q.id().equals(""));
        assertTrue(!q.getChoiceA().equals(""));
        assertTrue(!q.getChoiceB().equals(""));
        assertTrue(!q.getChoiceC().equals(""));
        assertTrue(!q.getChoiceD().equals(""));
        assertTrue(!q.getQuestion().equals(""));

    }

    public static void main(String[] args) {
        junit.textui.TestRunner.run(DistriviaAPITest.class);
    }
}
