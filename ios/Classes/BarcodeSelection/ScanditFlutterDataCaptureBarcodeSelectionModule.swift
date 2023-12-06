/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import Foundation

@objc
public class ScanditFlutterDataCaptureBarcodeSelectionModule: NSObject {
    private enum FunctionNames {
        static let getDefaults = "getBarcodeSelectionDefaults"
    }

    let methodChannel: FlutterMethodChannel
    let barcodeSelection: ScanditFlutterDataCaptureBarcodeSelectionProtocol

    @objc
    public init(messenger: FlutterBinaryMessenger,
                barcodeSelection: ScanditFlutterDataCaptureBarcodeSelectionProtocol) {
        let channelName = "com.scandit.datacapture.barcode.selection.method/barcode_selection_defaults"
        methodChannel = FlutterMethodChannel(name: channelName,
                                             binaryMessenger: messenger)
        self.barcodeSelection = barcodeSelection
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
        barcodeSelection.dispose()
    }
}
