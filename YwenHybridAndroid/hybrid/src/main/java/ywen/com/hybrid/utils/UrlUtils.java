package ywen.com.hybrid.utils;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Iterator;

/**
 * Created by ywen(yaliyingwy@gmail.com) on 16/3/26.
 */
public class UrlUtils {

    public final static String IS_FIRST_IN = "IS_FIRST_IN";

    public static String objToQuery(JSONObject jsonObject)  {
        String query = "";
        Iterator<String> keys = jsonObject.keys();
        while (keys.hasNext()) {
            String key = keys.next();
            try {
                String value = jsonObject.getString(key);
                query += String.format("%s=%s&", key, URLEncoder.encode(value, "utf-8"));
            } catch (JSONException e) {
                e.printStackTrace();
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
        return query;
    }
}
