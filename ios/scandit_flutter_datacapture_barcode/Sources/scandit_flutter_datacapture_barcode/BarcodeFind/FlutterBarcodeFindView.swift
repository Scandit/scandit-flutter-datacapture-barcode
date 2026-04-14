/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import scandit_flutter_datacapture_core

class FlutterBarcodeFindView: UIView, FlutterPlatformView {
    weak var findModule: BarcodeFindModule?

    func view() -> UIView {
        self
    }

    override func removeFromSuperview() {
        findModule?.onViewRemovedFromSuperview(viewId: self.tag)
        super.removeFromSuperview()
    }
}
