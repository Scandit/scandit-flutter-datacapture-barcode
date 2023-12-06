package com.scandit.datacapture.flutter.barcode.count.listeners

import com.scandit.datacapture.barcode.count.ui.view.BarcodeCountView
import com.scandit.datacapture.barcode.count.ui.view.BarcodeCountViewListener
import com.scandit.datacapture.barcode.tracking.data.TrackedBarcode
import com.scandit.datacapture.core.ui.style.Brush
import com.scandit.datacapture.flutter.core.utils.EventHandler
import com.scandit.datacapture.flutter.core.utils.EventSinkWithResult
import org.json.JSONObject

class ScanditFlutterBarcodeCountViewListener(
    private val eventHandler: EventHandler,
    private val brushForRecognizedBarcodeEvent: EventSinkWithResult<Brush?> =
        EventSinkWithResult(BRUSH_FOR_RECOGNIZED_BARCODE_EVENT),
    private val brushForRecognizedBarcodeNotInListEvent: EventSinkWithResult<Brush?> =
        EventSinkWithResult(BRUSH_FOR_RECOGNIZED_BARCODE_NOT_IN_LIST_EVENT),
    private val brushForUnrecognizedBarcodeEvent: EventSinkWithResult<Brush?> =
        EventSinkWithResult(BRUSH_FOR_UNRECOGNIZED_BARCODE)
) : BarcodeCountViewListener {
    override fun brushForRecognizedBarcode(
        view: BarcodeCountView,
        trackedBarcode: TrackedBarcode
    ): Brush? {
        // TODO: https://scandit.atlassian.net/browse/SDC-16601
        return view.recognizedBrush
//        val eventSink = eventHandler.getCurrentEventSink() ?: return null
//        val params = JSONObject(
//            mapOf(
//                FIELD_EVENT to BRUSH_FOR_RECOGNIZED_BARCODE_EVENT,
//                FIELD_TRACKED_BARCODE to trackedBarcode.toJson()
//            )
//        ).toString()
//        return brushForRecognizedBarcodeEvent.emitForResult(eventSink, params, null)
    }

    override fun brushForRecognizedBarcodeNotInList(
        view: BarcodeCountView,
        trackedBarcode: TrackedBarcode
    ): Brush? {
        // TODO: https://scandit.atlassian.net/browse/SDC-16601
        return  view.notInListBrush
//        val eventSink = eventHandler.getCurrentEventSink() ?: return null
//        val params = JSONObject(
//            mapOf(
//                FIELD_EVENT to BRUSH_FOR_RECOGNIZED_BARCODE_NOT_IN_LIST_EVENT,
//                FIELD_TRACKED_BARCODE to trackedBarcode.toJson()
//            )
//        ).toString()
//        return brushForRecognizedBarcodeNotInListEvent.emitForResult(eventSink, params, null)
    }

    override fun brushForUnrecognizedBarcode(
        view: BarcodeCountView,
        trackedBarcode: TrackedBarcode
    ): Brush? {
        // TODO: https://scandit.atlassian.net/browse/SDC-16601
        return view.unrecognizedBrush
//        val eventSink = eventHandler.getCurrentEventSink() ?: return null
//        val params = JSONObject(
//            mapOf(
//                FIELD_EVENT to BRUSH_FOR_UNRECOGNIZED_BARCODE,
//                FIELD_TRACKED_BARCODE to trackedBarcode.toJson()
//            )
//        ).toString()
//        return brushForUnrecognizedBarcodeEvent.emitForResult(eventSink, params, null)
    }

    override fun onFilteredBarcodeTapped(view: BarcodeCountView, filteredBarcode: TrackedBarcode) {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to DID_TAP_FILTERED_BARCODE,
                    FIELD_TRACKED_BARCODE to filteredBarcode.toJson()
                )
            )
        )
    }

    override fun onRecognizedBarcodeNotInListTapped(
        view: BarcodeCountView,
        trackedBarcode: TrackedBarcode
    ) {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to DID_TAP_RECOGNIZED_BARCODE_NOT_IN_LIST,
                    FIELD_TRACKED_BARCODE to trackedBarcode.toJson()
                )
            )
        )
    }

    override fun onRecognizedBarcodeTapped(view: BarcodeCountView, trackedBarcode: TrackedBarcode) {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to DID_TAP_RECOGNIZED_BARCODE,
                    FIELD_TRACKED_BARCODE to trackedBarcode.toJson()
                )
            )
        )
    }

    override fun onUnrecognizedBarcodeTapped(
        view: BarcodeCountView,
        trackedBarcode: TrackedBarcode
    ) {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to DID_TAP_UNRECOGNIZED_BARCODE,
                    FIELD_TRACKED_BARCODE to trackedBarcode.toJson()
                )
            )
        )
    }

    override fun onCaptureListCompleted(view: BarcodeCountView) {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to DID_COMPLETE_CAPTURE_LIST
                )
            )
        )
    }

    fun finishBrushForRecognizedBarcodeEvent(brush: Brush?) {
        brushForRecognizedBarcodeEvent.onResult(brush)
    }

    fun finishBrushForRecognizedBarcodeNotInListEvent(brush: Brush?) {
        brushForRecognizedBarcodeNotInListEvent.onResult(brush)
    }

    fun finishBrushForUnrecognizedBarcodeEvent(brush: Brush?) {
        brushForUnrecognizedBarcodeEvent.onResult(brush)
    }

    companion object {
        private const val BRUSH_FOR_RECOGNIZED_BARCODE_EVENT =
            "barcodeCountViewListener-brushForRecognizedBarcode"
        private const val BRUSH_FOR_RECOGNIZED_BARCODE_NOT_IN_LIST_EVENT =
            "barcodeCountViewListener-brushForRecognizedBarcodeNotInList"
        private const val BRUSH_FOR_UNRECOGNIZED_BARCODE =
            "barcodeCountViewListener-brushForUnrecognizedBarcode"

        private const val DID_TAP_RECOGNIZED_BARCODE =
            "barcodeCountViewListener-didTapRecognizedBarcode"
        private const val DID_TAP_UNRECOGNIZED_BARCODE =
            "barcodeCountViewListener-didTapUnrecognizedBarcode"
        private const val DID_TAP_FILTERED_BARCODE =
            "barcodeCountViewListener-didTapFilteredBarcode"
        private const val DID_TAP_RECOGNIZED_BARCODE_NOT_IN_LIST =
            "barcodeCountViewListener-didTapRecognizedBarcodeNotInList"
        private const val DID_COMPLETE_CAPTURE_LIST =
            "barcodeCountViewListener-didCompleteCaptureList"

        private const val FIELD_EVENT = "event"
        private const val FIELD_TRACKED_BARCODE = "trackedBarcode"

        const val CHANNEL_NAME =
            "com.scandit.datacapture.barcode.count.event/barcode_count_view_events"
    }
}
