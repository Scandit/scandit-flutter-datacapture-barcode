/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

class BarcodeGeneratorHandler {
    private let barcodeGeneratorModule: BarcodeGeneratorModule

    init(barcodeGeneratorModule: BarcodeGeneratorModule) {
        self.barcodeGeneratorModule = barcodeGeneratorModule
    }

    func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let executionResult = barcodeGeneratorModule.execute(
            method: FlutterFrameworksMethodCall(methodCall),
            result: FlutterFrameworkResult(reply: result)
        )

        if !executionResult {
            result(FlutterMethodNotImplemented)
        }
    }
}
