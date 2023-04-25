/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

extension ScanditFlutterDataCaptureBarcodeTracking {
    func setWidgetForTrackedBarcode(arguments: Any?, result: FlutterResult) {
        guard let parsedArgs = arguments as? [String: Any?] else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        if let frameSequenceId = parsedArgs["sessionFrameSequenceID"] as? Int,
           let sequenceId = sessionHolder.latestSession?.frameSequenceId,
           sequenceId != frameSequenceId {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .invalidSequenceId))
            return
        }

        guard let lastTrackedBarcodes = sessionHolder.latestSession?.trackedBarcodes,
              let trackedBarcodeId = parsedArgs["identifier"] as? Int,
              let trackedCode = lastTrackedBarcodes[NSNumber(value: trackedBarcodeId)] else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .trackedBarcodeNotFound))
            return
        }
        guard let overlay = barcodeTrackingAdvancedOverlay else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .nilOverlay))
            return
        }
        guard let widgetData = parsedArgs["widget"] as? FlutterStandardTypedData else {
            overlay.setView(nil, for: trackedCode)
            result(nil)
            return
        }
        guard let image = UIImage(data: widgetData.data) else {
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

    func setAnchorForTrackedBarcode(arguments: Any?, result: FlutterResult) {
        var anchor = Anchor.center
        guard let parsedArgs = arguments as? [String: Any?] else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }

        guard let anchorJSON = parsedArgs["anchor"] as? String else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        SDCAnchorFromJSONString(anchorJSON, &anchor)

        if let frameSequenceId = parsedArgs["sessionFrameSequenceID"] as? Int,
           let sequenceId = sessionHolder.latestSession?.frameSequenceId,
           sequenceId != frameSequenceId {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .invalidSequenceId))
            return
        }
        guard let lastTrackedBarcodes = sessionHolder.latestSession?.trackedBarcodes,
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

    func setOffsetForTrackedBarcode(arguments: Any?, result: FlutterResult) {
        var offset = PointWithUnit.zero
        guard let parsedArgs = arguments as? [String: Any?] else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        
        guard let offsetJSON = parsedArgs["offset"] as? String else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        
        SDCPointWithUnitFromJSONString(offsetJSON, &offset)
        
        if let frameSequenceId = parsedArgs["sessionFrameSequenceID"] as? Int,
           let sequenceId = sessionHolder.latestSession?.frameSequenceId,
           sequenceId != frameSequenceId {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .invalidSequenceId))
            return
        }
        guard let lastTrackedBarcodes = sessionHolder.latestSession?.trackedBarcodes,
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
