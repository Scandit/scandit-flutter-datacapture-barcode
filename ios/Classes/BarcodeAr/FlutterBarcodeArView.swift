/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import scandit_flutter_datacapture_core

class FlutterBarcodeArView: UIView, FlutterPlatformView {
    weak var barcodeArModule: BarcodeArModule?

    func view() -> UIView {
        self
    }

    override func removeFromSuperview() {
        barcodeArModule?.removeView(viewId: self.tag, result: FlutterLogInsteadOfResult())
        super.removeFromSuperview()
    }

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        if let subview = subview as? BarcodeArView {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addConstraints([
                subview.leadingAnchor.constraint(equalTo: leadingAnchor),
                subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor),
                subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        }
    }
}
