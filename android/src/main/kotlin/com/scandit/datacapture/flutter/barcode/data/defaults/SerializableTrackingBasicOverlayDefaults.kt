/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.data.defaults

import com.scandit.datacapture.barcode.tracking.capture.BarcodeTracking
import com.scandit.datacapture.barcode.tracking.capture.BarcodeTrackingSettings
import com.scandit.datacapture.barcode.tracking.ui.overlay.BarcodeTrackingBasicOverlay
import com.scandit.datacapture.barcode.tracking.ui.overlay.BarcodeTrackingBasicOverlayStyle
import com.scandit.datacapture.barcode.tracking.ui.overlay.toJson
import com.scandit.datacapture.core.ui.style.Brush
import com.scandit.datacapture.flutter.core.data.SerializableData
import com.scandit.datacapture.flutter.core.data.defaults.SerializableBrushDefaults
import org.json.JSONObject

internal data class SerializableTrackingBasicOverlayDefaults(
    private val defaultStyle: BarcodeTrackingBasicOverlayStyle
) : SerializableData {

    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_DEFAULT_STYLE to defaultStyle.toJson(),
            FIELD_BRUSHES to mapOf(
                BarcodeTrackingBasicOverlayStyle.DOT.toJson() to
                    createOverlayForStyle(BarcodeTrackingBasicOverlayStyle.DOT),
                BarcodeTrackingBasicOverlayStyle.FRAME.toJson() to
                    createOverlayForStyle(BarcodeTrackingBasicOverlayStyle.FRAME),
                BarcodeTrackingBasicOverlayStyle.LEGACY.toJson() to
                    createOverlayForStyle(BarcodeTrackingBasicOverlayStyle.LEGACY)
            )
        )
    )

    companion object {
        private const val FIELD_BRUSHES = "Brushes"
        private const val FIELD_DEFAULT_STYLE = "defaultStyle"

        private fun createOverlayForStyle(
            style: BarcodeTrackingBasicOverlayStyle
        ): Map<String, Any?> {
            val tracking = BarcodeTracking.forDataCaptureContext(
                null,
                BarcodeTrackingSettings()
            )
            val overlay = BarcodeTrackingBasicOverlay.newInstance(tracking, null, style)
            val brush = if (overlay.brush != null) overlay.brush else Brush.transparent()
            return SerializableBrushDefaults(brush).toMap()
        }
    }
}
