package com.scandit.datacapture.flutter.barcode.count

import com.scandit.datacapture.core.ui.style.BrushDeserializer
import com.scandit.datacapture.flutter.core.utils.rejectKotlinError
import com.scandit.datacapture.frameworks.barcode.count.BarcodeCountModule
import com.scandit.datacapture.frameworks.core.errors.FrameDataNullError
import com.scandit.datacapture.frameworks.core.utils.DefaultLastFrameData
import com.scandit.datacapture.frameworks.core.utils.LastFrameData
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

class BarcodeCountMethodHandler(
    private val barcodeCountModule: BarcodeCountModule,
    private val lastFrameData: LastFrameData = DefaultLastFrameData.getInstance()
) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_ADD_BARCODE_COUNT_VIEW_LISTENER -> {
                barcodeCountModule.addBarcodeCountViewListener()
                result.success(null)
            }

            METHOD_REMOVE_BARCODE_COUNT_VIEW_LISTENER -> {
                barcodeCountModule.removeBarcodeCountViewListener()
                result.success(null)
            }

            METHOD_ADD_BARCODE_COUNT_VIEW_UI_LISTENER -> {
                barcodeCountModule.addBarcodeCountViewUiListener()
                result.success(null)
            }

            METHOD_REMOVE_BARCODE_COUNT_VIEW_UI_LISTENER -> {
                barcodeCountModule.removeBarcodeCountViewUiListener()
                result.success(null)
            }

            METHOD_CLEAR_HIGHLIGHTS -> {
                barcodeCountModule.clearHighlights()
                result.success(null)
            }

            METHOD_FINISH_BRUSH_FOR_RECOGNIZED_BARCODE_EVENT -> {
                val arguments = call.arguments as? HashMap<*, *> ?: run {
                    result.error(
                        "-1",
                        "Invalid argument for " +
                            METHOD_FINISH_BRUSH_FOR_RECOGNIZED_BARCODE_EVENT,
                        ""
                    )
                    return
                }
                val brushJson = arguments["brush"] as String
                val trackedBarcodeId = arguments["trackedBarcodeId"] as Int

                barcodeCountModule.finishBrushForRecognizedBarcodeEvent(
                    BrushDeserializer.fromJson(brushJson),
                    trackedBarcodeId
                )
                result.success(null)
            }

            METHOD_FINISH_BRUSH_FOR_RECOGNIZED_BARCODE_NOT_IN_LIST_EVENT -> {
                val arguments = call.arguments as? HashMap<*, *> ?: run {
                    result.error(
                        "-1",
                        "Invalid argument for " +
                            METHOD_FINISH_BRUSH_FOR_RECOGNIZED_BARCODE_NOT_IN_LIST_EVENT,
                        ""
                    )
                    return
                }
                val brushJson = arguments["brush"] as String
                val trackedBarcodeId = arguments["trackedBarcodeId"] as Int

                barcodeCountModule.finishBrushForRecognizedBarcodeNotInListEvent(
                    BrushDeserializer.fromJson(brushJson),
                    trackedBarcodeId
                )
                result.success(null)
            }

            METHOD_FINISH_BRUSH_FOR_UNRECOGNIZED_BARCODE_EVENT -> {
                val arguments = call.arguments as? HashMap<*, *> ?: run {
                    result.error(
                        "-1",
                        "Invalid argument for " +
                            METHOD_FINISH_BRUSH_FOR_UNRECOGNIZED_BARCODE_EVENT,
                        ""
                    )
                    return
                }
                val brushJson = arguments["brush"] as String
                val trackedBarcodeId = arguments["trackedBarcodeId"] as Int

                barcodeCountModule.finishBrushForUnrecognizedBarcodeEvent(
                    BrushDeserializer.fromJson(brushJson),
                    trackedBarcodeId
                )
                result.success(null)
            }

            METHOD_GET_BC_DEFAULTS -> {
                val defaults = barcodeCountModule.getDefaults()
                result.success(JSONObject(defaults).toString())
            }

            METHOD_SET_BC_CAPTURE_LIST -> {
                barcodeCountModule.setBarcodeCountCaptureList(
                    JSONArray(call.arguments as String)
                )
                result.success(null)
            }

            METHOD_RESET_BC_SESSION -> {
                barcodeCountModule.resetBarcodeCountSession(call.arguments as? Long)
                result.success(null)
            }

            METHOD_FINISH_ON_SCAN -> {
                val enabled = call.arguments as? Boolean ?: false
                barcodeCountModule.finishOnScan(enabled)
                result.success(true)
            }

            METHOD_ADD_BC_LISTENER -> {
                barcodeCountModule.addBarcodeCountListener()
                result.success(null)
            }

            METHOD_REMOVE_BC_LISTENER -> {
                barcodeCountModule.removeBarcodeCountListener()
                result.success(null)
            }

            METHOD_GET_LAST_FRAME -> lastFrameData.getLastFrameDataBytes {
                if (it == null) {
                    result.rejectKotlinError(FrameDataNullError())
                    return@getLastFrameDataBytes
                }
                result.success(it)
            }

            METHOD_RESET_BC -> {
                barcodeCountModule.resetBarcodeCount()
                result.success(null)
            }

            METHOD_START_SCANNING_PHASE -> {
                barcodeCountModule.startScanningPhase()
                result.success(null)
            }

            METHOD_END_SCANNING_PHASE -> {
                barcodeCountModule.endScanningPhase()
                result.success(null)
            }

            METHOD_UPDATE_BARCODE_COUNT_VIEW -> {
                barcodeCountModule.updateBarcodeCountView(call.arguments as String)
                result.success(null)
            }

            METHOD_UPDATE_BARCODE_COUNT -> {
                barcodeCountModule.updateBarcodeCount(call.arguments as String)
                result.success(null)
            }

            METHOD_SET_MODE_ENABLED_STATE -> barcodeCountModule.setModeEnabled(
                call.arguments as Boolean
            )

            else -> throw IllegalArgumentException("Nothing implemented for ${call.method}")
        }
    }

    companion object {
        private const val METHOD_ADD_BARCODE_COUNT_VIEW_LISTENER = "addBarcodeCountViewListener"
        private const val METHOD_REMOVE_BARCODE_COUNT_VIEW_LISTENER =
            "removeBarcodeCountViewListener"
        private const val METHOD_ADD_BARCODE_COUNT_VIEW_UI_LISTENER =
            "addBarcodeCountViewUiListener"
        private const val METHOD_REMOVE_BARCODE_COUNT_VIEW_UI_LISTENER =
            "removeBarcodeCountViewUiListener"
        private const val METHOD_CLEAR_HIGHLIGHTS = "clearHighlights"
        private const val METHOD_FINISH_BRUSH_FOR_RECOGNIZED_BARCODE_EVENT =
            "finishBrushForRecognizedBarcodeEvent"
        private const val METHOD_FINISH_BRUSH_FOR_RECOGNIZED_BARCODE_NOT_IN_LIST_EVENT =
            "finishBrushForRecognizedBarcodeNotInListEvent"
        private const val METHOD_FINISH_BRUSH_FOR_UNRECOGNIZED_BARCODE_EVENT =
            "finishBrushForUnrecognizedBarcodeEvent"
        private const val METHOD_UPDATE_BARCODE_COUNT_VIEW =
            "updateBarcodeCountView"

        private const val METHOD_GET_BC_DEFAULTS = "getBarcodeCountDefaults"
        private const val METHOD_RESET_BC_SESSION = "resetBarcodeCountSession"
        private const val METHOD_FINISH_ON_SCAN = "barcodeCountFinishOnScan"
        private const val METHOD_ADD_BC_LISTENER = "addBarcodeCountListener"
        private const val METHOD_REMOVE_BC_LISTENER = "removeBarcodeCountListener"
        private const val METHOD_GET_LAST_FRAME = "getBarcodeCountLastFrameData"
        private const val METHOD_RESET_BC = "resetBarcodeCount"
        private const val METHOD_START_SCANNING_PHASE = "startScanningPhase"
        private const val METHOD_END_SCANNING_PHASE = "endScanningPhase"
        private const val METHOD_SET_BC_CAPTURE_LIST = "setBarcodeCountCaptureList"
        private const val METHOD_UPDATE_BARCODE_COUNT = "updateBarcodeCountMode"
        private const val METHOD_SET_MODE_ENABLED_STATE = "setModeEnabledState"

        const val EVENT_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.count/event_channel"

        const val METHOD_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.count/method_channel"
    }
}
