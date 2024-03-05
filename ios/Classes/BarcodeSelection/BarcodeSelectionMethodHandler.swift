/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore

class BarcodeSelectionMethodHandler {
    private enum FunctionNames {
        static let resetMode = "resetMode"
        static let unfreezeCamera = "unfreezeCamera"
        static let addListener = "addBarcodeSelectionListener"
        static let removeListener = "removeBarcodeSelectionListener"
        static let finishDidUpdateSelection = "finishDidUpdateSelection"
        static let finishDidUpdateSession = "finishDidUpdateSession"
        static let getBarcodeSelectionSessionCount = "getBarcodeSelectionSessionCount"
        static let resetBarcodeSelectionSession = "resetBarcodeSelectionSession"
        static let getLastFrameData = "getLastFrameData"
        static let getDefaults = "getBarcodeSelectionDefaults"
        static let setModeEnabledState = "setModeEnabledState"
    }

    private let barcodeSelectionModule: BarcodeSelectionModule

    init(barcodeSelectionModule: BarcodeSelectionModule) {
        self.barcodeSelectionModule = barcodeSelectionModule
    }

    func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getDefaults:
            let jsonString = barcodeSelectionModule.defaults.stringValue
            result(jsonString)
        case FunctionNames.getBarcodeSelectionSessionCount:
            let count = barcodeSelectionModule.getBarcodeCount(selectionIdentifier: methodCall.arguments as! String)
            result(count)
        case FunctionNames.resetBarcodeSelectionSession:
            barcodeSelectionModule.resetLatestSession(frameSequenceId: methodCall.arguments as? Int)
            result(nil)
        case FunctionNames.addListener:
            barcodeSelectionModule.addListener()
            result(nil)
        case FunctionNames.removeListener:
            barcodeSelectionModule.removeListener()
            result(nil)
        case FunctionNames.resetMode:
            barcodeSelectionModule.resetSelection()
            result(nil)
        case FunctionNames.unfreezeCamera:
            barcodeSelectionModule.unfreezeCamera()
            result(nil)
        case FunctionNames.finishDidUpdateSelection:
            let enabled = methodCall.arguments as? Bool ?? false
            barcodeSelectionModule.finishDidSelect(enabled: enabled)
            result(nil)
        case FunctionNames.finishDidUpdateSession:
            let enabled = methodCall.arguments as? Bool ?? false
            barcodeSelectionModule.finishDidUpdate(enabled: enabled)
        case FunctionNames.getLastFrameData:
            LastFrameData.shared.getLastFrameDataJSON {
                result($0)
            }
        case FunctionNames.setModeEnabledState:
            barcodeSelectionModule.setModeEnabled(enabled: methodCall.arguments as! Bool)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
