/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import UIKit
import ScanditBarcodeCapture

final class TrackedBarcodeView: UIImageView {
    let trackedBarcode: TrackedBarcode
    let onTap: ((TrackedBarcode) -> Void)

    init(image: UIImage, trackedBarcode: TrackedBarcode, onTap: @escaping ((TrackedBarcode) -> Void)) {
        self.trackedBarcode = trackedBarcode
        self.onTap = onTap
        super.init(image: image)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didReceiveTap))
        addGestureRecognizer(gestureRecognizer)
        isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func didReceiveTap() {
        onTap(trackedBarcode)
    }
}
