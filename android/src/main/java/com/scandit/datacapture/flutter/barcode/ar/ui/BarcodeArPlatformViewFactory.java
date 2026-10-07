/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.ar.ui;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.scandit.datacapture.frameworks.barcode.ar.BarcodeArModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import java.util.HashMap;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class BarcodeArPlatformViewFactory extends PlatformViewFactory {

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public BarcodeArPlatformViewFactory(ServiceLocator<FrameworkModule> serviceLocator) {
        super(StandardMessageCodec.INSTANCE);
        this.serviceLocator = serviceLocator;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        HashMap<?, ?> creationArgs = (HashMap<?, ?>) args;

        if (creationArgs == null) {
            throw new IllegalArgumentException("Unable to create the BarcodeArView without the json.");
        }

        Object creationJson = creationArgs.get("BarcodeArView");

        if (creationJson == null) {
            throw new IllegalArgumentException("Unable to create the BarcodeArView without the json.");
        }

        BarcodeArModule module = (BarcodeArModule) this.serviceLocator.resolve(BarcodeArModule.class.getName());
        if (module == null) {
            throw new IllegalArgumentException("Unable to create the BarcodeFindView. Barcode Find module not initialized.");
        }

        return new FlutterBarcodeArView(context, creationJson.toString(), module);
    }
}
