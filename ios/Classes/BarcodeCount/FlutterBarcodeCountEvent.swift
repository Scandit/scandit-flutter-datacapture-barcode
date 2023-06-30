/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

enum FlutterBarcodeCountEvent: String {
    case didScan = "BarcodeCountListener.onScan"

    case didUpdateCaptureList = "BarcodeCountCaptureListListener.didUpdateSession"

    case brushForRecognizedBarcode = "BarcodeCountViewListener.brushForRecognizedBarcode"
    case brushForUnrecognizedBarcode = "BarcodeCountViewListener.brushForUnrecognizedBarcode"
    case brushForRecgonizedBarcodeNotInList = "BarcodeCountViewListener.brushForRecognizedBarcodeNotInList"
    case didTapRecognizedBarcode = "BarcodeCountViewListener.didTapRecognizedBarcode"
    case didTapUnrecognizedBarcode = "BarcodeCountViewListener.didTapUnrecognizedBarcode"
    case didTapFilteredBarcode = "BarcodeCountViewListener.didTapFilteredBarcode"
    case didTapRecognizedBarcodeNotInList = "BarcodeCountViewListener.didTapRecognizedBarcodeNotInList"

    case onExitButtonTapped = "BarcodeCountViewUiListener.onExitButtonTapped"
    case onListButtonTapped = "BarcodeCountViewUiListener.onListButtonTapped"
    case onSingleScanButtonTapped = "BarcodeCountViewUiListener.onSingleScanButtonTapped"
}

extension ScanditFlutterDataCaptureBarcodeCount {
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
