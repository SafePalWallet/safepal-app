package io.safepal.example;

import android.app.NotificationManager;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.content.Intent;
import android.content.ClipboardManager;
import android.view.MotionEvent;
import android.view.WindowManager;

import androidx.annotation.NonNull;

import java.util.*;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import io.fluttertoast.FluttertoastPlugin;
import io.safepal.example.UtilPluginHandler;
import io.safepal.scan.ScanActivity;


public class ExampleActivity extends FlutterActivity {
    private static final String TAG = "MainActivity";

    private static final int SCAN_QR_CODE_RESULT_CODE = 5566;
    public static final int ACTION_CHOOSER_RECEIVER = 80001;

    private static final String CRYPTO_CHANNEL = "flutter.safepal.io/crypto";
    private static final String QR_CHANNEL = "flutter.safepal.io/qr";
    private static final String UTIL_CHANNEL = "flutter.safepal.io/util";
    private static final String PROGRESS_CHANNEL ="flutter.safepal.io/HUDProgress";

    private MethodChannel cryptoChannel;
    private MethodChannel qrChannel;

    private MethodChannel utilChannel;
    private UtilPluginHandler utilPluginHandler;

    private MethodChannel progressChannel;

    private MethodChannel.Result qrScanResult;

    io.safepal.example.CustomDialog dialog;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        registerChannels(flutterEngine);
    }

    private void registerChannels(FlutterEngine flutterEngine) {
        BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();

        FluttertoastPlugin.registerWith(messenger, this);

        this.cryptoChannel = new MethodChannel(messenger, CRYPTO_CHANNEL);
        this.cryptoChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                cryptoMethodCallHandler(methodCall, result);
            }
        });

        this.qrChannel = new MethodChannel(messenger, QR_CHANNEL);
        this.qrChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                qrMethodCallHandler(methodCall, result);
            }
        });

        this.utilPluginHandler = new  UtilPluginHandler();
        this.utilPluginHandler.activity = this;
        this.utilChannel = new MethodChannel(messenger, UTIL_CHANNEL);
        this.utilChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    utilPluginHandler.methodCallHandler(methodCall, result);
                }
            }
        });

        this.progressChannel = new MethodChannel(messenger,PROGRESS_CHANNEL);
        this.progressChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            boolean showProgress = false;

            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                switch (methodCall.method){
                    case "show":
                        showProgress = true;
                        dialog.show();
                        result.success(true);
                        break;
                    case "dismiss":
                        showProgress = false;
                        dialog.dismiss();
                        result.success(true);
                        break;
                    case "isShow":
                        result.success(showProgress);
                        break;
                }
            }
        });
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
         dialog = new io.safepal.example.CustomDialog(io.safepal.example.ExampleActivity.this);
    }


    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        return super.onTouchEvent(event);
    }

    @Override
    protected void onStop() {
        getWindow().setSoftInputMode(
                WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    protected void qrMethodCallHandler(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "show_qr_scan": {
                showQRScanView(call, result);
            }
            break;
            case "split_qr_data": {
                String tag = "split_qr_data";
                Map args = (Map) call.arguments;
                byte[] qrData = (byte[]) args.get("data");
                int clientId = ((Number) args.get("client_id")).intValue();
                byte[] secKey = (byte[]) args.get("sec_key");
                byte[] exHeader = (byte[]) args.get("exHeader");
                int msgType = ((Number) args.get("msg_type")).intValue();
                boolean crypto = (boolean) args.get("aes_flag");
                boolean base64 = (boolean) args.get("qr_type");
                int version = ((Number) args.get("version")).intValue();
                byte[][] results = JNICryptoUtils.splitQrData(
                        qrData,
                        msgType,
                        clientId,
                        secKey,
                        exHeader,
                        base64,
                        crypto,
                        version);
                List<byte[]> list = new ArrayList<byte[]>();
                for (int i = 0; i < results.length; i++) {
                    list.add(results[i]);
                }
                result.success(list);
            }
            break;
            default:
                result.notImplemented();
                break;
        }
    }

    protected void cryptoMethodCallHandler(MethodCall call, MethodChannel.Result result) {
        CryptoPluginHandler.cryptoMethodCallHandler(call, result);
    }

    public void showQRScanView(MethodCall call, MethodChannel.Result result) {
        @SuppressWarnings("unchecked")
        Map<String, Object> args = (Map<String, Object>) call.arguments;
        byte[] secKey = (byte[]) args.get("sec_key");
        Boolean showGuideTips = (Boolean) args.get("show_guide_tips");
        String tips = (String) args.get("tips");
        String title = (String) args.get("title");
        String scanPhotoError = (String) args.get("scan_photo_error");
        String noPhotoPermission = (String) args.get("no_photo_permission");
        String ok = (String) args.get("ok");
        Intent intent = new Intent();
        if (secKey != null) {
            intent.putExtra("sec_key", secKey);
        }
        intent.putExtra("show_guide_tips", showGuideTips);
        intent.putExtra("title", title);
        intent.putExtra("tips", tips);
        intent.putExtra("scan_photo_error", scanPhotoError);
        intent.putExtra("no_photo_permission", noPhotoPermission);
        intent.putExtra("ok", ok);
        this.qrScanResult = result;
        intent.setClass(io.safepal.example.ExampleActivity.this, ScanActivity.class);

        startActivityForResult(intent, SCAN_QR_CODE_RESULT_CODE);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case UtilPluginHandler.REQUEST_EXTERNAL_STORAGE_CODE: {
                boolean result = grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED;
            }
            break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        HashMap<String, Object> hashMap = new HashMap<String, Object>();
        if (resultCode == RESULT_OK && requestCode == SCAN_QR_CODE_RESULT_CODE) {
            byte[] qrData = data.getByteArrayExtra("qr_result");
            int msgType = data.getIntExtra("message_type", 0);
            int errorCode = data.getIntExtra("errorCode", 0);
            // qr_result
            byte[] extHeader = data.getByteArrayExtra("ext_header");
            if (qrData != null) {
                hashMap.put("data", qrData);
            }
            if (extHeader != null) {
                hashMap.put("ext_header", extHeader);
            }
            hashMap.put("message_type", msgType);
            hashMap.put("errorCode", errorCode);
        } else if (resultCode == RESULT_CANCELED){
            hashMap.put("cancel", 1);
        }
        if (this.qrScanResult != null) {
            try {
                this.qrScanResult.success(hashMap);
            } catch (Exception e) {

            }
        }

    }

    public ClipboardManager  getClipboardManagher() {
        ClipboardManager myClipboard = null;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.HONEYCOMB) {
            myClipboard = (ClipboardManager) this.getSystemService(CLIPBOARD_SERVICE);
        }
        return  myClipboard;
    }


    @Override
    protected void onResume() {
        super.onResume();
        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.cancelAll();
    }
}

