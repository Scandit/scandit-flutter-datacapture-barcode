/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import Foundation

@objc
public class ScanditFlutterDataCaptureBarcodeSelectionModule: NSObject {

    let barcodeSelection: ScanditFlutterDataCaptureBarcodeSelectionProtocol

    @objc
    public init(messenger: FlutterBinaryMessenger,
                barcodeSelection: ScanditFlutterDataCaptureBarcodeSelectionProtocol) {
        self.barcodeSelection = barcodeSelection
        super.init()
    }


    @objc
    public func dispose() {
        barcodeSelection.dispose()
    }
}
