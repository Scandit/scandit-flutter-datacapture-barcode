/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.spark.ui;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;
import android.view.ViewParent;

import androidx.annotation.Nullable;

import com.scandit.datacapture.barcode.spark.ui.SparkScanView;
import com.scandit.datacapture.flutter.core.ui.FlutterBasePlatformView;
import com.scandit.datacapture.flutter.core.utils.DefaultActivityLifecycleObserver;
import com.scandit.datacapture.flutter.core.utils.FlutterLogInsteadOfResult;
import com.scandit.datacapture.frameworks.barcode.spark.SparkScanModule;
import com.scandit.datacapture.frameworks.core.result.NoopFrameworksResult;

import io.flutter.embedding.android.FlutterView;

@SuppressLint("ViewConstructor")
public class FlutterSparkScanView extends FlutterBasePlatformView implements DefaultActivityLifecycleObserver.ViewObserver {

    private final SparkScanModule sparkScanModule;
    private final String jsonString;

    public FlutterSparkScanView(Context context, String jsonString, SparkScanModule sparkScanModule) {
        super(context);
        this.sparkScanModule = sparkScanModule;
        this.jsonString = jsonString;
        DefaultActivityLifecycleObserver.getInstance().addObserver(this);
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();

        FlutterView flutterView = getFlutterView(this.getParent());

        sparkScanModule.addViewToContainer(flutterView, jsonString, new FlutterLogInsteadOfResult());
        SparkScanView sparkScanView = sparkScanModule.getSparkScanView();

        if (sparkScanView != null) {
            sparkScanView.setLayoutParams(((View) this.getParent()).getLayoutParams());
            sparkScanView.requestLayout();
        }
    }

    @Override
    public void onCurrentTopViewVisibleChanged(String topViewId) {
        if (viewId.equals(topViewId)) {
            SparkScanView sparkScanView = sparkScanModule.getSparkScanView();

            if (sparkScanView != null) {
                sparkScanView.dispatchWindowVisibilityChanged(getVisibility());
            }
        }
    }

    @Nullable
    @Override
    public View getView() {
        return this;
    }

    @Override
    public void dispose() {
        sparkScanModule.disposeView();
        DefaultActivityLifecycleObserver.getInstance().removeObserver(this);
        super.dispose();
    }

    private FlutterView getFlutterView(ViewParent parent) {
        if (parent instanceof FlutterView) {
            return (FlutterView) parent;
        }

        return getFlutterView(parent.getParent());
    }

    @Override
    public void onCreate() {
        // no callback on SparkScanView
    }

    @Override
    public void onStart() {
        // no callback on SparkScanView
    }

    @Override
    public void onResume() {
        sparkScanModule.onResume(new NoopFrameworksResult());
    }

    @Override
    public void onPause() {
        sparkScanModule.onPause();
    }

    @Override
    public void onStop() {
        // no callback on SparkScanView
    }

    @Override
    public void onDestroy() {
        // no callback on SparkScanView
    }
}
