/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.pick

import com.scandit.datacapture.flutter.core.utils.FlutterResult
import com.scandit.datacapture.frameworks.barcode.pick.BarcodePickModule
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class BarcodePickMethodHandler(
    private val barcodePickModule: BarcodePickModule
) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) =
        when (call.method) {
            METHOD_GET_DEFAULTS ->
                result.success(JSONObject(barcodePickModule.getDefaults()).toString())

            METHOD_REMOVE_SCANNING_LISTENER -> barcodePickModule.removeScanningListener(
                FlutterResult(result)
            )

            METHOD_ADD_SCANNING_LISTENER -> barcodePickModule.addScanningListener(
                FlutterResult(result)
            )

            METHOD_START_PICK_VIEW -> {
                barcodePickModule.viewStart()
                result.success(null)
            }

            METHOD_RELEASE_PICK_VIEW -> barcodePickModule.viewRelease(
                FlutterResult(result)
            )

            METHOD_FREEZE_PICK_VIEW -> barcodePickModule.viewFreeze(
                FlutterResult(result)
            )

            METHOD_PAUSE_PICK_VIEW -> {
                barcodePickModule.viewPause()
                result.success(null)
            }

            METHOD_ADD_VIEW_UI_LISTENER -> barcodePickModule.addViewUiListener(
                FlutterResult(result)
            )

            METHOD_REMOVE_VIEW_UI_LISTENER -> barcodePickModule.removeViewUiListener(
                FlutterResult(result)
            )

            METHOD_ADD_VIEW_LISTENER -> barcodePickModule.addViewListener(
                FlutterResult(result)
            )

            METHOD_REMOVE_VIEW_LISTENER -> barcodePickModule.removeViewListener(
                FlutterResult(result)
            )

            METHOD_ADD_ACTION_LISTENER -> {
                barcodePickModule.addActionListener()
                result.success(null)
            }

            METHOD_REMOVE_ACTION_LISTENER -> {
                barcodePickModule.removeActionListener()
                result.success(null)
            }

            METHOD_FINISH_ON_PRODUCT_IDENTIFIER_FOR_ITEMS -> {
                barcodePickModule.finishOnProductIdentifierForItems(call.arguments as String)
                result.success(null)
            }

            METHOD_FINISH_PICK_ACTION -> barcodePickModule.finishPickAction(
                call.arguments as String,
                FlutterResult(result)
            )

            else -> throw IllegalArgumentException("Nothing implemented for ${call.method}")
        }

    companion object {
        private const val METHOD_GET_DEFAULTS = "getDefaults"
        private const val METHOD_REMOVE_SCANNING_LISTENER = "removeScanningListener"
        private const val METHOD_ADD_SCANNING_LISTENER = "addScanningListener"
        private const val METHOD_START_PICK_VIEW = "startPickView"
        private const val METHOD_RELEASE_PICK_VIEW = "releasePickView"
        private const val METHOD_FREEZE_PICK_VIEW = "freezePickView"
        private const val METHOD_PAUSE_PICK_VIEW = "pausePickView"
        private const val METHOD_ADD_VIEW_UI_LISTENER = "addViewUiListener"
        private const val METHOD_REMOVE_VIEW_UI_LISTENER = "removeViewUiListener"
        private const val METHOD_ADD_VIEW_LISTENER = "addViewListener"
        private const val METHOD_REMOVE_VIEW_LISTENER = "removeViewListener"
        private const val METHOD_ADD_ACTION_LISTENER = "addActionListener"
        private const val METHOD_REMOVE_ACTION_LISTENER = "removeActionListener"
        private const val METHOD_FINISH_ON_PRODUCT_IDENTIFIER_FOR_ITEMS =
            "finishOnProductIdentifierForItems"
        private const val METHOD_FINISH_PICK_ACTION = "finishPickAction"

        const val EVENT_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.pick/event_channel"

        const val METHOD_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.pick/method_channel"
    }
}
