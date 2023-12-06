/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation

enum ScanditFlutterDataCaptureBarcodeCaptureEvent: String, CaseIterable {
    case didUpdateSession = "barcodeCaptureListener-didUpdateSession"
    case didScan = "barcodeCaptureListener-didScan"
}

extension ScanditFlutterDataCaptureBarcodeCapture {
    func sendEvent(event: ScanditFlutterDataCaptureBarcodeCaptureEvent, body: [String: Any]) -> Bool {
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
