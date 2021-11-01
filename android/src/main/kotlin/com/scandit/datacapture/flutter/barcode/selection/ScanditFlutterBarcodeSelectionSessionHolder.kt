package com.scandit.datacapture.flutter.barcode.selection

import com.scandit.datacapture.barcode.data.Symbology
import com.scandit.datacapture.barcode.selection.capture.BarcodeSelectionSession
import java.util.concurrent.atomic.AtomicReference

class ScanditFlutterBarcodeSelectionSessionHolder {
    private val latestSession: AtomicReference<BarcodeSelectionSession?> = AtomicReference()

    fun setLatestSession(session: BarcodeSelectionSession) {
        latestSession.set(session)
    }

    fun getBarcodeCount(
        frameSequenceId: Long?,
        barcodeSymbology: Symbology?,
        barcodeData: String?
    ): Int {
        val session = latestSession.get() ?: return 0
        return if (frameSequenceId == null || session.frameSequenceId == frameSequenceId) {
            session.selectedBarcodes.find {
                it.data == barcodeData && it.symbology == barcodeSymbology
            }?.let {
                session.getCount(it)
            } ?: 0
        } else 0
    }

    fun reset(frameSequenceId: Long?) {
        val session = latestSession.get() ?: return
        if (frameSequenceId == null || session.frameSequenceId == frameSequenceId) {
            session.reset()
        }
    }
}
