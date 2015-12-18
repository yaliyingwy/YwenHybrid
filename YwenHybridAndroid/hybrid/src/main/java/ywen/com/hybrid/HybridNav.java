package ywen.com.hybrid;

import org.json.JSONObject;

/**
 * Created by ywen on 15/12/13.
 */
public interface HybridNav {
    void popTo(int index);
    void push(HybridWebView webView, JSONObject params, String callback);
}
