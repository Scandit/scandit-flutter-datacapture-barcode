package com.scandit.datacapture.flutter.barcode.capture

import com.scandit.datacapture.barcode.capture.BarcodeCaptureSession
import java.util.concurrent.atomic.AtomicReference

class ScanditFlutterBarcodeCaptureSessionHolder {
    private val latestSession: AtomicReference<BarcodeCaptureSession?> = AtomicReference()

    fun setLatestSession(session: BarcodeCaptureSession) {
        latestSession.set(session)
    }

    fun reset(frameSequenceId: Long?) {
        val session = latestSession.get() ?: return
        if (frameSequenceId == null || session.frameSequenceId == frameSequenceId) {
            session.reset()
        }
    }
}
