/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.scandit.datacapture.flutter.barcode.count.ui.FlutterBarcodeCountView;
import com.scandit.datacapture.frameworks.barcode.count.BarcodeCountModule;

import java.util.HashMap;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class BarcodeCountPlatformViewFactory extends PlatformViewFactory {

    BarcodeCountModule barcodeCountModule;

    public BarcodeCountPlatformViewFactory(BarcodeCountModule barcodeCountModule) {
        super(StandardMessageCodec.INSTANCE);
        this.barcodeCountModule = barcodeCountModule;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        //noinspection unchecked
        HashMap<String, String> creationArgs = (HashMap<String, String>) args;

        if (creationArgs == null) {
            throw new IllegalArgumentException("Unable to create the BarcodeCountView without the json.");
        }

        String creationJson = creationArgs.get("BarcodeCountView");

        if (creationJson == null) {
            throw new IllegalArgumentException("Unable to create the BarcodeCountView without the json.");
        }

        return new FlutterBarcodeCountView(context, creationJson, barcodeCountModule);
    }
}
