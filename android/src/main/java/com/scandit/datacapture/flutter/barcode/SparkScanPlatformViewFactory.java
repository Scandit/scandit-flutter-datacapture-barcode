/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.scandit.datacapture.flutter.barcode.spark.ui.FlutterSparkScanView;
import com.scandit.datacapture.frameworks.barcode.spark.SparkScanModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import java.util.HashMap;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class SparkScanPlatformViewFactory extends PlatformViewFactory {

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public SparkScanPlatformViewFactory(ServiceLocator<FrameworkModule> serviceLocator) {
        super(StandardMessageCodec.INSTANCE);
        this.serviceLocator = serviceLocator;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        HashMap<?, ?>  creationArgs = (HashMap<?, ?>) args;

        if (creationArgs == null) {
            throw new IllegalArgumentException("Unable to create the SparkScanView without the json.");
        }

        Object creationJson = creationArgs.get("SparkScanView");

        if (creationJson == null) {
            throw new IllegalArgumentException("Unable to create the SparkScanView without the json.");
        }

        SparkScanModule sparkScanModule = (SparkScanModule) this.serviceLocator.resolve(SparkScanModule.class.getName());
        if (sparkScanModule == null) {
            throw new IllegalArgumentException("Unable to create the SparkScanView. SparkScan module not initialized.");
        }

        return new FlutterSparkScanView(context, creationJson.toString(), sparkScanModule);
    }
}
