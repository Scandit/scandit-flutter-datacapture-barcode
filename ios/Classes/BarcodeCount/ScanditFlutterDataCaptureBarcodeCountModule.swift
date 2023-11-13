/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Foundation
import Flutter

@objc
public class ScanditFlutterDataCaptureBarcodeCountModule: NSObject {
   
    @objc
    public let barcodeCount: ScanditFlutterDataCaptureBarcodeCount

    @objc
    public init(with binaryMessenger: FlutterBinaryMessenger) {
        barcodeCount = ScanditFlutterDataCaptureBarcodeCount(with: binaryMessenger)
        super.init()
    }

    @objc
    public func dispose() {
        barcodeCount.dispose()
    }
}
