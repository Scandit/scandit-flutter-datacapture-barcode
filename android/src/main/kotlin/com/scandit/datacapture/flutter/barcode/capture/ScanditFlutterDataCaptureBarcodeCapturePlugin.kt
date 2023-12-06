/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.capture

import com.scandit.datacapture.flutter.core.common.LastFrameDataHolder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** ScanditFlutterDataCaptureBarcodeCapturePlugin. */
class ScanditFlutterDataCaptureBarcodeCapturePlugin(
    private val flutterBarcodeCaptureHandler: ScanditFlutterDataCaptureBarcodeCaptureHandler
) : FlutterPlugin, MethodChannel.MethodCallHandler {
    private var methodChannelDefaults: MethodChannel? = null
    private var methodChannelCaptureListener: MethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannelDefaults = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.barcode.capture.method/barcode_capture_defaults"
        ).also {
            it.setMethodCallHandler(this)
        }

        methodChannelCaptureListener = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.barcode.capture.method/barcode_capture_listener"
        ).also {
            it.setMethodCallHandler(this)
        }

        flutterBarcodeCaptureHandler.onAttachedToEngine()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannelDefaults?.setMethodCallHandler(null)
        methodChannelCaptureListener?.setMethodCallHandler(null)

        flutterBarcodeCaptureHandler.onDetachedFromEngine()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET_BC_DEFAULTS -> flutterBarcodeCaptureHandler.getDefaults(result)
            METHOD_FINISH_DID_SCAN -> {
                val enabled = call.arguments as? Boolean ?: false
                flutterBarcodeCaptureHandler.finishDidScan(enabled)
                result.success(null)
            }
            METHOD_FINISH_DID_UPDATE_SESSION -> {
                val enabled = call.arguments as? Boolean ?: false
                flutterBarcodeCaptureHandler.finishDidUpdateSession(enabled)
                result.success(null)
            }
            METHOD_ADD_BC_LISTENER -> {
                flutterBarcodeCaptureHandler.addListener()
                result.success(null)
            }
            METHOD_REMOVE_BC_LISTENER -> {
                flutterBarcodeCaptureHandler.removeListener()
                result.success(null)
            }
            METHOD_RESET_BC_SESSION -> {
                flutterBarcodeCaptureHandler.resetSession(call.arguments as? Long)
                result.success(null)
            }
            METHOD_GET_LAST_FRAME_DATA -> LastFrameDataHolder.handleGetRequest(result)
            else -> result.notImplemented()
        }
    }

    companion object {
        private const val METHOD_GET_BC_DEFAULTS = "getBarcodeCaptureDefaults"
        private const val METHOD_FINISH_DID_SCAN = "finishDidScan"
        private const val METHOD_FINISH_DID_UPDATE_SESSION = "finishDidUpdateSession"
        private const val METHOD_ADD_BC_LISTENER = "addBarcodeCaptureListener"
        private const val METHOD_REMOVE_BC_LISTENER = "removeBarcodeCaptureListener"
        private const val METHOD_RESET_BC_SESSION = "resetBarcodeCaptureSession"
        private const val METHOD_GET_LAST_FRAME_DATA = "getLastFrameData"
    }
}
