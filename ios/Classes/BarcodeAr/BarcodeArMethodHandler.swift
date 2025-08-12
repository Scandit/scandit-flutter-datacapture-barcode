/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

class BarcodeArMethodHandler {
    private enum FunctionNames {
        static let getBarcodeArDefaults = "getBarcodeArDefaults"
        static let updateFeedback = "updateFeedback"
        static let resetLatestBarcodeArSession = "resetLatestBarcodeArSession"
        static let applyBarcodeArModeSettings = "applyBarcodeArModeSettings"
        static let addBarcodeArListener = "addBarcodeArListener"
        static let removeBarcodeArListener = "removeBarcodeArListener"
        static let barcodeArFinishDidUpdateSession = "barcodeArFinishDidUpdateSession"
        static let getFrameData = "getFrameData"
        static let updateView = "updateView"
        static let registerBarcodeArViewUiListener = "registerBarcodeArViewUiListener"
        static let unregisterBarcodeArViewUiListener = "unregisterBarcodeArViewUiListener"
        static let registerBarcodeArHighlightProvider = "registerBarcodeArHighlightProvider"
        static let unregisterBarcodeArHighlightProvider = "unregisterBarcodeArHighlightProvider"
        static let registerBarcodeArAnnotationProvider = "registerBarcodeArAnnotationProvider"
        static let unregisterBarcodeArAnnotationProvider = "unregisterBarcodeArAnnotationProvider"
        static let viewStart = "viewStart"
        static let viewStop = "viewStop"
        static let viewPause = "viewPause"
        static let viewReset = "viewReset"
        static let finishHighlightForBarcode = "finishHighlightForBarcode"
        static let finishAnnotationForBarcode = "finishAnnotationForBarcode"
        static let updateAnnotation = "updateAnnotation"
        static let updateHighlight = "updateHighlight"
        static let updateBarcodeArPopoverButtonAtIndex = "updateBarcodeArPopoverButtonAtIndex"
    }

    private let barcodeAr: BarcodeArModule

    init(barcodeAr: BarcodeArModule) {
        self.barcodeAr = barcodeAr
    }

    func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getBarcodeArDefaults:
            let defaults = barcodeAr.defaults
            result(defaults.stringValue)
        case FunctionNames.updateFeedback:
            barcodeAr.updateFeedback(viewId: extractViewId(methodCall), feedbackJson: extractArgument(methodCall, key: "feedback"), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.resetLatestBarcodeArSession:
            barcodeAr.resetLatestBarcodeArSession(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.applyBarcodeArModeSettings:
            barcodeAr.applyBarcodeArModeSettings(viewId: extractViewId(methodCall), modeSettingsJson: extractArgument(methodCall, key: "settings"), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.addBarcodeArListener:
            barcodeAr.addModeListener(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeBarcodeArListener:
            barcodeAr.removeModeListener(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.barcodeArFinishDidUpdateSession:
            barcodeAr.finishDidUpdateSession(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.getFrameData:
            barcodeAr.getLastFrameDataBytes(frameId: extractArgument(methodCall, key: "frameId"), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateView:
            barcodeAr.updateView(viewId: extractViewId(methodCall), viewJson: extractArgument(methodCall, key: "view"), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.registerBarcodeArViewUiListener:
            barcodeAr.registerBarcodeArViewUiListener(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.unregisterBarcodeArViewUiListener:
            barcodeAr.unregisterBarcodeArViewUiListener(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.registerBarcodeArHighlightProvider:
            barcodeAr.registerBarcodeArHighlightProvider(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.unregisterBarcodeArHighlightProvider:
            barcodeAr.unregisterBarcodeArHighlightProvider(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.registerBarcodeArAnnotationProvider:
            barcodeAr.registerBarcodeArAnnotationProvider(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.unregisterBarcodeArAnnotationProvider:
            barcodeAr.unregisterBarcodeArAnnotationProvider(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.viewStart:
            barcodeAr.viewStart(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.viewStop:
            barcodeAr.viewStop(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.viewPause:
            barcodeAr.viewPause(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.viewReset:
            barcodeAr.viewReset(viewId: extractViewId(methodCall), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.finishHighlightForBarcode:
            barcodeAr.finishHighlightForBarcode(viewId: extractViewId(methodCall), highlightJson: extractArgument(methodCall, key: "result"), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.finishAnnotationForBarcode:
            barcodeAr.finishAnnotationForBarcode(viewId: extractViewId(methodCall), annotationJson: extractArgument(methodCall, key: "result"), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateAnnotation:
            barcodeAr.updateAnnotation(viewId: extractViewId(methodCall), annotationJson: extractArgument(methodCall, key: "annotationJson"), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateHighlight:
            barcodeAr.updateHighlight(viewId: extractViewId(methodCall), highlightJson: extractArgument(methodCall, key: "highlight"), result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateBarcodeArPopoverButtonAtIndex:
            barcodeAr.updateBarcodeArPopoverButtonAtIndex(viewId: extractViewId(methodCall), updateJson: extractArgument(methodCall, key: "update"), result: FlutterFrameworkResult(reply: result))
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

    func extractViewId(_ methodCall: FlutterMethodCall) -> Int {
        return extractArgument(methodCall, key: "viewId")
    }
}
