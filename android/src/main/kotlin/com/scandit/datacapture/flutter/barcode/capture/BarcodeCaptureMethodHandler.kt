/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.capture

import com.scandit.datacapture.frameworks.barcode.capture.BarcodeCaptureModule
import com.scandit.datacapture.frameworks.core.utils.LastFrameData
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

/** ScanditFlutterDataCaptureBarcodeCapturePlugin. */
class BarcodeCaptureMethodHandler(
    private val barcodeCaptureModule: BarcodeCaptureModule
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET_BC_DEFAULTS -> getDefaults(result)
            METHOD_FINISH_DID_SCAN -> {
                val enabled = call.arguments as? Boolean ?: false
                barcodeCaptureModule.finishDidScan(enabled)
                result.success(null)
            }
            METHOD_FINISH_DID_UPDATE_SESSION -> {
                val enabled = call.arguments as? Boolean ?: false
                barcodeCaptureModule.finishDidUpdateSession(enabled)
                result.success(null)
            }
            METHOD_ADD_BC_LISTENER -> {
                barcodeCaptureModule.addListener()
                result.success(null)
            }
            METHOD_REMOVE_BC_LISTENER -> {
                barcodeCaptureModule.removeListener()
                result.success(null)
            }
            METHOD_RESET_BC_SESSION -> {
                barcodeCaptureModule.resetSession(call.arguments as? Long)
                result.success(null)
            }
            METHOD_GET_LAST_FRAME_DATA -> LastFrameData.getLastFrameDataJson {
                result.success(it)
            }
            else -> result.notImplemented()
        }
    }

    private fun getDefaults(result: MethodChannel.Result) {
        val defaults = barcodeCaptureModule.getDefaults()
        result.success(JSONObject(defaults).toString())
    }

    companion object {
        private const val METHOD_GET_BC_DEFAULTS = "getBarcodeCaptureDefaults"
        private const val METHOD_FINISH_DID_SCAN = "finishDidScan"
        private const val METHOD_FINISH_DID_UPDATE_SESSION = "finishDidUpdateSession"
        private const val METHOD_ADD_BC_LISTENER = "addBarcodeCaptureListener"
        private const val METHOD_REMOVE_BC_LISTENER = "removeBarcodeCaptureListener"
        private const val METHOD_RESET_BC_SESSION = "resetBarcodeCaptureSession"
        private const val METHOD_GET_LAST_FRAME_DATA = "getLastFrameData"

        const val EVENT_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.capture/event_channel"

        const val METHOD_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.capture/method_channel"
    }
}