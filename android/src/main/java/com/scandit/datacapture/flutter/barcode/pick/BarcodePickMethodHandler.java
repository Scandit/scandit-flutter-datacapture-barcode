/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.pick;

import androidx.annotation.NonNull;

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
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getDefaults":
                result.success(new JSONObject(getSharedModule().getDefaults()).toString());
                break;

            case "removeScanningListener":
                getSharedModule().removeScanningListener(new FlutterResult(result));
                break;

            case "addScanningListener":
                getSharedModule().addScanningListener(new FlutterResult(result));
                break;

            case "startPickView":
                getSharedModule().viewStart();
                result.success(null);
                break;

            case "stopPickView":
                getSharedModule().viewStop();
                result.success(null);
                break;

            case "freezePickView":
                getSharedModule().viewFreeze(new FlutterResult(result));
                break;

            case "releasePickView":
                getSharedModule().viewDisposed();
                result.success(null);
                break;

            case "addViewUiListener":
                getSharedModule().addViewUiListener(new FlutterResult(result));
                break;

            case "removeViewUiListener":
                getSharedModule().removeViewUiListener(new FlutterResult(result));
                break;

            case "addViewListener":
                getSharedModule().addViewListener(new FlutterResult(result));
                break;

            case "removeViewListener":
                getSharedModule().removeViewListener(new FlutterResult(result));
                break;

            case "addActionListener":
                getSharedModule().addActionListener();
                result.success(null);
                break;

            case "removeActionListener":
                getSharedModule().removeActionListener();
                result.success(null);
                break;

            case "finishOnProductIdentifierForItems":
                assert call.arguments() != null;
                getSharedModule().finishOnProductIdentifierForItems(call.arguments());
                result.success(null);
                break;

            case "finishPickAction":
                assert call.arguments() != null;
                getSharedModule().finishPickAction(call.arguments(), new FlutterResult(result));
                break;

            default:
                throw new IllegalArgumentException("Nothing implemented for " + call.method);
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
