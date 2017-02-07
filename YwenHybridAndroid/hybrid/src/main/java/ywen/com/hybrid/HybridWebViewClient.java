package ywen.com.hybrid;

import android.content.Intent;
import android.net.Uri;
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
    public boolean shouldOverrideUrlLoading(WebView view, String url) {
        if (url.startsWith("ywen")) {
            this.hybridWebView.parseUrl(url);
            return true;
        }
        else if (url.startsWith("mailto:") || url.startsWith("tel:")) {
            Intent intent = new Intent(Intent.ACTION_VIEW,
                    Uri.parse(url));

            view.getContext().startActivity(intent);
            return  true;
        }
        else
        {
            return super.shouldOverrideUrlLoading(view, url);
        }

    }
}
