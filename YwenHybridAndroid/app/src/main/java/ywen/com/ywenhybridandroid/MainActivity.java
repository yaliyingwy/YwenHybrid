package ywen.com.ywenhybridandroid;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.webkit.WebView;

import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import ywen.com.hybrid.HybridCore;
import ywen.com.hybrid.HybridUI;
import ywen.com.hybrid.HybridUIImpl;
import ywen.com.hybrid.HybridWebView;
import ywen.com.hybrid.HybridWebViewImpl;


public class MainActivity extends ActionBarActivity implements HybridCore {

    private HybridUI hybridUI = HybridUIImpl.getInstance();
    private HybridWebViewImpl hybridWebView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        hybridWebView = (HybridWebViewImpl) this.findViewById(R.id.webView);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            WebView.setWebContentsDebuggingEnabled(true);
        }
        try {
            hybridWebView.loadPage(this, "index.html", null);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void callFromjs(HybridWebView webView, String tag, JSONObject params, String callback) {
        if ("push".equals(tag)) {
            this.startActivity(new Intent(this, SecondActivity.class));
            this.success(webView, callback, null);
        }
        else if ("toast".equals(tag))
        {
            this.hybridUI.toast(this, params);
        }
        else if ("loading".equals(tag))
        {
            this.hybridUI.loading(this, params);
        }
        else if ("alert".equals(tag))
        {
            this.hybridUI.alert(this, webView, params, callback);
        }
        else
        {
            Map<String, Object> paramMap = new HashMap<String, Object>();
            paramMap.put("msg", "例子里面还没实现呢！");
            webView.callJs(paramMap);
        }
    }

    @Override
    public void success(HybridWebView webView, String callback, Map params) {
        webView.success(callback, params);
    }

    @Override
    public void error(HybridWebView webView, String callback, String error) {
        webView.error(callback, error);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        hybridWebView.getHybridWebChromeClient().onActivityResult(requestCode, resultCode, data);
    }
}
