/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

class FlutterBarcodeCountView: UIView, FlutterPlatformView {
    func view() -> UIView {
        self
    }

    var barcodeCountView: BarcodeCountView? {
        subviews.first { $0 is BarcodeCountView } as? BarcodeCountView
    }

    override var frame: CGRect {
        didSet {
            barcodeCountView?.frame = frame
        }
    }
}
