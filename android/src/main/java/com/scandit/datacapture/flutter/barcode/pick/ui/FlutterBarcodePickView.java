/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.pick.ui;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;

import androidx.annotation.Nullable;

import com.scandit.datacapture.flutter.core.ui.FlutterBasePlatformView;
import com.scandit.datacapture.flutter.core.utils.FlutterLogInsteadOfResult;
import com.scandit.datacapture.frameworks.barcode.pick.BarcodePickModule;

@SuppressLint("ViewConstructor")
public class FlutterBarcodePickView extends FlutterBasePlatformView {
    private final BarcodePickModule barcodePickModule;

    public FlutterBarcodePickView(Context context,
                                  String jsonString,
                                  BarcodePickModule barcodePickModule) {
        super(context);
        this.barcodePickModule = barcodePickModule;

        barcodePickModule.addViewToContainer(this, jsonString, new FlutterLogInsteadOfResult());
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
        barcodePickModule.viewDisposed();
        removeAllViews();
        super.dispose();
    }
}
