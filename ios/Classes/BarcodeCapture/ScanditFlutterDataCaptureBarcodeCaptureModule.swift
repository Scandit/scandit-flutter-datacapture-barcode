/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import Flutter

@objc
public class ScanditFlutterDataCaptureBarcodeCaptureModule: NSObject {
    let barcodeCapture: ScanditFlutterDataCaptureBarcodeCapture

    @objc
    public init(with binaryMessenger: FlutterBinaryMessenger) {
        barcodeCapture = ScanditFlutterDataCaptureBarcodeCapture(with: binaryMessenger)
        super.init()
    }

    @objc
    public func dispose() {
        barcodeCapture.dispose()
    }
}
