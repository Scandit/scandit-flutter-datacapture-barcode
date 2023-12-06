/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import scandit_flutter_datacapture_core

class FlutterBarcodeCountViewListener: NSObject {
    let eventChannel: FlutterEventChannel

    init(eventChannel: FlutterEventChannel) {
        self.eventChannel = eventChannel
        super.init()
        self.eventChannel.setStreamHandler(self)
    }

    var sink: FlutterEventSink?

    var hasListeners = false

    var brushForRecognizedBarcodeLock = CallbackLock<Brush>(name: FlutterBarcodeCountEvent.brushForRecognizedBarcode.rawValue)
    var brushForUnrecognizedBarcodeLock = CallbackLock<Brush>(name: FlutterBarcodeCountEvent.brushForUnrecognizedBarcode.rawValue)
    var brushForRecognizedBarcodeNotInListLock = CallbackLock<Brush>(name: FlutterBarcodeCountEvent.brushForRecgonizedBarcodeNotInList.rawValue)

    func addBarcodeCountViewListener(_ result: FlutterResult) {
        hasListeners = true
        result(nil)
    }

    func removeBarcodeCountViewListener(_ result: FlutterResult) {
        hasListeners = false
        unlockLocks()
        result(nil)
    }

    func dispose() {
        unlockLocks()
        eventChannel.setStreamHandler(nil)
    }

    private func unlockLocks() {
        brushForRecognizedBarcodeLock.reset()
        brushForUnrecognizedBarcodeLock.reset()
        brushForRecognizedBarcodeNotInListLock.reset()
    }

    deinit {
        unlockLocks()
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

extension FlutterBarcodeCountViewListener: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}

extension FlutterBarcodeCountViewListener: BarcodeCountViewDelegate {
    func barcodeCountView(_ view: BarcodeCountView,
                          brushForRecognizedBarcode trackedBarcode: TrackedBarcode) -> Brush? {
        // TODO: https://scandit.atlassian.net/browse/SDC-16601
        return view.recognizedBrush
//        brushForRecognizedBarcodeLock.wait {
//            sendEvent(event: .brushForRecognizedBarcode, body: trackedBarcode.asDictionary)
//        }
    }

    func finishBrushForRecognizedBarcodeCallback(brushJson: String?, result: FlutterResult) {
        guard let brushJson = brushJson, let brush = Brush(jsonString: brushJson) else {
            brushForRecognizedBarcodeLock.unlock(value: nil)
            result(nil)
            return
        }
        brushForRecognizedBarcodeLock.unlock(value: brush)
        result(nil)
    }

    func barcodeCountView(_ view: BarcodeCountView,
                          brushForUnrecognizedBarcode trackedBarcode: TrackedBarcode) -> Brush? {
        // TODO: https://scandit.atlassian.net/browse/SDC-16601
        return view.unrecognizedBrush
//        brushForUnrecognizedBarcodeLock.wait {
//            sendEvent(event: .brushForUnrecognizedBarcode, body: trackedBarcode.asDictionary)
//        }
    }

    func finishBrushForUnrecognizedBarcodeCallback(brushJson: String?, result: FlutterResult) {
        guard let brushJson = brushJson, let brush = Brush(jsonString: brushJson) else {
            brushForUnrecognizedBarcodeLock.unlock(value: nil)
            result(nil)
            return
        }
        brushForUnrecognizedBarcodeLock.unlock(value: brush)
        result(nil)
    }

    func barcodeCountView(_ view: BarcodeCountView,
                          brushForRecognizedBarcodeNotInList trackedBarcode: TrackedBarcode) -> Brush? {
        // TODO: https://scandit.atlassian.net/browse/SDC-16601
        return view.notInListBrush
//        brushForRecognizedBarcodeNotInListLock.wait {
//            sendEvent(event: .brushForRecgonizedBarcodeNotInList, body: trackedBarcode.asDictionary)
//        }
    }

    func finishBrushForRecognizedBarcodeNotInListCallback(brushJson: String?, result: FlutterResult) {
        guard let brushJson = brushJson, let brush = Brush(jsonString: brushJson) else {
            brushForRecognizedBarcodeNotInListLock.unlock(value: nil)
            result(nil)
            return
        }
        brushForRecognizedBarcodeNotInListLock.unlock(value: brush)
        result(nil)
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
