/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.data.defaults

import com.scandit.datacapture.flutter.core.data.SerializableData
import com.scandit.datacapture.flutter.core.data.defaults.SerializableBrushDefaults
import org.json.JSONObject

internal data class SerializableTrackingBasicOverlayDefaults(
    private val defaultBrush: SerializableBrushDefaults
) : SerializableData {

    override fun toJson(): JSONObject = JSONObject(
        mapOf(FIELD_BRUSH to defaultBrush.toJson())
    )

    companion object {
        private const val FIELD_BRUSH = "DefaultBrush"
    }
}
