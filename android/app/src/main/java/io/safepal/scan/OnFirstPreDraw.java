package io.safepal.scan;

import android.view.View;
import android.view.ViewTreeObserver;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.atomic.AtomicBoolean;

import static androidx.core.util.Preconditions.checkNotNull;


public class OnFirstPreDraw implements ViewTreeObserver.OnPreDrawListener {
    public static interface Callback {
        boolean onFirstPreDraw();
    }

    public static void listen(final View view, final Callback callback) {
        new OnFirstPreDraw(view.getViewTreeObserver(), callback);
    }

    private final ViewTreeObserver viewTreeObserver;
    private final Callback callback;
    private final AtomicBoolean fired = new AtomicBoolean(false);

    private static final Logger log = LoggerFactory.getLogger(OnFirstPreDraw.class);

    private OnFirstPreDraw(final ViewTreeObserver viewTreeObserver, final Callback callback) {
        this.viewTreeObserver = viewTreeObserver;
        this.callback = checkNotNull(callback);
        viewTreeObserver.addOnPreDrawListener(this);
    }

    @Override
    public boolean onPreDraw() {
        if (viewTreeObserver.isAlive())
            viewTreeObserver.removeOnPreDrawListener(this);
        else
            log.debug("ViewTreeObserver has died, cannot remove listener");
        if (!fired.getAndSet(true))
            return callback.onFirstPreDraw();
        return true;
    }
}
