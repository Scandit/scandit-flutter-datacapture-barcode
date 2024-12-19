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
        static let updateFeedback = "updateFeedback"
        
        static let submitBarcodeCountStatusProviderCallback = "submitBarcodeCountStatusProviderCallback"
        static let addBarcodeCountStatusProvider = "addBarcodeCountStatusProvider"
    }

    private let barcodeCountModule: BarcodeCountModule

    init(barcodeCountModule: BarcodeCountModule) {
        self.barcodeCountModule = barcodeCountModule
    }

    public func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionNames.addBarcodeCountViewListener:
            barcodeCountModule.addBarcodeCountViewListener(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeBarcodeCountViewListener:
            barcodeCountModule.removeBarcodeCountViewListener(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.addBarcodeCountViewUiListener:
            barcodeCountModule.addBarcodeCountViewUiListener(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeBarcodeCountViewUiListener:
            barcodeCountModule.removeBarcodeCountViewUiListener(result: FlutterFrameworkResult(reply: result))
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
                                                                    trackedBarcodeId: trackedBarcodeId,
                                                                    result: FlutterFrameworkResult(reply: result))
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
                                                                             trackedBarcodeId: trackedBarcodeId,
                                                                             result: FlutterFrameworkResult(reply: result))
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
                                                                      trackedBarcodeId: trackedBarcodeId,
                                                                      result: FlutterFrameworkResult(reply: result))
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
            barcodeCountModule.addAsyncBarcodeCountListener()
            result(nil)
        case FunctionNames.removeBarcodeCountListener:
            barcodeCountModule.removeAsyncBarcodeCountListener()
            result(nil)
        case FunctionNames.getBarcodeCountLastFrameData:
            barcodeCountModule.getLastFrameDataBytes(
                frameId: methodCall.arguments as! String,
                result: FlutterFrameworkResult(reply: result)
            )
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
            barcodeCountModule.updateBarcodeCountView(viewJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateBarcodeCount:
            barcodeCountModule.updateBarcodeCount(modeJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.setModeEnabledState:
            barcodeCountModule.setModeEnabled(enabled: methodCall.arguments as! Bool)
            result(nil)
        case FunctionNames.updateFeedback:
            barcodeCountModule.updateFeedback(
                feedbackJson: methodCall.arguments as! String,
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.submitBarcodeCountStatusProviderCallback:
            barcodeCountModule.submitBarcodeCountStatusProviderCallbackResult(
                statusJson:  methodCall.arguments as! String,
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.addBarcodeCountStatusProvider:
            barcodeCountModule.addBarcodeCountStatusProvider(
                result: FlutterFrameworkResult(reply: result)
            )
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
