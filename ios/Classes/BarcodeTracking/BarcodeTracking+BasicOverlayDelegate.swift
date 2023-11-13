/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

enum BarcodeTrackingBasicOverlayEvent: String, CaseIterable {
    case brushForTrackedBarcode = "BarcodeTrackingBasicOverlayListener.brushForTrackedBarcode"
    case didTapTrackedBarcode = "BarcodeTrackingBasicOverlayListener.didTapTrackedBarcode"
}

extension ScanditFlutterDataCaptureBarcodeTracking: BarcodeTrackingBasicOverlayDelegate {
    public func barcodeTrackingBasicOverlay(_ overlay: BarcodeTrackingBasicOverlay,
                                            brushFor trackedBarcode: TrackedBarcode) -> Brush? {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let body = ["trackedBarcode": trackedBarcode.jsonString]
            let brush = self.brushForTrackedBarcodeLock.wait {
                return self.send(event: .brushForTrackedBarcode, body: body)
            }
            overlay.setBrush(brush, for: trackedBarcode)
        }
        return nil
    }
    
    public func barcodeTrackingBasicOverlay(_ overlay: BarcodeTrackingBasicOverlay,
                                            didTap trackedBarcode: TrackedBarcode) {
        let body = ["trackedBarcode": trackedBarcode.jsonString]
        guard send(event: .didTapTrackedBarcode, body: body) else { return }
    }
    
    func finishBrushForTrackedBarcodeCallback(arguments: String?, result: FlutterResult, lock: CallbackLock<Brush>) {
        guard let jsonString = arguments else {
            lock.unlock(value: nil)
            return
        }
        let brush = Brush(jsonString: jsonString)
        lock.unlock(value: brush)
    }

    func didTapOnTrackedBarcode(_ trackedBarcode: TrackedBarcode) {
       
    }
    
    private func send(event: BarcodeTrackingBasicOverlayEvent, body: [String: Any]) -> Bool {
        guard let sink = barcodeTrackingSink, hasBasicOverlayListeners else { return false }
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
