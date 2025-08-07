/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.batch;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.frameworks.barcode.batch.BarcodeBatchModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.json.JSONObject;

import java.util.HashMap;

public class BarcodeBatchMethodHandler implements MethodChannel.MethodCallHandler {

    public static final String EVENT_CHANNEL_NAME = "com.scandit.datacapture.barcode.batch/event_channel";
    public static final String METHOD_CHANNEL_NAME = "com.scandit.datacapture.barcode.batch/method_channel";

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public BarcodeBatchMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this.serviceLocator = serviceLocator;
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getBarcodeBatchDefaults":
                result.success(new JSONObject(getSharedModule().getDefaults()).toString());
                break;
            case "addBarcodeBatchListener":
                getSharedModule().addAsyncBarcodeBatchListener();
                result.success(null);
                break;
            case "removeBarcodeBatchListener":
                getSharedModule().removeAsyncBarcodeBatchListener();
                result.success(null);
                break;
            case "barcodeBatchFinishDidUpdateSession":
                getSharedModule().finishDidUpdateSession(Boolean.TRUE.equals(call.arguments));
                result.success(true);
                break;
            case "resetBarcodeBatchSession":
                getSharedModule().resetSession(
                        call.arguments instanceof Long ? (Long) call.arguments : null
                );
                result.success(null);
                break;
            case "getLastFrameData":
                assert call.arguments() != null;
                getSharedModule().getFrameDataBytes(call.arguments(), new FlutterResult(result));
                break;
            case "addBarcodeBatchAdvancedOverlayDelegate":
                getSharedModule().addAdvancedOverlayListener();
                result.success(null);
                break;
            case "removeBarcodeBatchAdvancedOverlayDelegate":
                getSharedModule().removeAdvancedOverlayListener();
                result.success(null);
                break;
            case "clearTrackedBarcodeWidgets":
                getSharedModule().clearAdvancedOverlayTrackedBarcodeViews();
                result.success(null);
                break;
            case "setWidgetForTrackedBarcode":
                if (!(call.arguments instanceof HashMap)) {
                    result.error("-1", "Invalid argument for setWidgetForTrackedBarcode", "");
                    return;
                }

                //noinspection unchecked
                getSharedModule().setWidgetForTrackedBarcode((HashMap<String, Object>) call.arguments);
                result.success(null);
                break;
            case "setAnchorForTrackedBarcode":
                if (!(call.arguments instanceof HashMap)) {
                    result.error("-1", "Invalid argument for setAnchorForTrackedBarcode", "");
                    return;
                }
                //noinspection unchecked
                getSharedModule().setAnchorForTrackedBarcode((HashMap<String, Object>) call.arguments);
                result.success(null);
                break;
            case "setOffsetForTrackedBarcode":
                if (!(call.arguments instanceof HashMap)) {
                    result.error("-1", "Invalid argument for setOffsetForTrackedBarcode", "");
                    return;
                }
                //noinspection unchecked
                getSharedModule().setOffsetForTrackedBarcode((HashMap<String, Object>) call.arguments);
                result.success(null);
                break;
            case "subscribeBarcodeBatchBasicOverlayListener":
                getSharedModule().addBasicOverlayListener();
                result.success(null);
                break;
            case "unsubscribeBarcodeBatchBasicOverlayListener":
                getSharedModule().removeBasicOverlayListener();
                result.success(null);
                break;
            case "setBrushForTrackedBarcode":
                getSharedModule().setBasicOverlayBrushForTrackedBarcode(
                        call.arguments.toString()
                );
                result.success(null);
                break;
            case "clearTrackedBarcodeBrushes":
                getSharedModule().clearBasicOverlayTrackedBarcodeBrushes();
                result.success(null);
                break;
            case "setModeEnabledState":
                getSharedModule().setModeEnabled(Boolean.TRUE.equals(call.arguments()));
                break;
            case "updateBarcodeBatchMode":
                assert call.arguments() != null;
                getSharedModule().updateModeFromJson(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;
            case "applyBarcodeBatchModeSettings":
                assert call.arguments() != null;
                getSharedModule().applyModeSettings(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;
            case "updateBarcodeBatchBasicOverlay":
                assert call.arguments() != null;
                getSharedModule().updateBasicOverlay(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;
            case "updateBarcodeBatchAdvancedOverlay":
                assert call.arguments() != null;
                getSharedModule().updateAdvancedOverlay(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;
            default:
                result.notImplemented();
        }
    }

    private volatile BarcodeBatchModule sharedModuleInstance;

    private BarcodeBatchModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (BarcodeBatchModule)this.serviceLocator.resolve(BarcodeBatchModule.class.getName());
                }
            }
        }
        return sharedModuleInstance;
    }
}
