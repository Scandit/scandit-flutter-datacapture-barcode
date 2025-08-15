/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import scandit_flutter_datacapture_core
import ScanditFrameworksBarcode
import ScanditFrameworksCore

class BarcodePickMethodHandler {
    private enum FunctionNames {
        static let getDefaults = "getDefaults"
        static let addScanningListener = "addScanningListener"
        static let removeScanningListener = "removeScanningListener"
        static let startPickView = "startPickView"
        static let stopPickView = "stopPickView"
        static let freezePickView = "freezePickView"
        static let releasePickView = "releasePickView"
        
        static let addViewUiListener = "addViewUiListener"
        static let removeViewUiListener = "removeViewUiListener"
        static let addViewListener = "addViewListener"
        static let removeViewListener = "removeViewListener"
        static let addActionListener = "addActionListener"
        static let removeActionListener = "removeActionListener"
        static let finishOnProductIdentifierForItems = "finishOnProductIdentifierForItems"
        static let finishPickAction = "finishPickAction"
        static let addBarcodePickListener = "addBarcodePickListener"
        static let removeBarcodePickListener = "removeBarcodePickListener"
        static let finishBarcodePickViewHighlightStyleCustomViewProviderViewForRequest 
        = "finishBarcodePickViewHighlightStyleCustomViewProviderViewForRequest"
        static let finishBarcodePickViewHighlightStyleAsyncProviderStyleForRequest
        = "finishBarcodePickViewHighlightStyleAsyncProviderStyleForRequest"
    }

    private let barcodePickModule: BarcodePickModule

    init(barcodePickModule: BarcodePickModule) {
        self.barcodePickModule = barcodePickModule
    }

    public func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getDefaults:
            let defaults = barcodePickModule.defaults.stringValue
            result(defaults)
        case FunctionNames.addScanningListener:
            barcodePickModule.addScanningListener()
            result(nil)
        case FunctionNames.removeScanningListener:
            barcodePickModule.removeScanningListener()
            result(nil)
        case FunctionNames.startPickView:
            barcodePickModule.viewStart()
            result(nil)
        case FunctionNames.freezePickView:
            barcodePickModule.viewFreeze()
            result(nil)
        case FunctionNames.releasePickView:
            barcodePickModule.viewStop()
            result(nil)
        case FunctionNames.stopPickView:
            barcodePickModule.viewPause()
            result(nil)
        case FunctionNames.addViewUiListener:
            barcodePickModule.addViewUiListener()
            result(nil)
        case FunctionNames.removeViewUiListener:
            barcodePickModule.removeViewUiListener()
            result(nil)
        case FunctionNames.addViewListener:
            barcodePickModule.addViewListener()
            result(nil)
        case FunctionNames.removeViewListener:
            barcodePickModule.removeViewListener()
            result(nil)
        case FunctionNames.addActionListener:
            barcodePickModule.addActionListener()
            result(nil)
        case FunctionNames.removeActionListener:
            barcodePickModule.removeActionListener()
            result(nil)
        case FunctionNames.finishOnProductIdentifierForItems:
            barcodePickModule.finishProductIdentifierForItems(barcodePickProductProviderCallbackItemsJson: methodCall.arguments as! String)
            result(nil)
        case FunctionNames.finishPickAction:
            let data = methodCall.arguments as! String
            barcodePickModule.finishPickAction(data: data, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.addBarcodePickListener:
            barcodePickModule.addBarcodePickListener(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeBarcodePickListener:
            barcodePickModule.removeBarcodePickListener(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.finishBarcodePickViewHighlightStyleCustomViewProviderViewForRequest:
            guard let args = methodCall.arguments as? [String: Any?] else {
                result(FlutterError(
                    code: "-1",
                    message: "Invalid argument for \(FunctionNames.finishBarcodePickViewHighlightStyleCustomViewProviderViewForRequest)",
                    details: methodCall.arguments)
                )
                return
            }
            barcodePickModule.finishBarcodePickViewHighlightStyleCustomViewProviderViewForRequest(
                response: args, result: FlutterFrameworkResult(reply: result)
            )
        case FunctionNames.finishBarcodePickViewHighlightStyleAsyncProviderStyleForRequest:
            guard let args = methodCall.arguments as? [String: Any?] else {
                result(FlutterError(
                    code: "-1",
                    message: "Invalid argument for \(FunctionNames.finishBarcodePickViewHighlightStyleAsyncProviderStyleForRequest)",
                    details: methodCall.arguments)
                )
                return
            }
            barcodePickModule.finishBarcodePickViewHighlightStyleAsyncProviderStyleForRequest(
                response: args, result: FlutterFrameworkResult(reply: result)
            )
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
