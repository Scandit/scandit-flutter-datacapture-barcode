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
    private static final String FIELD_VIEW_ID = "viewId";

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public BarcodeCountMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this.serviceLocator = serviceLocator;
    }

    private <T> T getArgument(MethodCall call, String key) {
        if (!call.hasArgument(key)) {
            throw new IllegalArgumentException("Missing viewId in call " + call.method);
        }
        return call.argument(key);
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "addBarcodeCountViewListener":
                getSharedModule().addBarcodeCountViewListener(getArgument(call, FIELD_VIEW_ID));
                result.success(null);
                break;

            case "removeBarcodeCountViewListener":
                getSharedModule().removeBarcodeCountViewListener(getArgument(call, FIELD_VIEW_ID));
                result.success(null);
                break;

            case "addBarcodeCountViewUiListener":
                getSharedModule().addBarcodeCountViewUiListener(getArgument(call, FIELD_VIEW_ID));
                result.success(null);
                break;

            case "removeBarcodeCountViewUiListener":
                getSharedModule().removeBarcodeCountViewUiListener(getArgument(call, FIELD_VIEW_ID));
                result.success(null);
                break;

            case "clearHighlights":
                getSharedModule().clearHighlights(getArgument(call, FIELD_VIEW_ID));
                result.success(null);
                break;

            case "finishBrushForRecognizedBarcodeEvent":
                handleFinishBrushForRecognizedBarcodeEvent(call, result);
                break;

            case "finishBrushForRecognizedBarcodeNotInListEvent":
                handleFinishBrushForRecognizedBarcodeNotInListEvent(call, result);
                break;

            case "getBarcodeCountDefaults":
                result.success(new JSONObject(getSharedModule().getDefaults()).toString());
                break;

            case "setBarcodeCountCaptureList":
                try {
                    getSharedModule().setBarcodeCountCaptureList(
                            getArgument(call, FIELD_VIEW_ID),
                            new JSONArray((String) getArgument(call, "targetBarcodes"))
                    );
                    result.success(null);
                } catch (JSONException e) {
                    result.error("-1", e.getMessage(), e.getCause());
                }
                break;

            case "resetBarcodeCountSession":
                getSharedModule().resetBarcodeCountSession(
                        getArgument(call, FIELD_VIEW_ID),
                        getArgument(call, "frameSequenceId")
                );
                result.success(null);
                break;

            case "barcodeCountFinishOnScan":
                getSharedModule().finishOnScan(
                        getArgument(call, FIELD_VIEW_ID),
                        getArgument(call, "enabled")
                );
                result.success(true);
                break;

            case "addBarcodeCountListener":
                getSharedModule().addAsyncBarcodeCountListener(getArgument(call, FIELD_VIEW_ID));
                result.success(null);
                break;

            case "removeBarcodeCountListener":
                getSharedModule().removeAsyncBarcodeCountListener(getArgument(call, FIELD_VIEW_ID));
                result.success(null);
                break;

            case "getBarcodeCountLastFrameData":
                assert call.arguments() != null;
                getSharedModule().getFrameDataBytes(call.arguments(), new FlutterResult(result));
                break;

            case "resetBarcodeCount":
                getSharedModule().resetBarcodeCount(getArgument(call, FIELD_VIEW_ID));
                result.success(null);
                break;

            case "startScanningPhase":
                getSharedModule().startScanningPhase(getArgument(call, FIELD_VIEW_ID));
                result.success(null);
                break;

            case "endScanningPhase":
                getSharedModule().endScanningPhase(getArgument(call, FIELD_VIEW_ID));
                result.success(null);
                break;

            case "updateBarcodeCountView":
                assert call.arguments() != null;
                getSharedModule().updateBarcodeCountView(
                        getArgument(call, FIELD_VIEW_ID),
                        getArgument(call, "viewJson")
                );
                result.success(null);
                break;

            case "updateBarcodeCountMode":
                assert call.arguments() != null;
                getSharedModule().updateBarcodeCount(
                        getArgument(call, FIELD_VIEW_ID),
                        getArgument(call, "modeJson")
                );
                result.success(null);
                break;

            case "setModeEnabledState":
                getSharedModule().setModeEnabled(
                        getArgument(call, FIELD_VIEW_ID),
                        getArgument(call, "enabled")
                );
                break;

            case "updateFeedback":
                assert call.arguments() != null;
                getSharedModule().updateFeedback(
                        getArgument(call, FIELD_VIEW_ID),
                        getArgument(call, "feedbackJson"),
                        new FlutterResult(result)
                );
                break;
            case "submitBarcodeCountStatusProviderCallback":
                assert call.arguments() != null;
                getSharedModule().submitBarcodeCountStatusProviderCallbackResult(
                        getArgument(call, FIELD_VIEW_ID),
                        getArgument(call, "statusJson"),
                        new FlutterResult(result)
                );
                break;
            case "addBarcodeCountStatusProvider":
                getSharedModule().addBarcodeCountStatusProvider(
                        getArgument(call, FIELD_VIEW_ID),
                        new FlutterResult(result)
                );
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
        String brushJson = getArgument(call, "brush");
        int trackedBarcodeId = getArgument(call, "trackedBarcodeId");
        int viewId = getArgument(call, FIELD_VIEW_ID);

        assert brushJson != null;
        getSharedModule().finishBrushForRecognizedBarcodeEvent(viewId, BrushDeserializer.fromJson(brushJson), trackedBarcodeId);
        result.success(null);
    }

    private void handleFinishBrushForRecognizedBarcodeNotInListEvent(MethodCall call, MethodChannel.Result result) {
        HashMap<?, ?> arguments = call.arguments instanceof HashMap ? (HashMap<?, ?>) call.arguments : null;
        if (arguments == null) {
            result.error("-1", "Invalid argument for finishBrushForRecognizedBarcodeNotInListEvent", "");
            return;
        }
        String brushJson = getArgument(call, "brush");
        int trackedBarcodeId = getArgument(call, "trackedBarcodeId");
        int viewId = getArgument(call, FIELD_VIEW_ID);

        assert brushJson != null;
        getSharedModule().finishBrushForRecognizedBarcodeNotInListEvent(viewId, BrushDeserializer.fromJson(brushJson), trackedBarcodeId);
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
