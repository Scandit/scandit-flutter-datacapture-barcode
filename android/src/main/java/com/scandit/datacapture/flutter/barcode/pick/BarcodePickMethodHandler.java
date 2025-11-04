/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.pick;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterMethodCall;
import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.frameworks.barcode.pick.BarcodePickModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.json.JSONObject;

public class BarcodePickMethodHandler implements MethodChannel.MethodCallHandler {

    public static final String EVENT_CHANNEL_NAME = "com.scandit.datacapture.barcode.pick/event_channel";
    public static final String METHOD_CHANNEL_NAME = "com.scandit.datacapture.barcode.pick/method_channel";

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public BarcodePickMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
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

    private volatile BarcodePickModule sharedModuleInstance;

    private BarcodePickModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (BarcodePickModule)this.serviceLocator.resolve(BarcodePickModule.class.getName());
                }
            }
        }
        return sharedModuleInstance;
    }
}
