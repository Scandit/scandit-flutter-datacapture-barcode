/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.spark

import com.scandit.datacapture.flutter.core.utils.FlutterResult
import com.scandit.datacapture.frameworks.barcode.spark.SparkScanModule
import com.scandit.datacapture.frameworks.core.utils.DefaultLastFrameData
import com.scandit.datacapture.frameworks.core.utils.LastFrameData
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class SparkScanMethodHandler(
    private val sparkScanModule: SparkScanModule,
    private val lastFrameData: LastFrameData = DefaultLastFrameData.getInstance()
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET_DEFAULTS -> {
                val defaults = sparkScanModule.getDefaults()
                result.success(JSONObject(defaults).toString())
            }

            METHOD_FINISH_DID_SCAN -> {
                sparkScanModule.finishDidScanCallback(
                    call.arguments as? Boolean ?: false
                )
                result.success(null)
            }

            METHOD_FINISH_DID_UPDATE_SESSION -> {
                sparkScanModule.finishDidUpdateSessionCallback(
                    call.arguments as? Boolean ?: false
                )
                result.success(null)
            }

            METHOD_ADD_LISTENER -> {
                sparkScanModule.addSparkScanListener()
                result.success(null)
            }

            METHOD_REMOVE_LISTENER -> {
                sparkScanModule.removeSparkScanListener()
                result.success(null)
            }

            METHOD_RESET_SESSION -> {
                sparkScanModule.resetSession()
                result.success(null)
            }

            METHOD_GET_LAST_FRAME_DATA ->
                lastFrameData.getLastFrameDataJson {
                    result.success(result)
                }

            METHOD_UPDATE_SPARK_SCAN_MODE -> sparkScanModule.updateMode(
                call.arguments as String,
                FlutterResult(result)
            )

            METHOD_ADD_SPARK_SCAN_VIEW_UI_LISTENER -> {
                sparkScanModule.addSparkScanViewUiListener()
                result.success(null)
            }

            METHOD_REMOVE_SPARK_SCAN_VIEW_UI_LISTENER -> {
                sparkScanModule.removeSparkScanViewUiListener()
                result.success(null)
            }

            METHOD_SPARK_SCAN_VIEW_START_SCANNING ->
                sparkScanModule.startScanning(FlutterResult(result))

            METHOD_SPARK_SCAN_VIEW_PAUSE_SCANNING -> {
                sparkScanModule.pauseScanning()
                result.success(null)
            }

            METHOD_SPARK_SCAN_VIEW_EMIT_FEEDBACK ->
                sparkScanModule.emitFeedback(call.arguments as String, FlutterResult(result))

            METHOD_SPARK_SCAN_VIEW_SHOW_TOAST ->
                sparkScanModule.showToast(call.arguments as String, FlutterResult(result))

            METHOD_SPARK_SCAN_VIEW_ON_WIDGET_PAUSED -> {
                sparkScanModule.onPause()
                result.success(null)
            }

            METHOD_SET_MODE_ENABLED_STATE -> sparkScanModule.setModeEnabled(
                call.arguments as Boolean
            )
        }
    }

    companion object {
        private const val METHOD_GET_DEFAULTS = "getSparkScanDefaults"
        private const val METHOD_FINISH_DID_SCAN = "finishDidScan"
        private const val METHOD_FINISH_DID_UPDATE_SESSION = "finishDidUpdateSession"
        private const val METHOD_ADD_LISTENER = "addSparkScanListener"
        private const val METHOD_REMOVE_LISTENER = "removeSparkScanListener"
        private const val METHOD_RESET_SESSION = "resetSparkScanSession"
        private const val METHOD_GET_LAST_FRAME_DATA = "getLastFrameData"
        private const val METHOD_UPDATE_SPARK_SCAN_MODE = "updateSparkScanMode"
        private const val METHOD_ADD_SPARK_SCAN_VIEW_UI_LISTENER = "addSparkScanViewUiListener"
        private const val METHOD_REMOVE_SPARK_SCAN_VIEW_UI_LISTENER =
            "removeSparkScanViewUiListener"
        private const val METHOD_SPARK_SCAN_VIEW_START_SCANNING = "sparkScanViewStartScanning"
        private const val METHOD_SPARK_SCAN_VIEW_PAUSE_SCANNING = "sparkScanViewPauseScanning"
        private const val METHOD_SPARK_SCAN_VIEW_EMIT_FEEDBACK = "sparkScanViewEmitFeedback"
        private const val METHOD_SPARK_SCAN_VIEW_SHOW_TOAST = "showToast"
        private const val METHOD_SPARK_SCAN_VIEW_ON_WIDGET_PAUSED = "onWidgetPaused"
        private const val METHOD_SET_MODE_ENABLED_STATE = "setModeEnabledState"

        const val EVENT_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.spark/event_channel"

        const val METHOD_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.spark/method_channel"
    }
}
