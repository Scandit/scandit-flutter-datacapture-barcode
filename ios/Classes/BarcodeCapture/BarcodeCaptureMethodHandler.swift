/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore

class BarcodeCaptureMethodHandler {
    private enum FunctionNames {
        static let finishDidScan = "finishDidScan"
        static let finishDidUpdateSession = "finishDidUpdateSession"
        static let addBarcodeCaptureListener = "addBarcodeCaptureListener"
        static let removeBarcodeCaptureListener = "removeBarcodeCaptureListener"
        static let resetBarcodeCaptureSession = "resetBarcodeCaptureSession"
        static let getLastFrameData = "getLastFrameData"
        static let getBarcodeCaptureDefaults = "getBarcodeCaptureDefaults"
        static let setModeEnabledState = "setModeEnabledState"
    }

    private let barcodeCaptureModule: BarcodeCaptureModule

    init(barcodeCaptureModule: BarcodeCaptureModule) {
        self.barcodeCaptureModule = barcodeCaptureModule
    }

    func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getBarcodeCaptureDefaults:
            let jsonString = barcodeCaptureModule.defaults.stringValue
            result(jsonString)
        case FunctionNames.finishDidScan:
            let enabled = methodCall.arguments as? Bool ?? false
            barcodeCaptureModule.finishDidScan(enabled: enabled)
            result(nil)
        case FunctionNames.finishDidUpdateSession:
            let enabled = methodCall.arguments as? Bool ?? false
            barcodeCaptureModule.finishDidUpdateSession(enabled: enabled)
            result(nil)
        case FunctionNames.addBarcodeCaptureListener:
            barcodeCaptureModule.addListener()
            result(nil)
        case FunctionNames.removeBarcodeCaptureListener:
            barcodeCaptureModule.removeListener()
            result(nil)
        case FunctionNames.resetBarcodeCaptureSession:
            barcodeCaptureModule.resetSession(frameSequenceId: methodCall.arguments as? Int)
            result(nil)
        case FunctionNames.getLastFrameData:
            LastFrameData.shared.getLastFrameDataJSON {
                result($0)
            }
        case FunctionNames.setModeEnabledState:
            barcodeCaptureModule.setModeEnabled(enabled: methodCall.arguments as! Bool)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
