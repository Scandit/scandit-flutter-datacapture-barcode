/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

class BarcodeMethodHandler {
    private enum FunctionNames {
        static let getDefaults = "getDefaults"
    }

    private let barcodeModule: BarcodeModule

    init(barcodeModule: BarcodeModule) {
        self.barcodeModule = barcodeModule
    }

    func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getDefaults:
            do {
                let defaultsJSONString = String(
                    data: try JSONSerialization.data(
                        withJSONObject: self.barcodeModule.getDefaults(),
                        options: []
                    ),
                    encoding: .utf8
                )
                result(defaultsJSONString)
            } catch let error as NSError {
                result(
                    FlutterError(code: "-1", message: "Unable to load the defaults. \(error)", details: error.domain)
                )
            }
        case "executeBarcode":
            guard let args = methodCall.params(), let moduleName = methodCall.stringValue(for: "moduleName", from: args)
            else {
                result(FlutterError(code: "-1", message: "Missing moduleName parameter", details: nil))
                return
            }

            let coreModuleName = String(describing: CoreModule.self)
            guard let coreModule = DefaultServiceLocator.shared.resolve(clazzName: coreModuleName) as? CoreModule else {
                result(
                    FlutterError(
                        code: "-1",
                        message: "Unable to retrieve the CoreModule from the locator.",
                        details: nil
                    )
                )
                return
            }

            guard let targetModule = DefaultServiceLocator.shared.resolve(clazzName: moduleName) else {
                result(
                    FlutterError(
                        code: "-1",
                        message: "Unable to retrieve the \(moduleName) from the locator.",
                        details: nil
                    )
                )
                return
            }

            let flutterResult = FlutterFrameworkResult(reply: result)
            let handled = coreModule.execute(
                FlutterFrameworksMethodCall(methodCall),
                result: flutterResult,
                module: targetModule
            )

            if !handled {
                let methodName = methodCall.stringValue(for: "methodName", from: args) ?? "unknown"
                result(FlutterError(code: "-1", message: "Unknown Core method: \(methodName)", details: nil))
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
