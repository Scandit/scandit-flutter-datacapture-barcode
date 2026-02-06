/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.find;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.frameworks.barcode.find.BarcodeFindModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.json.JSONObject;

public class BarcodeFindMethodHandler implements MethodChannel.MethodCallHandler {

    public static final String EVENT_CHANNEL_NAME = "com.scandit.datacapture.barcode.find/event_channel";
    public static final String METHOD_CHANNEL_NAME = "com.scandit.datacapture.barcode.find/method_channel";

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public BarcodeFindMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this.serviceLocator = serviceLocator;
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getBarcodeFindDefaults":
                result.success(new JSONObject(getSharedModule().getDefaults()).toString());
                break;
            case "updateFindView":
                assert call.arguments() != null;
                getSharedModule().updateBarcodeFindView(call.arguments(), new FlutterResult(result));
                break;
            case "updateFindMode":
                assert call.arguments() != null;
                getSharedModule().updateBarcodeFindMode(call.arguments(), new FlutterResult(result));
                break;
            case "registerBarcodeFindListener":
                getSharedModule().addBarcodeFindListener(new FlutterResult(result));
                break;
            case "unregisterBarcodeFindListener":
                getSharedModule().removeBarcodeFindListener(new FlutterResult(result));
                break;
            case "registerBarcodeFindViewListener":
                getSharedModule().addBarcodeFindViewListener(new FlutterResult(result));
                break;
            case "unregisterBarcodeFindViewListener":
                getSharedModule().removeBarcodeFindViewListener(new FlutterResult(result));
                break;
            case "barcodeFindSetItemList":
                assert call.arguments() != null;
                getSharedModule().setItemList(call.arguments(), new FlutterResult(result));
                break;
            case "barcodeFindViewStopSearching":
                getSharedModule().viewStopSearching(new FlutterResult(result));
                break;
            case "barcodeFindViewStartSearching":
                getSharedModule().viewStartSearching(new FlutterResult(result));
                break;
            case "barcodeFindViewPauseSearching":
                getSharedModule().viewPauseSearching(new FlutterResult(result));
                break;
            case "barcodeFindModeStart":
                getSharedModule().modeStart(new FlutterResult(result));
                break;
            case "barcodeFindModePause":
                getSharedModule().modePause(new FlutterResult(result));
                break;
            case "barcodeFindModeStop":
                getSharedModule().modeStop(new FlutterResult(result));
                break;
            case "setModeEnabledState":
                getSharedModule().setModeEnabled(Boolean.TRUE.equals(call.arguments()));
                break;
            case "setBarcodeTransformer":
                getSharedModule().setBarcodeFindTransformer(new FlutterResult(result));
                break;
            case "submitBarcodeTransformerResult":
                getSharedModule().submitBarcodeFindTransformerResult(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;
            case "updateFeedback":
                assert call.arguments() != null;
                getSharedModule().updateFeedback(call.arguments(), new FlutterResult(result));
                break;
            default:
                throw new IllegalArgumentException("Nothing implemented for " + call.method);
        }
    }

    private volatile BarcodeFindModule sharedModuleInstance;

    private BarcodeFindModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (BarcodeFindModule)this.serviceLocator.resolve(BarcodeFindModule.class.getName());
                }
            }
        }
        return sharedModuleInstance;
    }
}
