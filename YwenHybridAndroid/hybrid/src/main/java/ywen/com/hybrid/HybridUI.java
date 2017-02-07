package ywen.com.hybrid;

import android.app.Activity;

import org.json.JSONObject;

/**
 * Created by ywen on 15/12/13.
 */
public interface HybridUI {
    void alert(Activity context, HybridWebView webView, JSONObject params, String callback);
    void toast(Activity context, JSONObject params);
    void loading(Activity context, JSONObject params);
}
