package ywen.com.hybrid;

import android.content.Context;

import org.json.JSONObject;

/**
 * Created by ywen on 15/12/13.
 */
public interface HybridUI {
    void alert(HybridWebView webView, JSONObject params, String callback);
    void toast(Context context, JSONObject params);
    void loading(Context context, JSONObject params);
}
