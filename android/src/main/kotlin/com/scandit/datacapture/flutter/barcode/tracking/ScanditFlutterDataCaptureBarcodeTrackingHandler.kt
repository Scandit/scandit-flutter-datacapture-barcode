/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.tracking

import com.scandit.datacapture.barcode.tracking.capture.BarcodeTracking
import com.scandit.datacapture.barcode.tracking.capture.BarcodeTrackingDeserializer
import com.scandit.datacapture.barcode.tracking.capture.BarcodeTrackingDeserializerListener
import com.scandit.datacapture.barcode.tracking.capture.BarcodeTrackingSettings
import com.scandit.datacapture.barcode.tracking.ui.overlay.BarcodeTrackingAdvancedOverlay
import com.scandit.datacapture.barcode.tracking.ui.overlay.BarcodeTrackingBasicOverlay
import com.scandit.datacapture.core.capture.DataCaptureContextListener
import com.scandit.datacapture.core.json.JsonValue
import com.scandit.datacapture.flutter.barcode.data.defaults.SerializableBarcodeTrackingDefaults
import com.scandit.datacapture.flutter.barcode.data.defaults.SerializableTrackingBasicOverlayDefaults
import com.scandit.datacapture.flutter.barcode.tracking.listeners.ScanditFlutterBarcodeTrackingListener
import com.scandit.datacapture.flutter.core.data.defaults.SerializableCameraSettingsDefaults
import com.scandit.datacapture.flutter.core.deserializers.Deserializers

class ScanditFlutterDataCaptureBarcodeTrackingHandler(
    private val barcodeTrackingListener: ScanditFlutterBarcodeTrackingListener,
    private val flutterBarcodeTrackingBasicOverlayHandler:
        ScanditFlutterBarcodeTrackingBasicOverlayHandler,
    private val flutterBarcodeTrackingAdvancedOverlayHandler:
        ScanditFlutterBarcodeTrackingAdvancedOverlayHandler,
    private val sessionHolder: ScanditFlutterBarcodeTrackingSessionHolder,
    private val barcodeTrackingDeserializer: BarcodeTrackingDeserializer =
        BarcodeTrackingDeserializer()
) : BarcodeTrackingDeserializerListener,
    DataCaptureContextListener {

    companion object {
        private val defaults: SerializableBarcodeTrackingDefaults by lazy {
            val cameraSettings = BarcodeTracking.createRecommendedCameraSettings()
            val barcodeTracking = BarcodeTracking.forDataCaptureContext(
                null,
                BarcodeTrackingSettings()
            )
            val basicOverlay = BarcodeTrackingBasicOverlay.newInstance(barcodeTracking, null)

            SerializableBarcodeTrackingDefaults(
                recommendedCameraSettings = SerializableCameraSettingsDefaults(
                    settings = cameraSettings
                ),
                trackingBasicOverlayDefaults = SerializableTrackingBasicOverlayDefaults(
                    defaultStyle = basicOverlay.style
                )
            )
        }
    }

    private var barcodeTracking: BarcodeTracking? = null
        private set(value) {
            field?.removeListener(barcodeTrackingListener)
            field = value?.also { it.addListener(barcodeTrackingListener) }
        }

    fun getDefaultsAsJson(): String = defaults.toJson().toString()

    fun onAttachedToEngine() {
        barcodeTrackingDeserializer.listener = this
        Deserializers.Factory.addModeDeserializer(barcodeTrackingDeserializer)
        flutterBarcodeTrackingBasicOverlayHandler.onAttachedToEngine()
        flutterBarcodeTrackingAdvancedOverlayHandler.onAttachedToEngine()
    }

    fun onDetachedFromEngine() {
        barcodeTrackingDeserializer.listener = null
        Deserializers.Factory.removeModeDeserializer(barcodeTrackingDeserializer)
        flutterBarcodeTrackingBasicOverlayHandler.onDetachedFromEngine()
        flutterBarcodeTrackingAdvancedOverlayHandler.onDetachedFromEngine()
    }

    override fun onBasicOverlayDeserializationStarted(
        deserializer: BarcodeTrackingDeserializer,
        overlay: BarcodeTrackingBasicOverlay,
        json: JsonValue
    ) {
        flutterBarcodeTrackingBasicOverlayHandler.overlay = overlay
    }

    override fun onAdvancedOverlayDeserializationStarted(
        deserializer: BarcodeTrackingDeserializer,
        overlay: BarcodeTrackingAdvancedOverlay,
        json: JsonValue
    ) {
        flutterBarcodeTrackingAdvancedOverlayHandler.overlay = overlay
    }

    override fun onModeDeserializationFinished(
        deserializer: BarcodeTrackingDeserializer,
        mode: BarcodeTracking,
        json: JsonValue
    ) {
        if (json.contains("enabled")) {
            mode.isEnabled = json.requireByKeyAsBoolean("enabled")
        }
        barcodeTracking = mode
    }

    fun addBarcodeTrackingListener() {
        barcodeTrackingListener.enableListener()
    }

    fun removeBarcodeTrackingListener() {
        barcodeTrackingListener.disableListener()
    }

    fun finishDidUpdateSession(enabled: Boolean) {
        barcodeTrackingListener.finishDidUpdateSession(enabled)
    }

    fun resetSession(frameSequenceId: Long?) {
        sessionHolder.reset(frameSequenceId)
    }
}
