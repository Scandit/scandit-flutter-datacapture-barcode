/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

extension ScanditFlutterDataCaptureBarcodeTracking: BarcodeTrackingListener, FlutterStreamHandler {
    public func barcodeTracking(_ barcodeTracking: BarcodeTracking,
                                didUpdate session: BarcodeTrackingSession,
                                frameData: FrameData) {
        ScanditFlutterDataCaptureCore.lastFrame = frameData
        DispatchQueue.main.async {
            let removedCodes = session.removedTrackedBarcodes
            for removed in removedCodes {
                guard let pair =
                    self.trackedBarcodeViewCache
                        .first(where: { $0.value.identifier == removed.intValue }) else { continue }
                self.trackedBarcodeViewCache.removeValue(forKey: pair.key)
            }
        }
        sessionHolder.latestSession = session
        guard let value = didUpdateSessionLock.wait(afterDoing: { () -> Bool in
            return sendEvent(event: .didUpdateSession, body: ["session": session.jsonString])
        }) else { return }
        barcodeTracking.isEnabled = value
        ScanditFlutterDataCaptureCore.lastFrame = nil
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        barcodeTrackingSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        barcodeTrackingSink = nil
        return nil
    }

    func finishDidUpdateSessionCallback(enabled: Bool, result: FlutterResult) {
        didUpdateSessionLock.unlock(value: enabled)
        result(nil)
    }
}
