/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.data

import com.scandit.datacapture.core.common.geometry.PointWithUnit
import com.scandit.datacapture.core.common.geometry.PointWithUnitDeserializer
import org.json.JSONObject

class SerializableAdvancedOverlayOffsetData(
    val offset: PointWithUnit,
    val trackedBarcodeId: Int,
    val sessionFrameSequenceId: Long?
) {

    constructor(json: JSONObject) : this(
        offset = PointWithUnitDeserializer.fromJson(json.getString(FIELD_OFFSET)),
        trackedBarcodeId = json.getInt(FIELD_TRACKED_BARCODE_ID),
        sessionFrameSequenceId = if (json.has(FIELD_FRAME_SEQUENCE_ID)) {
            json.getLong(FIELD_FRAME_SEQUENCE_ID)
        } else null
    )

    companion object {
        private const val FIELD_OFFSET = "offset"
        private const val FIELD_TRACKED_BARCODE_ID = "identifier"
        private const val FIELD_FRAME_SEQUENCE_ID = "sessionFrameSequenceID"
    }
}
