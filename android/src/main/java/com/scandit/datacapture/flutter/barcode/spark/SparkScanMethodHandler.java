/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.spark;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.frameworks.barcode.spark.SparkScanModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.json.JSONObject;

public class SparkScanMethodHandler implements MethodChannel.MethodCallHandler {

    public static final String EVENT_CHANNEL_NAME = "com.scandit.datacapture.barcode.spark/event_channel";
    public static final String METHOD_CHANNEL_NAME = "com.scandit.datacapture.barcode.spark/method_channel";

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public SparkScanMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this.serviceLocator = serviceLocator;
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getSparkScanDefaults":
                result.success(new JSONObject(getSharedModule().getDefaults()).toString());
                break;

            case "finishDidScan":
                getSharedModule().finishDidScanCallback(Boolean.TRUE.equals(call.arguments()));
                result.success(null);
                break;

            case "finishDidUpdateSession":
                getSharedModule().finishDidUpdateSessionCallback(
                        Boolean.TRUE.equals(call.arguments())
                );
                result.success(null);
                break;

            case "addSparkScanListener":
                getSharedModule().addAsyncSparkScanListener();
                result.success(null);
                break;

            case "removeSparkScanListener":
                getSharedModule().removeAsyncSparkScanListener();
                result.success(null);
                break;

            case "resetSparkScanSession":
                getSharedModule().resetSession();
                result.success(null);
                break;

            case "getLastFrameData":
                assert call.arguments() != null;
                getSharedModule().getFrameDataBytes(call.arguments(), new FlutterResult(result));
                break;

            case "updateSparkScanMode":
                assert call.arguments() != null;
                getSharedModule().updateMode(call.arguments(), new FlutterResult(result));
                break;

            case "addSparkScanViewUiListener":
                getSharedModule().addSparkScanViewUiListener();
                result.success(null);
                break;

            case "removeSparkScanViewUiListener":
                getSharedModule().removeSparkScanViewUiListener();
                result.success(null);
                break;

            case "sparkScanViewStartScanning":
                getSharedModule().startScanning(new FlutterResult(result));
                break;

            case "sparkScanViewPauseScanning":
                getSharedModule().pauseScanning();
                result.success(null);
                break;

            case "showToast":
                assert call.arguments() != null;
                getSharedModule().showToast(call.arguments(), new FlutterResult(result));
                break;

            case "setModeEnabledState":
                getSharedModule().setModeEnabled(Boolean.TRUE.equals(call.arguments()));
                break;

            case "addFeedbackDelegate":
                getSharedModule().addFeedbackDelegate(new FlutterResult(result));
                break;

            case "removeFeedbackDelegate":
                getSharedModule().removeFeedbackDelegate(new FlutterResult(result));
                break;

            case "submitFeedbackForBarcode":
                getSharedModule().submitFeedbackForBarcode(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;

            case "sparkScanViewUpdate":
                assert call.arguments() != null;
                getSharedModule().updateView(call.arguments(), new FlutterResult(result));
                break;

            default:
                throw new IllegalStateException("Unexpected value: " + call.method);
        }
    }

    private volatile SparkScanModule sharedModuleInstance;

    private SparkScanModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (SparkScanModule)this.serviceLocator.resolve(SparkScanModule.class.getName());
                }
            }
        }
        return sharedModuleInstance;
    }
}
