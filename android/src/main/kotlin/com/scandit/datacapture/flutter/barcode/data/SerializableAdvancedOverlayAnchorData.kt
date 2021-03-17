/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.data

import com.scandit.datacapture.core.common.geometry.Anchor
import com.scandit.datacapture.core.common.geometry.AnchorDeserializer
import org.json.JSONObject

class SerializableAdvancedOverlayAnchorData(
    val anchor: Anchor,
    val trackedBarcodeId: Int,
    val sessionFrameSequenceId: Long?
) {

    constructor(json: JSONObject) : this(
        anchor = AnchorDeserializer.fromJson(json.getString(FIELD_ANCHOR)),
        trackedBarcodeId = json.getInt(FIELD_TRACKED_BARCODE_ID),
        sessionFrameSequenceId = if (json.has(FIELD_FRAME_SEQUENCE_ID)) {
            json.getLong(FIELD_FRAME_SEQUENCE_ID)
        } else null
    )

    companion object {
        private const val FIELD_ANCHOR = "anchor"
        private const val FIELD_TRACKED_BARCODE_ID = "identifier"
        private const val FIELD_FRAME_SEQUENCE_ID = "sessionFrameSequenceID"
    }
}
