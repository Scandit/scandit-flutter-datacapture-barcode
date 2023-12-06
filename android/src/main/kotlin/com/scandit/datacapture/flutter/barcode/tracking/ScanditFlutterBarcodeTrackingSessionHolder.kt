/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.tracking

import com.scandit.datacapture.barcode.tracking.capture.BarcodeTrackingSession
import com.scandit.datacapture.barcode.tracking.data.TrackedBarcode
import java.util.concurrent.atomic.AtomicReference

class ScanditFlutterBarcodeTrackingSessionHolder {
    private val latestSession: AtomicReference<BarcodeTrackingSession?> = AtomicReference()

    fun setLatestTrackedSession(session: BarcodeTrackingSession) {
        latestSession.set(session)
    }

    fun getTrackedBarcodeFromLatestSession(
        barcodeId: Int,
        frameSequenceId: Long?
    ): TrackedBarcode? {
        val session = latestSession.get() ?: return null
        return if (frameSequenceId == null || session.frameSequenceId == frameSequenceId) {
            session.trackedBarcodes[barcodeId]
        } else null
    }

    fun reset(frameSequenceId: Long?) {
        val session = latestSession.get() ?: return
        if (frameSequenceId == null || session.frameSequenceId == frameSequenceId) {
            session.reset()
        }
    }
}
