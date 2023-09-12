package io.safepal.example;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.os.StrictMode;

import androidx.multidex.MultiDex;

import java.util.List;

import io.flutter.app.FlutterApplication;

public class WalletMainApplication extends FlutterApplication {

    public static WalletMainApplication CONTEXT;

    private int mActivityCnt = 0;

    private void updateActivityCntState(boolean started) {
        if (started) {
            if (mActivityCnt < 0) {
                mActivityCnt = 0;
            }
            mActivityCnt++;
        } else {
            if (mActivityCnt > 0) {
                mActivityCnt--;
            }
        }
    }

    @Override
    public void onCreate() {
        super.onCreate();
        CONTEXT = this;
        StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
        StrictMode.setVmPolicy(builder.build());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            builder.detectFileUriExposure();
        }
        registerActivityLifecycleCallbacks(new ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
            }

            @Override
            public void onActivityStarted(Activity activity) {
                updateActivityCntState(true);
            }

            @Override
            public void onActivityResumed(Activity activity) {
            }

            @Override
            public void onActivityPaused(Activity activity) {
            }

            @Override
            public void onActivityStopped(Activity activity) {
                updateActivityCntState(false);
            }

            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
            }

            @Override
            public void onActivityDestroyed(Activity activity) {
            }
        });
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

}
