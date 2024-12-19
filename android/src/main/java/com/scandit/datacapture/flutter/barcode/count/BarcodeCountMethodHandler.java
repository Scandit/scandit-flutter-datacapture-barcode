/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.count;

import androidx.annotation.NonNull;

import com.scandit.datacapture.core.ui.style.BrushDeserializer;
import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.frameworks.barcode.count.BarcodeCountModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

public class BarcodeCountMethodHandler implements MethodChannel.MethodCallHandler {

    public static final String EVENT_CHANNEL_NAME = "com.scandit.datacapture.barcode.count/event_channel";
    public static final String METHOD_CHANNEL_NAME = "com.scandit.datacapture.barcode.count/method_channel";

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public BarcodeCountMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this.serviceLocator = serviceLocator;
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "addBarcodeCountViewListener":
                getSharedModule().addBarcodeCountViewListener();
                result.success(null);
                break;

            case "removeBarcodeCountViewListener":
                getSharedModule().removeBarcodeCountViewListener();
                result.success(null);
                break;

            case "addBarcodeCountViewUiListener":
                getSharedModule().addBarcodeCountViewUiListener();
                result.success(null);
                break;

            case "removeBarcodeCountViewUiListener":
                getSharedModule().removeBarcodeCountViewUiListener();
                result.success(null);
                break;

            case "clearHighlights":
                getSharedModule().clearHighlights();
                result.success(null);
                break;

            case "finishBrushForRecognizedBarcodeEvent":
                handleFinishBrushForRecognizedBarcodeEvent(call, result);
                break;

            case "finishBrushForRecognizedBarcodeNotInListEvent":
                handleFinishBrushForRecognizedBarcodeNotInListEvent(call, result);
                break;

            case "finishBrushForUnrecognizedBarcodeEvent":
                handleFinishBrushForUnrecognizedBarcodeEvent(call, result);
                break;

            case "getBarcodeCountDefaults":
                result.success(new JSONObject(getSharedModule().getDefaults()).toString());
                break;

            case "setBarcodeCountCaptureList":
                try {
                    getSharedModule().setBarcodeCountCaptureList(new JSONArray((String) call.arguments));
                    result.success(null);
                } catch (JSONException e) {
                    result.error("-1", e.getMessage(), e.getCause());
                }
                break;

            case "resetBarcodeCountSession":
                getSharedModule().resetBarcodeCountSession((Long) call.arguments);
                result.success(null);
                break;

            case "barcodeCountFinishOnScan":
                boolean enabled = call.arguments instanceof Boolean ? (Boolean) call.arguments : false;
                getSharedModule().finishOnScan(enabled);
                result.success(true);
                break;

            case "addBarcodeCountListener":
                getSharedModule().addAsyncBarcodeCountListener();
                result.success(null);
                break;

            case "removeBarcodeCountListener":
                getSharedModule().removeAsyncBarcodeCountListener();
                result.success(null);
                break;

            case "getBarcodeCountLastFrameData":
                assert call.arguments() != null;
                getSharedModule().getFrameDataBytes(call.arguments(), new FlutterResult(result));
                break;

            case "resetBarcodeCount":
                getSharedModule().resetBarcodeCount();
                result.success(null);
                break;

            case "startScanningPhase":
                getSharedModule().startScanningPhase();
                result.success(null);
                break;

            case "endScanningPhase":
                getSharedModule().endScanningPhase();
                result.success(null);
                break;

            case "updateBarcodeCountView":
                assert call.arguments() != null;
                getSharedModule().updateBarcodeCountView(call.arguments());
                result.success(null);
                break;

            case "updateBarcodeCountMode":
                assert call.arguments() != null;
                getSharedModule().updateBarcodeCount(call.arguments());
                result.success(null);
                break;

            case "setModeEnabledState":
                getSharedModule().setModeEnabled(Boolean.TRUE.equals(call.arguments()));
                break;

            case "updateFeedback":
                assert call.arguments() != null;
                getSharedModule().updateFeedback(call.arguments(), new FlutterResult(result));
                break;
            case "submitBarcodeCountStatusProviderCallback":
                assert call.arguments() != null;
                getSharedModule().submitBarcodeCountStatusProviderCallbackResult(call.arguments(),
                        new FlutterResult(result)
                );
                break;
            case "addBarcodeCountStatusProvider":
                getSharedModule().addBarcodeCountStatusProvider(new FlutterResult(result));
                break;

            default:
                throw new IllegalArgumentException("Nothing implemented for " + call.method);
        }
    }

    private void handleFinishBrushForRecognizedBarcodeEvent(MethodCall call, MethodChannel.Result result) {
        HashMap<?, ?> arguments = call.arguments instanceof HashMap ? (HashMap<?, ?>) call.arguments : null;
        if (arguments == null) {
            result.error("-1", "Invalid argument for finishBrushForRecognizedBarcodeEvent", "");
            return;
        }
        String brushJson = (String) arguments.get("brush");
        int trackedBarcodeId = (int) arguments.get("trackedBarcodeId");

        assert brushJson != null;
        getSharedModule().finishBrushForRecognizedBarcodeEvent(BrushDeserializer.fromJson(brushJson), trackedBarcodeId);
        result.success(null);
    }

    private void handleFinishBrushForRecognizedBarcodeNotInListEvent(MethodCall call, MethodChannel.Result result) {
        HashMap<?, ?> arguments = call.arguments instanceof HashMap ? (HashMap<?, ?>) call.arguments : null;
        if (arguments == null) {
            result.error("-1", "Invalid argument for finishBrushForRecognizedBarcodeNotInListEvent", "");
            return;
        }
        String brushJson = (String) arguments.get("brush");
        int trackedBarcodeId = (int) arguments.get("trackedBarcodeId");

        assert brushJson != null;
        getSharedModule().finishBrushForRecognizedBarcodeNotInListEvent(BrushDeserializer.fromJson(brushJson), trackedBarcodeId);
        result.success(null);
    }

    private void handleFinishBrushForUnrecognizedBarcodeEvent(MethodCall call, MethodChannel.Result result) {
        HashMap<?, ?> arguments = call.arguments instanceof HashMap ? (HashMap<?, ?>) call.arguments : null;
        if (arguments == null) {
            result.error("-1", "Invalid argument for finishBrushForUnrecognizedBarcodeEvent", "");
            return;
        }
        String brushJson = (String) arguments.get("brush");
        int trackedBarcodeId = (int) arguments.get("trackedBarcodeId");

        assert brushJson != null;
        getSharedModule().finishBrushForUnrecognizedBarcodeEvent(BrushDeserializer.fromJson(brushJson), trackedBarcodeId);
        result.success(null);
    }

    private volatile BarcodeCountModule sharedModuleInstance;

    private BarcodeCountModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (BarcodeCountModule) this.serviceLocator.resolve(BarcodeCountModule.class.getName());
                }
            }
        }
        return sharedModuleInstance;
    }
}
