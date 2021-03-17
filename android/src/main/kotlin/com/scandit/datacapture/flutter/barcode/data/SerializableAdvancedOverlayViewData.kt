/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.data

import org.json.JSONObject

class SerializableAdvancedOverlayViewData(
    val base64EncodedWidget: String?,
    val trackedBarcodeId: Int,
    val sessionFrameSequenceId: Long?
) {

    constructor(json: JSONObject) : this(
        base64EncodedWidget = if (json.isNull(FIELD_WIDGET)) null else json.getString(FIELD_WIDGET),
        trackedBarcodeId = json.getInt(FIELD_TRACKED_BARCODE_ID),
        sessionFrameSequenceId = if (json.has(FIELD_FRAME_SEQUENCE_ID)) {
            json.getLong(FIELD_FRAME_SEQUENCE_ID)
        } else null
    )

    companion object {
        private const val FIELD_WIDGET = "widget"
        private const val FIELD_TRACKED_BARCODE_ID = "identifier"
        private const val FIELD_FRAME_SEQUENCE_ID = "sessionFrameSequenceID"
    }
}
