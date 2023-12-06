package com.scandit.datacapture.flutter.barcode.count

import com.scandit.datacapture.barcode.count.capture.BarcodeCountSession
import java.util.concurrent.atomic.AtomicReference

class ScanditFlutterBarcodeCountSessionHolder {
    private val latestSession: AtomicReference<BarcodeCountSession?> = AtomicReference()

    fun setLatestSession(session: BarcodeCountSession) {
        latestSession.set(session)
    }

    fun reset(frameSequenceId: Long?) {
        val session = latestSession.get() ?: return
        if (frameSequenceId == null || session.frameSequenceId == frameSequenceId) {
            session.reset()
        }
    }
}
