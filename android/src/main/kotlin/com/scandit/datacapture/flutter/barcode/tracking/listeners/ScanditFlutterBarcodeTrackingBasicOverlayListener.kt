/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.tracking.listeners

import com.scandit.datacapture.barcode.tracking.data.TrackedBarcode
import com.scandit.datacapture.barcode.tracking.ui.overlay.BarcodeTrackingBasicOverlay
import com.scandit.datacapture.barcode.tracking.ui.overlay.BarcodeTrackingBasicOverlayListener
import com.scandit.datacapture.core.ui.style.Brush
import com.scandit.datacapture.flutter.core.utils.EventHandler
import com.scandit.datacapture.flutter.core.utils.EventSinkWithResult
import org.json.JSONObject

class ScanditFlutterBarcodeTrackingBasicOverlayListener(
    private val eventHandler: EventHandler,
    private val onSetBrushForTrackedBarcode: EventSinkWithResult<Brush?> =
        EventSinkWithResult(EVENT_SET_BRUSH_FOR_TRACKED_BARCODE)
) : BarcodeTrackingBasicOverlayListener {

    override fun brushForTrackedBarcode(
        overlay: BarcodeTrackingBasicOverlay,
        trackedBarcode: TrackedBarcode
    ): Brush? {
        eventHandler.getCurrentEventSink()?.let {
            val data = JSONObject(
                mapOf(
                    FIELD_EVENT to EVENT_SET_BRUSH_FOR_TRACKED_BARCODE,
                    FIELD_TRACKED_BARCODE to trackedBarcode.toJson()
                )
            ).toString()
            return onSetBrushForTrackedBarcode.emitForResult(it, data, null)
        }
        return null
    }

    override fun onTrackedBarcodeTapped(
        overlay: BarcodeTrackingBasicOverlay,
        trackedBarcode: TrackedBarcode
    ) {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to EVENT_ON_TRACKED_BARCODE_TAPPED,
                    FIELD_TRACKED_BARCODE to trackedBarcode.toJson()
                )
            )
        )
    }

    fun enableListener() {
        eventHandler.enableListener()
    }

    fun disableListener() {
        eventHandler.disableListener()
    }

    fun finishBrushForTrackedBarcode(brush: Brush?) {
        onSetBrushForTrackedBarcode.onResult(brush)
    }

    companion object {
        const val CHANNEL_NAME =
            "com.scandit.datacapture.barcode.tracking.event/barcode_tracking_basic_overlay"

        private const val EVENT_SET_BRUSH_FOR_TRACKED_BARCODE =
            "barcodeTrackingBasicOverlayListener-brushForTrackedBarcode"
        private const val EVENT_ON_TRACKED_BARCODE_TAPPED =
            "barcodeTrackingBasicOverlayListener-didTapTrackedBarcode"

        private const val FIELD_EVENT = "event"
        private const val FIELD_TRACKED_BARCODE = "trackedBarcode"
    }
}
