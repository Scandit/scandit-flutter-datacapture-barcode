/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture

extension ScanditFlutterDataCaptureBarcodeTracking: BarcodeTrackingBasicOverlayDelegate {
    public func barcodeTrackingBasicOverlay(_ overlay: BarcodeTrackingBasicOverlay,
                                            brushFor trackedBarcode: TrackedBarcode) -> Brush? {
        return basicOverlayStreamHandler.brushForTrackedBarcode(trackedBarcode, lock: brushForTrackedBarcodeLock)
    }

    public func barcodeTrackingBasicOverlay(_ overlay: BarcodeTrackingBasicOverlay,
                                            didTap trackedBarcode: TrackedBarcode) {
        basicOverlayStreamHandler.didTapOnTrackedBarcode(trackedBarcode)
    }
}
