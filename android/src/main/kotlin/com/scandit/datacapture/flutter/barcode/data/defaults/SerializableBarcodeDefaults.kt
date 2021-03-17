/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.data.defaults

import com.scandit.datacapture.flutter.core.data.SerializableData
import org.json.JSONArray
import org.json.JSONObject

internal data class SerializableBarcodeDefaults(
    private val symbologySettingsDefaults: SerializableSymbologySettingsDefaults,
    private val symbologyDescriptionsDefaults: JSONArray,
    private val compositeTypeDescriptions: JSONArray
) : SerializableData {

    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_SYMBOLOGY_SETTINGS_DEFAULTS to symbologySettingsDefaults.toJson(),
            FIELD_SYMBOLOGY_DESCRIPTION_DEFAULTS to symbologyDescriptionsDefaults,
            FIELD_COMPOSITE_TYPE_DESCRIPTION_DEFAULTS to compositeTypeDescriptions
        )
    )

    companion object {
        private const val FIELD_SYMBOLOGY_SETTINGS_DEFAULTS = "SymbologySettings"
        private const val FIELD_SYMBOLOGY_DESCRIPTION_DEFAULTS = "SymbologyDescriptions"
        private const val FIELD_COMPOSITE_TYPE_DESCRIPTION_DEFAULTS = "CompositeTypeDescriptions"
    }
}
