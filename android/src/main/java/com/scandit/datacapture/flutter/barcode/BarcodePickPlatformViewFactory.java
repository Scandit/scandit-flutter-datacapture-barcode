/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.scandit.datacapture.flutter.barcode.find.ui.FlutterBarcodeFindView;
import com.scandit.datacapture.flutter.barcode.pick.ui.FlutterBarcodePickView;
import com.scandit.datacapture.frameworks.barcode.find.BarcodeFindModule;
import com.scandit.datacapture.frameworks.barcode.pick.BarcodePickModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import java.util.HashMap;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class BarcodePickPlatformViewFactory extends PlatformViewFactory {

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public BarcodePickPlatformViewFactory(ServiceLocator<FrameworkModule> serviceLocator) {
        super(StandardMessageCodec.INSTANCE);
        this.serviceLocator = serviceLocator;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        HashMap<?, ?>  creationArgs = (HashMap<?, ?>) args;

        if (creationArgs == null) {
            throw new IllegalArgumentException("Unable to create the BarcodePickView without the json.");
        }

        Object creationJson = creationArgs.get("BarcodePickView");

        if (creationJson == null) {
            throw new IllegalArgumentException("Unable to create the BarcodePickView without the json.");
        }

        BarcodePickModule barcodePickModule = (BarcodePickModule) this.serviceLocator.resolve(BarcodePickModule.class.getName());
        if (barcodePickModule == null) {
            throw new IllegalArgumentException("Unable to create the BarcodePickView. Barcode Pick module not initialized.");
        }

        return new FlutterBarcodePickView(context, creationJson.toString(), barcodePickModule);
    }
}
