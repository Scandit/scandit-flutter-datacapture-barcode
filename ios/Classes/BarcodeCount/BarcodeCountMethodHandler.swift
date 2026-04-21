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
            barcodeCountModule.addBarcodeCountViewListener(viewId:  extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeBarcodeCountViewListener:
            barcodeCountModule.removeBarcodeCountViewListener(viewId:  extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.addBarcodeCountViewUiListener:
            barcodeCountModule.addBarcodeCountViewUiListener(viewId:  extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeBarcodeCountViewUiListener:
            barcodeCountModule.removeBarcodeCountViewUiListener(viewId:  extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.clearHighlights:
            barcodeCountModule.clearHighlights(viewId:  extractViewId(methodCall))
            result(nil)
        case FunctionNames.finishBrushForRecognizedBarcode:
            
            let viewId =  extractViewId(methodCall)
            let brush: Brush? = extractArgumentOrDefault(methodCall, key: "brush", defaultValue: nil).flatMap { Brush(jsonString: $0) }
            let trackedBarcodeId: Int =  extractArgument(methodCall, key: "trackedBarcodeId")
            
            barcodeCountModule.finishBrushForRecognizedBarcodeEvent(viewId: viewId,
                                                                    brush: brush,
                                                                    trackedBarcodeId: trackedBarcodeId,
                                                                    result: FlutterFrameworkResult(reply: result))
        case FunctionNames.finishBrushForRecognizedBarcodeNotInListEvent:
            let viewId =  extractViewId(methodCall)
            let brush: Brush? = extractArgumentOrDefault(methodCall, key: "brush", defaultValue: nil).flatMap { Brush(jsonString: $0) }
            let trackedBarcodeId: Int =  extractArgument(methodCall, key: "trackedBarcodeId")
            
            barcodeCountModule.finishBrushForRecognizedBarcodeNotInListEvent(viewId: viewId,
                                                                             brush: brush,
                                                                             trackedBarcodeId: trackedBarcodeId,
                                                                             result: FlutterFrameworkResult(reply: result))
        case FunctionNames.getBarcodeCountDefaults:
            let jsonString = barcodeCountModule.defaults.stringValue
            result(jsonString)
        case FunctionNames.setBarcodeCountCaptureList:
            barcodeCountModule.setBarcodeCountCaptureList(viewId:  extractViewId(methodCall), barcodesJson:  extractArgument(methodCall, key: "targetBarcodes"))
            result(nil)
        case FunctionNames.resetBarcodeCountSession:
            barcodeCountModule.resetBarcodeCountSession(
                viewId:  extractViewId(methodCall),
                frameSequenceId: extractArgumentOrDefault(methodCall, key: "frameSequenceId", defaultValue: nil)
            )
            result(nil)
        case FunctionNames.finishDidScan:
            barcodeCountModule.finishOnScan(
                viewId:  extractViewId(methodCall),
                enabled:  extractArgument(methodCall, key: "enabled"))
            result(nil)
        case FunctionNames.addBarcodeCountListener:
            barcodeCountModule.addAsyncBarcodeCountListener(viewId:  extractViewId(methodCall))
            result(nil)
        case FunctionNames.removeBarcodeCountListener:
            barcodeCountModule.removeAsyncBarcodeCountListener(viewId:  extractViewId(methodCall))
            result(nil)
        case FunctionNames.getBarcodeCountLastFrameData:
            barcodeCountModule.getLastFrameDataBytes(
                frameId: methodCall.arguments as! String,
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.resetBarcodeCount:
            barcodeCountModule.resetBarcodeCount(viewId:  extractViewId(methodCall))
            result(nil)
        case FunctionNames.startScanningPhase:
            barcodeCountModule.startScanningPhase(viewId:  extractViewId(methodCall))
            result(nil)
        case FunctionNames.endScanningPhase:
            barcodeCountModule.endScanningPhase(viewId:  extractViewId(methodCall))
            result(nil)
        case FunctionNames.updateBarcodeCountView:
            barcodeCountModule.updateBarcodeCountView(viewId:  extractViewId(methodCall), viewJson:  extractArgument(methodCall, key: "viewJson"), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateBarcodeCount:
            barcodeCountModule.updateBarcodeCount(viewId:  extractViewId(methodCall), modeJson:  extractArgument(methodCall, key: "modeJson"), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.setModeEnabledState:
            barcodeCountModule.setModeEnabled(viewId:  extractViewId(methodCall), enabled:  extractArgument(methodCall, key: "enabled"))
            result(nil)
        case FunctionNames.updateFeedback:
            barcodeCountModule.updateFeedback(
                viewId:  extractViewId(methodCall),
                feedbackJson:  extractArgument(methodCall, key: "feedbackJson"),
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.submitBarcodeCountStatusProviderCallback:
            barcodeCountModule.submitBarcodeCountStatusProviderCallbackResult(
                viewId:  extractViewId(methodCall),
                statusJson:  extractArgument(methodCall, key: "statusJson"),
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.addBarcodeCountStatusProvider:
            barcodeCountModule.addBarcodeCountStatusProvider(
                viewId: extractViewId(methodCall),
                result: FlutterFrameworkResult(reply: result)
            )
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func extractArgument<T>(_ methodCall: FlutterMethodCall, key: String, as type: T.Type = T.self) -> T {
        guard let args = methodCall.arguments as? [String: Any] else {
            fatalError("FlutterMethodCall arguments are not a [String: Any] dictionary.")
        }
        guard let value = args[key] as? T else {
            fatalError("Argument for key '\(key)' is missing or of the wrong type.")
        }
        return value
    }
    
    func extractArgumentOrDefault<T>(_ methodCall: FlutterMethodCall, key: String, defaultValue: T?, as type: T.Type = T.self) -> T? {
        guard let args = methodCall.arguments as? [String: Any] else {
            return defaultValue
        }
        guard let value = args[key] as? T else {
            return defaultValue
        }
        return value
    }
    
    func extractViewId(_ methodCall: FlutterMethodCall) -> Int {
        return extractArgument(methodCall, key: "viewId")
    }
}
