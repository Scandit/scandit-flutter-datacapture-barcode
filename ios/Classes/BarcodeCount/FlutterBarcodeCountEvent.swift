/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

enum FlutterBarcodeCountEvent: String {
    case didScan = "barcodeCountListener-onScan"

    case didUpdateCaptureList = "barcodeCountCaptureListListener-didUpdateSession"

    case brushForRecognizedBarcode = "barcodeCountViewListener-brushForRecognizedBarcode"
    case brushForUnrecognizedBarcode = "barcodeCountViewListener-brushForUnrecognizedBarcode"
    case brushForRecgonizedBarcodeNotInList = "barcodeCountViewListener-brushForRecognizedBarcodeNotInList"
    case didTapRecognizedBarcode = "barcodeCountViewListener-didTapRecognizedBarcode"
    case didTapUnrecognizedBarcode = "barcodeCountViewListener-didTapUnrecognizedBarcode"
    case didTapFilteredBarcode = "barcodeCountViewListener-didTapFilteredBarcode"
    case didTapRecognizedBarcodeNotInList = "barcodeCountViewListener-didTapRecognizedBarcodeNotInList"

    case onExitButtonTapped = "barcodeCountViewUiListener-onExitButtonTapped"
    case onListButtonTapped = "barcodeCountViewUiListener-onListButtonTapped"
    case onSingleScanButtonTapped = "barcodeCountViewUiListener-onSingleScanButtonTapped"
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
