/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.find.ui;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;

import androidx.annotation.Nullable;

import com.scandit.datacapture.flutter.core.ui.FlutterBasePlatformView;
import com.scandit.datacapture.flutter.core.utils.FlutterLogInsteadOfResult;
import com.scandit.datacapture.frameworks.barcode.find.BarcodeFindModule;

@SuppressLint("ViewConstructor")
public class FlutterBarcodeFindView extends FlutterBasePlatformView {

    private final BarcodeFindModule barcodeFindModule;

    public FlutterBarcodeFindView(Context context,
                                  String jsonString,
                                  BarcodeFindModule barcodeFindModule) {
        super(context);
        this.barcodeFindModule = barcodeFindModule;

        barcodeFindModule.addViewToContainer(this, jsonString, new FlutterLogInsteadOfResult());
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
        barcodeFindModule.viewDisposed();
        removeAllViews();
        super.dispose();
    }
}
