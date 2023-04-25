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
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let brush = self.basicOverlayStreamHandler.brushForTrackedBarcode(trackedBarcode, lock: self.brushForTrackedBarcodeLock)
            overlay.setBrush(brush, for: trackedBarcode)
        }
        return nil
    }
    
    public func barcodeTrackingBasicOverlay(_ overlay: BarcodeTrackingBasicOverlay,
                                            didTap trackedBarcode: TrackedBarcode) {
        basicOverlayStreamHandler.didTapOnTrackedBarcode(trackedBarcode)
    }
}
