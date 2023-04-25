/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

enum BarcodeTrackingBasicOverlayEvent: String, CaseIterable {
    case brushForTrackedBarcode = "barcodeTrackingBasicOverlayListener-brushForTrackedBarcode"
    case didTapTrackedBarcode = "barcodeTrackingBasicOverlayListener-didTapTrackedBarcode"
}

@objc
public class BarcodeTrackingBasicOverlayStreamHandler: NSObject, FlutterStreamHandler {
    var sink: FlutterEventSink?
    var hasListeners = false

    public func onListen(withArguments arguments: Any?,
                         eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }

    func brushForTrackedBarcode(_ trackedBarcode: TrackedBarcode, lock: CallbackLock<Brush>) -> Brush? {
        let body = ["trackedBarcode": trackedBarcode.jsonString]
        return lock.wait {
            return send(event: .brushForTrackedBarcode, body: body)
        }
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
        let body = ["trackedBarcode": trackedBarcode.jsonString]
        guard send(event: .didTapTrackedBarcode, body: body) else { return }
    }

    private func send(event: BarcodeTrackingBasicOverlayEvent, body: [String: Any]) -> Bool {
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
