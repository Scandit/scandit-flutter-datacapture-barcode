/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

extension ScanditFlutterDataCaptureBarcodeCapture {
    func registerDeserializer() {
        let barcodeCaptureDeserializer = BarcodeCaptureDeserializer()
        barcodeCaptureDeserializer.delegate = self
        ScanditFlutterDataCaptureCore.register(modeDeserializer: barcodeCaptureDeserializer)
    }
}

extension ScanditFlutterDataCaptureBarcodeCapture: BarcodeCaptureDeserializerDelegate {
    func barcodeCaptureDeserializer(_ deserializer: BarcodeCaptureDeserializer,
                                    didStartDeserializingMode mode: BarcodeCapture,
                                    from JSONValue: JSONValue) {}

    func barcodeCaptureDeserializer(_ deserializer: BarcodeCaptureDeserializer,
                                    didFinishDeserializingMode mode: BarcodeCapture,
                                    from JSONValue: JSONValue) {
        mode.addListener(self)
        if JSONValue.containsKey("enabled") {
            mode.isEnabled = JSONValue.bool(forKey: "enabled")
        }
    }

    func barcodeCaptureDeserializer(_ deserializer: BarcodeCaptureDeserializer,
                                    didStartDeserializingSettings settings: BarcodeCaptureSettings,
                                    from JSONValue: JSONValue) {}

    func barcodeCaptureDeserializer(_ deserializer: BarcodeCaptureDeserializer,
                                    didFinishDeserializingSettings settings: BarcodeCaptureSettings,
                                    from JSONValue: JSONValue) {}

    func barcodeCaptureDeserializer(_ deserializer: BarcodeCaptureDeserializer,
                                    didStartDeserializingOverlay overlay: BarcodeCaptureOverlay,
                                    from JSONValue: JSONValue) {}

    func barcodeCaptureDeserializer(_ deserializer: BarcodeCaptureDeserializer,
                                    didFinishDeserializingOverlay overlay: BarcodeCaptureOverlay,
                                    from JSONValue: JSONValue) {}
}
