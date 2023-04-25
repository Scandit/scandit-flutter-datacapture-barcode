/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.count.listeners

import com.scandit.datacapture.barcode.count.capture.BarcodeCount
import com.scandit.datacapture.barcode.count.capture.BarcodeCountListener
import com.scandit.datacapture.barcode.count.capture.BarcodeCountSession
import com.scandit.datacapture.core.data.FrameData
import com.scandit.datacapture.flutter.barcode.count.ScanditFlutterBarcodeCountSessionHolder
import com.scandit.datacapture.flutter.core.common.LastFrameDataHolder
import com.scandit.datacapture.flutter.core.utils.EventHandler
import com.scandit.datacapture.flutter.core.utils.EventSinkWithResult
import org.json.JSONObject

class ScanditFlutterBarcodeCountListener(
    private val eventHandler: EventHandler,
    private val sessionHolder: ScanditFlutterBarcodeCountSessionHolder,
    private val onBarcodeScanned: EventSinkWithResult<Boolean> =
        EventSinkWithResult(ON_BARCODE_SCANNED_EVENT_NAME)
) : BarcodeCountListener {

    fun enableListener() {
        eventHandler.enableListener()
    }

    fun disableListener() {
        eventHandler.disableListener()
        onBarcodeScanned.onCancel()
    }

    override fun onScan(mode: BarcodeCount, session: BarcodeCountSession, data: FrameData) {
        LastFrameDataHolder.frameData = data
        sessionHolder.setLatestSession(session)
        eventHandler.getCurrentEventSink()?.let {
            val params = JSONObject(
                mapOf(
                    FIELD_EVENT to ON_BARCODE_SCANNED_EVENT_NAME,
                    FIELD_SESSION to session.toJson()
                )
            ).toString()
            onBarcodeScanned.emitForResult(it, params, mode.isEnabled)
        }
        LastFrameDataHolder.frameData = null
    }

    fun finishOnScan(enabled: Boolean) {
        onBarcodeScanned.onResult(enabled)
    }

    companion object {
        private const val ON_BARCODE_SCANNED_EVENT_NAME = "barcodeCountListener-onScan"

        private const val FIELD_EVENT = "event"
        private const val FIELD_SESSION = "session"

        const val CHANNEL_NAME =
            "com.scandit.datacapture.barcode.count.event/barcode_count_events"
    }
}
