/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import scandit_flutter_datacapture_core

class FlutterBarcodeFindView: UIView, FlutterPlatformView {
    weak var factory: FlutterBarcodeFindViewFactory?

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
