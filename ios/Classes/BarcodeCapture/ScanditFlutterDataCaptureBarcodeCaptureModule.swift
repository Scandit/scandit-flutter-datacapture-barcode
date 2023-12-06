/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import Flutter

@objc
public class ScanditFlutterDataCaptureBarcodeCaptureModule: NSObject {
    private enum FunctionNames {
        static let getBarcodeCaptureDefaults = "getBarcodeCaptureDefaults"
    }

    let methodChannel: FlutterMethodChannel
    let barcodeCapture: ScanditFlutterDataCaptureBarcodeCapture

    @objc
    public init(with binaryMessenger: FlutterBinaryMessenger) {
        let channelName = "com.scandit.datacapture.barcode.capture.method/barcode_capture_defaults"
        methodChannel = FlutterMethodChannel(name: channelName,
                                             binaryMessenger: binaryMessenger)
        barcodeCapture = ScanditFlutterDataCaptureBarcodeCapture(with: binaryMessenger)
        super.init()
        methodChannel.setMethodCallHandler(self.methodCallHandler)
    }

    public func methodCallHandler(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getBarcodeCaptureDefaults:
            defaults(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func defaults(result: FlutterResult) {
        do {
            let jsonString = String(data: try JSONSerialization.data(withJSONObject: defaults, options: []),
                                    encoding: .utf8)
            result(jsonString)
        } catch {
            result(FlutterError(code: "-1", message: "Unable to load the defaults. \(error)", details: nil))
        }
    }

    @objc
    public func dispose() {
        methodChannel.setMethodCallHandler(nil)
        barcodeCapture.dispose()
    }
}
