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

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Matrix.ScaleToFit;
import android.graphics.Paint;
import android.graphics.Paint.Style;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.util.AttributeSet;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.graphics.drawable.BitmapDrawable;

import com.google.zxing.ResultPoint;

import io.safepal.example.R;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class ScannerView extends View {
    private static final String TAG = "ScannerView";

    private static final long LASER_ANIMATION_DELAY_MS = 20l;
    private static final int TEXT_PADDING_TOP = 20;
    private static final int TEXT_SIZE = 12;
    private static final int PROGRESS_BAR_HEIGHT = 4;

    private Resources res;

    private final Paint maskPaint;
    private final Paint laserPaint;

    private final Paint guidePaint;
    private final Paint progressPaint;
    private final TextPaint textPaint;


    private boolean isResult;
    private final int maskColor, maskResultColor;
    private Rect frame;
    private final Matrix matrix = new Matrix();
    private float progressWidth;
    private int cur;
    private int total;

    private static float density;
    private int screenRate;
    private static final int CORNER_WIDTH = 5;

    public ScannerView(final Context context, final AttributeSet attrs) {
        super(context, attrs);

        res = getResources();

        maskColor = res.getColor(R.color.scan_mask);
        maskResultColor = res.getColor(R.color.scan_result_view);

        density = context.getResources().getDisplayMetrics().density;
        screenRate = (int) (20 * density);

        maskPaint = new Paint();
        maskPaint.setStyle(Style.FILL);

        laserPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        laserPaint.setStrokeWidth(res.getDimensionPixelSize(R.dimen.scan_laser_width));
        laserPaint.setStyle(Style.STROKE);

        progressPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        progressPaint.setColor(res.getColor(R.color.scan_grey));
        progressPaint.setStrokeWidth(PROGRESS_BAR_HEIGHT * density);
        progressPaint.setStrokeCap(Paint.Cap.ROUND);
        progressPaint.setTextSize(TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_PX, TEXT_SIZE * density, context.getResources().getDisplayMetrics()));
        progressPaint.setTypeface(Typeface.create("System", Typeface.BOLD));

        guidePaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        guidePaint.setStyle(Style.FILL);
        guidePaint.setColor(Color.WHITE);
        guidePaint.setTextSize(TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_PX, (TEXT_SIZE + 2) * density, context.getResources().getDisplayMetrics()));
        guidePaint.setTypeface(Typeface.create("System", Typeface.NORMAL));

        textPaint = new TextPaint(Paint.ANTI_ALIAS_FLAG);
        textPaint.setAntiAlias(true);
        textPaint.setColor(Color.GRAY);
        textPaint.setTextSize(TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_PX, (TEXT_SIZE + 2) * density, context.getResources().getDisplayMetrics()));
        textPaint.setTypeface(Typeface.create("System", Typeface.NORMAL));
    }
    public void setFraming(
            final Rect frame,
            final RectF framePreview,
            final int displayRotation,
            final int cameraRotation,
            final boolean cameraFlip,
            final String guideHint,
            final boolean showGuide // display guide tips & progress
    ) {
        this.frame = frame;
        matrix.setRectToRect(framePreview, new RectF(frame), ScaleToFit.FILL);
        matrix.postRotate(-displayRotation, frame.exactCenterX(), frame.exactCenterY());
        matrix.postScale(cameraFlip ? -1 : 1, 1, frame.exactCenterX(), frame.exactCenterY());
        matrix.postRotate(cameraRotation, frame.exactCenterX(), frame.exactCenterY());

        invalidate();
    }


    public void updateProgress(int cur, int total) {
        this.cur = cur;
        this.total = total;
        invalidate();
    }

    @Override
    public void onDraw(final Canvas canvas) {
        if (frame == null)
            return;

        final int width = canvas.getWidth();
        final int height = canvas.getHeight();

        // draw mask darkened
        maskPaint.setColor(isResult ? maskResultColor : maskColor);
        canvas.drawRect(0, 0, width, frame.top, maskPaint);
        canvas.drawRect(0, frame.top, frame.left, frame.bottom + 1, maskPaint);
        canvas.drawRect(frame.right + 1, frame.top, width, frame.bottom + 1, maskPaint);
        canvas.drawRect(0, frame.bottom + 1, width, height, maskPaint);

        laserPaint.setColor(Color.GREEN);
        canvas.drawRect(frame.left, frame.top, frame.left + screenRate,
                frame.top + CORNER_WIDTH, laserPaint);
        canvas.drawRect(frame.left, frame.top, frame.left + CORNER_WIDTH, frame.top
                + screenRate, laserPaint);
        canvas.drawRect(frame.right - screenRate, frame.top, frame.right,
                frame.top + CORNER_WIDTH, laserPaint);
        canvas.drawRect(frame.right - CORNER_WIDTH, frame.top, frame.right, frame.top
                + screenRate, laserPaint);
        canvas.drawRect(frame.left, frame.bottom - CORNER_WIDTH, frame.left
                + screenRate, frame.bottom, laserPaint);
        canvas.drawRect(frame.left, frame.bottom - screenRate,
                frame.left + CORNER_WIDTH, frame.bottom, laserPaint);
        canvas.drawRect(frame.right - screenRate, frame.bottom - CORNER_WIDTH,
                frame.right, frame.bottom, laserPaint);
        canvas.drawRect(frame.right - CORNER_WIDTH, frame.bottom - screenRate,
                frame.right, frame.bottom, laserPaint);

            float progress = 0.0f;
            String progressText = null;
            if (this.total > 0) {
                progress = (float) this.cur / this.total;
                progressText = this.cur + " / " + this.total;
            }

            if (progressText != null) {
                progressPaint.setColor(res.getColor(R.color.scan_grey));
                RectF progressRect = new RectF();
                if (this.progressWidth <= 0) {
                    this.progressWidth = frame.width() * 0.75f;
                }

                float startX = (width - this.progressWidth) / 2.0f;
                float y = (frame.top - PROGRESS_BAR_HEIGHT) / 2.0f;

                progressRect.top = (frame.top - PROGRESS_BAR_HEIGHT) / 2.0f;
                progressRect.bottom = progressRect.top + PROGRESS_BAR_HEIGHT;
                progressRect.left = (width - this.progressWidth) / 2.0f;
                progressRect.right = progressRect.left + this.progressWidth;
                canvas.drawLine(startX, y, startX + this.progressWidth, y, progressPaint);

                // draw progress thumb
                progressRect.right = progressRect.left + (int) (this.progressWidth * progress);
                progressPaint.setColor(Color.GREEN);
                canvas.drawLine(startX, y, startX + this.progressWidth * progress, y, progressPaint);
//                Debug.i(TAG, "thumb progressRect:" + progressRect + " density:" + density);
                // draw progress text
                progressPaint.setColor(res.getColor(R.color.scan_white));
                canvas.drawText(
                        progressText,
                        (width - progressPaint.measureText(progressText)) / 2,
                        (progressRect.bottom + (float) TEXT_PADDING_TOP * density),
                        progressPaint);
            }
//        }

        postInvalidateDelayed(
                LASER_ANIMATION_DELAY_MS,
                frame.left,
                frame.top,
                frame.right,
                frame.bottom);
    }
}
