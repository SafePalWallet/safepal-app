/*
 * Copyright the original author or authors.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package io.safepal.scan;

import com.google.common.base.Charsets;
import android.Manifest;
import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.app.Activity;
import android.app.Dialog;

import androidx.annotation.Nullable;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.SurfaceTexture;
import android.graphics.drawable.ColorDrawable;
import android.hardware.Camera;
import android.hardware.Camera.CameraInfo;
import android.hardware.Camera.PreviewCallback;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Process;
import android.os.Vibrator;
import androidx.core.app.ActivityCompat;
import androidx.fragment.app.DialogFragment;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.core.content.ContextCompat;

import android.view.KeyEvent;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.TextureView;
import android.view.TextureView.SurfaceTextureListener;
import android.view.View;
import android.view.ViewAnimationUtils;
import android.view.WindowManager;
import android.view.animation.AccelerateInterpolator;
import android.widget.ImageView;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.ChecksumException;
import com.google.zxing.DecodeHintType;
import com.google.zxing.FormatException;
import com.google.zxing.NotFoundException;
import com.google.zxing.PlanarYUVLuminanceSource;
import com.google.zxing.RGBLuminanceSource;
import com.google.zxing.ReaderException;
import com.google.zxing.Result;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.qrcode.QRCodeReader;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.EnumMap;
import java.util.Map;

import io.safepal.example.R;
import io.safepal.example.JNICryptoUtils;


@SuppressWarnings("deprecation")
public final class ScanActivity extends FragmentActivity
        implements SurfaceTextureListener, ActivityCompat.OnRequestPermissionsResultCallback {
    private static final String INTENT_EXTRA_SCENE_TRANSITION_X = "scene_transition_x";
    private static final String INTENT_EXTRA_SCENE_TRANSITION_Y = "scene_transition_y";

    public static final String TAG = "ScanActivity";


    private static final long AUTO_FOCUS_INTERVAL_MS = 1000L;

    private CameraManager cameraManager = new CameraManager();
    private SensorControler mSensor;

    private long lastFocusTime;

    private View contentView;
    private ScannerView scannerView;
    private TextureView previewView;

    private volatile boolean surfaceCreated = false;
    private Animator sceneTransition = null;

    private HandlerThread cameraThread;
    private volatile Handler cameraHandler;
    private AutoFocusRunnable autoFocusRunnable;

    private ScanViewModel viewModel;

    private volatile boolean mIsPause = false;

    private static final Logger log = LoggerFactory.getLogger(ScanActivity.class);

    private String scanPhotoError;
    private String noPhotoPermission;
    private String okButton;


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                finish();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mSensor = SensorControler.getInstance();
        mSensor.setCameraFocusListener(new SensorControler.CameraFocusListener() {
            @Override
            public void onFocus() {
                lastFocusTime = System.currentTimeMillis();
                cameraHandler.postDelayed(autoFocusRunnable, 100);
            }
        });

        scanPhotoError = getIntent().getStringExtra("scan_photo_error");
        scanPhotoError = scanPhotoError==null?"":scanPhotoError;
        noPhotoPermission = getIntent().getStringExtra("no_photo_permission");
        noPhotoPermission = noPhotoPermission==null?"":noPhotoPermission;
        okButton = getIntent().getStringExtra("ok");
        okButton = okButton==null?"ok":okButton;



        JNICryptoUtils.clearBuffer();

        viewModel = ViewModelProviders.of(this).get(ScanViewModel.class);
        viewModel.showPermissionWarnDialog.observe(this, new Observer<Void>() {
            @Override
            public void onChanged(final Void v) {
                WarnDialogFragment.show(getSupportFragmentManager(), R.string.scan_camera_permission_dialog_title,
                        getString(R.string.scan_camera_permission_dialog_message));
            }
        });
        viewModel.showProblemWarnDialog.observe(this, new Observer<Void>() {
            @Override
            public void onChanged(final Void v) {
                WarnDialogFragment.show(getSupportFragmentManager(), R.string.scan_camera_problem_dialog_title,
                        getString(R.string.scan_camera_problem_dialog_message));
            }
        });

        // Stick to the orientation the activity was started with. We cannot declare this in the
        // AndroidManifest.xml, because it's not allowed in combination with the windowIsTranslucent=true
        // theme attribute.
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LOCKED);
        // Draw under navigation and status bars.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
            getWindow().setFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
                    WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);

        setContentView(R.layout.scan_activity);
        contentView = findViewById(android.R.id.content);
        scannerView = (ScannerView) findViewById(R.id.scan_activity_mask);
        previewView = (TextureView) findViewById(R.id.scan_activity_preview);
        previewView.setSurfaceTextureListener(this);



        ImageView ivClose = findViewById(R.id.ivClose);
        ivClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });

        cameraThread = new HandlerThread("cameraThread", Process.THREAD_PRIORITY_BACKGROUND);
        cameraThread.start();
        cameraHandler = new Handler(cameraThread.getLooper());

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED)
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA}, 0);

        if (savedInstanceState == null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            final Intent intent = getIntent();
            final int x = intent.getIntExtra(INTENT_EXTRA_SCENE_TRANSITION_X, -1);
            final int y = intent.getIntExtra(INTENT_EXTRA_SCENE_TRANSITION_Y, -1);
            if (x != -1 || y != -1) {
                // Using alpha rather than visibility because 'invisible' will cause the surface view to never
                // start up, so the animation will never start.
                contentView.setAlpha(0);
                getWindow()
                        .setBackgroundDrawable(new ColorDrawable(getResources().getColor(android.R.color.transparent)));
                OnFirstPreDraw.listen(contentView, new OnFirstPreDraw.Callback() {
                    @Override
                    public boolean onFirstPreDraw() {
                        float finalRadius = (float) (Math.max(contentView.getWidth(), contentView.getHeight()));
                        final int duration = getResources().getInteger(android.R.integer.config_mediumAnimTime);
                        //@todo api level
                        sceneTransition = ViewAnimationUtils.createCircularReveal(contentView, x, y, 0, finalRadius);
                        sceneTransition.setDuration(duration);
                        sceneTransition.setInterpolator(new AccelerateInterpolator());
                        // TODO Here, the transition should start in a paused state, showing the first frame
                        // of the animation. Sadly, RevealAnimator doesn't seem to support this, unlike
                        // (subclasses of) ValueAnimator.
                        return false;
                    }
                });
            }
        }
    }


    private void maybeTriggerSceneTransition() {
        if (sceneTransition != null) {
            contentView.setAlpha(1);
            sceneTransition.addListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    getWindow()
                            .setBackgroundDrawable(new ColorDrawable(getResources().getColor(android.R.color.black)));
                }
            });
            sceneTransition.start();
            sceneTransition = null;
        }
    }

    @Override
    protected void onResume() {
        mIsPause = false;
        super.onResume();
        if (mSensor != null) {
            mSensor.onStart();
        }
        maybeOpenCamera();
    }

    @Override
    protected void onPause() {
        mIsPause = true;
        if (mSensor != null) {
            mSensor.onStop();
        }
        cameraHandler.post(closeRunnable);
        super.onPause();
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        return super.onTouchEvent(event);
    }

    @Override
    protected void onDestroy() {
        surfaceCreated = false;
        if (mSensor != null) {
            mSensor.onStop();
        }
        previewView.setSurfaceTextureListener(null);

        // We're removing the requested orientation because if we don't, somehow the requested orientation is
        // bleeding through to the calling activity, forcing it into a locked state until it is restarted.
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED);
        super.onDestroy();
    }

    @Override
    public void onRequestPermissionsResult(final int requestCode, final String[] permissions,
                                           final int[] grantResults) {
        if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED)
            maybeOpenCamera();
        else
            viewModel.showPermissionWarnDialog.call();
    }

    private void maybeOpenCamera() {
        if (surfaceCreated && ContextCompat.checkSelfPermission(this,
                Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
            cameraHandler.post(openRunnable);
        }
    }

    @Override
    public void onSurfaceTextureAvailable(final SurfaceTexture surface, final int width, final int height) {
        surfaceCreated = true;
        maybeOpenCamera();
    }

    @Override
    public boolean onSurfaceTextureDestroyed(final SurfaceTexture surface) {
        surfaceCreated = false;
        return true;
    }

    @Override
    public void onSurfaceTextureSizeChanged(final SurfaceTexture surface, final int width, final int height) {
//        Debug.i(TAG, "onSurfaceTextureSizeChanged");
    }

    @Override
    public void onSurfaceTextureUpdated(final SurfaceTexture surface) {

    }

    @Override
    public void onAttachedToWindow() {
        if (Build.VERSION.SDK_INT >= 27) {
            setShowWhenLocked(true);
        }
    }

    @Override
    public void onBackPressed() {
        scannerView.setVisibility(View.GONE);
        setResult(RESULT_CANCELED);
        finish();
    }

    @Override
    public boolean onKeyDown(final int keyCode, final KeyEvent event) {
        switch (keyCode) {
            case KeyEvent.KEYCODE_FOCUS:
            case KeyEvent.KEYCODE_CAMERA:
                // don't launch camera app
                return true;
            case KeyEvent.KEYCODE_VOLUME_DOWN:
            case KeyEvent.KEYCODE_VOLUME_UP:
                cameraHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        cameraManager.setTorch(keyCode == KeyEvent.KEYCODE_VOLUME_UP);
                    }
                });
                return true;
        }

        return super.onKeyDown(keyCode, event);
    }

    public void handleResult(final Result scanResult) {
        if (scanResult.getBarcodeFormat() != BarcodeFormat.QR_CODE) {
            if (!mIsPause) {
                cameraHandler.post(fetchAndDecodeRunnable);
            }
            return;
        }
        byte[] decyptResult;
        byte[] rawByte = scanResult.getText().getBytes(Charsets.ISO_8859_1);
        int errorCode = 0;
        if (rawByte == null) {
            if (!mIsPause) {
                cameraHandler.post(fetchAndDecodeRunnable);
            }
            return;
        }
        int qrType = JNICryptoUtils.getQrPacketType(rawByte);

        if (qrType == 0) {
            // common qr code
            decyptResult = scanResult.getText().getBytes();
        } else  {
            int mergeRet = JNICryptoUtils.mergeQrPacketBuffer(rawByte);
            if (mergeRet < 0) {
                // @todo merge qr code faile, toast tips
//                Toast.makeText(this, R.string.merge_qr_packet_failed, Toast.LENGTH_SHORT);
                errorCode = mergeRet;
            } else if (mergeRet > 0) {
                int total = JNICryptoUtils.getQrPacketCount();
                int progress = JNICryptoUtils.getQrPacketProgress();
                ScanActivity.this.scannerView.updateProgress(progress + 1, total);
                if ((total - 1) > progress && !mIsPause) {
                    cameraHandler.post(fetchAndDecodeRunnable);
                }
                return;
            }
            byte[] secKey = getIntent().getByteArrayExtra("sec_key");
            // merge finish
            decyptResult = JNICryptoUtils.decrypQrData(secKey);
            if (decyptResult != null) {
//                Debug.i(TAG, "decrypt result hex:" + CommonUtils.bytesToHex(decyptResult).toLowerCase());
            } else  {
                errorCode = -101;
            }
        }
        Intent intent =getIntent();
        Bundle bundle =new Bundle();
        if (decyptResult != null) {
            bundle.putByteArray("qr_result", decyptResult);
        }
        byte[] extHeader = JNICryptoUtils.getExtHeaderData();
        if (extHeader != null) {
            bundle.putByteArray("ext_header", extHeader);
        }
        int msgType = JNICryptoUtils.getMessageType();
        bundle.putInt("message_type", msgType);
        bundle.putInt("errorCode", errorCode);
        intent.putExtras(bundle);
        setResult(RESULT_OK, intent);
        JNICryptoUtils.clearBuffer();
        finish();
    }
    Camera camera;
    private final Runnable openRunnable = new Runnable() {
        @Override
        public void run() {
            try {
                camera = cameraManager.open(previewView, displayRotation());

                autoFocusRunnable = new  AutoFocusRunnable(camera);
                final Rect framingRect = cameraManager.getFrame();
                final RectF framingRectInPreview = new RectF(cameraManager.getFramePreview());
                framingRectInPreview.offsetTo(0, 0);
                final boolean cameraFlip = cameraManager.getFacing() == CameraInfo.CAMERA_FACING_FRONT;
                final int cameraRotation = cameraManager.getOrientation();


                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        String tips = getIntent().getStringExtra("tips");
                        if (tips == null) {
                            tips = "";
                        }
                        scannerView.setFraming(
                                framingRect,
                                framingRectInPreview,
                                displayRotation(),
                                cameraRotation,
                                cameraFlip,
                                tips,
                                false);
                    }
                });
                lastFocusTime = System.currentTimeMillis();
                cameraHandler.postDelayed(autoFocusRunnable, 100L);
                maybeTriggerSceneTransition();
                cameraHandler.post(fetchAndDecodeRunnable);
            } catch (final Exception x) {
                viewModel.showProblemWarnDialog.postCall();
            }
        }

        private int displayRotation() {
            final int rotation = getWindowManager().getDefaultDisplay().getRotation();
            if (rotation == Surface.ROTATION_0)
                return 0;
            else if (rotation == Surface.ROTATION_90)
                return 90;
            else if (rotation == Surface.ROTATION_180)
                return 180;
            else if (rotation == Surface.ROTATION_270)
                return 270;
            else
                throw new IllegalStateException("rotation: " + rotation);
        }
    };

    private final Runnable closeRunnable = new Runnable() {
        @Override
        public void run() {
            cameraHandler.removeCallbacksAndMessages(null);
            cameraManager.close();
        }
    };

    private final class AutoFocusRunnable implements Runnable {
        private final Camera camera;

        public AutoFocusRunnable(final Camera camera) {
            this.camera = camera;
        }

        @Override
        public void run() {
            try {
                camera.autoFocus(autoFocusCallback);
            } catch (final Exception x) {
                log.info("problem with auto-focus, will not schedule again", x);
            }
        }

        private final Camera.AutoFocusCallback autoFocusCallback = new Camera.AutoFocusCallback() {
            @Override
            public void onAutoFocus(final boolean success, final Camera camera) {
                // schedule again
                lastFocusTime = System.currentTimeMillis();
                if (!success) {
                    cameraHandler.postDelayed(autoFocusRunnable, AUTO_FOCUS_INTERVAL_MS);
                    return;
                }
                if (mSensor == null) {
                    if (success && cameraManager.isSupportedConinuousAutoFocus()) {
                        cameraManager.camera.startPreview();
                        cameraManager.setCameraFocusContinuouPictureMode();
                        cameraManager.camera.cancelAutoFocus();
                    } else  {
                        lastFocusTime = System.currentTimeMillis();
                        cameraHandler.postDelayed(autoFocusRunnable, AUTO_FOCUS_INTERVAL_MS);
                    }
                }
            }
        };
    }

    private final Runnable fetchAndDecodeRunnable = new Runnable() {
        private final QRCodeReader reader = new QRCodeReader();
        private final Map<DecodeHintType, Object> hints = new EnumMap<DecodeHintType, Object>(DecodeHintType.class);

        @Override
        public void run() {
            cameraManager.requestPreviewFrame(new PreviewCallback() {
                @Override
                public void onPreviewFrame(final byte[] data, final Camera camera) {
                    decode(data);
                }
            });
        }

        private void decode(final byte[] data) {
            final PlanarYUVLuminanceSource source = cameraManager.buildLuminanceSource(data);
            HybridBinarizer hybridBinarizer = new HybridBinarizer(source);
            final BinaryBitmap bitmap = new BinaryBitmap(hybridBinarizer);
            try {
                hints.put(DecodeHintType.CHARACTER_SET, "ISO_8859_1");
                final Result scanResult = reader.decode(bitmap, hints);
                lastFocusTime = System.currentTimeMillis();
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        handleResult(scanResult);
                    }
                });
            } catch (final ReaderException x) {
                if (!mIsPause) {
                    long curTimestamp = System.currentTimeMillis();
                    cameraHandler.post(fetchAndDecodeRunnable);
                    if ((curTimestamp - lastFocusTime) <= 1500L) {

                    } else  {
                        lastFocusTime = System.currentTimeMillis();
                        cameraHandler.post(autoFocusRunnable);
                    }
                }
            } finally {
                reader.reset();
            }
        }
    };

    public static class WarnDialogFragment extends DialogFragment {
        private static final String FRAGMENT_TAG = WarnDialogFragment.class.getName();

        public static void show(final FragmentManager fm, final int titleResId, final String message) {
            final WarnDialogFragment newFragment = new WarnDialogFragment();
            final Bundle args = new Bundle();
            args.putInt("title", titleResId);
            args.putString("message", message);
            newFragment.setArguments(args);
            newFragment.show(fm, FRAGMENT_TAG);
        }

        @Override
        public Dialog onCreateDialog(final Bundle savedInstanceState) {
            final Bundle args = getArguments();
            final DialogBuilder dialog = DialogBuilder.warn(getActivity(), args.getInt("title"));
            dialog.setMessage(args.getString("message"));
            dialog.singleDismissButton(new OnClickListener() {
                @Override
                public void onClick(final DialogInterface dialog, final int which) {
                    getActivity().finish();
                }
            });
            return dialog.create();
        }

        @Override
        public void onCancel(final DialogInterface dialog) {
            getActivity().finish();
        }

        public static void startForResult(final Activity activity, final int resultCode) {
            activity.startActivityForResult(new Intent(activity, ScanActivity.class), resultCode);
        }
    }

}
