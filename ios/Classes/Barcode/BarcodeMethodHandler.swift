/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode

class BarcodeMethodHandler {
    private enum FunctionNames {
        static let getDefaults = "getDefaults"
    }

    private let barcodeModule: BarcodeModule

    init(barcodeModule: BarcodeModule) {
        self.barcodeModule = barcodeModule
    }

    func methodCallHandler(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getDefaults:
            do {
                let defaultsJSONString = String(data: try JSONSerialization.data(withJSONObject: barcodeModule.defaults.toEncodable(),
                                                                                 options: []),
                                                encoding: .utf8)
                result(defaultsJSONString)
            } catch let error as NSError {
                result(FlutterError(code: "-1", message: "Unable to load the defaults. \(error)", details: error.domain))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
