/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode

import com.scandit.datacapture.barcode.capture.BarcodeCaptureSettings
import com.scandit.datacapture.barcode.data.CompositeTypeDescription
import com.scandit.datacapture.barcode.data.SymbologyDescription
import com.scandit.datacapture.flutter.barcode.data.defaults.SerializableBarcodeDefaults
import com.scandit.datacapture.flutter.barcode.data.defaults.SerializableSymbologySettingsDefaults
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray

/** ScanditFlutterDataCaptureBarcodeCorePlugin */
class ScanditFlutterDataCaptureBarcodePlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.barcode.method/barcode_defaults"
        ).also {
            it.setMethodCallHandler(this)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET_DEFAULTS -> getDefaults(result)
            else -> result.notImplemented()
        }
    }

    private val defaults: SerializableBarcodeDefaults by lazy {
        val captureSettings = BarcodeCaptureSettings()
        val symbologyDescriptions = SymbologyDescription.all()
        val compositeTypeDescriptions = CompositeTypeDescription.all()

        SerializableBarcodeDefaults(
            symbologySettingsDefaults = SerializableSymbologySettingsDefaults(
                barcodeCaptureSettings = captureSettings
            ),
            symbologyDescriptionsDefaults = JSONArray(
                symbologyDescriptions.map { it.toJson() }
            ),
            compositeTypeDescriptions = JSONArray(
                compositeTypeDescriptions.map { it.toJson() }
            )
        )
    }

    private fun getDefaults(result: MethodChannel.Result) {
        result.success(defaults.toJson().toString())
    }

    companion object {
        private const val METHOD_GET_DEFAULTS = "getDefaults"
    }
}
