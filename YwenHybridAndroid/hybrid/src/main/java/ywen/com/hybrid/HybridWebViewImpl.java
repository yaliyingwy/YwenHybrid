package ywen.com.hybrid;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
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
        this.init();
    }

    public void init() {
        WebSettings settings = this.getSettings();
        settings.setJavaScriptEnabled(true);

        HybridWebViewClient hybridWebViewClient = new HybridWebViewClient();
        hybridWebViewClient.setHybridWebView(this);
        this.setWebViewClient(hybridWebViewClient);

        this.setWebChromeClient(new HybridWebChromeClient());

    }


    @Override
    public void parseUrl(String url) {
        try {
            url = URLDecoder.decode(url, "utf8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        if (url.startsWith("ywen")) {
            String[] urlParts = url.split("\\?", 2);
            String tag = urlParts[0].split("//", 2)[1];
            String query = urlParts[1];
            Log.d("url", String.format("tag %s   query %s", tag, query));

            JSONObject params = null;
            String callback = null;

            for (String s : query.split("&")) {
                if (s.contains("params")) {
                    try {
                        params = new JSONObject(s.split("=", 2)[1]);
                    } catch (JSONException e) {
                        Log.e("params", "not json format!!!");
                        e.printStackTrace();
                    }
                }
                else if (s.contains("callback"))
                {
                    callback = s.split("=", 2)[1];
                }
            }

            this.callFromjs(tag, params, callback);
        }
    }


    public void callFromjs(String tag, JSONObject params, String callback) {
        Log.d("call from js:", String.format("tag %s  params %s callback %s", tag, params, callback));

        this.hybridCore.callFromjs(this, tag, params, callback);
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
        this.loadUrl(js);
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
        this.loadUrl(js);

    }

    @Override
    public void callJs(Map<String, Object> params) {
        String json = (new JSONObject(params)).toString();
        String js = String.format("javascript:(function(){window.ywenHybrid.callJs('%s')})()", json);
        this.loadUrl(js);
    }

    @Override
    public void loadPage(HybridCore hybridCore, String page) {
        this.hybridCore = hybridCore;
        this.setHtmlPage(page);
    }


}


