/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditCaptureCore
import scandit_flutter_datacapture_core
import ScanditFrameworksBarcode
import ScanditFrameworksCore

class SparkScanMethodHandler {
    private enum FunctionNames {

        static let getSparkScanDefaults = "getSparkScanDefaults"
        static let finishDidScan = "finishDidScan"
        static let finishDidUpdateSession = "finishDidUpdateSession"
        static let addSparkScanListener = "addSparkScanListener"
        static let removeSparkScanListener = "removeSparkScanListener"
        static let resetSparkScanSession = "resetSparkScanSession"
        static let getLastFrameData = "getLastFrameData"
        static let updateSparkScanMode = "updateSparkScanMode"
        static let addSparkScanViewUiListener = "addSparkScanViewUiListener"
        static let removeSparkScanViewUiListener = "removeSparkScanViewUiListener"
        static let sparkScanViewStartScanning = "sparkScanViewStartScanning"
        static let sparkScanViewPauseScanning = "sparkScanViewPauseScanning"
        static let showToast = "showToast"
        static let onWidgetPaused = "onWidgetPaused"
        static let setModeEnabledState = "setModeEnabledState"
        static let addFeedbackDelegate = "addFeedbackDelegate"
        static let removeFeedbackDelegate = "removeFeedbackDelegate"
        static let submitFeedbackForBarcode = "submitFeedbackForBarcode"
        static let bringSparkScanViewToFront = "bringViewToFront"
        static let updateSparkScanView = "sparkScanViewUpdate"
    }

    private let sparkScanModule: SparkScanModule

    init(sparkScanModule: SparkScanModule) {
        self.sparkScanModule = sparkScanModule
    }

    public func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getSparkScanDefaults:
            let jsonString = sparkScanModule.defaults.stringValue
            result(jsonString)
        case FunctionNames.finishDidScan:
            let enabled = methodCall.arguments as? Bool ?? false
            sparkScanModule.finishDidScan(enabled: enabled)
            result(nil)
        case FunctionNames.finishDidUpdateSession:
            let enabled = methodCall.arguments as? Bool ?? false
            sparkScanModule.finishDidUpdateSession(enabled: enabled)
            result(nil)
        case FunctionNames.addSparkScanListener:
            sparkScanModule.addAsyncSparkScanListener()
            result(nil)
        case FunctionNames.removeSparkScanListener:
            sparkScanModule.removeasyncSparkScanListener()
            result(nil)
        case FunctionNames.resetSparkScanSession:
            sparkScanModule.resetSession()
            result(nil)
        case FunctionNames.getLastFrameData:
            sparkScanModule.getLastFrameDataBytes(
                frameId: methodCall.arguments as! String,
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.updateSparkScanMode:
            sparkScanModule.updateMode(modeJson: methodCall.arguments as! String,
                                       result: FlutterFrameworkResult(reply: result))
        case FunctionNames.addSparkScanViewUiListener:
            sparkScanModule.addSparkScanViewUiListener()
            result(nil)
        case FunctionNames.removeSparkScanViewUiListener:
            sparkScanModule.removeSparkScanViewUiListener()
            result(nil)
        case FunctionNames.sparkScanViewStartScanning:
            sparkScanModule.startScanning(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.sparkScanViewPauseScanning:
            sparkScanModule.pauseScanning()
            result(nil)
        case FunctionNames.showToast:
            sparkScanModule.showToast(text: methodCall.arguments as! String,
                                      result: FlutterFrameworkResult(reply: result))
        case FunctionNames.setModeEnabledState:
            sparkScanModule.setModeEnabled(enabled: methodCall.arguments as! Bool)
            result(nil)
        case FunctionNames.addFeedbackDelegate:
            sparkScanModule.addFeedbackDelegate(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeFeedbackDelegate:
            sparkScanModule.removeFeedbackDelegate(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.submitFeedbackForBarcode:
            sparkScanModule.submitFeedbackForBarcode(feedbackJson: methodCall.arguments as? String,
                                                     result: FlutterFrameworkResult(reply: result))
        case FunctionNames.bringSparkScanViewToFront:
            guard sparkScanModule.shouldBringSparkScanViewToFront else {
                result(nil)
                return
            }
            guard let sparkScanView = sparkScanModule.sparkScanView else {
                result(nil)
                return
            }
            guard let parent = sparkScanView.superview else {
                result(nil)
                return
            }
            dispatchMain {
                parent.bringSubviewToFront(sparkScanView)
            }
            result(nil)
        case FunctionNames.updateSparkScanView:
            sparkScanModule.updateView(viewJson: methodCall.arguments as! String,
                                       result: FlutterFrameworkResult(reply: result))
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
