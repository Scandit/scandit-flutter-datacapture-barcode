/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.data

class SerializableAdvancedOverlayViewData(
    val widgetBytes: ByteArray?,
    val trackedBarcodeId: Int,
    val sessionFrameSequenceId: Long?
) {

    constructor(data: HashMap<String, Any?>) : this(
        widgetBytes = if (data.containsKey(FIELD_WIDGET)) data[FIELD_WIDGET] as ByteArray else null,
        trackedBarcodeId = data[FIELD_TRACKED_BARCODE_ID] as Int,
        sessionFrameSequenceId = if (data.containsKey(FIELD_FRAME_SEQUENCE_ID)) {
            data[FIELD_FRAME_SEQUENCE_ID].toString().toLongOrNull()
        } else null
    )

    companion object {
        private const val FIELD_WIDGET = "widget"
        private const val FIELD_TRACKED_BARCODE_ID = "identifier"
        private const val FIELD_FRAME_SEQUENCE_ID = "sessionFrameSequenceID"
    }
}
