/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.tracking

import com.scandit.datacapture.flutter.core.common.LastFrameDataHolder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** ScanditFlutterDataCaptureBarcodeTrackingPlugin */
class ScanditFlutterDataCaptureBarcodeTrackingPlugin(
    private val flutterBarcodeTrackingHandler: ScanditFlutterDataCaptureBarcodeTrackingHandler
) : FlutterPlugin, MethodChannel.MethodCallHandler {
    private var methodChannelDefaults: MethodChannel? = null
    private var methodChannelTrackingListener: MethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannelDefaults = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.barcode.tracking.method/barcode_tracking_defaults"
        ).also {
            it.setMethodCallHandler(this)
        }

        methodChannelTrackingListener = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.barcode.tracking.method/barcode_tracking_listener"
        ).also {
            it.setMethodCallHandler(this)
        }

        flutterBarcodeTrackingHandler.onAttachedToEngine()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannelDefaults?.setMethodCallHandler(null)
        methodChannelTrackingListener?.setMethodCallHandler(null)
        flutterBarcodeTrackingHandler.onDetachedFromEngine()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET_BARCODE_TRACKING_DEFAULTS ->
                result.success(flutterBarcodeTrackingHandler.getDefaultsAsJson())
            METHOD_ADD_BARCODE_TRACKING_LISTENER -> {
                flutterBarcodeTrackingHandler.addBarcodeTrackingListener()
                result.success(null)
            }
            METHOD_REMOVE_BARCODE_TRACKING_LISTENER -> {
                flutterBarcodeTrackingHandler.removeBarcodeTrackingListener()
                result.success(null)
            }
            METHOD_TRACKING_FINISH_DID_UPDATE_SESSION -> {
                flutterBarcodeTrackingHandler.finishDidUpdateSession(
                    call.arguments as? Boolean ?: false
                )
                result.success(true)
            }
            METHOD_RESET_TRACKING_SESSION -> {
                flutterBarcodeTrackingHandler.resetSession(call.arguments as? Long)
                result.success(null)
            }
            METHOD_GET_LAST_FRAME_DATA -> LastFrameDataHolder.handleGetRequest(result)
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
    }
}
