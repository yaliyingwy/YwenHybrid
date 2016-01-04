package ywen.com.hybrid;

import android.webkit.JavascriptInterface;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by ywen(yaliyingwy@gmail.com) on 16/1/4.
 */
public class HybridInterface {
    private HybridWebView hybridWebView;

    public HybridInterface(HybridWebView hybridWebView) {
        this.hybridWebView = hybridWebView;
    }


   @JavascriptInterface
    public void getMessageQueue(String queueStr) {
        try {
            JSONArray queue = new JSONArray(queueStr);
            for (int i = 0; i < queue.length() ; i++) {
                JSONObject msgObj = queue.getJSONObject(i);
                String tag = msgObj.getString("msg");
                JSONObject params = msgObj.getJSONObject("params");
                String callback = null;
                if (msgObj.has("callback")){
                    callback = msgObj.getString("callback");
                }

                this.hybridWebView.callFromjs(tag, params, callback);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
}
