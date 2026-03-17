/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode

class FlutterBarcodeCountView: UIView, FlutterPlatformView {
    weak var barcodeCountModule: BarcodeCountModule?

    func view() -> UIView {
        self
    }

    override func removeFromSuperview() {
        barcodeCountModule?.disposeBarcodeCountView(viewId: self.tag)
        super.removeFromSuperview()
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        if view is BarcodeCountView {
            view.translatesAutoresizingMaskIntoConstraints = false
            addConstraints([
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
                view.topAnchor.constraint(equalTo: topAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}
