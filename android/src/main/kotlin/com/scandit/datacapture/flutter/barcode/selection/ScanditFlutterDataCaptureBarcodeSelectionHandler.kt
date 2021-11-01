/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.selection

import com.scandit.datacapture.barcode.data.Symbology
import com.scandit.datacapture.barcode.selection.capture.BarcodeSelection
import com.scandit.datacapture.barcode.selection.capture.BarcodeSelectionDeserializer
import com.scandit.datacapture.barcode.selection.capture.BarcodeSelectionDeserializerListener
import com.scandit.datacapture.core.json.JsonValue
import com.scandit.datacapture.flutter.barcode.data.defaults.SerializableBarcodeSelectionDefaults
import com.scandit.datacapture.flutter.barcode.selection.listeners.ScanditFlutterBarcodeSelectionListener
import com.scandit.datacapture.flutter.core.deserializers.Deserializers

class ScanditFlutterDataCaptureBarcodeSelectionHandler(
    private val barcodeSelectionListener: ScanditFlutterBarcodeSelectionListener,
    private val sessionHolder: ScanditFlutterBarcodeSelectionSessionHolder,
    private val barcodeSelectionDeserializer: BarcodeSelectionDeserializer =
        BarcodeSelectionDeserializer()
) : BarcodeSelectionDeserializerListener {

    private var barcodeSelection: BarcodeSelection? = null
        private set(value) {
            field?.removeListener(barcodeSelectionListener)
            field = value?.also { it.addListener(barcodeSelectionListener) }
        }

    fun onAttachedToEngine() {
        barcodeSelectionDeserializer.listener = this
        Deserializers.Factory.addModeDeserializer(barcodeSelectionDeserializer)
    }

    fun onDetachedFromEngine() {
        Deserializers.Factory.removeModeDeserializer(barcodeSelectionDeserializer)
        barcodeSelectionDeserializer.listener = null
    }

    fun addListener() {
        barcodeSelectionListener.enableListener()
    }

    fun removeListener() {
        barcodeSelectionListener.disableListener()
    }

    fun unfreezeCamera() {
        barcodeSelection?.unfreezeCamera()
    }

    fun resetSelection() {
        barcodeSelection?.reset()
    }

    val defaults: String by lazy {
        SerializableBarcodeSelectionDefaults.create()
    }

    fun getBarcodeCount(
        frameSequenceId: Long?,
        barcodeSymbology: Symbology?,
        barcodeData: String?
    ) = sessionHolder.getBarcodeCount(frameSequenceId, barcodeSymbology, barcodeData)

    fun resetLatestSession(frameSequenceId: Long?) {
        sessionHolder.reset(frameSequenceId)
    }

    fun finishDidSelect(enabled: Boolean) {
        barcodeSelectionListener.finishDidSelect(enabled)
    }

    fun finishDidUpdateSession(enabled: Boolean) {
        barcodeSelectionListener.finishDidUpdateSession(enabled)
    }

    override fun onModeDeserializationFinished(
        deserializer: BarcodeSelectionDeserializer,
        mode: BarcodeSelection,
        json: JsonValue
    ) {
        barcodeSelection = mode.also {
            if (json.contains("enabled")) {
                it.isEnabled = json.requireByKeyAsBoolean("enabled")
            }
        }
    }
}
