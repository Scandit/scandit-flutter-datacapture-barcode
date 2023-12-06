/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

enum BarcodeTrackingAdvancedOverlayEvent: String, CaseIterable {
    case didTapViewForTrackedBarcode = "barcodeTrackingAdvancedOverlayListener-didTapViewForTrackedBarcode"
    case widgetForTrackedBarcode = "barcodeTrackingAdvancedOverlayListener-widgetForTrackedBarcode"
    case anchorForTrackedBarcode = "barcodeTrackingAdvancedOverlayListener-anchorForTrackedBarcode"
    case offsetForTrackedBarcode = "barcodeTrackingAdvancedOverlayListener-offsetForTrackedBarcode"
}

@objc
public class BarcodeTrackingAdvancedOverlayStreamHandler: NSObject, FlutterStreamHandler {
    var sink: FlutterEventSink?
    var hasListeners = false

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }

    func overlay(_ overlay: BarcodeTrackingAdvancedOverlay,
                 viewFor trackedBarcode: TrackedBarcode) {
        let body = ["trackedBarcode": trackedBarcode.jsonString]
        sendEvent(event: .widgetForTrackedBarcode, body: body)
    }

    func overlay(_ overlay: BarcodeTrackingAdvancedOverlay,
                 anchorFor trackedBarcode: TrackedBarcode) -> Anchor {
        let body = ["trackedBarcode": trackedBarcode.jsonString]
        sendEvent(event: .anchorForTrackedBarcode, body: body)
        return .center
    }

    func overlay(_ overlay: BarcodeTrackingAdvancedOverlay,
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
