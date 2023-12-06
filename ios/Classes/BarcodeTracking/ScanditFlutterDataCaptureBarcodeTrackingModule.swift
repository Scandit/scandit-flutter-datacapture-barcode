/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation

@objc
public class ScanditFlutterDataCaptureBarcodeTrackingModule: NSObject {
    private enum FunctionNames {
        static let getBarcodeTrackingDefaults = "getBarcodeTrackingDefaults"
    }

    private let methodChannel: FlutterMethodChannel
    private let barcodeTracking: ScanditFlutterDataCaptureBarcodeTrackingProtocol

    @objc
    public init(with messenger: FlutterBinaryMessenger,
                barcodeTracking: ScanditFlutterDataCaptureBarcodeTracking) {
        let channelName = "com.scandit.datacapture.barcode.tracking.method/barcode_tracking_defaults"
        methodChannel = FlutterMethodChannel(name: channelName,
                                             binaryMessenger: messenger)
        self.barcodeTracking = barcodeTracking
        super.init()
        methodChannel.setMethodCallHandler(self.methodCallHandler)
    }

    func methodCallHandler(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getBarcodeTrackingDefaults:
            defaults(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func defaults(result: FlutterResult) {
        do {
            let defaultsJSON = String(data: try JSONSerialization.data(withJSONObject: defaults, options: []),
                                      encoding: .utf8)
            result(defaultsJSON)
        } catch {
            result(FlutterError(code: "-1", message: "Unable to load the defaults. \(error)", details: nil))
        }
    }

    @objc
    public func dispose() {
        methodChannel.setMethodCallHandler(nil)
        barcodeTracking.dispose()
    }
}
