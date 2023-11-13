/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import ScanditBarcodeCapture

extension ScanditFlutterDataCaptureBarcodeModule {
    var defaults: [String: Any] {
        return [
            "SymbologyDescriptions": symbologyDescriptions,
            "SymbologySettings": symbologySettings,
            "CompositeTypeDescriptions": compositeTypeDescriptions
        ]
    }

    var compositeTypeDescriptions: [String] {
        return CompositeTypeDescription.all.map { $0.jsonString }
    }

    var symbologyDescriptions: [String] {
        return SymbologyDescription.all.map { $0.jsonString }
    }

    var symbologySettings: [String: String] {
        let barcodeCaptureSettings = BarcodeCaptureSettings()
        var settings: [String: String] = [:]
        SymbologyDescription.all.forEach {
            settings[$0.identifier] = barcodeCaptureSettings.settings(for: $0.symbology).jsonString
        }
        return settings
    }
}
