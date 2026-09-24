/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import scandit_flutter_datacapture_core

class FlutterBarcodePickView: UIView, FlutterPlatformView {
    weak var barcodePickModule: BarcodePickModule?

    func view() -> UIView {
        self
    }

    override func removeFromSuperview() {
        barcodePickModule?.removeView(viewId: self.tag, result: FlutterLogInsteadOfResult())
        super.removeFromSuperview()
    }

    override func didAddSubview(_ subview: UIView) {
        if let subview = subview as? BarcodePickView {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addConstraints([
                subview.leadingAnchor.constraint(equalTo: leadingAnchor),
                subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor),
                subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        }
        super.didAddSubview(subview)
    }
}
