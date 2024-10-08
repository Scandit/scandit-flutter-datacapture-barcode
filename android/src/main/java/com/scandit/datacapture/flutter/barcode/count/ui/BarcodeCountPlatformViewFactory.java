/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.count.ui;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.scandit.datacapture.frameworks.barcode.count.BarcodeCountModule;
import com.scandit.datacapture.frameworks.core.CoreModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import java.util.HashMap;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class BarcodeCountPlatformViewFactory extends PlatformViewFactory {

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public BarcodeCountPlatformViewFactory(ServiceLocator<FrameworkModule> serviceLocator) {
        super(StandardMessageCodec.INSTANCE);
        this.serviceLocator = serviceLocator;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        HashMap<?, ?>  creationArgs = (HashMap<?, ?>) args;

        if (creationArgs == null) {
            throw new IllegalArgumentException("Unable to create the BarcodeCountView without the json.");
        }

        Object creationJson = creationArgs.get("BarcodeCountView");

        if (creationJson == null) {
            throw new IllegalArgumentException("Unable to create the BarcodeCountView without the json.");
        }

        BarcodeCountModule barcodeCountModule = (BarcodeCountModule) this.serviceLocator.resolve(BarcodeCountModule.class.getName());
        if (barcodeCountModule == null) {
            throw new IllegalArgumentException("Unable to create the BarcodeCountView. Barcode Count module not initialized.");
        }

        return new FlutterBarcodeCountView(context, creationJson.toString(), barcodeCountModule);
    }
}
