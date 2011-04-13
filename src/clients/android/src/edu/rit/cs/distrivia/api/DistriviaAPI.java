package edu.rit.cs.distrivia.api;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpHost;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.SingleClientConnManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;
import edu.rit.cs.distrivia.model.GameData;

/**
 * Main utility class which can talk to the Distrivia web service over
 * HTTP/HTTPS.
 */
public class DistriviaAPI {

    private static HttpClient httpClient = createHttpClient();
    final private static String API_PROTOCOL = "https";
    final private static String API_ROOT = "distrivia.lame.ws";
    final private static String API_URL = API_PROTOCOL + "://" + API_ROOT;
    final private static int API_PORT = 443;

    /** Constant representing API error */
    final public static String API_ERROR = "err";

    /** Constant representing API success */
    final public static String API_SUCCESS = "suc";

    /**
     * API call to login to Distrivia with a specific user name.
     * 
     * @param userName
     *            The user name to attempt to login to distrivia with.
     * @param pass
     *            The user's password for authentication
     * 
     * @return The authorization users token on success, otherwise null on
     *         authentication failure.
     * 
     * @throws Exception
     */
    public static String login(final String userName, final String pass)
            throws Exception {
        String url = new String();
        url += "/login/" + userName;

        final List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("password", pass));

        final String data = post(url, params);

        if (data == API_ERROR) {
            throw new DistriviaAPIException("Login Failed");
        } else {
            Log.d("DistriviaAPI", "The auth token: " + data);
            return data;
        }
    }

    /**
     * API Call to register a new user
     * 
     * @param username
     *            The user name to register with the service.
     * @param pass
     * @return True on register success, false on register failure.
     * @throws Exception
     */
    public static String register(final String username, final String pass)
            throws Exception {

        String url = new String();
        url += "/register/" + username;

        final List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("password", pass));

        final String data = post(url, params);
        return data;
    }

    /**
     * @param gdata
     * @return The game id string
     * @throws Exception
     */
    public static GameData join(GameData gdata) throws Exception {
        String url = new String();
        url += "/public/join";

        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("authToken", gdata.getAuthToken()));
        params.add(new BasicNameValuePair("user", gdata.getUserName()));

        String data = post(url, params);
        JSON jsonParser = new JSON(data);

        gdata.setGameId(jsonParser.gameid());

        return gdata;
    }

    /**
     * @param gdata
     * @return The modified GameData object
     * @throws Exception
     */
    public static GameData status(GameData gdata) throws Exception {
        String url = new String();
        url += "/game/" + gdata.getGameID();

        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("authToken", gdata.getAuthToken()));

        String data = post(url, params);
        JSON jsonParser = new JSON(data);

        // if ( jsonParser.status() == ) {

        gdata.setGameId(jsonParser.gameid());
        gdata.setStatus(jsonParser.gamestatus());

        return gdata;
        // }

    }

    /**
     * API call to get the initial multiple choice question in a game.
     * 
     * @param authToken
     *            The authorization token for this session, obtained at user
     *            login.
     * @param gameId
     *            The identification string for this game.
     * @return The next question in the game, or null if the game is over, or
     *         error.
     * @throws Exception
     */
    public static Question firstQuestion(final String authToken,
            final String gameId) throws Exception {
        return nextQuestion(authToken, gameId, "0");
    }

    /**
     * API call to get the next multiple choice question in a game.
     * 
     * @param authToken
     *            The authorization token for this session, obtained at user
     *            login.
     * @param gameId
     *            The identification string for this game.
     * @param prevId
     *            The previous question id, just pass "0" if this is the initial
     *            question fetch.
     * 
     * @return The next question in the game, or null if the game is over.
     * @throws Exception
     */
    public static Question nextQuestion(final String authToken,
            final String gameId, final String prevId) throws Exception {

        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("authToken", authToken));

        String url = new String(API_URL);
        url += "/game/" + gameId + "/next/" + prevId;

        String data = post(url, params);

        // Decompose JSON response into a Question object
        Question nextQ = null;
        try {
            JSONObject json = new JSONObject(data);
            nextQ = Question.create(json);
        } catch (JSONException e) {
            throw new DistriviaAPIException("Question request was malformed: ");
        }

        return nextQ;
    }

    /**
     * API call to answer a given question that has been posed to a user.
     * 
     * @param authToken
     *            The authorization token for this session, obtained at user
     *            login.
     * @param username
     *            The user name to login with
     * @param gameId
     *            The unique identification string for the current game.
     * @param answer
     *            The answer to the question the user is currently work on.
     *            Should be "a", "b", "c", or "d"
     * @param answerTime_ms
     *            The time in mili-seconds it took the user to answer the
     *            question.
     * 
     * @return Return true if answer went through successfully, otherwise return
     *         false on error. Error could be, wrong authorization token,
     *         incorrect gameId, impossible answerTIme etc...
     * @throws Exception
     */
    public static boolean answerQuestion(final GameData gdata,
            final String answer, final int time_ms) throws Exception {

        String url = new String();
        url += "/game/" + gdata.getGameID();
        url += "/answer/" + answer;
        url += "/time/" + time_ms;

        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("authToken", gdata.getAuthToken()));
        params.add(new BasicNameValuePair("user", gdata.getUserName()));

        String data = post(url, params);

        if (data.equals(API_ERROR)) {
            throw new DistriviaAPIException("Question's answer was malformed");
        }

        return data.equals("correct");
    }

    /**
     * API call to obtain the current leader board for a given game.
     * 
     * @param authToken
     *            The authorization token for this session, obtained at user
     *            login.
     * @param gameId
     *            The unique identification string for the current game.
     * 
     * @return The game leader board at the time of the query, or null if the
     *         gameId does not exist, or the user is not properly logged in.
     * @throws Exception
     */
    public static String[][] leaderBoard(final GameData gdata) throws Exception {

        String url = new String();
        url += "/leaderboard/0";

        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("authToken", gdata.getAuthToken()));

        String data = post(url, params);

        JSON parser = new JSON(data);

        String[][] lb = parser.leaderboard();
        return lb;
    }

    private static String post(String url, List<NameValuePair> params)
            throws Exception {

        HttpPost op = new HttpPost(url);
        if (params != null) {
            op.setEntity(new UrlEncodedFormEntity(params));
        }
        HttpResponse response = executeRequest(op);
        String data = responseToString(response);
        return data;
    }

    private static String get(final String url) throws Exception {
        HttpGet op = new HttpGet(url);
        HttpResponse response = executeRequest(op);
        String data = responseToString(response);
        return data;
    }

    private static HttpClient createHttpClient() {
        /*
         * HttpParams params = new BasicHttpParams();
         * HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
         * HttpProtocolParams.setContentCharset(params,
         * HTTP.DEFAULT_CONTENT_CHARSET);
         * HttpProtocolParams.setUseExpectContinue(params, true);
         * 
         * SchemeRegistry schReg = new SchemeRegistry(); schReg.register(new
         * Scheme("http", PlainSocketFactory .getSocketFactory(), 80));
         * schReg.register(new Scheme("https",
         * SSLSocketFactory.getSocketFactory(), 443)); ClientConnectionManager
         * conMgr = new ThreadSafeClientConnManager( params, schReg);
         */

        SchemeRegistry schemeRegistry = new SchemeRegistry();
        schemeRegistry.register(new Scheme("https", SSLSocketFactory
                .getSocketFactory(), 443));

        HttpParams params = new BasicHttpParams();

        SingleClientConnManager mgr = new SingleClientConnManager(params,
                schemeRegistry);

        return new DefaultHttpClient(mgr, params);
    }

    private static HttpResponse executeRequest(HttpRequestBase op)
            throws Exception {
        HttpHost host = new HttpHost(API_ROOT, API_PORT, API_PROTOCOL);
        HttpResponse response = null;
        try {
            response = httpClient.execute(host, op);
        } catch (ClientProtocolException e) {
            throw e;
        } catch (IOException e) {
            throw e;
        }
        return response;
    }

    private static String responseToString(HttpResponse res) throws Exception {

        InputStream is = null;
        try {
            is = res.getEntity().getContent();
        } catch (Exception e) {
            throw e;
        }

        if (is != null) {

            Writer writer = new StringWriter();
            char[] buffer = new char[1024];

            try {
                Reader reader = new BufferedReader(new InputStreamReader(is,
                        "UTF-8"));
                int n;
                while ((n = reader.read(buffer)) != -1) {
                    writer.write(buffer, 0, n);
                }
            } catch (UnsupportedEncodingException e) {
                throw e;
            } catch (IOException e) {
                throw e;
            } finally {
                try {
                    is.close();
                } catch (IOException e) {
                    // Nothing we can do now!
                }
            }
            return writer.toString();
        } else {
            return "";
        }
    }

}
