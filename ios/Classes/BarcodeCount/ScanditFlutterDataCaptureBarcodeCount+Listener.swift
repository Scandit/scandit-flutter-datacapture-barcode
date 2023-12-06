/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import scandit_flutter_datacapture_core

extension ScanditFlutterDataCaptureBarcodeCount: BarcodeCountListener {
    public func barcodeCount(_ barcodeCount: BarcodeCount,
                      didScanIn session: BarcodeCountSession,
                      frameData: FrameData) {
        defer { ScanditFlutterDataCaptureCore.lastFrame = nil }
        ScanditFlutterDataCaptureCore.lastFrame = frameData
        barcodeCountSessionHolder.latestSession = session
        let enabled = didScanLock.wait {
            sendEvent(event: .didScan, body: ["session": session.jsonString])
        } ?? false
        barcodeCount.isEnabled = enabled
    }

    func finishDidScanCallback(enabled: Bool, result: FlutterResult) {
        didScanLock.unlock(value: enabled)
        result(nil)
    }
}

extension ScanditFlutterDataCaptureBarcodeCount: BarcodeCountCaptureListListener {
    public func captureList(_ captureList: BarcodeCountCaptureList,
                     didUpdate session: BarcodeCountCaptureListSession) {
        sendEvent(event: .didUpdateCaptureList, body: ["session": session.jsonString])
    }
}

extension ScanditFlutterDataCaptureBarcodeCount: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}
