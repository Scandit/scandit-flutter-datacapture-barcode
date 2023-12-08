/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import scandit_flutter_datacapture_core
import ScanditFrameworksBarcode
import ScanditFrameworksCore

class BarcodeCountMethodHandler {
    private enum FunctionNames {
        static let addBarcodeCountListener = "addBarcodeCountListener"
        static let removeBarcodeCountListener = "removeBarcodeCountListener"
        static let addBarcodeCountViewListener = "addBarcodeCountViewListener"
        static let removeBarcodeCountViewListener = "removeBarcodeCountViewListener"
        static let addBarcodeCountViewUiListener = "addBarcodeCountViewUiListener"
        static let removeBarcodeCountViewUiListener = "removeBarcodeCountViewUiListener"

        static let updateBarcodeCount = "updateBarcodeCountMode"
        static let updateBarcodeCountView = "updateBarcodeCountView"

        static let resetBarcodeCountSession = "resetBarcodeCountSession"
        static let getBarcodeCountLastFrameData = "getBarcodeCountLastFrameData"
        static let resetBarcodeCount = "resetBarcodeCount"
        static let startScanningPhase = "startScanningPhase"
        static let endScanningPhase = "endScanningPhase"
        static let setBarcodeCountCaptureList = "setBarcodeCountCaptureList"

        static let clearHighlights = "clearHighlights"

        static let finishDidScan = "barcodeCountFinishOnScan"

        static let finishBrushForRecognizedBarcode = "finishBrushForRecognizedBarcodeEvent"
        static let finishBrushForUnrecognizedBarcode = "finishBrushForUnrecognizedBarcodeEvent"
        static let finishBrushForRecognizedBarcodeNotInListEvent = "finishBrushForRecognizedBarcodeNotInListEvent"

        static let getBarcodeCountDefaults = "getBarcodeCountDefaults"
        static let setModeEnabledState = "setModeEnabledState"
    }

    private let barcodeCountModule: BarcodeCountModule

    init(barcodeCountModule: BarcodeCountModule) {
        self.barcodeCountModule = barcodeCountModule
    }

    public func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionNames.addBarcodeCountViewListener:
            barcodeCountModule.addBarcodeCountViewListener()
            result(nil)
        case FunctionNames.removeBarcodeCountViewListener:
            barcodeCountModule.removeBarcodeCountViewListener()
            result(nil)
        case FunctionNames.addBarcodeCountViewUiListener:
            barcodeCountModule.addBarcodeCountViewUiListener()
            result(nil)
        case FunctionNames.removeBarcodeCountViewUiListener:
            barcodeCountModule.removeBarcodeCountViewUiListener()
            result(nil)
        case FunctionNames.clearHighlights:
            barcodeCountModule.clearHighlights()
            result(nil)
        case FunctionNames.finishBrushForRecognizedBarcode:
            guard let args = methodCall.arguments as? [String: Any],
                  let brushJson = args["brush"] as? String,
                  let trackedBarcodeId = args["trackedBarcodeId"] as? Int else {
                result(FlutterError(code: "-1",
                                    message: "Invalid argument for \(FunctionNames.finishBrushForRecognizedBarcode)",
                                    details: methodCall.arguments))
                return
            }
            barcodeCountModule.finishBrushForRecognizedBarcodeEvent(brush: Brush(jsonString: brushJson),
                                                                    trackedBarcodeId: trackedBarcodeId)
            result(nil)
        case FunctionNames.finishBrushForRecognizedBarcodeNotInListEvent:
            guard let args = methodCall.arguments as? [String: Any],
                  let brushJson = args["brush"] as? String,
                  let trackedBarcodeId = args["trackedBarcodeId"] as? Int else {
                result(FlutterError(code: "-1",
                                    message: "Invalid argument for \(FunctionNames.finishBrushForRecognizedBarcodeNotInListEvent)",
                                    details: methodCall.arguments))
                return
            }
            barcodeCountModule.finishBrushForRecognizedBarcodeNotInListEvent(brush: Brush(jsonString: brushJson),
                                                                             trackedBarcodeId: trackedBarcodeId)
            result(nil)
        case FunctionNames.finishBrushForUnrecognizedBarcode:
            guard let args = methodCall.arguments as? [String: Any],
                  let brushJson = args["brush"] as? String,
                  let trackedBarcodeId = args["trackedBarcodeId"] as? Int else {
                result(FlutterError(code: "-1",
                                    message: "Invalid argument for \(FunctionNames.finishBrushForRecognizedBarcodeNotInListEvent)",
                                    details: methodCall.arguments))
                return
            }
            barcodeCountModule.finishBrushForUnrecognizedBarcodeEvent(brush: Brush(jsonString: brushJson),
                                                                      trackedBarcodeId: trackedBarcodeId)
            result(nil)
        case FunctionNames.getBarcodeCountDefaults:
            let jsonString = barcodeCountModule.defaults.stringValue
            result(jsonString)
        case FunctionNames.setBarcodeCountCaptureList:
            barcodeCountModule.setBarcodeCountCaptureList(barcodesJson: methodCall.arguments as! String)
            result(nil)
        case FunctionNames.resetBarcodeCountSession:
            barcodeCountModule.resetBarcodeCountSession(frameSequenceId: methodCall.arguments as? Int)
            result(nil)
        case FunctionNames.finishDidScan:
            let enabled = methodCall.arguments as? Bool ?? false
            barcodeCountModule.finishOnScan(enabled: enabled)
            result(nil)
        case FunctionNames.addBarcodeCountListener:
            barcodeCountModule.addBarcodeCountListener()
            result(nil)
        case FunctionNames.removeBarcodeCountListener:
            barcodeCountModule.removeBarcodeCountListener()
            result(nil)
        case FunctionNames.getBarcodeCountLastFrameData:
            LastFrameData.shared.getLastFrameDataJSON {
                result($0)
            }
        case FunctionNames.resetBarcodeCount:
            barcodeCountModule.resetBarcodeCount()
            result(nil)
        case FunctionNames.startScanningPhase:
            barcodeCountModule.startScanningPhase()
            result(nil)
        case FunctionNames.endScanningPhase:
            barcodeCountModule.endScanningPhase()
            result(nil)
        case FunctionNames.updateBarcodeCountView:
            barcodeCountModule.updateBarcodeCountView(viewJson: methodCall.arguments as! String)
            result(nil)
        case FunctionNames.updateBarcodeCount:
            barcodeCountModule.updateBarcodeCount(modeJson: methodCall.arguments as! String)
            result(nil)
        case FunctionNames.setModeEnabledState:
            barcodeCountModule.setModeEnabled(enabled: methodCall.arguments as! Bool)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
