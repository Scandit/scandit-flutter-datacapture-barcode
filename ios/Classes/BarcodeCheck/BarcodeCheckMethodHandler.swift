/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

class BarcodeCheckMethodHandler {
    private enum FunctionNames {
        static let getBarcodeCheckDefaults = "getBarcodeCheckDefaults"
        static let updateFeedback = "updateFeedback"
        static let resetLatestBarcodeCheckSession = "resetLatestBarcodeCheckSession"
        static let applyBarcodeCheckModeSettings = "applyBarcodeCheckModeSettings"
        static let addBarcodeCheckListener = "addBarcodeCheckListener"
        static let removeBarcodeCheckListener = "removeBarcodeCheckListener"
        static let barcodeCheckFinishDidUpdateSession = "barcodeCheckFinishDidUpdateSession"
        static let getFrameData = "getFrameData"
        static let updateView = "updateView"
        static let registerBarcodeCheckViewUiListener = "registerBarcodeCheckViewUiListener"
        static let unregisterBarcodeCheckViewUiListener = "unregisterBarcodeCheckViewUiListener"
        static let registerBarcodeCheckHighlightProvider = "registerBarcodeCheckHighlightProvider"
        static let unregisterBarcodeCheckHighlightProvider = "unregisterBarcodeCheckHighlightProvider"
        static let registerBarcodeCheckAnnotationProvider = "registerBarcodeCheckAnnotationProvider"
        static let unregisterBarcodeCheckAnnotationProvider = "unregisterBarcodeCheckAnnotationProvider"
        static let viewStart = "viewStart"
        static let viewStop = "viewStop"
        static let viewPause = "viewPause"
        static let viewReset = "viewReset"
        static let finishHighlightForBarcode = "finishHighlightForBarcode"
        static let finishAnnotationForBarcode = "finishAnnotationForBarcode"
        static let updateAnnotation = "updateAnnotation"
        static let updateHighlight = "updateHighlight"
        static let updateBarcodeCheckPopoverButtonAtIndex = "updateBarcodeCheckPopoverButtonAtIndex"
    }

    private let barcodeCheck: BarcodeCheckModule

    init(barcodeCheck: BarcodeCheckModule) {
        self.barcodeCheck = barcodeCheck
    }

    func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getBarcodeCheckDefaults:
            let defaults = barcodeCheck.defaults

            result(defaults.stringValue)
        case FunctionNames.updateFeedback:
            barcodeCheck.updateFeedback(feedbackJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.resetLatestBarcodeCheckSession:
            barcodeCheck.resetLatestBarcodeCheckSession(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.applyBarcodeCheckModeSettings:
            barcodeCheck.applyBarcodeCheckModeSettings(modeSettingsJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.addBarcodeCheckListener:
            barcodeCheck.addModeListener(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.removeBarcodeCheckListener:
            barcodeCheck.removeModeListener(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.barcodeCheckFinishDidUpdateSession:
            barcodeCheck.finishDidUpdateSession(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.getFrameData:
            barcodeCheck.finishDidUpdateSession(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.getFrameData:
            barcodeCheck.getLastFrameDataBytes(frameId: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateView:
            barcodeCheck.updateView(viewJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.registerBarcodeCheckViewUiListener:
            barcodeCheck.registerBarcodeCheckViewUiListener(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.unregisterBarcodeCheckViewUiListener:
            barcodeCheck.unregisterBarcodeCheckViewUiListener(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.registerBarcodeCheckHighlightProvider:
            barcodeCheck.registerBarcodeCheckHighlightProvider(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.unregisterBarcodeCheckHighlightProvider:
            barcodeCheck.unregisterBarcodeCheckHighlightProvider(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.registerBarcodeCheckAnnotationProvider:
            barcodeCheck.registerBarcodeCheckAnnotationProvider(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.registerBarcodeCheckAnnotationProvider:
            barcodeCheck.unregisterBarcodeCheckAnnotationProvider(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.viewStart:
            barcodeCheck.viewStart(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.viewStop:
            barcodeCheck.viewStop(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.viewPause:
            barcodeCheck.viewPause(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.viewReset:
            barcodeCheck.viewReset(result: FlutterFrameworkResult(reply: result))
        case FunctionNames.finishHighlightForBarcode:
            barcodeCheck.finishHighlightForBarcode(highlightJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.finishAnnotationForBarcode:
            barcodeCheck.finishAnnotationForBarcode(annotationJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateAnnotation:
            barcodeCheck.updateAnnotation(annotationJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateHighlight:
            barcodeCheck.updateHighlight(highlightJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.updateBarcodeCheckPopoverButtonAtIndex:
            barcodeCheck.updateBarcodeCheckPopoverButtonAtIndex(updateJson: methodCall.arguments as! String, result: FlutterFrameworkResult(reply: result))
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
