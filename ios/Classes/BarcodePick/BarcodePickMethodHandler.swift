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
        static let releasePickView = "releasePickView"
        static let freezePickView = "freezePickView"
        static let pausePickView = "pausePickView"
        static let addViewUiListener = "addViewUiListener"
        static let removeViewUiListener = "removeViewUiListener"
        static let addViewListener = "addViewListener"
        static let removeViewListener = "removeViewListener"
        static let addActionListener = "addActionListener"
        static let removeActionListener = "removeActionListener"
        static let finishOnProductIdentifierForItems = "finishOnProductIdentifierForItems"
        static let finishPickAction = "finishPickAction"
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
        case FunctionNames.releasePickView:
            // Not existing on iOS
            result(nil)
        case FunctionNames.freezePickView:
            barcodePickModule.viewFreeze()
            result(nil)
        case FunctionNames.pausePickView:
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
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
