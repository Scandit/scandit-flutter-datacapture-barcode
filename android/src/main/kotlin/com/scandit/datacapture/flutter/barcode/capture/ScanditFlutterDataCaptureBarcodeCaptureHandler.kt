/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.capture

import com.scandit.datacapture.barcode.capture.BarcodeCapture
import com.scandit.datacapture.barcode.capture.BarcodeCaptureDeserializer
import com.scandit.datacapture.barcode.capture.BarcodeCaptureDeserializerListener
import com.scandit.datacapture.barcode.capture.BarcodeCaptureSettings
import com.scandit.datacapture.barcode.ui.overlay.BarcodeCaptureOverlay
import com.scandit.datacapture.core.json.JsonValue
import com.scandit.datacapture.flutter.barcode.capture.listeners.ScanditFlutterBarcodeCaptureListener
import com.scandit.datacapture.flutter.barcode.data.defaults.SerializableBarcodeCaptureDefaults
import com.scandit.datacapture.flutter.barcode.data.defaults.SerializableBarcodeCaptureOverlayDefaults
import com.scandit.datacapture.flutter.barcode.data.defaults.SerializableBarcodeCaptureSettingsDefaults
import com.scandit.datacapture.flutter.core.data.defaults.SerializableCameraSettingsDefaults
import com.scandit.datacapture.flutter.core.deserializers.Deserializers
import io.flutter.plugin.common.MethodChannel.Result

class ScanditFlutterDataCaptureBarcodeCaptureHandler(
    private val barcodeCaptureListener: ScanditFlutterBarcodeCaptureListener,
    private val sessionHolder: ScanditFlutterBarcodeCaptureSessionHolder,
    private val barcodeCaptureDeserializer: BarcodeCaptureDeserializer =
        BarcodeCaptureDeserializer()
) : BarcodeCaptureDeserializerListener {

    private val defaults: SerializableBarcodeCaptureDefaults by lazy {
        val settings = BarcodeCaptureSettings()
        val cameraSettings = BarcodeCapture.createRecommendedCameraSettings()
        val captureMode = BarcodeCapture.forDataCaptureContext(null, BarcodeCaptureSettings())
        val overlay = BarcodeCaptureOverlay.newInstance(captureMode, null)

        SerializableBarcodeCaptureDefaults(
            recommendedCameraSettings = SerializableCameraSettingsDefaults(
                settings = cameraSettings
            ),
            barcodeCaptureSettings = SerializableBarcodeCaptureSettingsDefaults(
                duplicateFilter = settings.codeDuplicateFilter.asMillis()
            ),
            barcodeCaptureOverlay = SerializableBarcodeCaptureOverlayDefaults(
                defaultStyle = overlay.style
            )
        )
    }

    private var barcodeCapture: BarcodeCapture? = null
        private set(value) {
            field?.removeListener(barcodeCaptureListener)
            field = value?.also { it.addListener(barcodeCaptureListener) }
        }

    fun onAttachedToEngine() {
        barcodeCaptureDeserializer.listener = this
        Deserializers.Factory.addModeDeserializer(barcodeCaptureDeserializer)
    }

    fun onDetachedFromEngine() {
        barcodeCaptureDeserializer.listener = null
        Deserializers.Factory.removeModeDeserializer(barcodeCaptureDeserializer)
        removeListener()
    }

    fun getDefaults(result: Result) {
        result.success(defaults.toJson().toString())
    }

    fun addListener() {
        barcodeCaptureListener.enableListener()
    }

    fun removeListener() {
        barcodeCaptureListener.disableListener()
    }

    fun finishDidScan(enabled: Boolean) {
        barcodeCaptureListener.finishDidScan(enabled)
    }

    fun finishDidUpdateSession(enabled: Boolean) {
        barcodeCaptureListener.finishDidUpdateSession(enabled)
    }

    fun resetSession(frameSequenceId: Long?) {
        sessionHolder.reset(frameSequenceId)
    }

    override fun onModeDeserializationFinished(
        deserializer: BarcodeCaptureDeserializer,
        mode: BarcodeCapture,
        json: JsonValue
    ) {
        barcodeCapture = mode
    }
}
