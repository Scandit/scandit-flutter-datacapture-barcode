/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.spark;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterMethodCall;
import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.frameworks.barcode.spark.SparkScanModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SparkScanMethodHandler implements MethodChannel.MethodCallHandler {

    public static final String EVENT_CHANNEL_NAME = "com.scandit.datacapture.barcode.spark/event_channel";
    public static final String METHOD_CHANNEL_NAME = "com.scandit.datacapture.barcode.spark/method_channel";

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public SparkScanMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this.serviceLocator = serviceLocator;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean executionResult = getSharedModule().execute(
                new FlutterMethodCall(call),
                new FlutterResult(result)
        );

        if (!executionResult) {
            result.notImplemented();
        }
    }

    private volatile SparkScanModule sharedModuleInstance;

    private SparkScanModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (SparkScanModule) this.serviceLocator.resolve(SparkScanModule.class.getName());
                }
            }
        }
        return sharedModuleInstance;
    }
}
