/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode;

import androidx.annotation.NonNull;

import com.scandit.datacapture.frameworks.barcode.BarcodeModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.json.JSONObject;

public class BarcodeMethodHandler implements MethodChannel.MethodCallHandler {

    public static String METHOD_CHANNEL = "com.scandit.datacapture.barcode/method_channel";

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public BarcodeMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this.serviceLocator = serviceLocator;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("getDefaults")) {
            result.success(new JSONObject(getSharedModule().getDefaults()).toString());
            return;
        }
        result.notImplemented();
    }

    private volatile BarcodeModule sharedModuleInstance;

    private BarcodeModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (BarcodeModule)this.serviceLocator.resolve(BarcodeModule.class.getName());
                }
            }
        }
        return sharedModuleInstance;
    }
}
