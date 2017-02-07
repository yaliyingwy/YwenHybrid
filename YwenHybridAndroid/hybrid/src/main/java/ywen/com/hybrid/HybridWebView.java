package ywen.com.hybrid;

import android.content.Context;

import org.json.JSONObject;

import java.io.IOException;
import java.util.Map;

/**
 * Created by ywen on 15/12/15.
 */
public interface HybridWebView {
    void parseUrl(String url);
    void callFromjs(String tag, JSONObject params, String callback);
    void success(String callback, Map params);
    void error(String callback, String error);
    void callJs(Map<String, Object> params);
    void loadPage(HybridCore hybridCore, String page, String queryStr) throws IOException;
    void loadUrlOnUIThread(final String url);
    void init(Context context);
}
