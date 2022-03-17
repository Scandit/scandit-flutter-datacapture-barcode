/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

extension ScanditFlutterDataCaptureBarcodeTracking {
    func setBrushForTrackedBarcode(arguments: String, result: FlutterReply) {
        guard let jsonData = arguments.data(using: .utf8),
              let untypedArgs = try? JSONSerialization.jsonObject(with: jsonData, options: []),
              let parsedArgs = untypedArgs as? [String: Any] else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        guard let sequenceId = sessionHolder.latestSession?.frameSequenceId,
              let frameSequenceId = parsedArgs["sessionFrameSequenceID"] as? Int,
              sequenceId == frameSequenceId else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .invalidSequenceId))
            return
        }
        guard let lastTrackedBarcodes = sessionHolder.latestSession?.trackedBarcodes,
              let trackedBarcodeId = parsedArgs["identifier"] as? Int,
              let trackedCode = lastTrackedBarcodes[NSNumber(value: trackedBarcodeId)] else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .trackedBarcodeNotFound))
            return
        }
        guard let overlay = barcodeTrackingBasicOverlay else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .nilOverlay))
            return
        }
        guard let brush = Brush(jsonString: parsedArgs["brush"] as! String) else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        overlay.setBrush(brush, for: trackedCode)
        result(nil)
    }

    func clearTrackedBarcodeBrushes(result: FlutterReply) {
        barcodeTrackingBasicOverlay?.clearTrackedBarcodeBrushes()
        result(nil)
    }
}
