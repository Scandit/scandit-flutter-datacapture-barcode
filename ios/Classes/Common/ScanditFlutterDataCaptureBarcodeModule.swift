/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation

@objc
public class ScanditFlutterDataCaptureBarcodeModule: NSObject {
    private enum FunctionNames {
        static let getDefaults = "getDefaults"
    }

    let methodChannel: FlutterMethodChannel

    @objc
    public init(with messenger: FlutterBinaryMessenger) {
        methodChannel = FlutterMethodChannel(name: "com.scandit.datacapture.barcode.method/barcode_defaults",
                                             binaryMessenger: messenger)
        super.init()
        methodChannel.setMethodCallHandler(self.methodCallHandler)
    }

    public func methodCallHandler(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getDefaults:
            do {
                let defaultsJSONString = String(data: try JSONSerialization.data(withJSONObject: defaults, options: []),
                                                encoding: .utf8)
                result(defaultsJSONString)
            } catch {
                result(FlutterError(code: "-1", message: "Unable to load the defaults. \(error)", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @objc
    public func dispose() {
        methodChannel.setMethodCallHandler(nil)
    }
}
