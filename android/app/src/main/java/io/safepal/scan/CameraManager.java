
package io.safepal.scan;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Rect;
import android.graphics.RectF;
import android.hardware.Camera;
import android.hardware.Camera.CameraInfo;
import android.hardware.Camera.PreviewCallback;
import android.util.Log;
import android.view.TextureView;

import com.google.zxing.PlanarYUVLuminanceSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@SuppressWarnings("deprecation")
public final class CameraManager {
    private static final String TAG = "CameraManager";

    private static final int MIN_PREVIEW_PIXELS = 470 * 320; // normal screen
    private static final int MAX_PREVIEW_PIXELS = 1280 * 720;

    public Camera camera;
    private CameraInfo cameraInfo = new CameraInfo();
    public Camera.Size cameraResolution; // selected camera resolution
    private Rect frame;
    private RectF framePreview;

    private Rect focusArea;

    private static final Logger log = LoggerFactory.getLogger(CameraManager.class);

    public Rect getFrame() {
        return frame;
    }

    public RectF getFramePreview() {
        return framePreview;
    }

    public int getFacing() {
        return cameraInfo.facing;
    }

    public int getOrientation() {
        return cameraInfo.orientation;
    }

    public boolean isSupportedConinuousAutoFocus() {
        if (this.camera == null) {
            return false;
        }
        return this.camera.getParameters().getSupportedFocusModes().contains(Camera.Parameters.FOCUS_MODE_CONTINUOUS_PICTURE);
    }

    public Camera open(final TextureView textureView, final int displayOrientation) throws IOException {
        final int cameraId = determineCameraId();
            Camera.getCameraInfo(cameraId, cameraInfo);
        camera = Camera.open(cameraId);
        if (cameraInfo.facing == CameraInfo.CAMERA_FACING_FRONT) {
            int display = (cameraInfo.orientation + displayOrientation) % 360;
            display = (360 - display) % 360;
            camera.setDisplayOrientation(display);
        } else if (cameraInfo.facing == CameraInfo.CAMERA_FACING_BACK) {
            int display = (cameraInfo.orientation - displayOrientation + 360) % 360;
            camera.setDisplayOrientation(display);
        } else {
            throw new IllegalStateException("facing: " + cameraInfo.facing);
        }

        final Camera.Parameters parameters = camera.getParameters();
        cameraResolution = findCloselySize(
                textureView.getWidth(),
                textureView.getHeight(),
                parameters.getSupportedPreviewSizes());

        int width = textureView.getWidth();
        int height = textureView.getHeight();
        camera.setPreviewTexture(textureView.getSurfaceTexture());

        final int size = Math.min(width * 2 / 3, height * 2 / 3);
        final int leftOffset = (width - size) / 2;
        final int topOffset = (height - size) / 2;
        frame = new Rect(leftOffset, topOffset, leftOffset + size, topOffset + size);

        if (width > height) { // landscape
            framePreview = new RectF(
                    frame.left * cameraResolution.width / width,
                    frame.top * cameraResolution.height / height,
                    frame.right * cameraResolution.width / width,
                    frame.bottom * cameraResolution.height / height
            );
        } else { // portrait

            framePreview = new RectF(
                    frame.top * cameraResolution.width / height,
                    frame.left * cameraResolution.height / width,
                    frame.bottom * cameraResolution.width / height,
                    frame.right * cameraResolution.height / width
            );
        }

        final String savedParameters = parameters == null ? null : parameters.flatten();

        try {
            setDesiredCameraParameters(camera, cameraResolution, getFocusArea());
        } catch (final RuntimeException x) {
            if (savedParameters != null) {
                final Camera.Parameters parameters2 = camera.getParameters();
                parameters2.unflatten(savedParameters);
                try {
                    camera.setParameters(parameters2);
                    setDesiredCameraParameters(camera, cameraResolution, getFocusArea());
                } catch (final RuntimeException x2) {
                    log.info("problem setting camera parameters", x2);
                }
            }
        }

        try {
            camera.startPreview();
            return camera;
        } catch (final RuntimeException x) {
            log.warn("something went wrong while starting camera preview", x);
            camera.release();
            throw x;
        }
    }

    private synchronized Rect getFocusArea() {
        if (framePreview == null) {
            return null;
        }
        if (focusArea != null) {
            return focusArea;
        }
        int expand = 0;
        Rect rect = new Rect();
        rect.left = (int) (framePreview.left - expand);
        rect.top = (int) (framePreview.top - expand);
        rect.right = (int) (framePreview.right + expand);
        rect.bottom = (int) (framePreview.bottom + expand);
        focusArea = rect;
        return focusArea;
    }

    private int determineCameraId() {
        final int cameraCount = Camera.getNumberOfCameras();
        final CameraInfo cameraInfo = new CameraInfo();

        // prefer back-facing camera
        for (int i = 0; i < cameraCount; i++) {
            Camera.getCameraInfo(i, cameraInfo);
            if (cameraInfo.facing == CameraInfo.CAMERA_FACING_BACK)
                return i;
        }

        // fall back to front-facing camera
        for (int i = 0; i < cameraCount; i++) {
            Camera.getCameraInfo(i, cameraInfo);
            if (cameraInfo.facing == CameraInfo.CAMERA_FACING_FRONT)
                return i;
        }

        return -1;
    }

    public void close() {
        if (camera != null) {
            try {
                camera.stopPreview();
            } catch (final RuntimeException x) {
                log.warn("something went wrong while stopping camera preview", x);
            }

            camera.release();
        }
    }

    public void setCameraFocusContinuouPictureMode() {
        if (camera == null) {
            return;
        }
        final Camera.Parameters parameters = camera.getParameters();
        if (parameters == null) {
            return;
        }
        parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_CONTINUOUS_PICTURE);

        try {
            camera.setParameters(parameters);
            camera.cancelAutoFocus();
        } catch (final RuntimeException x) {
        }
    }

    private static final Comparator<Camera.Size> numPixelComparator = new Comparator<Camera.Size>() {
        @Override
        public int compare(final Camera.Size size1, final Camera.Size size2) {
            final int pixels1 = size1.height * size1.width;
            final int pixels2 = size2.height * size2.width;

            if (pixels1 < pixels2)
                return 1;
            else if (pixels1 > pixels2)
                return -1;
            else
                return 0;
        }
    };

    @SuppressLint("InlinedApi")
    private static void setDesiredCameraParameters(final Camera camera, final Camera.Size cameraResolution, final Rect rect) {
        final Camera.Parameters parameters = camera.getParameters();
        if (parameters == null) {
            return;
        }

        final List<String> supportedFocusModes = parameters.getSupportedFocusModes();
        final String focusMode = findValue(
                supportedFocusModes,
                Camera.Parameters.FOCUS_MODE_AUTO,
                Camera.Parameters.FOCUS_MODE_MACRO);
        if (focusMode != null) {
            parameters.setFocusMode(focusMode);
        } else {
        }
        parameters.setPreviewSize(cameraResolution.width, cameraResolution.height);
        camera.setParameters(parameters);
    }

    public void requestPreviewFrame(final PreviewCallback callback) {
        try {
            camera.setOneShotPreviewCallback(callback);
        } catch (final RuntimeException x) {
        }
    }

    public PlanarYUVLuminanceSource buildLuminanceSource(final byte[] data) {
        return new PlanarYUVLuminanceSource(data,
                cameraResolution.width,
                cameraResolution.height,
                (int) framePreview.left,
                (int) framePreview.top,
                (int) framePreview.width(),
                (int) framePreview.height(),
                false);
    }

    public void setTorch(final boolean enabled) {
        if (enabled != getTorchEnabled(camera))
            setTorchEnabled(camera, enabled);
    }

    private static boolean getTorchEnabled(final Camera camera) {
        final Camera.Parameters parameters = camera.getParameters();
        if (parameters != null) {
            final String flashMode = camera.getParameters().getFlashMode();
            return flashMode != null && (Camera.Parameters.FLASH_MODE_ON.equals(flashMode)
                    || Camera.Parameters.FLASH_MODE_TORCH.equals(flashMode));
        }

        return false;
    }

    private static void setTorchEnabled(final Camera camera, final boolean enabled) {
        final Camera.Parameters parameters = camera.getParameters();

        final List<String> supportedFlashModes = parameters.getSupportedFlashModes();
        if (supportedFlashModes != null) {
            final String flashMode;
            if (enabled)
                flashMode = findValue(supportedFlashModes, Camera.Parameters.FLASH_MODE_TORCH,
                        Camera.Parameters.FLASH_MODE_ON);
            else
                flashMode = findValue(supportedFlashModes, Camera.Parameters.FLASH_MODE_OFF);

            if (flashMode != null) {
                camera.cancelAutoFocus(); // autofocus can cause conflict

                parameters.setFlashMode(flashMode);
                camera.setParameters(parameters);
            }
        }
    }

    private static String findValue(final Collection<String> values, final String... valuesToFind) {
        for (final String valueToFind : valuesToFind)
            if (values.contains(valueToFind))
                return valueToFind;

        return null;
    }

    protected Camera.Size findCloselySize(int surfaceWidth, int surfaceHeight, List<Camera.Size> preSizeList) {
        Collections.sort(preSizeList, new SizeComparator(surfaceWidth, surfaceHeight));
        Camera.Size size = preSizeList.get(0);
        return size;
    }
}

final class SizeComparator implements Comparator<Camera.Size> {

    private final int width;
    private final int height;
    private final float ratio;

    SizeComparator(int width, int height) {
        if (width < height) {
            this.width = height;
            this.height = width;
        } else {
            this.width = width;
            this.height = height;
        }
        this.ratio = (float) this.height / this.width;
    }

    @Override
    public int compare(Camera.Size size1, Camera.Size size2) {
        int width1 = size1.width;
        int height1 = size1.height;
        int width2 = size2.width;
        int height2 = size2.height;

        float ratio1 = Math.abs((float) height1 / width1 - ratio);
        float ratio2 = Math.abs((float) height2 / width2 - ratio);
        int result = Float.compare(ratio1, ratio2);
        if (result != 0) {
            return result;
        } else {
            int minGap1 = Math.abs(width - width1) + Math.abs(height - height1);
            int minGap2 = Math.abs(width - width2) + Math.abs(height - height2);
            return minGap1 - minGap2;
        }
    }
}
