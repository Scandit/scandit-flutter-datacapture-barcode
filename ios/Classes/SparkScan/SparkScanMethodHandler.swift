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
        static let registerSparkScanFeedbackDelegateForEvents = "registerSparkScanFeedbackDelegateForEvents"
        static let unregisterSparkScanFeedbackDelegateForEvents = "unregisterSparkScanFeedbackDelegateForEvents"
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
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.finishDidScan(
                viewId: params["viewId"] as! Int,
                enabled: params["enabled"] as? Bool ?? false
            )
            result(nil)
        case FunctionNames.finishDidUpdateSession:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.finishDidUpdateSession(
                viewId: params["viewId"] as! Int,
                enabled: params["enabled"] as? Bool ?? false
            )
            result(nil)
        case FunctionNames.addSparkScanListener:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.addAsyncSparkScanListener(viewId: params["viewId"] as! Int)
            result(nil)
        case FunctionNames.removeSparkScanListener:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.removeAsyncSparkScanListener(viewId: params["viewId"] as! Int)
            result(nil)
        case FunctionNames.resetSparkScanSession:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.resetSession(viewId: params["viewId"] as! Int)
            result(nil)
        case FunctionNames.getLastFrameData:
            sparkScanModule.getLastFrameDataBytes(
                frameId: methodCall.arguments as! String,
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.updateSparkScanMode:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.updateMode(
                viewId: params["viewId"] as! Int,
                modeJson: params["updateJson"] as! String,
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.addSparkScanViewUiListener:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.addSparkScanViewUiListener(viewId: params["viewId"] as! Int)
            result(nil)
        case FunctionNames.removeSparkScanViewUiListener:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.removeSparkScanViewUiListener(viewId: params["viewId"] as! Int)
            result(nil)
        case FunctionNames.sparkScanViewStartScanning:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.startScanning(viewId: params["viewId"] as! Int, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.sparkScanViewPauseScanning:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.pauseScanning(viewId: params["viewId"] as! Int)
            result(nil)
        case FunctionNames.showToast:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.showToast(
                viewId: params["viewId"] as! Int,
                text: params["text"] as! String,
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.setModeEnabledState:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.setModeEnabled(viewId: params["viewId"] as! Int, enabled: params["enabled"] as! Bool)
            result(nil)
        case FunctionNames.registerSparkScanFeedbackDelegateForEvents:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.addFeedbackDelegate(params["viewId"] as! Int)
            result(nil)
        case FunctionNames.unregisterSparkScanFeedbackDelegateForEvents:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.removeFeedbackDelegate(params["viewId"] as! Int)
            result(nil)
        case FunctionNames.submitFeedbackForBarcode:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.submitFeedbackForBarcode(
                viewId: params["viewId"] as! Int,
                feedbackJson: params["feedbackJson"] as? String,
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.bringSparkScanViewToFront:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.bringSparkScanViewToFront(viewId: params["viewId"] as! Int)
            result(nil)
        case FunctionNames.updateSparkScanView:
            let params = methodCall.arguments as! [String: Any]
            sparkScanModule.updateView(
                viewId: params["viewId"] as! Int,
                viewJson: params["updateJson"] as! String,
                result: FlutterFrameworkResult(reply: result)
            )
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
