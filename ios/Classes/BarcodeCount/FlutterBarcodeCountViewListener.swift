/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import scandit_flutter_datacapture_core

class FlutterBarcodeCountViewListener: NSObject {
    private var brushRequests: [String: TrackedBarcode] = [:]

    var sink: FlutterEventSink?

    var hasListeners = false
    

    func addBarcodeCountViewListener(_ result: FlutterResult) {
        hasListeners = true
        result(nil)
    }

    func removeBarcodeCountViewListener(_ result: FlutterResult) {
        hasListeners = false
        brushRequests.removeAll()
        result(nil)
    }

    func dispose() {
        brushRequests.removeAll()
    }

    @discardableResult
    func sendEvent(event: FlutterBarcodeCountEvent, body: [String: Any]) -> Bool {
        guard let sink = sink, hasListeners else { return false }
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

extension FlutterBarcodeCountViewListener: BarcodeCountViewDelegate {

    
    func barcodeCountView(_ view: BarcodeCountView,
                          brushForRecognizedBarcode trackedBarcode: TrackedBarcode) -> Brush? {
        sendEvent(event: .brushForRecognizedBarcode, body: trackedBarcode.asDictionary)
        brushRequests[trackedBarcode.identifier.keyFor(prefix: FlutterBarcodeCountEvent.brushForRecognizedBarcode.rawValue)] = trackedBarcode
        return nil
    }
    
    func getTrackedBarcodeForBrushForRecognizedEvent(trackedBarcodeId: Int) -> TrackedBarcode? {
        let key = trackedBarcodeId.keyFor(prefix: FlutterBarcodeCountEvent.brushForRecognizedBarcode.rawValue)
        let trackedBarcode = brushRequests[key]
        
        if (trackedBarcode != nil) {
            brushRequests.removeValue(forKey: key)
        }
        return trackedBarcode
    }

    func barcodeCountView(_ view: BarcodeCountView,
                          brushForUnrecognizedBarcode trackedBarcode: TrackedBarcode) -> Brush? {
        sendEvent(event: .brushForUnrecognizedBarcode, body: trackedBarcode.asDictionary)
        brushRequests[trackedBarcode.identifier.keyFor(prefix: FlutterBarcodeCountEvent.brushForUnrecognizedBarcode.rawValue)] = trackedBarcode
        return nil
    }
    
    func getTrackedBarcodeForBrushForUnrecognizedEvent(trackedBarcodeId: Int) -> TrackedBarcode? {
        let key = trackedBarcodeId.keyFor(prefix: FlutterBarcodeCountEvent.brushForUnrecognizedBarcode.rawValue)
        let trackedBarcode = brushRequests[key]
        
        if (trackedBarcode != nil) {
            brushRequests.removeValue(forKey: key)
        }
        return trackedBarcode
    }

    func barcodeCountView(_ view: BarcodeCountView,
                          brushForRecognizedBarcodeNotInList trackedBarcode: TrackedBarcode) -> Brush? {
        sendEvent(event: .brushForRecgonizedBarcodeNotInList, body: trackedBarcode.asDictionary)
        brushRequests[trackedBarcode.identifier.keyFor(prefix: FlutterBarcodeCountEvent.brushForRecgonizedBarcodeNotInList.rawValue)] = trackedBarcode
        return nil
    }
    
    func getTrackedBarcodeForBrushForBarcodeNotInListEvent(trackedBarcodeId: Int) -> TrackedBarcode? {
        let key = trackedBarcodeId.keyFor(prefix: FlutterBarcodeCountEvent.brushForRecgonizedBarcodeNotInList.rawValue)
        let trackedBarcode = brushRequests[key]
        
        if (trackedBarcode != nil) {
            brushRequests.removeValue(forKey: key)
        }
        return trackedBarcode
    }

    func barcodeCountView(_ view: BarcodeCountView,
                          didTapRecognizedBarcode trackedBarcode: TrackedBarcode) {
        sendEvent(event: .didTapRecognizedBarcode, body: trackedBarcode.asDictionary)
    }

    func barcodeCountView(_ view: BarcodeCountView,
                          didTapUnrecognizedBarcode trackedBarcode: TrackedBarcode) {
        sendEvent(event: .didTapUnrecognizedBarcode, body: trackedBarcode.asDictionary)
    }

    func barcodeCountView(_ view: BarcodeCountView,
                          didTapRecognizedBarcodeNotInList trackedBarcode: TrackedBarcode) {
        sendEvent(event: .brushForRecgonizedBarcodeNotInList, body: trackedBarcode.asDictionary)
    }

    func barcodeCountView(_ view: BarcodeCountView,
                          didTapFilteredBarcode trackedBarcode: TrackedBarcode) {
        sendEvent(event: .didTapFilteredBarcode, body: trackedBarcode.asDictionary)
    }
}

fileprivate extension TrackedBarcode {
    var asDictionary: [String: String] {
        [
            "trackedBarcode": jsonString
        ]
    }
}

fileprivate extension Int {
    func keyFor(prefix: String) -> String {
        return  "\(prefix)-\(self)"
    }
}
