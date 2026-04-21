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
            let viewId = extractViewId(methodCall)
            barcodePickModule.addScanningListener(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeScanningListener:
            let viewId = extractViewId(methodCall)
            barcodePickModule.removeScanningListener(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.startPickView:
            let viewId = extractViewId(methodCall)
            barcodePickModule.viewStart(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.freezePickView:
            let viewId = extractViewId(methodCall)
            barcodePickModule.viewFreeze(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.releasePickView:
            let viewId = extractViewId(methodCall)
            barcodePickModule.viewStop(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.stopPickView:
            let viewId = extractViewId(methodCall)
            barcodePickModule.viewPause(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.addViewUiListener:
            let viewId = extractViewId(methodCall)
            barcodePickModule.addViewUiListener(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeViewUiListener:
            let viewId = extractViewId(methodCall)
            barcodePickModule.removeViewUiListener(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.addViewListener:
            let viewId = extractViewId(methodCall)
            barcodePickModule.addViewListener(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeViewListener:
            let viewId = extractViewId(methodCall)
            barcodePickModule.removeViewListener(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.addActionListener:
            let viewId = extractViewId(methodCall)
            barcodePickModule.addActionListener(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeActionListener:
            let viewId = extractViewId(methodCall)
            barcodePickModule.removeActionListener(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.finishOnProductIdentifierForItems:
            let viewId = extractViewId(methodCall)
            let data = extractArgument(methodCall, key: "data", as: String.self)
            barcodePickModule.finishProductIdentifierForItems(viewId: viewId, barcodePickProductProviderCallbackItemsJson: data, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.finishPickAction:
            let viewId = extractViewId(methodCall)
            let itemData = extractArgument(methodCall, key: "itemData", as: String.self)
            let actionResult = extractArgument(methodCall, key: "result", as: Bool.self)
            barcodePickModule.finishPickAction(viewId: viewId, data: itemData, actionResult: actionResult, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.addBarcodePickListener:
            let viewId = extractViewId(methodCall)
            barcodePickModule.addBarcodePickListener(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeBarcodePickListener:
            let viewId = extractViewId(methodCall)
            barcodePickModule.removeBarcodePickListener(viewId: viewId, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.finishBarcodePickViewHighlightStyleCustomViewProviderViewForRequest:
            guard let args = methodCall.arguments as? [String: Any?] else {
                result(FlutterError(
                    code: "-1",
                    message: "Invalid argument for \(FunctionNames.finishBarcodePickViewHighlightStyleCustomViewProviderViewForRequest)",
                    details: methodCall.arguments)
                )
                return
            }
            let viewId = extractViewId(methodCall)
            barcodePickModule.finishBarcodePickViewHighlightStyleCustomViewProviderViewForRequest(
                viewId: viewId, response: args, result: FlutterFrameworkResult(reply: result)
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
            let viewId = extractViewId(methodCall)
            barcodePickModule.finishBarcodePickViewHighlightStyleAsyncProviderStyleForRequest(
                viewId: viewId, response: args, result: FlutterFrameworkResult(reply: result)
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
