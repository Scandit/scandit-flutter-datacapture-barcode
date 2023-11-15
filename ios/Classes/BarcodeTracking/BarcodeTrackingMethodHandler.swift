/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore

class BarcodeTrackingMethodHandler {
    private enum FunctionNames {
        static let barcodeTrackingFinishDidUpdateSession = "barcodeTrackingFinishDidUpdateSession"
        static let addBarcodeTrackingListener = "addBarcodeTrackingListener"
        static let removeBarcodeTrackingListener = "removeBarcodeTrackingListener"
        static let resetBarcodeTrackingSession = "resetBarcodeTrackingSession"
        static let getLastFrameData = "getLastFrameData"
        static let setBrushForTrackedBarcode = "setBrushForTrackedBarcode"
        static let clearTrackedBarcodeBrushes = "clearTrackedBarcodeBrushes"
        static let addBasicOverlayDelegate = "subscribeBarcodeTrackingBasicOverlayListener"
        static let removeBasicOverlayDelegate = "unsubscribeBarcodeTrackingBasicOverlayListener"
        static let setWidgetForTrackedBarcode = "setWidgetForTrackedBarcode"
        static let setAnchorForTrackedBarcode = "setAnchorForTrackedBarcode"
        static let setOffsetForTrackedBarcode = "setOffsetForTrackedBarcode"
        static let clearTrackedBarcodeWidgets = "clearTrackedBarcodeWidgets"
        static let addBarcodeTrackingAdvancedOverlayDelegate = "addBarcodeTrackingAdvancedOverlayDelegate"
        static let removeBarcodeTrackingAdvancedOverlayDelegate = "removeBarcodeTrackingAdvancedOverlayDelegate"
        static let getBarcodeTrackingDefaults = "getBarcodeTrackingDefaults"
    }

    private let barcodeTrackingModule: BarcodeTrackingModule

    init(barcodeTrackingModule: BarcodeTrackingModule) {
        self.barcodeTrackingModule = barcodeTrackingModule
    }

    func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getBarcodeTrackingDefaults:
            let jsonString = barcodeTrackingModule.defaults.stringValue
            result(jsonString)
        case FunctionNames.addBarcodeTrackingListener:
            barcodeTrackingModule.addBarcodeTrackingListener()
            result(nil)
        case FunctionNames.removeBarcodeTrackingListener:
            barcodeTrackingModule.removeBarcodeTrackingListener()
            result(nil)
        case FunctionNames.barcodeTrackingFinishDidUpdateSession:
            let enabled = methodCall.arguments as? Bool ?? false
            barcodeTrackingModule.finishDidUpdateSession(enabled: enabled)
            result(true)
        case FunctionNames.resetBarcodeTrackingSession:
            barcodeTrackingModule.resetSession(frameSequenceId: methodCall.arguments as? Int)
            result(nil)
        case FunctionNames.getLastFrameData:
            LastFrameData.shared.getLastFrameDataJSON {
                result($0)
            }
        case FunctionNames.addBarcodeTrackingAdvancedOverlayDelegate:
            barcodeTrackingModule.addAdvancedOverlayListener()
            result(nil)
        case FunctionNames.removeBarcodeTrackingAdvancedOverlayDelegate:
            barcodeTrackingModule.removeAdvancedOverlayListener()
            result(nil)
        case FunctionNames.clearTrackedBarcodeWidgets:
            barcodeTrackingModule.clearAdvancedOverlayTrackedBarcodeViews()
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
            barcodeTrackingModule.setWidgetForTrackedBarcode(with: args)
            result(nil)
        case FunctionNames.setAnchorForTrackedBarcode:
            guard let args = methodCall.arguments as? [String: Any?] else {
                result(FlutterError(code: "-1",
                                    message: "Invalid argument for \(FunctionNames.setAnchorForTrackedBarcode)",
                                    details: methodCall.arguments))
                return
            }
            barcodeTrackingModule.setAnchorForTrackedBarcode(anchorParams: args)
            result(nil)
        case FunctionNames.setOffsetForTrackedBarcode:
            guard let args = methodCall.arguments as? [String: Any?] else {
                result(FlutterError(code: "-1",
                                    message: "Invalid argument for \(FunctionNames.setOffsetForTrackedBarcode)",
                                    details: methodCall.arguments))
                return
            }
            barcodeTrackingModule.setOffsetForTrackedBarcode(offsetParams: args)
            result(nil)
        case FunctionNames.addBasicOverlayDelegate:
            barcodeTrackingModule.addBasicOverlayListener()
            result(nil)
        case FunctionNames.removeBasicOverlayDelegate:
            barcodeTrackingModule.removeBasicOverlayListener()
            result(nil)
        case FunctionNames.setBrushForTrackedBarcode:
            barcodeTrackingModule.setBasicOverlayBrush(with: methodCall.arguments as! String)
            result(nil)
        case FunctionNames.clearTrackedBarcodeBrushes:
            barcodeTrackingModule.clearBasicOverlayTrackedBarcodeBrushes()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
