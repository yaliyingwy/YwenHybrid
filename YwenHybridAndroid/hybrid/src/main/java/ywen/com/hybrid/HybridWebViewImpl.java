package ywen.com.hybrid;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.os.Build;
import android.util.AttributeSet;
import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by ywen on 15/12/13.
 */
public class HybridWebViewImpl extends WebView implements HybridWebView{
    private String htmlPath = "file:///android_asset/www";
    private String htmlPage = "index.html";
    private Map<String, String> params;
    private String url;

    private HybridCore hybridCore;



    public HybridCore getHybridCore() {
        return hybridCore;
    }

    public void setHybridCore(HybridCore hybridCore) {
        this.hybridCore = hybridCore;
    }


    public String getUrl() {
        String query = "";
        return String.format("%s/%s?%s", this.htmlPath, this.htmlPage, query);
    }

    public String getHtmlPath() {
        return htmlPath;
    }

    public void setHtmlPath(String htmlPath) {
        this.htmlPath = htmlPath;
    }

    public Map<String, String> getParams() {
        return params;
    }

    public void setParams(Map<String, String> params) {
        this.params = params;
    }

    public String getHtmlPage() {
        return htmlPage;
    }

    public void setHtmlPage(String htmlPage) {
        this.htmlPage = htmlPage;
        this.loadUrl(this.getUrl());
    }


    public HybridWebViewImpl(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.init(context);

    }

    public void init(Context context) {
        WebSettings settings = this.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);

        settings.setAllowFileAccess(true);

        settings.setAppCacheEnabled(true);

        final HybridInterface hybridInterface = new HybridInterface(this);
        this.addJavascriptInterface(hybridInterface, "hybridAndroid");


        HybridWebViewClient hybridWebViewClient = new HybridWebViewClient();
        hybridWebViewClient.setHybridWebView(this);
        this.setWebViewClient(hybridWebViewClient);

        this.setWebChromeClient(new HybridWebChromeClient());

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            if (0 != (context.getApplicationInfo().flags &= ApplicationInfo.FLAG_DEBUGGABLE))
            { WebView.setWebContentsDebuggingEnabled(true); }
        }

    }


    @Override
    public void parseUrl(String url) {
        if ("ywen://new_msg".equals(url)) {
            this.loadUrl("javascript:(function(){window.ywenHybrid.getMessageQueue()})()");
        }
    }



    public void callFromjs(String tag, JSONObject params, String callback) {
        Log.d("call from js:", String.format("tag %s  params %s callback %s", tag, params, callback));

        this.hybridCore.callFromjs(this, tag, params, callback);
    }



    public void loadUrlOnUIThread(final String url) {
        this.post(new Runnable() {
            @Override
            public void run() {
                loadUrl(url);
            }
        });
    }

    public void success(String callback, Map params) {
        if (callback == null)
        {
            return;
        }

        Map<String, Object> paramMap = new HashMap<String, Object>();
        if (params != null) {
            paramMap.put("params", params);
        }


        paramMap.put("code", "0000");

        JSONObject json = new JSONObject(paramMap);
        String js = String.format("javascript:(function(){window.ywenHybrid.cbs['%s']('%s')})()", callback, json.toString());
        this.loadUrlOnUIThread(js);
    }


    public void error(String callback, String error) {
        if (callback == null)
        {
            return;
        }

        Map<String, Object> paramMap = new HashMap<String, Object>();

        paramMap.put("error", error != null ? error : "出错啦");


        paramMap.put("code", "0001");

        JSONObject json = new JSONObject(paramMap);
        String js = String.format("javascript:(function(){window.ywenHybrid.cbs['%s']('%s')})()", callback, json.toString());
        this.loadUrlOnUIThread(js);

    }

    @Override
    public void callJs(Map<String, Object> params) {
        String json = (new JSONObject(params)).toString();
        String js = String.format("javascript:(function(){window.ywenHybrid.callJs('%s')})()", json);
        this.loadUrlOnUIThread(js);
    }

    @Override
    public void loadPage(HybridCore hybridCore, String page) {
        this.hybridCore = hybridCore;
        this.setHtmlPage(page);
    }


}


