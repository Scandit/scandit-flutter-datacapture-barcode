/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

class FlutterBarcodeCountViewUIListener: NSObject {
    var sink: FlutterEventSink?

    var hasListeners = false

    func addBarcodeCountViewUIListener(_ result: FlutterResult) {
        hasListeners = true
        result(nil)
    }

    func removeBarcodeCountViewUIListener(_ result: FlutterResult) {
        hasListeners = false
        result(nil)
    }

    func dispose() {
        // dispose 
    }

    @discardableResult
    func sendEvent(event: FlutterBarcodeCountEvent) -> Bool {
        guard let sink = sink, hasListeners else { return false }
        do {
            let jsonString = String(data: try JSONSerialization.data(withJSONObject: ["event": event.rawValue],
                                                                     options: []),
                                    encoding: .utf8)
            sink(jsonString)
            return true
        } catch {
            print(error)
            return false
        }
    }
}

extension FlutterBarcodeCountViewUIListener: BarcodeCountViewUIDelegate {
    func listButtonTapped(for view: BarcodeCountView) {
        sendEvent(event: .onListButtonTapped)
    }

    func exitButtonTapped(for view: BarcodeCountView) {
        sendEvent(event: .onExitButtonTapped)
    }

    func singleScanButtonTapped(for view: BarcodeCountView) {
        sendEvent(event: .onSingleScanButtonTapped)
    }
}
