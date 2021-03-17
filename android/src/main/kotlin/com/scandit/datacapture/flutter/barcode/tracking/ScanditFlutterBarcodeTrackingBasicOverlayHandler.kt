/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.tracking

import com.scandit.datacapture.barcode.tracking.ui.overlay.BarcodeTrackingBasicOverlay
import com.scandit.datacapture.core.ui.style.BrushDeserializer
import com.scandit.datacapture.flutter.barcode.data.SerializableBrushAndTrackedBarcode
import com.scandit.datacapture.flutter.barcode.tracking.listeners.ScanditFlutterBarcodeTrackingBasicOverlayListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class ScanditFlutterBarcodeTrackingBasicOverlayHandler(
    private val binaryMessenger: BinaryMessenger,
    private val barcodeTrackingBasicOverlayListener:
        ScanditFlutterBarcodeTrackingBasicOverlayListener,
    private val sessionHolder: ScanditFlutterBarcodeTrackingSessionHolder
) : MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null

    var overlay: BarcodeTrackingBasicOverlay? = null

    fun onAttachedToEngine() {
        methodChannel = MethodChannel(
            binaryMessenger,
            METHOD_CHANNEL_NAME
        ).also {
            it.setMethodCallHandler(this)
        }
    }

    fun onDetachedFromEngine() {
        methodChannel?.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_SUBSCRIBE_BASIC_OVERLAY_LISTENER -> {
                overlay?.listener = barcodeTrackingBasicOverlayListener
                barcodeTrackingBasicOverlayListener.enableListener()
                result.success(null)
            }
            METHOD_UNSUBSCRIBE_BASIC_OVERLAY_LISTENER -> {
                barcodeTrackingBasicOverlayListener.disableListener()
                overlay?.listener = null
                result.success(null)
            }
            METHOD_FINISH_BRUSH_FOR_TRACKED_BARCODE_CALLBACK -> {
                barcodeTrackingBasicOverlayListener.finishBrushForTrackedBarcode(
                    BrushDeserializer.fromJson(call.arguments as String)
                )
                result.success(null)
            }
            METHOD_SET_BRUSH_FOR_TRACKED_BARCODE -> {
                setBrushForTrackedBarcode(call.arguments)
                result.success(null)
            }
            METHOD_CLEAR_TRACKED_BARCODE_BRUSHES -> {
                overlay?.clearTrackedBarcodeBrushes()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun setBrushForTrackedBarcode(arguments: Any) {
        val data = SerializableBrushAndTrackedBarcode(JSONObject(arguments as String))
        sessionHolder.getTrackedBarcodeFromLatestSession(
            data.trackedBarcodeId,
            data.sessionFrameSequenceId
        )?.let {
            overlay?.setBrushForTrackedBarcode(it, data.brush)
        }
    }

    companion object {
        private const val METHOD_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.tracking.method/barcode_tracking_basic_overlay"

        private const val METHOD_SET_BRUSH_FOR_TRACKED_BARCODE = "setBrushForTrackedBarcode"
        private const val METHOD_CLEAR_TRACKED_BARCODE_BRUSHES = "clearTrackedBarcodeBrushes"
        private const val METHOD_SUBSCRIBE_BASIC_OVERLAY_LISTENER =
            "subscribeBarcodeTrackingBasicOverlayListener"
        private const val METHOD_UNSUBSCRIBE_BASIC_OVERLAY_LISTENER =
            "unsubscribeBarcodeTrackingBasicOverlayListener"
        private const val METHOD_FINISH_BRUSH_FOR_TRACKED_BARCODE_CALLBACK =
            "finishBrushForTrackedBarcodeCallback"
    }
}
