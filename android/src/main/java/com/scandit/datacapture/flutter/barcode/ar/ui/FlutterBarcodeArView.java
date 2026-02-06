/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.ar.ui;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;

import androidx.annotation.Nullable;

import com.scandit.datacapture.flutter.core.ui.FlutterBasePlatformView;
import com.scandit.datacapture.flutter.core.utils.FlutterLogInsteadOfResult;
import com.scandit.datacapture.frameworks.barcode.ar.BarcodeArModule;

@SuppressLint("ViewConstructor")
public class FlutterBarcodeArView extends FlutterBasePlatformView {

    private final BarcodeArModule module;

    public FlutterBarcodeArView(Context context,
                                String jsonString,
                                BarcodeArModule module) {
        super(context);
        this.module = module;
        module.addViewToContainer(this, jsonString, new FlutterLogInsteadOfResult());
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
        module.viewDisposed();
        removeAllViews();
        super.dispose();
    }
}
