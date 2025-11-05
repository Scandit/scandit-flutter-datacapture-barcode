/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.check.ui;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;

import androidx.annotation.Nullable;

import com.scandit.datacapture.flutter.core.ui.FlutterBasePlatformView;
import com.scandit.datacapture.flutter.core.utils.DefaultActivityLifecycleObserver;
import com.scandit.datacapture.flutter.core.utils.FlutterLogInsteadOfResult;
import com.scandit.datacapture.frameworks.barcode.check.BarcodeCheckModule;
import com.scandit.datacapture.frameworks.barcode.find.BarcodeFindModule;
import com.scandit.datacapture.frameworks.core.result.NoopFrameworksResult;

@SuppressLint("ViewConstructor")
public class FlutterBarcodeCheckView extends FlutterBasePlatformView {

    private final BarcodeCheckModule module;

    public FlutterBarcodeCheckView(Context context,
                                   String jsonString,
                                   BarcodeCheckModule module) {
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
