/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

class BarcodeBatchMethodHandler {
    private let barcodeBatchModule: BarcodeBatchModule

    init(barcodeBatchModule: BarcodeBatchModule) {
        self.barcodeBatchModule = barcodeBatchModule
    }

    func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let executionResult = barcodeBatchModule.execute(
            method: FlutterFrameworksMethodCall(methodCall),
            result: FlutterFrameworkResult(reply: result)
        )

        if !executionResult {
            result(FlutterMethodNotImplemented)
        }
    }
}
