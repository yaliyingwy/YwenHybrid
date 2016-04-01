package ywen.com.hybrid;

import android.content.Context;
import android.os.Build;
import android.util.AttributeSet;
import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;

import org.json.JSONObject;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
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
    private String query = "";
    private String baseUrl = null;

    private HybridWebChromeClient hybridWebChromeClient = new HybridWebChromeClient();



    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    private HybridCore hybridCore;


    public HybridCore getHybridCore() {
        return hybridCore;
    }

    public void setHybridCore(HybridCore hybridCore) {
        this.hybridCore = hybridCore;
    }


    public String getUrl() {
        return String.format("%s/%s?%s", this.htmlPath, this.htmlPage, query);
    }

    public void setQuery(String query) {
        if (query != null) {
            this.query = query;
        }
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
    }


    public HybridWebViewImpl(Context context, AttributeSet attrs) {
        super(context, attrs);
        if (!isInEditMode()) {
            this.init();
        }
    }


    public void init() {
        WebSettings settings = this.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);

        settings.setAllowFileAccess(true);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
            settings.setAllowUniversalAccessFromFileURLs(true);
        }


        settings.setAppCacheEnabled(true);


        final HybridInterface hybridInterface = new HybridInterface(this);
        this.addJavascriptInterface(hybridInterface, "hybridAndroid");


        HybridWebViewClient hybridWebViewClient = new HybridWebViewClient();
        hybridWebViewClient.setHybridWebView(this);
        this.setWebViewClient(hybridWebViewClient);


        this.setWebChromeClient(hybridWebChromeClient);

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
    public void loadPage(HybridCore hybridCore, String page, String queryStr) throws IOException {
        this.hybridCore = hybridCore;
        this.query = queryStr;
        this.setHtmlPage(page);
        String url = getUrl();
        if (baseUrl != null) {
            String filePath = htmlPath;
            if (htmlPage.endsWith("?")) {
                filePath += String.format("/%s", htmlPage.replace("?", ""));
            } else {
                filePath += String.format("/%s", htmlPage);
            }

            FileInputStream fin = null;
            try {
                fin = new FileInputStream(filePath);
                int length = fin.available();

                byte [] buffer = new byte[length];
                fin.read(buffer);

                String res = new String(buffer);

                this.loadDataWithBaseURL(String.format("%s/%s?%s", baseUrl, htmlPage, query), res, "text/html", "utf-8", null);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }


        } else {
            this.loadUrl(this.getUrl());
        }

    }


}


