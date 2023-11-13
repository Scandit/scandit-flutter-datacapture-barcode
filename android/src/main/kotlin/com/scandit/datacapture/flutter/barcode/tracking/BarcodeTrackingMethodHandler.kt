/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.tracking

import com.scandit.datacapture.flutter.core.utils.Error
import com.scandit.datacapture.flutter.core.utils.reject
import com.scandit.datacapture.frameworks.barcode.tracking.BarcodeTrackingModule
import com.scandit.datacapture.frameworks.core.utils.LastFrameData
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

/** ScanditFlutterDataCaptureBarcodeTrackingPlugin */
class BarcodeTrackingMethodHandler(
    private val barcodeTrackingModule: BarcodeTrackingModule
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET_BARCODE_TRACKING_DEFAULTS ->
                result.success(JSONObject(barcodeTrackingModule.getDefaults()).toString())
            METHOD_ADD_BARCODE_TRACKING_LISTENER -> {
                barcodeTrackingModule.addBarcodeTrackingListener()
                result.success(null)
            }
            METHOD_REMOVE_BARCODE_TRACKING_LISTENER -> {
                barcodeTrackingModule.removeBarcodeTrackingListener()
                result.success(null)
            }
            METHOD_TRACKING_FINISH_DID_UPDATE_SESSION -> {
                barcodeTrackingModule.finishDidUpdateSession(
                    call.arguments as? Boolean ?: false
                )
                result.success(true)
            }
            METHOD_RESET_TRACKING_SESSION -> {
                barcodeTrackingModule.resetSession(call.arguments as? Long)
                result.success(null)
            }
            METHOD_GET_LAST_FRAME_DATA -> LastFrameData.getLastFrameDataJson {
                if (it.isNullOrBlank()) {
                    result.reject(Error(-1, "Frame is null, it might've been reused already."))
                    return@getLastFrameDataJson
                }
                result.success(it)
            }
            METHOD_ADD_BARCODE_TRACKING_ADVANCED_OVERLAY_LISTENER -> {
                barcodeTrackingModule.addAdvancedOverlayListener()
                result.success(null)
            }
            METHOD_REMOVE_BARCODE_TRACKING_ADVANCED_OVERLAY_LISTENER -> {
                barcodeTrackingModule.removeAdvancedOverlayListener()
                result.success(null)
            }
            METHOD_CLEAR_TRACKED_BARCODE_WIDGETS -> {
                barcodeTrackingModule.clearAdvancedOverlayTrackedBarcodeViews()
                result.success(null)
            }
            METHOD_SET_WIDGET_FOR_TRACKED_BARCODE -> {
                @Suppress("UNCHECKED_CAST")
                val arguments = call.arguments as? HashMap<String, Any?> ?: run {
                    result.error(
                        "-1",
                        "Invalid argument for $METHOD_SET_WIDGET_FOR_TRACKED_BARCODE",
                        ""
                    )
                    return
                }
                barcodeTrackingModule.setWidgetForTrackedBarcode(arguments)
                result.success(null)
            }
            METHOD_SET_ANCHOR_FOR_TRACKED_BARCODE -> {
                @Suppress("UNCHECKED_CAST")
                val arguments = call.arguments as? HashMap<String, Any?> ?: run {
                    result.error(
                        "-1",
                        "Invalid argument for $METHOD_SET_ANCHOR_FOR_TRACKED_BARCODE",
                        ""
                    )
                    return
                }
                barcodeTrackingModule.setAnchorForTrackedBarcode(arguments)
                result.success(null)
            }
            METHOD_SET_OFFSET_FOR_TRACKED_BARCODE -> {
                @Suppress("UNCHECKED_CAST")
                val arguments = call.arguments as? HashMap<String, Any?> ?: run {
                    result.error(
                        "-1",
                        "Invalid argument for $METHOD_SET_OFFSET_FOR_TRACKED_BARCODE",
                        ""
                    )
                    return
                }
                barcodeTrackingModule.setOffsetForTrackedBarcode(arguments)
                result.success(null)
            }
            METHOD_SUBSCRIBE_BASIC_OVERLAY_LISTENER -> {
                barcodeTrackingModule.addBasicOverlayListener()
                result.success(null)
            }
            METHOD_UNSUBSCRIBE_BASIC_OVERLAY_LISTENER -> {
                barcodeTrackingModule.removeBasicOverlayListener()
                result.success(null)
            }
            METHOD_FINISH_BRUSH_FOR_TRACKED_BARCODE_CALLBACK -> {
                barcodeTrackingModule.finishBasicOverlayBrushForTrackedBarcode(
                    call.arguments as String
                )
                result.success(null)
            }
            METHOD_SET_BRUSH_FOR_TRACKED_BARCODE -> {
                barcodeTrackingModule.setBasicOverlayBrushForTrackedBarcode(
                    call.arguments as String
                )
                result.success(null)
            }
            METHOD_CLEAR_TRACKED_BARCODE_BRUSHES -> {
                barcodeTrackingModule.clearBasicOverlayTrackedBarcodeBrushes()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    companion object {
        private const val METHOD_GET_BARCODE_TRACKING_DEFAULTS = "getBarcodeTrackingDefaults"
        private const val METHOD_ADD_BARCODE_TRACKING_LISTENER = "addBarcodeTrackingListener"
        private const val METHOD_REMOVE_BARCODE_TRACKING_LISTENER = "removeBarcodeTrackingListener"
        private const val METHOD_TRACKING_FINISH_DID_UPDATE_SESSION =
            "barcodeTrackingFinishDidUpdateSession"
        private const val METHOD_RESET_TRACKING_SESSION = "resetBarcodeTrackingSession"
        private const val METHOD_GET_LAST_FRAME_DATA = "getLastFrameData"
        private const val METHOD_SET_WIDGET_FOR_TRACKED_BARCODE = "setWidgetForTrackedBarcode"
        private const val METHOD_SET_ANCHOR_FOR_TRACKED_BARCODE = "setAnchorForTrackedBarcode"
        private const val METHOD_SET_OFFSET_FOR_TRACKED_BARCODE = "setOffsetForTrackedBarcode"
        private const val METHOD_CLEAR_TRACKED_BARCODE_WIDGETS = "clearTrackedBarcodeWidgets"

        private const val METHOD_ADD_BARCODE_TRACKING_ADVANCED_OVERLAY_LISTENER =
            "addBarcodeTrackingAdvancedOverlayDelegate"
        private const val METHOD_REMOVE_BARCODE_TRACKING_ADVANCED_OVERLAY_LISTENER =
            "removeBarcodeTrackingAdvancedOverlayDelegate"
        private const val METHOD_SET_BRUSH_FOR_TRACKED_BARCODE = "setBrushForTrackedBarcode"
        private const val METHOD_CLEAR_TRACKED_BARCODE_BRUSHES = "clearTrackedBarcodeBrushes"
        private const val METHOD_SUBSCRIBE_BASIC_OVERLAY_LISTENER =
            "subscribeBarcodeTrackingBasicOverlayListener"
        private const val METHOD_UNSUBSCRIBE_BASIC_OVERLAY_LISTENER =
            "unsubscribeBarcodeTrackingBasicOverlayListener"
        private const val METHOD_FINISH_BRUSH_FOR_TRACKED_BARCODE_CALLBACK =
            "finishBrushForTrackedBarcodeCallback"

        const val EVENT_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.tracking/event_channel"

        const val METHOD_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.tracking/method_channel"
    }
}
