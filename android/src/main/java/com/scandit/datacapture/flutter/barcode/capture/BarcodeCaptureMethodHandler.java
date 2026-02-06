/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.capture;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.frameworks.barcode.capture.BarcodeCaptureModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.json.JSONObject;

public class BarcodeCaptureMethodHandler implements MethodChannel.MethodCallHandler {

    public static final String EVENT_CHANNEL_NAME = "com.scandit.datacapture.barcode.capture/event_channel";
    public static final String METHOD_CHANNEL_NAME = "com.scandit.datacapture.barcode.capture/method_channel";

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public BarcodeCaptureMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this.serviceLocator = serviceLocator;
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getBarcodeCaptureDefaults":
                result.success(new JSONObject(getSharedModule().getDefaults()).toString());
                break;
            case "finishDidScan":
                getSharedModule().finishDidScan(Boolean.TRUE.equals(call.arguments));
                result.success(null);
                break;
            case "finishDidUpdateSession":
                getSharedModule().finishDidUpdateSession(Boolean.TRUE.equals(call.arguments));
                result.success(null);
                break;
            case "addBarcodeCaptureListener":
                getSharedModule().addAsyncListener();
                result.success(null);
                break;
            case "removeBarcodeCaptureListener":
                getSharedModule().removeAsyncListener();
                result.success(null);
                break;
            case "resetBarcodeCaptureSession":
                getSharedModule().resetSession(
                        call.arguments()
                );
                result.success(null);
                break;
            case "getLastFrameData":
                assert call.arguments() != null;
                getSharedModule().getFrameDataBytes(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;
            case "setModeEnabledState":
                getSharedModule().setModeEnabled(Boolean.TRUE.equals(call.arguments()));
                break;
            case "updateBarcodeCaptureMode":
                assert call.arguments() != null;
                getSharedModule().updateModeFromJson(
                        call.arguments(), new FlutterResult(result)
                );
                break;
            case "applyBarcodeCaptureModeSettings":
                assert call.arguments() != null;
                getSharedModule().applyModeSettings(
                        call.arguments(), new FlutterResult(result)
                );
                break;
            case "updateBarcodeCaptureOverlay":
                assert call.arguments() != null;
                getSharedModule().updateOverlay(call.arguments(), new FlutterResult(result));
                break;
            case "updateFeedback":
                assert call.arguments() != null;
                getSharedModule().updateFeedback(call.arguments(), new FlutterResult(result));
                break;
            default:
                result.notImplemented();
        }
    }

    private volatile BarcodeCaptureModule sharedModuleInstance;

    private BarcodeCaptureModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (BarcodeCaptureModule)this.serviceLocator.resolve(BarcodeCaptureModule.class.getName());
                }
            }
        }
        return sharedModuleInstance;
    }
}
