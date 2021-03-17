/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.tracking.listeners

import android.view.View
import com.scandit.datacapture.barcode.tracking.data.TrackedBarcode
import com.scandit.datacapture.barcode.tracking.ui.overlay.BarcodeTrackingAdvancedOverlay
import com.scandit.datacapture.barcode.tracking.ui.overlay.BarcodeTrackingAdvancedOverlayListener
import com.scandit.datacapture.core.common.geometry.Anchor
import com.scandit.datacapture.core.common.geometry.FloatWithUnit
import com.scandit.datacapture.core.common.geometry.MeasureUnit
import com.scandit.datacapture.core.common.geometry.PointWithUnit
import com.scandit.datacapture.flutter.core.utils.EventHandler
import org.json.JSONObject

class ScanditFlutterBarcodeTrackingAdvancedOverlayListener(
    private val eventHandler: EventHandler
) : BarcodeTrackingAdvancedOverlayListener {

    fun enableListener() {
        eventHandler.enableListener()
    }

    fun disableListener() {
        eventHandler.disableListener()
    }

    override fun anchorForTrackedBarcode(
        overlay: BarcodeTrackingAdvancedOverlay,
        trackedBarcode: TrackedBarcode
    ): Anchor {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to EVENT_ANCHOR_FOR_TRACKED_BARCODE,
                    FIELD_TRACKED_BARCODE to trackedBarcode.toJson()
                )
            )
        )

        return Anchor.CENTER
    }

    override fun offsetForTrackedBarcode(
        overlay: BarcodeTrackingAdvancedOverlay,
        trackedBarcode: TrackedBarcode,
        view: View
    ): PointWithUnit {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to EVENT_OFFSET_FOR_TRACKED_BARCODE,
                    FIELD_TRACKED_BARCODE to trackedBarcode.toJson()
                )
            )
        )

        return PointWithUnit(
            FloatWithUnit(0f, MeasureUnit.PIXEL),
            FloatWithUnit(0f, MeasureUnit.PIXEL)
        )
    }

    override fun viewForTrackedBarcode(
        overlay: BarcodeTrackingAdvancedOverlay,
        trackedBarcode: TrackedBarcode
    ): View? {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to EVENT_WIDGET_FOR_TRACKED_BARCODE,
                    FIELD_TRACKED_BARCODE to trackedBarcode.toJson()
                )
            )
        )

        return null
    }

    fun onViewForBarcodeTapped(trackedBarcode: TrackedBarcode) {
        eventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to EVENT_DID_TAP_VIEW_FOR_TRACKED_BARCODE,
                    FIELD_TRACKED_BARCODE to trackedBarcode.toJson()
                )
            )
        )
    }

    companion object {
        const val CHANNEL_NAME: String =
            "com.scandit.datacapture.barcode.tracking.event/barcode_tracking_advanced_overlay"

        private const val EVENT_OFFSET_FOR_TRACKED_BARCODE =
            "barcodeTrackingAdvancedOverlayListener-offsetForTrackedBarcode"

        private const val EVENT_ANCHOR_FOR_TRACKED_BARCODE =
            "barcodeTrackingAdvancedOverlayListener-anchorForTrackedBarcode"

        private const val EVENT_WIDGET_FOR_TRACKED_BARCODE =
            "barcodeTrackingAdvancedOverlayListener-widgetForTrackedBarcode"

        private const val EVENT_DID_TAP_VIEW_FOR_TRACKED_BARCODE =
            "barcodeTrackingAdvancedOverlayListener-didTapViewForTrackedBarcode"

        private const val FIELD_EVENT = "event"
        private const val FIELD_TRACKED_BARCODE = "trackedBarcode"
    }
}
