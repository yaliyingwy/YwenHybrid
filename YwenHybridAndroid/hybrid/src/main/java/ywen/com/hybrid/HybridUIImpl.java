package ywen.com.hybrid;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.graphics.drawable.ColorDrawable;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Timer;
import java.util.TimerTask;


/**
 * Created by ywen(yaliyingwy@gmail.com)(yaliyingwy@gmail.com) on 15/12/16.
 */



public class HybridUIImpl implements HybridUI {

    private static Dialog loadingDialog = null;
    private static int loadingCount = 0;  //相当于一个计数器,防止多个网络请求的时候dismiss出现并发性问题
    private static HybridUIImpl mInstance = null;

    private HybridUIImpl() {
    }

    public static HybridUIImpl getInstance() {
        if (mInstance == null) {
            Class clazz = HybridUIImpl.class;
            synchronized (clazz) {
                mInstance = new HybridUIImpl();
            }
        }
        return mInstance;
    }

    private static class  HybridHandler extends Handler {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            switch (msg.what) {
                case 1:
                {
                    if (loadingCount == 1) {
                        loadingDialog.dismiss();
                    }
                    else
                    {
                        loadingCount--;
                    }
                    break;
                }
            }
        }
    }

    static  Handler handler = new HybridHandler();
    @Override
    public void alert(final Activity activity, final HybridWebView webView, JSONObject params, final String callback) {
        String title = "提示", msg ="";
        String[] btns = {"确定", "取消"};
        try {
            title = params.getString("title");
            msg = params.getString("msg");
            JSONArray btnArr = params.getJSONArray("btns");

            for (int i = 0; i < btnArr.length(); i++) {
                btns[i] = btnArr.getString(i);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        finally {
            final  AlertDialog.Builder dlg = new AlertDialog.Builder(activity, AlertDialog.THEME_DEVICE_DEFAULT_LIGHT); // new AlertDialog.Builder(cordova.getActivity(), AlertDialog.THEME_DEVICE_DEFAULT_LIGHT);
            dlg.setMessage(msg);
            dlg.setTitle(title);
            dlg.setCancelable(true);
            dlg.setPositiveButton(btns[0],
                    new AlertDialog.OnClickListener() {
                        public void onClick(final  DialogInterface dialog, int which) {
                            dialog.dismiss();
                            webView.success(callback, null);

                        }
                    });
            dlg.setOnCancelListener(new AlertDialog.OnCancelListener() {
                public void onCancel(final DialogInterface dialog) {
                    dialog.dismiss();
                    webView.error(callback, "user canceled");

                }
            });

            dlg.setNegativeButton(btns[1],
                    new AlertDialog.OnClickListener() {
                        public void onClick(final DialogInterface dialog, int which) {
                            dialog.dismiss();
                            webView.error(callback, "cancel");

                        }
                    });
            dlg.show();

        }

    }

    @Override
    public void toast(Activity activity, JSONObject params) {
        String type = "show" , msg = "", position = "bottom";
        try {
            type = params.getString("type");
            msg = params.getString("msg");
            position = params.getString("position");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        finally {
            switch (type) {
                case "show":
                    this.showToast(activity, msg, position);
                    break;
                case "success":
                    this.showWithImg(activity, msg, R.drawable.toast_success);
                    break;
                case "error":
                    this.showWithImg(activity, msg, R.drawable.toast_err);
                    break;
            }
        }
    }

    @Override
    public void loading(final Activity activity, JSONObject params) {
        String type = "show", msg = "请稍候....";
        boolean force = true;
        int timeout = 35;
        try {
            type = params.getString("type");
            msg = params.getString("msg");
            force = params.getBoolean("force");
            timeout = params.getInt("timeout");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        finally {



            if ("hide".equals(type) && loadingDialog != null) {
                if (loadingCount == 1) {
                    loadingDialog.dismiss();
                    loadingCount = 0;

                } else {
                    loadingCount--;
                }
            }
            else
            {
                final String message = msg;
                if (loadingCount == 0) {
                    loadingDialog = createLoadingDialog(activity, message);

                }
                loadingCount++;

                loadingDialog.setCancelable(!force);// 不可以用“返回键”取消
                loadingDialog.setCancelable(!force);
                loadingDialog.setCanceledOnTouchOutside(!force);
                loadingDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
                    @Override
                    public void onDismiss(DialogInterface dialog) {
                        Log.d("dialog", "dismiss-------------" + loadingCount);
                        loadingCount = 0;
                    }
                });



                TimerTask timerTask = new TimerTask() {
                    @Override
                    public void run() {
//                        handler.sendEmptyMessage(1);
                        handler.post(new Runnable() {
                            @Override
                            public void run() {
                                if (loadingCount == 1) {
                                    loadingDialog.dismiss();
                                }
                                else
                                {
                                    loadingCount--;
                                }
                            }
                        });
                    }
                };

                Timer timer = new Timer();
                timer.schedule(timerTask, timeout * 1000);

                loadingDialog.show();

            }


        }

    }

    public void showToast(Activity activity, String msg, String position) {
        final Toast toast = Toast.makeText(activity, msg, Toast.LENGTH_SHORT);
        if ("center".equals(position)) {
            toast.setGravity(Gravity.CENTER, 0, 0);
        }

        toast.show();

    }

    public void showWithImg(Activity activity, String msg, int img) {
        final  Toast toast = Toast.makeText(activity, msg, Toast.LENGTH_SHORT);
        toast.setGravity(Gravity.CENTER, 0, 0);
        ImageView imageView = new ImageView(activity);
        imageView.setImageResource(img);

        LinearLayout toastView = (LinearLayout) toast.getView();
        toastView.addView(imageView, 0);

        toast.show();

    }

    /**
     * 得到自定义的progressDialog
     * @param activity activity
     * @param msg  消息
     * @return dialog
     */
    public static Dialog createLoadingDialog(Activity activity, String msg) {

        LayoutInflater inflater = LayoutInflater.from(activity);
        View v = inflater.inflate(R.layout.hybrid_loading, null);// 得到加载view
        LinearLayout layout = (LinearLayout) v.findViewById(R.id.dialog_view);// 加载布局
        // main.xml中的ImageView
        ImageView spaceshipImage = (ImageView) v.findViewById(R.id.img);
        TextView tipTextView = (TextView) v.findViewById(R.id.tipTextView);// 提示文字
        // 加载动画
        Animation hyperspaceJumpAnimation = AnimationUtils.loadAnimation(
                activity, R.anim.loading_anim);
        // 使用ImageView显示动画
        spaceshipImage.startAnimation(hyperspaceJumpAnimation);
        tipTextView.setText(msg);// 设置加载信息

        Dialog dialog = new Dialog(activity, R.style.loading_dialog);// 创建自定义样式dialog

        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(0));

        dialog.setContentView(layout, new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT));// 设置布局
        return dialog;

    }

}
