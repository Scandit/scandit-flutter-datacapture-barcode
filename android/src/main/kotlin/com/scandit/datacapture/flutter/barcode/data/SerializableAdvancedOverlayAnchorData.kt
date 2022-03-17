/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.data

import com.scandit.datacapture.core.common.geometry.Anchor
import com.scandit.datacapture.core.common.geometry.AnchorDeserializer

class SerializableAdvancedOverlayAnchorData(
    val anchor: Anchor,
    val trackedBarcodeId: Int,
    val sessionFrameSequenceId: Long?
) {

    constructor(data: HashMap<String, Any?>) : this(
        anchor = AnchorDeserializer.fromJson(data[FIELD_ANCHOR] as String),
        trackedBarcodeId = data[FIELD_TRACKED_BARCODE_ID] as Int,
        sessionFrameSequenceId = if (data.containsKey(FIELD_FRAME_SEQUENCE_ID)) {
            data[FIELD_FRAME_SEQUENCE_ID].toString().toLongOrNull()
        } else null
    )

    companion object {
        private const val FIELD_ANCHOR = "anchor"
        private const val FIELD_TRACKED_BARCODE_ID = "identifier"
        private const val FIELD_FRAME_SEQUENCE_ID = "sessionFrameSequenceID"
    }
}
