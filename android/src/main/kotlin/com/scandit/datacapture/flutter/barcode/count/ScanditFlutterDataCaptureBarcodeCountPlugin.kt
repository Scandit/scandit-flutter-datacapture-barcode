/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.count

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class ScanditFlutterDataCaptureBarcodeCountPlugin(
    private val frameworksBarcodeCount: FrameworksBarcodeCount,
    private val methodCallHandler: ScanditFlutterDataCaptureBarcodeCountMethodCallHandler
) : FlutterPlugin {
    private var methodChannelDefaults: MethodChannel? = null
    private var methodChannelBarcodeCount: MethodChannel? = null
    private var methodChannelBarcodeCountView: MethodChannel? = null
    private var binaryMessenger: BinaryMessenger? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        binaryMessenger = binding.binaryMessenger
        methodChannelDefaults = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.barcode.count.method/barcode_count_defaults"
        ).also {
            it.setMethodCallHandler(methodCallHandler)
        }
        methodChannelBarcodeCountView = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.barcode.capture.method/barcode_count_view_methods"
        ).also {
            it.setMethodCallHandler(methodCallHandler)
        }
        methodChannelBarcodeCount = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.barcode.capture.method/barcode_count_methods"
        ).also {
            it.setMethodCallHandler(methodCallHandler)
        }

        frameworksBarcodeCount.init()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannelDefaults?.setMethodCallHandler(null)
        methodChannelBarcodeCountView?.setMethodCallHandler(null)
        methodChannelBarcodeCount?.setMethodCallHandler(null)
        frameworksBarcodeCount.dispose()
        binaryMessenger = null
    }
}
