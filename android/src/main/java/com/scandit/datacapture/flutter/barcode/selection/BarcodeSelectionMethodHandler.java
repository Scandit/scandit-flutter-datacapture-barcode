/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.selection;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.flutter.core.utils.ResultUtils;
import com.scandit.datacapture.frameworks.barcode.selection.BarcodeSelectionModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.errors.FrameDataNullError;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;
import com.scandit.datacapture.frameworks.core.frames.DefaultFrameDataHandler;
import com.scandit.datacapture.frameworks.core.frames.FrameDataHandler;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.json.JSONObject;

public class BarcodeSelectionMethodHandler implements MethodChannel.MethodCallHandler {

    public static final String EVENT_CHANNEL_NAME = "com.scandit.datacapture.barcode.selection/event_channel";
    public static final String METHOD_CHANNEL_NAME = "com.scandit.datacapture.barcode.selection/method_channel";

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public BarcodeSelectionMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this.serviceLocator = serviceLocator;
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getBarcodeSelectionDefaults":
                result.success(new JSONObject(getSharedModule().getDefaults()).toString());
                break;

            case "getBarcodeSelectionSessionCount":
                assert call.arguments() != null;
                getSharedModule().submitBarcodeCountForIdentifier(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;

            case "resetBarcodeSelectionSession":
                getSharedModule().resetLatestSession(call.arguments());
                result.success(null);
                break;

            case "addBarcodeSelectionListener":
                getSharedModule().addAsyncListener();
                result.success(null);
                break;

            case "removeBarcodeSelectionListener":
                getSharedModule().removeAsyncListener();
                result.success(null);
                break;

            case "resetMode":
                getSharedModule().resetSelection();
                result.success(null);
                break;

            case "unfreezeCamera":
                getSharedModule().unfreezeCamera();
                result.success(null);
                break;

            case "finishDidUpdateSelection":
                getSharedModule().finishDidSelect(Boolean.TRUE.equals(call.arguments()));
                result.success(null);
                break;

            case "finishDidUpdateSession":
                getSharedModule().finishDidUpdateSession(
                        Boolean.TRUE.equals(call.arguments())
                );
                result.success(null);
                break;

            case "getLastFrameData":
                assert call.arguments() != null;
                getSharedModule().getFrameDataBytes(call.arguments(), new FlutterResult(result));
                break;

            case "setModeEnabledState":
                getSharedModule().setModeEnabled(Boolean.TRUE.equals(call.arguments()));
                break;

            case "updateBarcodeSelectionMode":
                assert call.arguments() != null;
                getSharedModule().updateModeFromJson(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;

            case "applyBarcodeSelectionModeSettings":
                assert call.arguments() != null;
                getSharedModule().applyModeSettings(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;

            case "updateBarcodeSelectionBasicOverlay":
                assert call.arguments() != null;
                getSharedModule().updateBasicOverlay(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;
            case "updateFeedback":
                assert call.arguments() != null;
                getSharedModule().updateFeedback(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;
            default:
                throw new IllegalStateException("Unexpected value: " + call.method);
        }
    }

    private volatile BarcodeSelectionModule sharedModuleInstance;

    private BarcodeSelectionModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (BarcodeSelectionModule)this.serviceLocator.resolve(BarcodeSelectionModule.class.getName());
                }
            }
        }
        return sharedModuleInstance;
    }
}
