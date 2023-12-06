/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.selection

import com.scandit.datacapture.flutter.barcode.data.SerializableBarcodeSelectionSessionData
import com.scandit.datacapture.flutter.core.common.LastFrameDataHolder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class ScanditFlutterDataCaptureBarcodeSelectionPlugin(
    private val flutterBarcodeSelectionHandler: ScanditFlutterDataCaptureBarcodeSelectionHandler
) : FlutterPlugin, MethodChannel.MethodCallHandler {
    private var methodChannelDefaults: MethodChannel? = null
    private var methodChannelSession: MethodChannel? = null
    private var methodChannelSelectionListener: MethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannelDefaults = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.barcode.selection.method/barcode_selection_defaults"
        ).also {
            it.setMethodCallHandler(this)
        }
        methodChannelSession = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.barcode.selection.method/barcode_selection_session"
        ).also {
            it.setMethodCallHandler(this)
        }
        methodChannelSelectionListener = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.barcode.selection.method/barcode_selection_listener"
        ).also {
            it.setMethodCallHandler(this)
        }
        flutterBarcodeSelectionHandler.onAttachedToEngine()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannelDefaults?.setMethodCallHandler(null)
        methodChannelSession?.setMethodCallHandler(null)
        methodChannelSelectionListener?.setMethodCallHandler(null)
        flutterBarcodeSelectionHandler.onDetachedFromEngine()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET_BARCODE_SELECTION_DEFAULTS ->
                result.success(flutterBarcodeSelectionHandler.defaults)
            METHOD_GET_BARCODE_COUNT -> {
                val data =
                    SerializableBarcodeSelectionSessionData(JSONObject(call.arguments as String))
                result.success(
                    flutterBarcodeSelectionHandler.getBarcodeCount(
                        data.frameSequenceId,
                        data.symbology,
                        data.barcodeData
                    )
                )
            }
            METHOD_RESET_BARCODE_SELECTION_SESSION -> {
                flutterBarcodeSelectionHandler.resetLatestSession(call.arguments as? Long)
                result.success(null)
            }
            METHOD_ADD_LISTENER -> {
                flutterBarcodeSelectionHandler.addListener()
                result.success(null)
            }
            METHOD_REMOVE_LISTENER -> {
                flutterBarcodeSelectionHandler.removeListener()
                result.success(null)
            }
            METHOD_RESET_MODE -> {
                flutterBarcodeSelectionHandler.resetSelection()
                result.success(null)
            }
            METHOD_UNFREEZE_CAMERA -> {
                flutterBarcodeSelectionHandler.unfreezeCamera()
                result.success(null)
            }
            METHOD_BARCODE_SELECTION_DID_SELECT -> {
                val enabled = call.arguments as? Boolean ?: false
                flutterBarcodeSelectionHandler.finishDidSelect(enabled)
                result.success(null)
            }
            METHOD_BARCODE_SELECTION_DID_UPDATE_SESSION -> {
                val enabled = call.arguments as? Boolean ?: false
                flutterBarcodeSelectionHandler.finishDidUpdateSession(enabled)
                result.success(null)
            }
            METHOD_GET_LAST_FRAME_DATA -> LastFrameDataHolder.handleGetRequest(result)
        }
    }

    companion object {
        private const val METHOD_GET_BARCODE_SELECTION_DEFAULTS = "getBarcodeSelectionDefaults"
        private const val METHOD_GET_BARCODE_COUNT = "getBarcodeSelectionSessionCount"
        private const val METHOD_RESET_BARCODE_SELECTION_SESSION = "resetBarcodeSelectionSession"
        private const val METHOD_ADD_LISTENER = "addBarcodeSelectionListener"
        private const val METHOD_REMOVE_LISTENER = "removeBarcodeSelectionListener"
        private const val METHOD_RESET_MODE = "resetMode"
        private const val METHOD_UNFREEZE_CAMERA = "unfreezeCamera"
        private const val METHOD_BARCODE_SELECTION_DID_SELECT = "finishDidUpdateSelection"
        private const val METHOD_BARCODE_SELECTION_DID_UPDATE_SESSION = "finishDidUpdateSession"
        private const val METHOD_GET_LAST_FRAME_DATA = "getLastFrameData"
    }
}
