/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode

import com.scandit.datacapture.frameworks.barcode.BarcodeModule
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

/** ScanditFlutterDataCaptureBarcodeCorePlugin */
class BarcodeMethodHandler(
    private val barcodeModule: BarcodeModule
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET_DEFAULTS -> getDefaults(result)
            else -> result.notImplemented()
        }
    }

    private fun getDefaults(result: MethodChannel.Result) {
        result.success(JSONObject(barcodeModule.getDefaults()).toString())
    }

    companion object {
        private const val METHOD_GET_DEFAULTS = "getDefaults"

        const val METHOD_CHANNEL = "com.scandit.datacapture.barcode/method_channel"
    }
}
