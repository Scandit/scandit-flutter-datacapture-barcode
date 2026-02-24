/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode

class FlutterBarcodeCountView: UIView, FlutterPlatformView {
    weak var factory: FlutterBarcodeCountViewFactory?

    func view() -> UIView {
        self
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        guard let index = factory?.views.firstIndex(of: self) else { return }
        factory?.views.remove(at: index)
        factory?.addBarcodeCountViewToLastContainer()
    }
}
