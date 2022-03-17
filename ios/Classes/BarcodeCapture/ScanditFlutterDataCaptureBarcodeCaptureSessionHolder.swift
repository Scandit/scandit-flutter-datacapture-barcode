/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture

// swiftlint:disable:next type_name
class ScanditFlutterDataCaptureBarcodeCaptureSessionHolder {
    private var lock = os_unfair_lock_s()

    private var _latestSession: BarcodeCaptureSession?

    var latestSession: BarcodeCaptureSession? {
        get {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            return _latestSession
        }
        set {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            _latestSession = newValue
        }
    }

    func reset(frameSequenceId: Int?) {
        if let session = latestSession,
           let sequenceId = frameSequenceId,
           session.frameSequenceId == sequenceId {
            session.reset()
        }
    }
}
