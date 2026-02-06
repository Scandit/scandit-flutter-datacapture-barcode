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
            barcodeAr.updateFeedback(feedbackJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.resetLatestBarcodeArSession:
            barcodeAr.resetLatestBarcodeArSession(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.applyBarcodeArModeSettings:
            barcodeAr.applyBarcodeArModeSettings(modeSettingsJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.addBarcodeArListener:
            barcodeAr.addModeListener(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeBarcodeArListener:
            barcodeAr.removeModeListener(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.barcodeArFinishDidUpdateSession:
            barcodeAr.finishDidUpdateSession(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.getFrameData:
            barcodeAr.finishDidUpdateSession(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.getFrameData:
            barcodeAr.getLastFrameDataBytes(frameId: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateView:
            barcodeAr.updateView(viewJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.registerBarcodeArViewUiListener:
            barcodeAr.registerBarcodeArViewUiListener(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.unregisterBarcodeArViewUiListener:
            barcodeAr.unregisterBarcodeArViewUiListener(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.registerBarcodeArHighlightProvider:
            barcodeAr.registerBarcodeArHighlightProvider(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.unregisterBarcodeArHighlightProvider:
            barcodeAr.unregisterBarcodeArHighlightProvider(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.registerBarcodeArAnnotationProvider:
            barcodeAr.registerBarcodeArAnnotationProvider(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.registerBarcodeArAnnotationProvider:
            barcodeAr.unregisterBarcodeArAnnotationProvider(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.viewStart:
            barcodeAr.viewStart(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.viewStop:
            barcodeAr.viewStop(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.viewPause:
            barcodeAr.viewPause(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.viewReset:
            barcodeAr.viewReset(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.finishHighlightForBarcode:
            barcodeAr.finishHighlightForBarcode(highlightJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.finishAnnotationForBarcode:
            barcodeAr.finishAnnotationForBarcode(annotationJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateAnnotation:
            barcodeAr.updateAnnotation(annotationJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateHighlight:
            barcodeAr.updateHighlight(highlightJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateBarcodeArPopoverButtonAtIndex:
            barcodeAr.updateBarcodeArPopoverButtonAtIndex(updateJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
