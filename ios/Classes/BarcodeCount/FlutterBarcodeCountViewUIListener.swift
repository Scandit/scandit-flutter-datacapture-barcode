/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

class FlutterBarcodeCountViewUIListener: NSObject {
    var sink: FlutterEventSink?

    let eventChannel: FlutterEventChannel

    var hasListeners = false

    init(eventChannel: FlutterEventChannel) {
        self.eventChannel = eventChannel
        super.init()
        self.eventChannel.setStreamHandler(self)
    }

    func addBarcodeCountViewUIListener(_ result: FlutterResult) {
        hasListeners = true
        result(nil)
    }

    func removeBarcodeCountViewUIListener(_ result: FlutterResult) {
        hasListeners = false
        result(nil)
    }

    func dispose() {
        eventChannel.setStreamHandler(nil)
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

extension FlutterBarcodeCountViewUIListener: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
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
