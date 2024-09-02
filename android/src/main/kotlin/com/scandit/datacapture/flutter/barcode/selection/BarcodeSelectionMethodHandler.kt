/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.selection

import com.scandit.datacapture.flutter.core.utils.FlutterResult
import com.scandit.datacapture.flutter.core.utils.rejectKotlinError
import com.scandit.datacapture.frameworks.barcode.selection.BarcodeSelectionModule
import com.scandit.datacapture.frameworks.core.errors.FrameDataNullError
import com.scandit.datacapture.frameworks.core.utils.DefaultLastFrameData
import com.scandit.datacapture.frameworks.core.utils.LastFrameData
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class BarcodeSelectionMethodHandler(
    private val barcodeSelectionModule: BarcodeSelectionModule,
    private val lastFrameData: LastFrameData = DefaultLastFrameData.getInstance()
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET_BARCODE_SELECTION_DEFAULTS ->
                result.success(JSONObject(barcodeSelectionModule.getDefaults()).toString())

            METHOD_GET_BARCODE_COUNT ->
                result.success(
                    barcodeSelectionModule.getBarcodeCount(
                        call.arguments as String
                    )
                )

            METHOD_RESET_BARCODE_SELECTION_SESSION -> {
                barcodeSelectionModule.resetLatestSession(call.arguments as? Long)
                result.success(null)
            }

            METHOD_ADD_LISTENER -> {
                barcodeSelectionModule.addListener()
                result.success(null)
            }

            METHOD_REMOVE_LISTENER -> {
                barcodeSelectionModule.removeListener()
                result.success(null)
            }

            METHOD_RESET_MODE -> {
                barcodeSelectionModule.resetSelection()
                result.success(null)
            }

            METHOD_UNFREEZE_CAMERA -> {
                barcodeSelectionModule.unfreezeCamera()
                result.success(null)
            }

            METHOD_BARCODE_SELECTION_DID_SELECT -> {
                val enabled = call.arguments as? Boolean ?: false
                barcodeSelectionModule.finishDidSelect(enabled)
                result.success(null)
            }

            METHOD_BARCODE_SELECTION_DID_UPDATE_SESSION -> {
                val enabled = call.arguments as? Boolean ?: false
                barcodeSelectionModule.finishDidUpdateSession(enabled)
                result.success(null)
            }

            METHOD_GET_LAST_FRAME_DATA -> lastFrameData.getLastFrameDataBytes {
                if (it == null) {
                    result.rejectKotlinError(FrameDataNullError())
                    return@getLastFrameDataBytes
                }
                result.success(result)
            }

            METHOD_SET_MODE_ENABLED_STATE -> barcodeSelectionModule.setModeEnabled(
                call.arguments as Boolean
            )

            METHOD_UPDATE_MODE_FROM_JSON -> barcodeSelectionModule.updateModeFromJson(
                call.arguments as String,
                FlutterResult(result)
            )

            METHOD_APPLY_MODE_SETTINGS -> barcodeSelectionModule.applyModeSettings(
                call.arguments as String,
                FlutterResult(result)
            )

            METHOD_UPDATE_BASIC_OVERLAY -> barcodeSelectionModule.updateBasicOverlay(
                call.arguments as String,
                FlutterResult(result)
            )
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
        private const val METHOD_SET_MODE_ENABLED_STATE = "setModeEnabledState"
        private const val METHOD_UPDATE_MODE_FROM_JSON = "updateBarcodeSelectionMode"
        private const val METHOD_APPLY_MODE_SETTINGS = "applyBarcodeSelectionModeSettings"
        private const val METHOD_UPDATE_BASIC_OVERLAY = "updateBarcodeSelectionBasicOverlay"

        const val EVENT_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.selection/event_channel"

        const val METHOD_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.selection/method_channel"
    }
}
