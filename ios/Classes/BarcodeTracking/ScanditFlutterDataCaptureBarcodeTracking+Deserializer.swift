/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

extension ScanditFlutterDataCaptureBarcodeTracking {
    func registerDeserializer() {
        let barcodeTrackingDeserializer = BarcodeTrackingDeserializer()
        barcodeTrackingDeserializer.delegate = self
        ScanditFlutterDataCaptureCore.register(modeDeserializer: barcodeTrackingDeserializer)
    }
}

extension ScanditFlutterDataCaptureBarcodeTracking: BarcodeTrackingDeserializerDelegate {
    public func barcodeTrackingDeserializer(_ deserializer: BarcodeTrackingDeserializer,
                                            didStartDeserializingMode mode: BarcodeTracking,
                                            from JSONValue: JSONValue) {}

    public func barcodeTrackingDeserializer(_ deserializer: BarcodeTrackingDeserializer,
                                            didFinishDeserializingMode mode: BarcodeTracking,
                                            from JSONValue: JSONValue) {
        if JSONValue.containsKey("enabled") {
            mode.isEnabled = JSONValue.bool(forKey: "enabled")
        }
        mode.addListener(self)
    }

    public func barcodeTrackingDeserializer(_ deserializer: BarcodeTrackingDeserializer,
                                            didStartDeserializingSettings settings: BarcodeTrackingSettings,
                                            from JSONValue: JSONValue) {}

    public func barcodeTrackingDeserializer(_ deserializer: BarcodeTrackingDeserializer,
                                            didFinishDeserializingSettings settings: BarcodeTrackingSettings,
                                            from JSONValue: JSONValue) {}

    public func barcodeTrackingDeserializer(_ deserializer: BarcodeTrackingDeserializer,
                                            didStartDeserializingBasicOverlay overlay: BarcodeTrackingBasicOverlay,
                                            from JSONValue: JSONValue) {}

    public func barcodeTrackingDeserializer(_ deserializer: BarcodeTrackingDeserializer,
                                            didFinishDeserializingBasicOverlay overlay: BarcodeTrackingBasicOverlay,
                                            from JSONValue: JSONValue) {
        barcodeTrackingBasicOverlay = overlay
    }

    public func barcodeTrackingDeserializer(
        _ deserializer: BarcodeTrackingDeserializer,
        didStartDeserializingAdvancedOverlay overlay: BarcodeTrackingAdvancedOverlay,
        from JSONValue: JSONValue) {}

    public func barcodeTrackingDeserializer(
        _ deserializer: BarcodeTrackingDeserializer,
        didFinishDeserializingAdvancedOverlay overlay: BarcodeTrackingAdvancedOverlay,
        from JSONValue: JSONValue) {
        barcodeTrackingAdvancedOverlay = overlay
        barcodeTrackingAdvancedOverlay?.delegate = self
    }
}
