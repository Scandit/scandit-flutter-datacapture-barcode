/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

extension ScanditFlutterDataCaptureBarcodeSelection: BarcodeSelectionListener {
    public func barcodeSelection(_ barcodeSelection: BarcodeSelection,
                                 didUpdateSelection session: BarcodeSelectionSession,
                                 frameData: FrameData?) {
        ScanditFlutterDataCaptureCore.lastFrame = frameData
        sessionHolder.latestSession = session
        guard let value = didUpdateSelectionLock.wait(afterDoing: {
            return sendEvent(event: .selectionDidUpdate, body: ["session": session.jsonString])
        }) else { return }
        barcodeSelection.isEnabled = value
        ScanditFlutterDataCaptureCore.lastFrame = nil
    }

    public func barcodeSelection(_ barcodeSelection: BarcodeSelection,
                                 didUpdate session: BarcodeSelectionSession,
                                 frameData: FrameData?) {
        ScanditFlutterDataCaptureCore.lastFrame = frameData
        guard let value = didUpdateSessionLock.wait(afterDoing: {
            return sendEvent(event: .sessionDidUpate, body: ["session": session.jsonString])
        }) else { return }
        barcodeSelection.isEnabled = value
        ScanditFlutterDataCaptureCore.lastFrame = nil
    }
}

extension ScanditFlutterDataCaptureBarcodeSelection: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?,
                         eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
