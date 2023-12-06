/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.data.defaults

import com.scandit.datacapture.flutter.core.data.SerializableData
import com.scandit.datacapture.flutter.core.data.defaults.SerializableCameraSettingsDefaults
import org.json.JSONObject

internal class SerializableBarcodeTrackingDefaults(
    private val recommendedCameraSettings: SerializableCameraSettingsDefaults,
    private val trackingBasicOverlayDefaults: SerializableTrackingBasicOverlayDefaults
) : SerializableData {

    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_RECOMMENDED_CAMERA_SETTINGS to recommendedCameraSettings.toJson(),
            FIELD_TRACKING_BASIC_OVERLAY to trackingBasicOverlayDefaults.toJson()
        )
    )

    companion object {
        private const val FIELD_RECOMMENDED_CAMERA_SETTINGS = "RecommendedCameraSettings"
        private const val FIELD_TRACKING_BASIC_OVERLAY = "BarcodeTrackingBasicOverlay"
    }
}
