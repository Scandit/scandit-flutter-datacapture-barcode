/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture

extension ScanditFlutterDataCaptureBarcodeCapture: BarcodeCaptureListener, FlutterStreamHandler {
    func barcodeCapture(_ barcodeCapture: BarcodeCapture,
                        didScanIn session: BarcodeCaptureSession,
                        frameData: FrameData) {
        sessionHolder.latestSession = session
        guard let value = didScanLock.wait(afterDoing: { () -> Bool in
            return sendEvent(event: .didScan, body: ["session": session.jsonString])
        }) else { return }
        barcodeCapture.isEnabled = value
    }

    func barcodeCapture(_ barcodeCapture: BarcodeCapture,
                        didUpdate session: BarcodeCaptureSession,
                        frameData: FrameData) {
        guard let value = didUpdateSessionLock.wait(afterDoing: { () -> Bool in
            return sendEvent(event: .didUpdateSession, body: ["session": session.jsonString])
        }) else { return }
        barcodeCapture.isEnabled = value
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }

    func finishDidScanCallback(enabled: Bool) {
        didScanLock.unlock(value: enabled)
    }

    func finishDidUpdateSessionCallback(enabled: Bool) {
        didUpdateSessionLock.unlock(value: enabled)
    }
}
