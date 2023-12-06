package com.scandit.datacapture.flutter.barcode.count.listeners

import com.scandit.datacapture.barcode.count.ui.view.BarcodeCountView
import com.scandit.datacapture.barcode.count.ui.view.BarcodeCountViewUiListener
import com.scandit.datacapture.flutter.core.utils.EventHandler
import org.json.JSONObject

class ScanditFlutterBarcodeCountViewUiListener(
    private val eventHandler: EventHandler
) : BarcodeCountViewUiListener {

    override fun onExitButtonTapped(view: BarcodeCountView) {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to ON_EXIT_BUTTON_TAPPED_EVENT_NAME
                )
            )
        )
    }

    override fun onListButtonTapped(view: BarcodeCountView) {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to ON_LIST_BUTTON_TAPPED_EVENT_NAME
                )
            )
        )
    }

    override fun onSingleScanButtonTapped(view: BarcodeCountView) {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to ON_SINGLE_SCAN_BUTTON_TAPPED_EVENT_NAME
                )
            )
        )
    }

    companion object {
        const val CHANNEL_NAME =
            "com.scandit.datacapture.barcode.count.event/barcode_count_view_ui_events"

        private const val FIELD_EVENT = "event"

        private const val ON_EXIT_BUTTON_TAPPED_EVENT_NAME =
            "barcodeCountViewUiListener-onExitButtonTapped"
        private const val ON_LIST_BUTTON_TAPPED_EVENT_NAME =
            "barcodeCountViewUiListener-onListButtonTapped"
        private const val ON_SINGLE_SCAN_BUTTON_TAPPED_EVENT_NAME =
            "barcodeCountViewUiListener-onSingleScanButtonTapped"
    }
}
