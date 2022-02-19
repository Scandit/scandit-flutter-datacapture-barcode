/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.data.defaults

import com.scandit.datacapture.barcode.capture.BarcodeCapture
import com.scandit.datacapture.barcode.capture.BarcodeCaptureSettings
import com.scandit.datacapture.barcode.ui.overlay.BarcodeCaptureOverlay
import com.scandit.datacapture.barcode.ui.overlay.BarcodeCaptureOverlayStyle
import com.scandit.datacapture.barcode.ui.overlay.toJson
import com.scandit.datacapture.flutter.core.data.SerializableData
import com.scandit.datacapture.flutter.core.data.defaults.SerializableBrushDefaults
import com.scandit.datacapture.flutter.core.data.defaults.SerializableCameraSettingsDefaults
import org.json.JSONObject

internal data class SerializableBarcodeCaptureDefaults(
    private val recommendedCameraSettings: SerializableCameraSettingsDefaults,
    private val barcodeCaptureSettings: SerializableBarcodeCaptureSettingsDefaults,
    private val barcodeCaptureOverlay: SerializableBarcodeCaptureOverlayDefaults
) : SerializableData {

    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_RECOMMENDED_CAMERA_SETTINGS to recommendedCameraSettings.toJson(),
            FIELD_BARCODE_CAPTURE_SETTINGS to barcodeCaptureSettings.toJson(),
            FIELD_BARCODE_CAPTURE_OVERLAY to barcodeCaptureOverlay.toJson()
        )
    )

    companion object {
        private const val FIELD_RECOMMENDED_CAMERA_SETTINGS = "RecommendedCameraSettings"
        private const val FIELD_BARCODE_CAPTURE_SETTINGS = "BarcodeCaptureSettings"
        private const val FIELD_BARCODE_CAPTURE_OVERLAY = "BarcodeCaptureOverlay"
    }
}

internal data class SerializableBarcodeCaptureSettingsDefaults(
    private val duplicateFilter: Long
) : SerializableData {

    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_CODE_DUPLICATE_FILTER to duplicateFilter
        )
    )

    companion object {
        private const val FIELD_CODE_DUPLICATE_FILTER = "codeDuplicateFilter"
    }
}

internal data class SerializableBarcodeCaptureOverlayDefaults(
    private val defaultStyle: BarcodeCaptureOverlayStyle
) : SerializableData {

    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_DEFAULT_STYLE to defaultStyle.toJson(),
            FIELD_BRUSHES to mapOf(
                BarcodeCaptureOverlayStyle.FRAME.toJson() to
                    createOverlayStyleBrush(BarcodeCaptureOverlayStyle.FRAME),
                BarcodeCaptureOverlayStyle.LEGACY.toJson() to
                    createOverlayStyleBrush(BarcodeCaptureOverlayStyle.LEGACY)
            )
        )
    )

    companion object {
        private const val FIELD_BRUSHES = "Brushes"
        private const val FIELD_DEFAULT_STYLE = "defaultStyle"

        private fun createOverlayStyleBrush(style: BarcodeCaptureOverlayStyle): Map<String, Any?> {
            val barcodeCapture = BarcodeCapture
                .forDataCaptureContext(null, BarcodeCaptureSettings())
            val brush = BarcodeCaptureOverlay.newInstance(barcodeCapture, null, style).brush
            return SerializableBrushDefaults(brush).toMap()
        }
    }
}
