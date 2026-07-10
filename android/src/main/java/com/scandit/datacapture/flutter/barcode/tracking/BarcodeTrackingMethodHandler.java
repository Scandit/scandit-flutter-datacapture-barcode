/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.tracking;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.flutter.core.utils.ResultUtils;
import com.scandit.datacapture.frameworks.barcode.tracking.BarcodeTrackingModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.errors.FrameDataNullError;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;
import com.scandit.datacapture.frameworks.core.utils.DefaultLastFrameData;
import com.scandit.datacapture.frameworks.core.utils.LastFrameData;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.json.JSONObject;

import java.util.HashMap;

public class BarcodeTrackingMethodHandler implements MethodChannel.MethodCallHandler {

    public static final String EVENT_CHANNEL_NAME = "com.scandit.datacapture.barcode.tracking/event_channel";
    public static final String METHOD_CHANNEL_NAME = "com.scandit.datacapture.barcode.tracking/method_channel";

    private final ServiceLocator<FrameworkModule> serviceLocator;
    private final LastFrameData lastFrameData;

    public BarcodeTrackingMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this(serviceLocator, DefaultLastFrameData.getInstance());
    }

    public BarcodeTrackingMethodHandler(ServiceLocator<FrameworkModule> serviceLocator, LastFrameData lastFrameData) {
        this.serviceLocator = serviceLocator;
        this.lastFrameData = lastFrameData;
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getBarcodeTrackingDefaults":
                result.success(new JSONObject(getSharedModule().getDefaults()).toString());
                break;
            case "addBarcodeTrackingListener":
                getSharedModule().addBarcodeTrackingListener();
                result.success(null);
                break;
            case "removeBarcodeTrackingListener":
                getSharedModule().removeBarcodeTrackingListener();
                result.success(null);
                break;
            case "barcodeTrackingFinishDidUpdateSession":
                getSharedModule().finishDidUpdateSession(Boolean.TRUE.equals(call.arguments));
                result.success(true);
                break;
            case "resetBarcodeTrackingSession":
                getSharedModule().resetSession(
                        call.arguments instanceof Long ? (Long) call.arguments : null
                );
                result.success(null);
                break;
            case "getLastFrameData":
                lastFrameData.getLastFrameDataBytes((bytes) -> {
                    if (bytes == null) {
                        ResultUtils.rejectKotlinError(result, new FrameDataNullError());
                        return null;
                    }
                    result.success(bytes);
                    return null;
                });
                break;
            case "addBarcodeTrackingAdvancedOverlayDelegate":
                getSharedModule().addAdvancedOverlayListener();
                result.success(null);
                break;
            case "removeBarcodeTrackingAdvancedOverlayDelegate":
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
            case "subscribeBarcodeTrackingBasicOverlayListener":
                getSharedModule().addBasicOverlayListener();
                result.success(null);
                break;
            case "unsubscribeBarcodeTrackingBasicOverlayListener":
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
            case "updateBarcodeTrackingMode":
                assert call.arguments() != null;
                getSharedModule().updateModeFromJson(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;
            case "applyBarcodeTrackingModeSettings":
                assert call.arguments() != null;
                getSharedModule().applyModeSettings(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;
            case "updateBarcodeTrackingBasicOverlay":
                assert call.arguments() != null;
                getSharedModule().updateBasicOverlay(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;
            case "updateBarcodeTrackingAdvancedOverlay":
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

    private volatile BarcodeTrackingModule sharedModuleInstance;

    private BarcodeTrackingModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (BarcodeTrackingModule)this.serviceLocator.resolve(BarcodeTrackingModule.class.getName());
                }
            }
        }
        return sharedModuleInstance;
    }
}
