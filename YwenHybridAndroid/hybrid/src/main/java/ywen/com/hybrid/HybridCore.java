package ywen.com.hybrid;

import org.json.JSONObject;

import java.util.Map;

/**
 * Created by ywen on 15/12/13.
 */
public interface HybridCore {
    void callFromjs(HybridWebView webView, String tag, JSONObject params, String callback);
    void success(HybridWebView webView, String callback, Map params);
    void error(HybridWebView webView, String callback, String error);
}
