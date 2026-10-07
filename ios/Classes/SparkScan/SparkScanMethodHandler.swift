/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditCaptureCore
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

// Helper extension to safely extract parameters from method call arguments
private extension FlutterMethodCall {
    func params() -> [String: Any]? {
        arguments as? [String: Any]
    }

    func intValue(for key: String, from params: [String: Any]) -> Int? {
        params[key] as? Int
    }

    func stringValue(for key: String, from params: [String: Any]) -> String? {
        params[key] as? String
    }

    func boolValue(for key: String, from params: [String: Any], default defaultValue: Bool = false) -> Bool {
        params[key] as? Bool ?? defaultValue
    }
}

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
        static let sparkScanViewStopScanning = "sparkScanViewStopScanning"
        static let showToast = "showToast"
        static let onWidgetPaused = "onWidgetPaused"
        static let setModeEnabledState = "setModeEnabledState"
        static let registerSparkScanFeedbackDelegateForEvents = "registerSparkScanFeedbackDelegateForEvents"
        static let unregisterSparkScanFeedbackDelegateForEvents = "unregisterSparkScanFeedbackDelegateForEvents"
        static let submitFeedbackForBarcode = "submitFeedbackForBarcode"
        static let bringSparkScanViewToFront = "bringViewToFront"
        static let updateSparkScanView = "sparkScanViewUpdate"
        static let showSparkScanView = "showSparkScanView"
        static let hideSparkScanView = "hideSparkScanView"
    }

    private let sparkScanModule: SparkScanModule

    init(sparkScanModule: SparkScanModule) {
        self.sparkScanModule = sparkScanModule
    }

    public func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getSparkScanDefaults:
            dispatchMain {
                let jsonString = self.sparkScanModule.defaults.stringValue
                result(jsonString)
            }
        case FunctionNames.finishDidScan:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.finishDidScan(
                viewId: viewId,
                enabled: methodCall.boolValue(for: "enabled", from: params, default: false)
            )
            result(nil)
        case FunctionNames.finishDidUpdateSession:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.finishDidUpdateSession(
                viewId: viewId,
                enabled: methodCall.boolValue(for: "enabled", from: params, default: false)
            )
            result(nil)
        case FunctionNames.addSparkScanListener:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.addSparkScanListener(viewId: viewId)
            result(nil)
        case FunctionNames.removeSparkScanListener:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.removeSparkScanListener(viewId: viewId)
            result(nil)
        case FunctionNames.resetSparkScanSession:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.resetSession(viewId: viewId)
            result(nil)
        case FunctionNames.getLastFrameData:
            guard let frameId = methodCall.arguments as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required frameId", details: nil))
                return
            }
            sparkScanModule.getLastFrameDataBytes(
                frameId: frameId,
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.updateSparkScanMode:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params),
                let modeJson = methodCall.stringValue(for: "updateJson", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.updateMode(
                viewId: viewId,
                modeJson: modeJson,
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.addSparkScanViewUiListener:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.addSparkScanViewUiListener(viewId: viewId)
            result(nil)
        case FunctionNames.removeSparkScanViewUiListener:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.removeSparkScanViewUiListener(viewId: viewId)
            result(nil)
        case FunctionNames.sparkScanViewStartScanning:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.startScanning(
                viewId: viewId,
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.sparkScanViewPauseScanning:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.pauseScanning(viewId: viewId)
            result(nil)
        case FunctionNames.sparkScanViewStopScanning:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.stopScanning(viewId: viewId)
            result(nil)
        case FunctionNames.showToast:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params),
                let text = methodCall.stringValue(for: "text", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.showToast(
                viewId: viewId,
                text: text,
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.setModeEnabledState:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params),
                let enabled = params["enabled"] as? Bool
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.setModeEnabled(viewId: viewId, enabled: enabled)
            result(nil)
        case FunctionNames.registerSparkScanFeedbackDelegateForEvents:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.addFeedbackDelegate(viewId)
            result(nil)
        case FunctionNames.unregisterSparkScanFeedbackDelegateForEvents:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.removeFeedbackDelegate(viewId)
            result(nil)
        case FunctionNames.submitFeedbackForBarcode:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.submitFeedbackForBarcode(
                viewId: viewId,
                feedbackJson: methodCall.stringValue(for: "feedbackJson", from: params),
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.bringSparkScanViewToFront:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.bringSparkScanViewToFront(viewId: viewId)
            result(nil)
        case FunctionNames.updateSparkScanView:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params),
                let viewJson = methodCall.stringValue(for: "updateJson", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.updateView(
                viewId: viewId,
                viewJson: viewJson,
                result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.showSparkScanView:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.showView(viewId)
            result(nil)
        case FunctionNames.hideSparkScanView:
            guard let params = methodCall.params(),
                let viewId = methodCall.intValue(for: "viewId", from: params)
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
                return
            }
            sparkScanModule.hideView(viewId)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
