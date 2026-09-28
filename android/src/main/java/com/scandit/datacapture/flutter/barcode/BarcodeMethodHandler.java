/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterMethodCall;
import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.frameworks.barcode.BarcodeModule;
import com.scandit.datacapture.frameworks.core.CoreModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.errors.ParameterNullError;
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
            result.success(new JSONObject(getBarcodeModule().getDefaults()).toString());
            return;
        } else if (call.method.equals("executeBarcode")) {
            CoreModule coreModule = (CoreModule) getModule(CoreModule.class.getSimpleName());
            if (coreModule == null) {
                result.error("-1", "Unable to retrieve the CoreModule from the locator.", null);
                return;
            }
            String moduleName = call.argument("moduleName");
            if (moduleName == null) {
                result.error("-1", new ParameterNullError("moduleName").getMessage(), null);
                return;
            }
            FrameworkModule module = getModule(moduleName);
            if (module == null) {
                result.error("-1", "Unable to retrieve the module from the locator.", null);
                return;
            }
            boolean executionResult = coreModule.execute(new FlutterMethodCall(call), new FlutterResult(result), module);
            if (!executionResult) {
                String methodName = call.argument("methodName");
                if (methodName == null) {
                    methodName = "unknown";
                }

                result.error("METHOD_NOT_FOUND", "Unknown Core method: " + methodName, null);
            }
            return;
        }
        result.notImplemented();
    }

    private volatile BarcodeModule sharedModuleInstance;

    private BarcodeModule getBarcodeModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (BarcodeModule) getModule(BarcodeModule.class.getSimpleName());
                }
            }
        }
        return sharedModuleInstance;
    }

    private FrameworkModule getModule(String moduleName) {
        return this.serviceLocator.resolve(moduleName);
    }
}
