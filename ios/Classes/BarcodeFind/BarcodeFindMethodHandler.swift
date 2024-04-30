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
    }

    private let barcodeFindModule: BarcodeFindModule

    init(barcodeFindModule: BarcodeFindModule) {
        self.barcodeFindModule = barcodeFindModule
    }

    public func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionNames.getDefaults:
            let defaults = barcodeFindModule.defaults.stringValue
            result(defaults)
        case FunctionNames.updateView:
            barcodeFindModule.updateBarcodeFindView(viewJson: methodCall.arguments as! String,
                                                    result: .create(result))
        case FunctionNames.updateMode:
            barcodeFindModule.updateBarcodeFindMode(modeJson: methodCall.arguments as! String,
                                                    result: .create(result))
        case FunctionNames.registerBarcodeFindListener:
            barcodeFindModule.addBarcodeFindListener(result: .create(result))
        case FunctionNames.unregisterBarcodeFindListener:
            barcodeFindModule.removeBarcodeFindListener(result: .create(result))
        case FunctionNames.registerBarcodeFindViewListener:
            barcodeFindModule.addBarcodeFindViewListener(result: .create(result))
        case FunctionNames.unregisterBarcodeFindViewListener:
            barcodeFindModule.removeBarcodeFindViewListener(result: .create(result))
        case FunctionNames.barcodeFindViewOnPause:
            // No iOS API exists for this
            result(nil)
        case FunctionNames.barcodeFindViewOnResume:
            barcodeFindModule.prepareSearching(result: .create(result))
        case FunctionNames.barcodeFindSetItemList:
            barcodeFindModule.setItemList(barcodeFindItemsJson: methodCall.arguments as! String,
                                          result: .create(result))
        case FunctionNames.barcodeFindViewStopSearching:
            barcodeFindModule.stopSearching(result: .create(result))
        case FunctionNames.barcodeFindViewPauseSearching:
            barcodeFindModule.pauseSearching(result: .create(result))
        case FunctionNames.barcodeFindViewStartSearching:
            barcodeFindModule.startSearching(result: .create(result))
        case FunctionNames.barcodeFindModeStart:
            barcodeFindModule.startMode(result: .create(result))
        case FunctionNames.barcodeFindModePause:
            barcodeFindModule.pauseMode(result: .create(result))
        case FunctionNames.barcodeFindModeStop:
            barcodeFindModule.stopMode(result: .create(result))
        case FunctionNames.setModeEnabledState:
            barcodeFindModule.setModeEnabled(enabled: methodCall.arguments as! Bool)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
