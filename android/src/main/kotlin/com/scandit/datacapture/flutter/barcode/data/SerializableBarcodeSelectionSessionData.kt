package com.scandit.datacapture.flutter.barcode.data

import com.scandit.datacapture.barcode.data.Symbology
import com.scandit.datacapture.barcode.data.SymbologyDescription
import org.json.JSONObject

class SerializableBarcodeSelectionSessionData(
    val symbology: Symbology?,
    val barcodeData: String?,
    val frameSequenceId: Long?
) {

    constructor(json: JSONObject) : this(
        symbology = SymbologyDescription.forIdentifier(json.getString(FIELD_SYMBOLOGY))?.symbology,
        barcodeData = json.getString(FIELD_DATA),
        frameSequenceId = if (json.has(FIELD_FRAME_SEQUENCE_ID)) {
            json.getLong(FIELD_FRAME_SEQUENCE_ID)
        } else null
    )

    companion object {
        private const val FIELD_SYMBOLOGY = "symbology"
        private const val FIELD_DATA = "data"
        private const val FIELD_FRAME_SEQUENCE_ID = "frameSequenceId"
    }
}
