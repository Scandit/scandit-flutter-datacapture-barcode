/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.capture.listeners

import com.scandit.datacapture.barcode.capture.BarcodeCapture
import com.scandit.datacapture.barcode.capture.BarcodeCaptureListener
import com.scandit.datacapture.barcode.capture.BarcodeCaptureSession
import com.scandit.datacapture.core.data.FrameData
import com.scandit.datacapture.flutter.barcode.capture.ScanditFlutterBarcodeCaptureSessionHolder
import com.scandit.datacapture.flutter.core.common.LastFrameDataHolder
import com.scandit.datacapture.flutter.core.utils.EventHandler
import com.scandit.datacapture.flutter.core.utils.EventSinkWithResult
import org.json.JSONObject

class ScanditFlutterBarcodeCaptureListener(
    private val eventHandler: EventHandler,
    private val sessionHolder: ScanditFlutterBarcodeCaptureSessionHolder,
    private val onBarcodeScanned: EventSinkWithResult<Boolean> =
        EventSinkWithResult(ON_BARCODE_SCANNED_EVENT_NAME),
    private val onSessionUpdated: EventSinkWithResult<Boolean> =
        EventSinkWithResult(ON_SESSION_UPDATED_EVENT_NAME)

) : BarcodeCaptureListener {
    companion object {
        private const val ON_BARCODE_SCANNED_EVENT_NAME = "barcodeCaptureListener-didScan"
        private const val ON_SESSION_UPDATED_EVENT_NAME = "barcodeCaptureListener-didUpdateSession"

        private const val FIELD_EVENT = "event"
        private const val FIELD_SESSION = "session"

        const val CHANNEL_NAME =
            "com.scandit.datacapture.barcode.capture.event/barcode_capture_listener"
    }

    fun enableListener() {
        eventHandler.enableListener()
    }

    fun disableListener() {
        eventHandler.disableListener()
        onSessionUpdated.onCancel()
        onBarcodeScanned.onCancel()
    }

    override fun onBarcodeScanned(
        barcodeCapture: BarcodeCapture,
        session: BarcodeCaptureSession,
        data: FrameData
    ) {
        sessionHolder.setLatestSession(session)
        LastFrameDataHolder.frameData = data
        eventHandler.getCurrentEventSink()?.let {
            val params = JSONObject(
                mapOf(
                    FIELD_EVENT to ON_BARCODE_SCANNED_EVENT_NAME,
                    FIELD_SESSION to session.toJson()
                )
            ).toString()
            barcodeCapture.isEnabled =
                onBarcodeScanned.emitForResult(it, params, barcodeCapture.isEnabled)
        }
        LastFrameDataHolder.frameData = null
    }

    override fun onSessionUpdated(
        barcodeCapture: BarcodeCapture,
        session: BarcodeCaptureSession,
        data: FrameData
    ) {
        LastFrameDataHolder.frameData = data
        eventHandler.getCurrentEventSink()?.let {
            val params = JSONObject(
                mapOf(
                    FIELD_EVENT to ON_SESSION_UPDATED_EVENT_NAME,
                    FIELD_SESSION to session.toJson()
                )
            ).toString()
            barcodeCapture.isEnabled =
                onSessionUpdated.emitForResult(it, params, barcodeCapture.isEnabled)
        }
        LastFrameDataHolder.frameData = null
    }

    fun finishDidScan(enabled: Boolean) {
        onBarcodeScanned.onResult(enabled)
    }

    fun finishDidUpdateSession(enabled: Boolean) {
        onSessionUpdated.onResult(enabled)
    }
}
