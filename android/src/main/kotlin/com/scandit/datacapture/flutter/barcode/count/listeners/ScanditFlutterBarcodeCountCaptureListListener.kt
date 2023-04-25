package com.scandit.datacapture.flutter.barcode.count.listeners

import com.scandit.datacapture.barcode.count.capture.list.BarcodeCountCaptureList
import com.scandit.datacapture.barcode.count.capture.list.BarcodeCountCaptureListListener
import com.scandit.datacapture.barcode.count.capture.list.BarcodeCountCaptureListSession
import com.scandit.datacapture.flutter.core.utils.EventHandler
import org.json.JSONObject

class ScanditFlutterBarcodeCountCaptureListListener(
    private val eventHandler: EventHandler
) : BarcodeCountCaptureListListener {

    fun enableListener() {
        eventHandler.enableListener()
    }

    fun disableListener() {
        eventHandler.disableListener()
    }

    override fun onCaptureListSessionUpdated(
        list: BarcodeCountCaptureList,
        session: BarcodeCountCaptureListSession
    ) {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to ON_CAPTURE_LIST_SESSION_UPDATED_EVENT_NAME,
                    FIELD_SESSION to session.toJson()
                )
            )
        )
    }

    companion object {
        private const val ON_CAPTURE_LIST_SESSION_UPDATED_EVENT_NAME =
            "barcodeCountCaptureListListener-didUpdateSession"

        private const val FIELD_EVENT = "event"
        private const val FIELD_SESSION = "session"
    }
}
