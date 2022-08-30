/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.selection.listeners

import com.scandit.datacapture.barcode.selection.capture.BarcodeSelection
import com.scandit.datacapture.barcode.selection.capture.BarcodeSelectionListener
import com.scandit.datacapture.barcode.selection.capture.BarcodeSelectionSession
import com.scandit.datacapture.core.data.FrameData
import com.scandit.datacapture.flutter.barcode.selection.ScanditFlutterBarcodeSelectionSessionHolder
import com.scandit.datacapture.flutter.core.common.LastFrameDataHolder
import com.scandit.datacapture.flutter.core.utils.EventHandler
import com.scandit.datacapture.flutter.core.utils.EventSinkWithResult
import org.json.JSONObject

class ScanditFlutterBarcodeSelectionListener(
    private val eventHandler: EventHandler,
    private val sessionHolder: ScanditFlutterBarcodeSelectionSessionHolder,
    private val onBarcodeSelection: EventSinkWithResult<Boolean> =
        EventSinkWithResult(ON_SELECTION_UPDATE_EVENT_NAME),
    private val onSessionUpdated: EventSinkWithResult<Boolean> =
        EventSinkWithResult(ON_SESSION_UPDATE_EVENT_NAME)
) : BarcodeSelectionListener {

    override fun onSelectionUpdated(
        barcodeSelection: BarcodeSelection,
        session: BarcodeSelectionSession,
        frameData: FrameData?
    ) {
        sessionHolder.setLatestSession(session)
        LastFrameDataHolder.frameData = frameData
        eventHandler.getCurrentEventSink()?.let {
            val params = JSONObject(
                mapOf(
                    FIELD_EVENT to ON_SELECTION_UPDATE_EVENT_NAME,
                    FIELD_SESSION to session.toJson()
                )
            ).toString()
            barcodeSelection.isEnabled =
                onBarcodeSelection.emitForResult(it, params, barcodeSelection.isEnabled)
        }
        LastFrameDataHolder.frameData = null
    }

    override fun onSessionUpdated(
        barcodeSelection: BarcodeSelection,
        session: BarcodeSelectionSession,
        frameData: FrameData?
    ) {
        LastFrameDataHolder.frameData = frameData
        eventHandler.getCurrentEventSink()?.let {
            val params = JSONObject(
                mapOf(
                    FIELD_EVENT to ON_SESSION_UPDATE_EVENT_NAME,
                    FIELD_SESSION to session.toJson()
                )
            ).toString()
            barcodeSelection.isEnabled =
                onSessionUpdated.emitForResult(it, params, barcodeSelection.isEnabled)
        }
        LastFrameDataHolder.frameData = null
    }

    fun enableListener() {
        eventHandler.enableListener()
    }

    fun disableListener() {
        eventHandler.disableListener()
    }

    fun finishDidSelect(enabled: Boolean) {
        onBarcodeSelection.onResult(enabled)
    }

    fun finishDidUpdateSession(enabled: Boolean) {
        onSessionUpdated.onResult(enabled)
    }

    companion object {
        const val CHANNEL_NAME =
            "com.scandit.datacapture.barcode.selection.event/barcode_selection_listener"

        private const val ON_SELECTION_UPDATE_EVENT_NAME =
            "barcodeSelectionListener-didUpdateSelection"
        private const val ON_SESSION_UPDATE_EVENT_NAME =
            "barcodeSelectionListener-didUpdateSession"

        private const val FIELD_EVENT = "event"
        private const val FIELD_SESSION = "session"
    }
}
