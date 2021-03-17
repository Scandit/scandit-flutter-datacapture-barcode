/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture

extension ScanditFlutterDataCaptureBarcodeTracking: BarcodeTrackingAdvancedOverlayDelegate {
    public func barcodeTrackingAdvancedOverlay(_ overlay: BarcodeTrackingAdvancedOverlay,
                                               viewFor trackedBarcode: TrackedBarcode) -> UIView? {
        advancedOverlayStreamHandler.overlay(overlay,
                                             viewFor: trackedBarcode)
        return nil
    }

    public func barcodeTrackingAdvancedOverlay(_ overlay: BarcodeTrackingAdvancedOverlay,
                                               anchorFor trackedBarcode: TrackedBarcode) -> Anchor {
        return advancedOverlayStreamHandler.overlay(overlay,
                                                    anchorFor: trackedBarcode)
    }

    public func barcodeTrackingAdvancedOverlay(_ overlay: BarcodeTrackingAdvancedOverlay,
                                               offsetFor trackedBarcode: TrackedBarcode) -> PointWithUnit {
        return advancedOverlayStreamHandler.overlay(overlay,
                                                    offsetFor: trackedBarcode)
    }
}
