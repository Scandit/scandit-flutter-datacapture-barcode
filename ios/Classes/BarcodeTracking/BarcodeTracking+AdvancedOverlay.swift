/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

extension ScanditFlutterDataCaptureBarcodeTracking {
    func setWidgetForTrackedBarcode(arguments: String, result: FlutterResult) {
        guard let jsonData = arguments.data(using: .utf8),
              let untypedArgs = try? JSONSerialization.jsonObject(with: jsonData, options: []),
              let parsedArgs = untypedArgs as? [String: Any] else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        if let frameSequenceId = parsedArgs["sessionFrameSequenceID"] as? Int,
           let sequenceId = lastFrameSequenceId {
            if sequenceId != frameSequenceId {
                result(ScanditDataCaptureBarcodeErrorWrapper(error: .invalidSequenceId))
                return
            }
        }
        guard let lastTrackedBarcodes = lastTrackedBarcodes,
              let trackedBarcodeId = parsedArgs["identifier"] as? Int,
              let trackedCode = lastTrackedBarcodes[NSNumber(value: trackedBarcodeId)] else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .trackedBarcodeNotFound))
            return
        }
        guard let overlay = barcodeTrackingAdvancedOverlay else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .nilOverlay))
            return
        }
        guard let base64EncodedWidget = parsedArgs["widget"] as? String else {
            overlay.setView(nil, for: trackedCode)
            result(nil)
            return
        }
        guard let data = Data(base64Encoded: base64EncodedWidget),
              let image = UIImage(data: data) else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .viewInvalid))
            return
        }
        let view = TrackedBarcodeView(image: image, trackedBarcode: trackedCode) { [weak self] (barcode) in
            self?.advancedOverlayStreamHandler.didTapViewForTrackedBarcode(barcode)
        }
        let scale = UIScreen.main.scale
        view.frame.size = CGSize(width: view.frame.size.width / scale, height: view.frame.size.height / scale)
        trackedBarcodeViewCache[view] = trackedCode
        overlay.setView(view, for: trackedCode)
        result(nil)
    }

    func setAnchorForTrackedBarcode(arguments: String, result: FlutterResult) {
        var anchor = Anchor.center
        guard let jsonData = arguments.data(using: .utf8),
              let untypedArgs = try? JSONSerialization.jsonObject(with: jsonData, options: []),
              let parsedArgs = untypedArgs as? [String: Any],
              let anchorJSON = parsedArgs["anchor"] as? String,
              SDCAnchorFromJSONString(anchorJSON, &anchor) else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        if let frameSequenceId = parsedArgs["sessionFrameSequenceID"] as? Int,
           let sequenceId = lastFrameSequenceId {
            if sequenceId != frameSequenceId {
                result(ScanditDataCaptureBarcodeErrorWrapper(error: .invalidSequenceId))
                return
            }
        }
        guard let lastTrackedBarcodes = lastTrackedBarcodes,
              let trackedBarcodeId = parsedArgs["identifier"] as? Int,
              let trackedCode = lastTrackedBarcodes[NSNumber(value: trackedBarcodeId)] else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .trackedBarcodeNotFound))
            return
        }
        guard let overlay = barcodeTrackingAdvancedOverlay else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .nilOverlay))
            return
        }
        overlay.setAnchor(anchor, for: trackedCode)
        result(nil)
    }

    func setOffsetForTrackedBarcode(arguments: String, result: FlutterResult) {
        var offset = PointWithUnit.zero
        guard let jsonData = arguments.data(using: .utf8),
              let untypedArgs = try? JSONSerialization.jsonObject(with: jsonData, options: []),
              let parsedArgs = untypedArgs as? [String: Any],
              let offsetDict = parsedArgs["offset"] as? [String: Any],
              let offsetJSON = String(data: try! JSONSerialization.data(withJSONObject: offsetDict,
                                                                   options: []),
                                      encoding: .utf8),
              SDCPointWithUnitFromJSONString(offsetJSON, &offset) else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        if let frameSequenceId = parsedArgs["sessionFrameSequenceID"] as? Int,
           let sequenceId = lastFrameSequenceId {
            if sequenceId != frameSequenceId {
                result(ScanditDataCaptureBarcodeErrorWrapper(error: .invalidSequenceId))
                return
            }
        }
        guard let lastTrackedBarcodes = lastTrackedBarcodes,
              let trackedBarcodeId = parsedArgs["identifier"] as? Int,
              let trackedCode = lastTrackedBarcodes[NSNumber(value: trackedBarcodeId)] else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .trackedBarcodeNotFound))
            return
        }
        guard let overlay = barcodeTrackingAdvancedOverlay else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .nilOverlay))
            return
        }
        overlay.setOffset(offset, for: trackedCode)
        result(nil)
    }

    func clearTrackedBarcodeWidgets(result: FlutterResult) {
        guard let overlay = barcodeTrackingAdvancedOverlay else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .nilOverlay))
            return
        }
        overlay.clearTrackedBarcodeViews()
        result(nil)
    }
}
