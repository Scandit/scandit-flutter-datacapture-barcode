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
                                    from jsonValue: JSONValue) {
        // not used in frameworks
    }

    func barcodeCaptureDeserializer(_ deserializer: BarcodeCaptureDeserializer,
                                    didFinishDeserializingMode mode: BarcodeCapture,
                                    from jsonValue: JSONValue) {
        mode.addListener(self)
        if jsonValue.containsKey("enabled") {
            mode.isEnabled = jsonValue.bool(forKey: "enabled")
        }
    }

    func barcodeCaptureDeserializer(_ deserializer: BarcodeCaptureDeserializer,
                                    didStartDeserializingSettings settings: BarcodeCaptureSettings,
                                    from jsonValue: JSONValue) {
        // not used in frameworks
    }

    func barcodeCaptureDeserializer(_ deserializer: BarcodeCaptureDeserializer,
                                    didFinishDeserializingSettings settings: BarcodeCaptureSettings,
                                    from jsonValue: JSONValue) {
        // not used in frameworks
    }

    func barcodeCaptureDeserializer(_ deserializer: BarcodeCaptureDeserializer,
                                    didStartDeserializingOverlay overlay: BarcodeCaptureOverlay,
                                    from jsonValue: JSONValue) {
        // not used in frameworks
    }

    func barcodeCaptureDeserializer(_ deserializer: BarcodeCaptureDeserializer,
                                    didFinishDeserializingOverlay overlay: BarcodeCaptureOverlay,
                                    from jsonValue: JSONValue) {
        // not used in frameworks
    }
}
