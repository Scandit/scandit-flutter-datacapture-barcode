/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

class BarcodeBatchMethodHandler {
    private enum FunctionNames {
        static let barcodeBatchFinishDidUpdateSession = "barcodeBatchFinishDidUpdateSession"
        static let addBarcodeBatchListener = "addBarcodeBatchListener"
        static let removeBarcodeBatchListener = "removeBarcodeBatchListener"
        static let resetBarcodeBatchSession = "resetBarcodeBatchSession"
        static let getLastFrameData = "getLastFrameData"
        static let setBrushForTrackedBarcode = "setBrushForTrackedBarcode"
        static let clearTrackedBarcodeBrushes = "clearTrackedBarcodeBrushes"
        static let addBasicOverlayDelegate = "subscribeBarcodeBatchBasicOverlayListener"
        static let removeBasicOverlayDelegate = "unsubscribeBarcodeBatchBasicOverlayListener"
        static let setWidgetForTrackedBarcode = "setWidgetForTrackedBarcode"
        static let setAnchorForTrackedBarcode = "setAnchorForTrackedBarcode"
        static let setOffsetForTrackedBarcode = "setOffsetForTrackedBarcode"
        static let clearTrackedBarcodeWidgets = "clearTrackedBarcodeWidgets"
        static let addBarcodeBatchAdvancedOverlayDelegate = "addBarcodeBatchAdvancedOverlayDelegate"
        static let removeBarcodeBatchAdvancedOverlayDelegate = "removeBarcodeBatchAdvancedOverlayDelegate"
        static let getBarcodeBatchDefaults = "getBarcodeBatchDefaults"
        static let setModeEnabledState = "setModeEnabledState"
        static let updateBarcodeBatchMode = "updateBarcodeBatchMode"
        static let applyBarcodeBatchModeSettings = "applyBarcodeBatchModeSettings"
        static let updateBarcodeBatchBasicOverlay = "updateBarcodeBatchBasicOverlay"
        static let updateBarcodeBatchAdvancedOverlay  = "updateBarcodeBatchAdvancedOverlay"
    }

    private let barcodeBatchModule: BarcodeBatchModule

    init(barcodeBatchModule: BarcodeBatchModule) {
        self.barcodeBatchModule = barcodeBatchModule
    }

    func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getBarcodeBatchDefaults:
            let jsonString = barcodeBatchModule.defaults.stringValue
            result(jsonString)
        case FunctionNames.addBarcodeBatchListener:
            barcodeBatchModule.addAsyncBarcodeBatchListener()
            result(nil)
        case FunctionNames.removeBarcodeBatchListener:
            barcodeBatchModule.removeAsyncBarcodeBatchListener()
            result(nil)
        case FunctionNames.barcodeBatchFinishDidUpdateSession:
            let enabled = methodCall.arguments as? Bool ?? false
            barcodeBatchModule.finishDidUpdateSession(enabled: enabled)
            result(true)
        case FunctionNames.resetBarcodeBatchSession:
            barcodeBatchModule.resetSession(frameSequenceId: methodCall.arguments as? Int)
            result(nil)
        case FunctionNames.getLastFrameData:
            barcodeBatchModule.getLastFrameDataBytes(
                frameId: methodCall.arguments as! String,
                result: FlutterFrameworkResult(
                    reply: result
                )
            )
        case FunctionNames.addBarcodeBatchAdvancedOverlayDelegate:
            barcodeBatchModule.addAdvancedOverlayListener()
            result(nil)
        case FunctionNames.removeBarcodeBatchAdvancedOverlayDelegate:
            barcodeBatchModule.removeAdvancedOverlayListener()
            result(nil)
        case FunctionNames.clearTrackedBarcodeWidgets:
            barcodeBatchModule.clearAdvancedOverlayTrackedBarcodeViews()
            result(nil)
        case FunctionNames.setWidgetForTrackedBarcode:
            guard var args = methodCall.arguments as? [String: Any?] else {
                result(FlutterError(code: "-1",
                                    message: "Invalid argument for \(FunctionNames.setWidgetForTrackedBarcode)",
                                    details: methodCall.arguments)
                )
                return
            }
            let regularData = args["widget"] as? FlutterStandardTypedData
            args["widget"] = regularData?.data
            barcodeBatchModule.setWidgetForTrackedBarcode(with: args)
            result(nil)
        case FunctionNames.setAnchorForTrackedBarcode:
            guard let args = methodCall.arguments as? [String: Any?] else {
                result(FlutterError(code: "-1",
                                    message: "Invalid argument for \(FunctionNames.setAnchorForTrackedBarcode)",
                                    details: methodCall.arguments))
                return
            }
            barcodeBatchModule.setAnchorForTrackedBarcode(anchorParams: args)
            result(nil)
        case FunctionNames.setOffsetForTrackedBarcode:
            guard let args = methodCall.arguments as? [String: Any?] else {
                result(FlutterError(code: "-1",
                                    message: "Invalid argument for \(FunctionNames.setOffsetForTrackedBarcode)",
                                    details: methodCall.arguments))
                return
            }
            barcodeBatchModule.setOffsetForTrackedBarcode(offsetParams: args)
            result(nil)
        case FunctionNames.addBasicOverlayDelegate:
            barcodeBatchModule.addBasicOverlayListener()
            result(nil)
        case FunctionNames.removeBasicOverlayDelegate:
            barcodeBatchModule.removeBasicOverlayListener()
            result(nil)
        case FunctionNames.setBrushForTrackedBarcode:
            barcodeBatchModule.setBasicOverlayBrush(with: methodCall.arguments as! String)
            result(nil)
        case FunctionNames.clearTrackedBarcodeBrushes:
            barcodeBatchModule.clearBasicOverlayTrackedBarcodeBrushes()
            result(nil)
        case FunctionNames.setModeEnabledState:
            barcodeBatchModule.setModeEnabled(enabled: methodCall.arguments as! Bool)
            result(nil)
        case FunctionNames.updateBarcodeBatchMode:
            barcodeBatchModule.updateModeFromJson(modeJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.applyBarcodeBatchModeSettings:
            barcodeBatchModule.applyModeSettings(modeSettingsJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateBarcodeBatchBasicOverlay:
            barcodeBatchModule.updateBasicOverlay(overlayJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateBarcodeBatchAdvancedOverlay:
            barcodeBatchModule.updateAdvancedOverlay(overlayJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
