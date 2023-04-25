/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture

// swiftlint:disable:next type_name
class ScanditFlutterDataCaptureBarcodeSelectionSessionHolder {
    private var lock = os_unfair_lock_s()

    private var holdedSession: BarcodeSelectionSession?

    var latestSession: BarcodeSelectionSession? {
        get {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            return holdedSession
        }
        set {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            holdedSession = newValue
        }
    }

    func barcodeCountOfFrame(with frameSequenceId: Int?,
                             and symbology: Symbology?,
                             and barcodeData: String?) -> Int {
        guard let session = latestSession,
              let sequenceId = frameSequenceId,
              sequenceId == session.frameSequenceId else { return 0 }
        let barcodePredicate: (Barcode) -> Bool = {
            $0.data == barcodeData && $0.symbology == symbology
        }
        if let firstMatchingBarcode = session.selectedBarcodes.first(where: barcodePredicate) {
            return session.count(for: firstMatchingBarcode)
        } else {
            return 0
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
