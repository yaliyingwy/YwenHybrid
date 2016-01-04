package ywen.com.hybrid;

import android.webkit.WebView;
import android.webkit.WebViewClient;

/**
 * Created by ywen on 15/12/13.
 */
public class HybridWebViewClient extends WebViewClient {

    private HybridWebView hybridWebView;

    public HybridWebView getHybridWebView() {
        return hybridWebView;
    }

    public void setHybridWebView(HybridWebView hybridWebView) {
        this.hybridWebView = hybridWebView;
    }

    @Override
    public void onLoadResource(WebView view, String url) {
        super.onLoadResource(view, url);

        this.hybridWebView.parseUrl(url);
    }
}
