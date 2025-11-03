/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.count.ui;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;

import com.scandit.datacapture.barcode.count.ui.view.BarcodeCountView;
import com.scandit.datacapture.flutter.core.ui.FlutterBasePlatformView;
import com.scandit.datacapture.frameworks.barcode.count.BarcodeCountModule;

@SuppressLint("ViewConstructor")
public class FlutterBarcodeCountView extends FlutterBasePlatformView {

    private final BarcodeCountModule barcodeCountModule;

    public FlutterBarcodeCountView(Context context, String jsonString, BarcodeCountModule barcodeCountModule) {
        super(context);

        this.barcodeCountModule = barcodeCountModule;

        BarcodeCountView view = barcodeCountModule.getViewFromJson(jsonString);

        if (view != null) {
            addView(view, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        }
    }

    @Override
    public void onCurrentTopViewVisibleChanged(String topViewId) {
        if (viewId.equals(topViewId)) {
            dispatchWindowVisibilityChanged(getVisibility());
        }
    }

    @Nullable
    @Override
    public View getView() {
        return this;
    }

    @Override
    public void dispose() {
        barcodeCountModule.disposeBarcodeCountView();
        super.dispose();
    }
}
