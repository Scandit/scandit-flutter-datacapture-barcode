/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

extension ScanditFlutterDataCaptureBarcodeTrackingModule {
    var defaults: [String: Any] {
        return [
            "RecommendedCameraSettings": BarcodeTracking.recommendedCameraSettings.defaults,
            "BarcodeTrackingBasicOverlay": barcodeTrackingBasicOverlayDefaults
        ]
    }

    private var barcodeTrackingBasicOverlayDefaults: [String: Any] {
        return [
            "DefaultBrush": BarcodeTrackingBasicOverlay.defaultBrush.defaults
        ]
    }
}
