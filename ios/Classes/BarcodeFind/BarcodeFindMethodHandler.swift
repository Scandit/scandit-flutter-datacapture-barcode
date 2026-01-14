/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import scandit_flutter_datacapture_core
import ScanditFrameworksBarcode
import ScanditFrameworksCore

class BarcodeFindMethodHandler {
    private enum FunctionNames {
        static let getDefaults = "getBarcodeFindDefaults"
        static let updateView = "updateFindView"
        static let updateMode = "updateFindMode"
        static let registerBarcodeFindListener = "registerBarcodeFindListener"
        static let unregisterBarcodeFindListener = "unregisterBarcodeFindListener"
        static let registerBarcodeFindViewListener = "registerBarcodeFindViewListener"
        static let unregisterBarcodeFindViewListener = "unregisterBarcodeFindViewListener"
        static let barcodeFindViewOnPause = "barcodeFindViewOnPause"
        static let barcodeFindViewOnResume = "barcodeFindViewOnResume"
        static let barcodeFindSetItemList = "barcodeFindSetItemList"
        static let barcodeFindViewStopSearching = "barcodeFindViewStopSearching"
        static let barcodeFindViewStartSearching = "barcodeFindViewStartSearching"
        static let barcodeFindViewPauseSearching = "barcodeFindViewPauseSearching"
        static let barcodeFindModeStart = "barcodeFindModeStart"
        static let barcodeFindModePause = "barcodeFindModePause"
        static let barcodeFindModeStop = "barcodeFindModeStop"
        static let setModeEnabledState = "setModeEnabledState"
        static let setBarcodeTransformer = "setBarcodeTransformer"
        static let submitBarcodeTransformerResult = "submitBarcodeTransformerResult"
        static let updateFeedback = "updateFeedback"
    }

    private let barcodeFindModule: BarcodeFindModule

    init(barcodeFindModule: BarcodeFindModule) {
        self.barcodeFindModule = barcodeFindModule
    }

    public func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let executionResult = barcodeFindModule.execute(
            method: FlutterFrameworksMethodCall(methodCall),
            result: FlutterFrameworkResult(reply: result)
        )

        if !executionResult {
            result(FlutterMethodNotImplemented)
        }
    }
}
