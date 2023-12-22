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
        static let sparkScanViewEmitFeedback = "sparkScanViewEmitFeedback"
        static let showToast = "showToast"
        static let onWidgetPaused = "onWidgetPaused"
        static let setModeEnabledState = "setModeEnabledState"
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
            sparkScanModule.addSparkScanListener()
            result(nil)
        case FunctionNames.removeSparkScanListener:
            sparkScanModule.removeSparkScanListener()
            result(nil)
        case FunctionNames.resetSparkScanSession:
            sparkScanModule.resetSession()
            result(nil)
        case FunctionNames.getLastFrameData:
            LastFrameData.shared.getLastFrameDataJSON {
                result($0)
            }
        case FunctionNames.updateSparkScanMode:
            sparkScanModule.updateMode(modeJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
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
        case FunctionNames.sparkScanViewEmitFeedback:
            sparkScanModule.emitFeedback(feedbackJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.showToast:
            sparkScanModule.showToast(text: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.onWidgetPaused:
            sparkScanModule.onPause(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.setModeEnabledState:
            sparkScanModule.setModeEnabled(enabled: methodCall.arguments as! Bool)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
