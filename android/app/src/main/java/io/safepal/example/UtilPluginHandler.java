package io.safepal.example;

import android.Manifest;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.SystemClock;
import android.provider.Settings;
import android.view.WindowManager;

import androidx.annotation.RequiresApi;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class UtilPluginHandler {
    static String TAG = "UtilPluginHandler";

    public static final int REQUEST_EXTERNAL_STORAGE_CODE = 1;
    public static String[] PERMISSIONS_STORAGE = {
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE
    };
    public ExampleActivity activity;

    @RequiresApi(api = Build.VERSION_CODES.O)
    public void methodCallHandler(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "copy": {
                String text = (String) call.arguments;
                ClipboardManager myClipboard = this.activity.getClipboardManagher();
                ClipData clipData = ClipData.newPlainText("text", text);
                myClipboard.setPrimaryClip(clipData);
                result.success(Boolean.TRUE);
            }
            break;
            case "paste": {
                ClipboardManager myClipboard = this.activity.getClipboardManagher();
                ClipData clipData = myClipboard.getPrimaryClip();
                String content = null;
                if (clipData != null && clipData.getItemCount() > 0) {
                    CharSequence text = clipData.getItemAt(0).getText();
                    if (text != null) {
                        content = text.toString();
                    }
                }
                result.success(content);
            }
            break;
            case "openBrower": {
                String url = (String) call.arguments;
                Uri uri = Uri.parse(url);
                Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                this.activity.startActivity(intent);
                result.success(Boolean.TRUE);
            }
            break;
            case "openMobileSetting": {
                Intent intent =  new Intent(Settings.ACTION_SETTINGS);
                this.activity.startActivity(intent);
                result.success(Boolean.TRUE);
            }
            break;
            case "elapsedRealtime":{
                long time = SystemClock.elapsedRealtime();
                result.success(time);
            }
            break;
            case "setScreenshotsSecureFlag": {
                @SuppressWarnings("unchecked")
                Map<String, Object> args =  (Map<String, Object>)call.arguments;
                Number flag = (Number) args.get("flag");
                if (flag == null || flag.intValue() == 0) {
                    this.activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
                } else  {
                    this.activity.getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);
                }
                result.success(Boolean.TRUE);
            }
                break;
            default: {
                if (result != null) {
                    result.notImplemented();
                }
            }
            break;
        }
    }

}
