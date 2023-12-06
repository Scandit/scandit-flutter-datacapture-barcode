package com.scandit.datacapture.flutter.barcode.count

import com.scandit.datacapture.core.ui.style.BrushDeserializer
import com.scandit.datacapture.flutter.core.common.LastFrameDataHolder
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray

class ScanditFlutterDataCaptureBarcodeCountMethodCallHandler(
    private val frameworksBarcodeCount: FrameworksBarcodeCount
) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_ADD_BARCODE_COUNT_VIEW_LISTENER -> {
                frameworksBarcodeCount.addBarcodeCountViewListener()
                result.success(null)
            }
            METHOD_REMOVE_BARCODE_COUNT_VIEW_LISTENER -> {
                frameworksBarcodeCount.removeBarcodeCountViewListener()
                result.success(null)
            }
            METHOD_ADD_BARCODE_COUNT_VIEW_UI_LISTENER -> {
                frameworksBarcodeCount.addBarcodeCountViewUiListener()
                result.success(null)
            }
            METHOD_REMOVE_BARCODE_COUNT_VIEW_UI_LISTENER -> {
                frameworksBarcodeCount.removeBarcodeCountViewUiListener()
                result.success(null)
            }
            METHOD_CLEAR_HIGHLIGHTS -> {
                frameworksBarcodeCount.clearHighlights()
                result.success(null)
            }
            METHOD_FINISH_BRUSH_FOR_RECOGNIZED_BARCODE_EVENT -> {
                frameworksBarcodeCount.finishBrushForRecognizedBarcodeEvent(
                    BrushDeserializer.fromJson(call.arguments as String)
                )
                result.success(null)
            }
            METHOD_FINISH_BRUSH_FOR_RECOGNIZED_BARCODE_NOT_IN_LIST_EVENT -> {
                frameworksBarcodeCount.finishBrushForRecognizedBarcodeNotInListEvent(
                    BrushDeserializer.fromJson(call.arguments as String)
                )
                result.success(null)
            }
            METHOD_FINISH_BRUSH_FOR_UNRECOGNIZED_BARCODE_EVENT -> {
                frameworksBarcodeCount.finishBrushForUnrecognizedBarcodeEvent(
                    BrushDeserializer.fromJson(call.arguments as String)
                )
                result.success(null)
            }
            METHOD_GET_BC_DEFAULTS -> {
                val defaults = frameworksBarcodeCount.getDefaults()
                result.success(defaults)
            }
            METHOD_SET_BC_CAPTURE_LIST -> {
                frameworksBarcodeCount.setBarcodeCountCaptureList(
                    JSONArray(call.arguments as String)
                )
                result.success(null)
            }
            METHOD_RESET_BC_SESSION -> {
                frameworksBarcodeCount.resetBarcodeCountSession(call.arguments as? Long)
                result.success(null)
            }
            METHOD_FINISH_ON_SCAN -> {
                val enabled = call.arguments as? Boolean ?: false
                frameworksBarcodeCount.finishOnScan(enabled)
                result.success(true)
            }
            METHOD_ADD_BC_LISTENER -> {
                frameworksBarcodeCount.enableBarcodeCountListener()
                result.success(null)
            }
            METHOD_REMOVE_BC_LISTENER -> {
                frameworksBarcodeCount.removeBarcodeCountListener()
                result.success(null)
            }
            METHOD_GET_LAST_FRAME -> LastFrameDataHolder.handleGetRequest(result)
            METHOD_RESET_BC -> {
                frameworksBarcodeCount.resetBarcodeCount()
                result.success(null)
            }
            METHOD_START_SCANNING_PHASE -> {
                frameworksBarcodeCount.startScanningPhase()
                result.success(null)
            }
            METHOD_END_SCANNING_PHASE -> {
                frameworksBarcodeCount.endScanningPhase()
                result.success(null)
            }
            METHOD_UPDATE_BARCODE_COUNT_VIEW -> {
                frameworksBarcodeCount.updateBarcodeCountView(call.arguments as String)
                result.success(null)
            }
            METHOD_UPDATE_BARCODE_COUNT -> {
                frameworksBarcodeCount.updateBarcodeCount(call.arguments as String)
                result.success(null)
            }
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
    }
}
