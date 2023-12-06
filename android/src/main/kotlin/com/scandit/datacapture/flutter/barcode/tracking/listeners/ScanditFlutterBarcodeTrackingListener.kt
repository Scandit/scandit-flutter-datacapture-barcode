/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.tracking.listeners

import com.scandit.datacapture.barcode.tracking.capture.BarcodeTracking
import com.scandit.datacapture.barcode.tracking.capture.BarcodeTrackingListener
import com.scandit.datacapture.barcode.tracking.capture.BarcodeTrackingSession
import com.scandit.datacapture.core.data.FrameData
import com.scandit.datacapture.flutter.barcode.tracking.ScanditFlutterBarcodeTrackingSessionHolder
import com.scandit.datacapture.flutter.core.common.LastFrameDataHolder
import com.scandit.datacapture.flutter.core.utils.EventHandler
import com.scandit.datacapture.flutter.core.utils.EventSinkWithResult
import org.json.JSONObject

class ScanditFlutterBarcodeTrackingListener(
    private val eventHandler: EventHandler,
    private val sessionHolder: ScanditFlutterBarcodeTrackingSessionHolder,
    private val onSessionUpdated: EventSinkWithResult<Boolean> =
        EventSinkWithResult(ON_SESSION_UPDATED_EVENT_NAME)
) : BarcodeTrackingListener {
    override fun onSessionUpdated(
        mode: BarcodeTracking,
        session: BarcodeTrackingSession,
        data: FrameData
    ) {
        LastFrameDataHolder.frameData = data
        eventHandler.getCurrentEventSink()?.let {
            val dataToSend = JSONObject(
                mapOf(
                    FIELD_EVENT to ON_SESSION_UPDATED_EVENT_NAME,
                    FIELD_SESSION to session.toJson()
                )
            ).toString()
            mode.isEnabled = onSessionUpdated.emitForResult(it, dataToSend, mode.isEnabled)
            sessionHolder.setLatestTrackedSession(session)
        }
        LastFrameDataHolder.frameData = null
    }

    fun enableListener() {
        eventHandler.enableListener()
    }

    fun disableListener() {
        eventHandler.disableListener()
        onSessionUpdated.onCancel()
    }

    fun finishDidUpdateSession(enabled: Boolean) {
        onSessionUpdated.onResult(enabled)
    }

    companion object {
        const val CHANNEL_NAME =
            "com.scandit.datacapture.barcode.tracking.event/barcode_tracking_listener"
        private const val ON_SESSION_UPDATED_EVENT_NAME =
            "barcodeTrackingListener-didUpdateSession"
        private const val FIELD_SESSION = "session"
        private const val FIELD_EVENT = "event"
    }
}
