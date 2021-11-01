/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import Foundation
import scandit_flutter_datacapture_core
import ScanditBarcodeCapture

extension ScanditFlutterDataCaptureBarcodeSelection {
    func registerDeserializer() {
        let deserializer = BarcodeSelectionDeserializer()
        deserializer.delegate = self
        ScanditFlutterDataCaptureCore.register(modeDeserializer: deserializer)
    }
}

extension ScanditFlutterDataCaptureBarcodeSelection: BarcodeSelectionDeserializerDelegate {
    public func barcodeSelectionDeserializer(_ deserializer: BarcodeSelectionDeserializer,
                                             didStartDeserializingMode mode: BarcodeSelection,
                                             from JSONValue: JSONValue) {}

    public func barcodeSelectionDeserializer(_ deserializer: BarcodeSelectionDeserializer,
                                             didFinishDeserializingMode mode: BarcodeSelection,
                                             from JSONValue: JSONValue) {
        if JSONValue.containsKey("enabled") {
            mode.isEnabled = JSONValue.bool(forKey: "enabled")
        }
        barcodeSelection = mode
    }

    public func barcodeSelectionDeserializer(_ deserializer: BarcodeSelectionDeserializer,
                                             didStartDeserializingSettings settings: BarcodeSelectionSettings,
                                             from JSONValue: JSONValue) {}

    public func barcodeSelectionDeserializer(_ deserializer: BarcodeSelectionDeserializer,
                                             didFinishDeserializingSettings settings: BarcodeSelectionSettings,
                                             from JSONValue: JSONValue) {}

    public func barcodeSelectionDeserializer(_ deserializer: BarcodeSelectionDeserializer,
                                             didStartDeserializingBasicOverlay overlay: BarcodeSelectionBasicOverlay,
                                             from JSONValue: JSONValue) {}

    public func barcodeSelectionDeserializer(_ deserializer: BarcodeSelectionDeserializer,
                                             didFinishDeserializingBasicOverlay overlay: BarcodeSelectionBasicOverlay,
                                             from JSONValue: JSONValue) {}
}
