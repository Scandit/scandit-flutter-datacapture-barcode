/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.tracking

import com.scandit.datacapture.barcode.tracking.ui.overlay.BarcodeTrackingAdvancedOverlay
import com.scandit.datacapture.flutter.barcode.data.SerializableAdvancedOverlayAnchorData
import com.scandit.datacapture.flutter.barcode.data.SerializableAdvancedOverlayOffsetData
import com.scandit.datacapture.flutter.barcode.data.SerializableAdvancedOverlayViewData
import com.scandit.datacapture.flutter.barcode.tracking.listeners.ScanditFlutterBarcodeTrackingAdvancedOverlayListener
import com.scandit.datacapture.flutter.barcode.utils.AdvancedOverlayViewPool
import com.scandit.datacapture.flutter.barcode.utils.ViewParser
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ScanditFlutterBarcodeTrackingAdvancedOverlayHandler(
    private val binaryMessenger: BinaryMessenger,
    private val advancedOverlayListener: ScanditFlutterBarcodeTrackingAdvancedOverlayListener,
    private val sessionHolder: ScanditFlutterBarcodeTrackingSessionHolder,
    private val advancedOverlayViewPool: AdvancedOverlayViewPool,
    private val viewParser: ViewParser = ViewParser()
) : MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null

    var overlay: BarcodeTrackingAdvancedOverlay? = null
        set(value) {
            field?.listener = null
            field = value?.also {
                it.listener = advancedOverlayListener
            }
        }

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
            METHOD_ADD_BARCODE_TRACKING_ADVANCED_OVERLAY_LISTENER -> {
                advancedOverlayListener.enableListener()
                result.success(null)
            }
            METHOD_REMOVE_BARCODE_TRACKING_ADVANCED_OVERLAY_LISTENER -> {
                advancedOverlayListener.disableListener()
                // cleanup
                advancedOverlayViewPool.clear()
                result.success(null)
            }
            METHOD_CLEAR_TRACKED_BARCODE_WIDGETS -> {
                overlay?.clearTrackedBarcodeViews()
                result.success(null)
            }
            METHOD_SET_WIDGET_FOR_TRACKED_BARCODE -> {
                setWidgetForTrackedBarcode(call.arguments)
                result.success(null)
            }
            METHOD_SET_ANCHOR_FOR_TRACKED_BARCODE -> {
                setAnchorForTrackedBarcode(call.arguments)
                result.success(null)
            }
            METHOD_SET_OFFSET_FOR_TRACKED_BARCODE -> {
                setOffsetForTrackedBarcode(call.arguments)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun setWidgetForTrackedBarcode(arguments: Any) {
        @Suppress("UNCHECKED_CAST")
        val inputParams = arguments as? HashMap<String, Any?> ?: return

        val data = SerializableAdvancedOverlayViewData(inputParams)
        sessionHolder.getTrackedBarcodeFromLatestSession(
            data.trackedBarcodeId,
            data.sessionFrameSequenceId
        )?.let { trackedBarcode ->
            if (data.widgetBytes == null) {
                advancedOverlayViewPool.removeView(trackedBarcode)
                overlay?.setViewForTrackedBarcode(trackedBarcode, null)
                return
            }

            val view = viewParser.parse(data.widgetBytes)?.let {
                advancedOverlayViewPool.getOrCreateView(trackedBarcode, it)
            } ?: return

            view.setOnClickListener {
                advancedOverlayListener.onViewForBarcodeTapped(trackedBarcode)
            }

            overlay?.setViewForTrackedBarcode(
                trackedBarcode,
                view
            )
        }
    }

    private fun setAnchorForTrackedBarcode(arguments: Any) {
        @Suppress("UNCHECKED_CAST")
        val inputParams = arguments as? HashMap<String, Any?> ?: return

        val data = SerializableAdvancedOverlayAnchorData(inputParams)
        sessionHolder.getTrackedBarcodeFromLatestSession(
            data.trackedBarcodeId,
            data.sessionFrameSequenceId
        )?.let { trackedBarcode ->
            overlay?.setAnchorForTrackedBarcode(
                trackedBarcode,
                data.anchor
            )
        }
    }

    private fun setOffsetForTrackedBarcode(arguments: Any) {
        @Suppress("UNCHECKED_CAST")
        val inputParams = arguments as? HashMap<String, Any?> ?: return

        val data = SerializableAdvancedOverlayOffsetData(inputParams)
        sessionHolder.getTrackedBarcodeFromLatestSession(
            data.trackedBarcodeId,
            data.sessionFrameSequenceId
        )?.let { trackedBarcode ->
            overlay?.setOffsetForTrackedBarcode(
                trackedBarcode,
                data.offset
            )
        }
    }

    companion object {
        private const val METHOD_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.tracking.method/barcode_tracking_advanced_overlay"

        private const val METHOD_SET_WIDGET_FOR_TRACKED_BARCODE = "setWidgetForTrackedBarcode"
        private const val METHOD_SET_ANCHOR_FOR_TRACKED_BARCODE = "setAnchorForTrackedBarcode"
        private const val METHOD_SET_OFFSET_FOR_TRACKED_BARCODE = "setOffsetForTrackedBarcode"
        private const val METHOD_CLEAR_TRACKED_BARCODE_WIDGETS = "clearTrackedBarcodeWidgets"

        private const val METHOD_ADD_BARCODE_TRACKING_ADVANCED_OVERLAY_LISTENER =
            "addBarcodeTrackingAdvancedOverlayDelegate"
        private const val METHOD_REMOVE_BARCODE_TRACKING_ADVANCED_OVERLAY_LISTENER =
            "removeBarcodeTrackingAdvancedOverlayDelegate"
    }
}
