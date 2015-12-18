package ywen.com.hybrid;

import java.util.Map;

/**
 * Created by ywen on 15/12/15.
 */
public interface HybridWebView {
    void parseUrl(String url);
    void success(String callback, Map params);
    void error(String callback, String error);
    void callJs(Map<String, Object> params);
    void loadPage(HybridCore hybridCore, String page);
}
