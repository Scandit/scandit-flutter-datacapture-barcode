/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation

@objc
public class ScanditFlutterDataCaptureBarcodeTrackingModule: NSObject {

    private let barcodeTracking: ScanditFlutterDataCaptureBarcodeTrackingProtocol

    @objc
    public init(with messenger: FlutterBinaryMessenger,
                barcodeTracking: ScanditFlutterDataCaptureBarcodeTracking) {
        self.barcodeTracking = barcodeTracking
        super.init()
    }

    @objc
    public func dispose() {
        barcodeTracking.dispose()
    }
}
