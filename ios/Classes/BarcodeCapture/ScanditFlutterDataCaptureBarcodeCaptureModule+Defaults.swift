/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

extension ScanditFlutterDataCaptureBarcodeCaptureModule {
    var defaults: [String: Any] {
        return [
            "RecommendedCameraSettings": recommendedCameraSettings,
            "BarcodeCaptureOverlay": barcodeCaptureOverlay,
            "BarcodeCaptureSettings": barcodeCaptureSettings
        ]
    }

    var recommendedCameraSettings: [String: Any] {
        return BarcodeCapture.recommendedCameraSettings.defaults
    }

    var barcodeCaptureOverlay: [String: Any] {
        func createOverlayWithStyle(style: BarcodeCaptureOverlayStyle) -> [String: Any] {
            return BarcodeCaptureOverlay.defaultBrush(forStyle: style).defaults
        }

        return [
            "defaultStyle": BarcodeCaptureOverlayStyle.legacy.jsonString,
            "Brushes": [
                BarcodeCaptureOverlayStyle.frame.jsonString: createOverlayWithStyle(style: .frame),
                BarcodeCaptureOverlayStyle.legacy.jsonString: createOverlayWithStyle(style: .legacy)
            ]
        ]
    }

    var barcodeCaptureSettings: [String: Any] {
        return [
            "codeDuplicateFilter": Int(BarcodeCaptureSettings().codeDuplicateFilter * 1000)
        ]
    }
}
