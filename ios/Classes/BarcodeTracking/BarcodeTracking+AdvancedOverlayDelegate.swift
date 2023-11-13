/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture

enum BarcodeTrackingAdvancedOverlayEvent: String, CaseIterable {
    case didTapViewForTrackedBarcode = "BarcodeTrackingAdvancedOverlayListener.didTapViewForTrackedBarcode"
    case widgetForTrackedBarcode = "BarcodeTrackingAdvancedOverlayListener.widgetForTrackedBarcode"
    case anchorForTrackedBarcode = "BarcodeTrackingAdvancedOverlayListener.anchorForTrackedBarcode"
    case offsetForTrackedBarcode = "BarcodeTrackingAdvancedOverlayListener.offsetForTrackedBarcode"
}

extension ScanditFlutterDataCaptureBarcodeTracking: BarcodeTrackingAdvancedOverlayDelegate {
    public func barcodeTrackingAdvancedOverlay(_ overlay: BarcodeTrackingAdvancedOverlay,
                                               viewFor trackedBarcode: TrackedBarcode) -> UIView? {
        let body = ["trackedBarcode": trackedBarcode.jsonString]
        sendEvent(event: .widgetForTrackedBarcode, body: body)
        return nil
    }

    public func barcodeTrackingAdvancedOverlay(_ overlay: BarcodeTrackingAdvancedOverlay,
                                               anchorFor trackedBarcode: TrackedBarcode) -> Anchor {
        let body = ["trackedBarcode": trackedBarcode.jsonString]
        sendEvent(event: .anchorForTrackedBarcode, body: body)
        
        return .center
    }

    public func barcodeTrackingAdvancedOverlay(_ overlay: BarcodeTrackingAdvancedOverlay,
                                               offsetFor trackedBarcode: TrackedBarcode) -> PointWithUnit {
        let body = ["trackedBarcode": trackedBarcode.jsonString]
        sendEvent(event: .offsetForTrackedBarcode, body: body)
        return .zero
    }
    
    func didTapViewForTrackedBarcode(_ trackedBarcode: TrackedBarcode) {
        guard sendEvent(event: .didTapViewForTrackedBarcode,
                        body: ["trackedBarcode": trackedBarcode.jsonString]) else {
            return
        }
    }
    
    @discardableResult
    func sendEvent(event: BarcodeTrackingAdvancedOverlayEvent, body: [String: Any]) -> Bool {
        guard let sink = barcodeTrackingSink, hasAdvancedOverlayListeners else { return false }
        let payload = ["event": event.rawValue].merging(body) { (_, new) in new }
        do {
            let jsonString = String(data: try JSONSerialization.data(withJSONObject: payload, options: []),
                                    encoding: .utf8)
            sink(jsonString)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
