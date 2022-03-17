/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture

extension ScanditFlutterDataCaptureBarcodeTracking: BarcodeTrackingListener, FlutterStreamHandler {
    public func barcodeTracking(_ barcodeTracking: BarcodeTracking,
                                didUpdate session: BarcodeTrackingSession,
                                frameData: FrameData) {
       
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
