/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

extension ScanditFlutterDataCaptureBarcodeCountModule {
    var defaults: [String: Any] {
        let barcodeFilterSettings = BarcodeFilterSettings()
        return [
            "RecommendedCameraSettings": BarcodeCount.recommendedCameraSettings.defaults,
            "BarcodeCountSettings": [
                "BarcodeFilterSettings": [
                    "excludeEan13": barcodeFilterSettings.excludeEAN13,
                    "excludeUpca": barcodeFilterSettings.excludeUPCA,
                    "excludedCodesRegex": barcodeFilterSettings.excludedCodesRegex,
                    "excludedSymbolCounts": barcodeFilterSettings.excludedSymbolCounts.mapValues { Array($0) },
                    "excludedSymbologies": Array(barcodeFilterSettings.excludedSymbologies)
                ],
                "expectsOnlyUniqueBarcodes": BarcodeCountSettings().expectsOnlyUniqueBarcodes
            ],
            "BarcodeCountFeedback": BarcodeCountFeedback().jsonString,
            "BarcodeCountView": [
                "style": BarcodeCountViewDefaults.defaultStyle.jsonString,
                "shouldShowUserGuidanceView": BarcodeCountViewDefaults.defaultShouldShowUserGuidanceView,
                "shouldShowListButton": BarcodeCountViewDefaults.defaultShouldShowListButton,
                "shouldShowExitButton": BarcodeCountViewDefaults.defaultShouldShowExitButton,
                "shouldShowShutterButton": BarcodeCountViewDefaults.defaultShouldShowShutterButton,
                "shouldShowHints": BarcodeCountViewDefaults.defaultShouldShowHints,
                "shouldShowClearHighlightsButton": BarcodeCountViewDefaults.defaultShouldShowClearHighlightsButton,
                "shouldShowSingleScanButton": BarcodeCountViewDefaults.defaultShouldShowSingleScanButton,
                "shouldShowFloatingShutterButton": BarcodeCountViewDefaults.defaultShouldShowFloatingShutterButton,
                "shouldShowToolbar": BarcodeCountViewDefaults.defaultShouldShowToolbar,
                "shouldShowScanAreaGuides": BarcodeCountViewDefaults.defaultShouldShowScanAreaGuides,
                "toolbarSettings": [
                    "audioOnButtonText": BarcodeCountToolbarDefaults.audioOnButtonText,
                    "audioOffButtonText": BarcodeCountToolbarDefaults.audioOffButtonText,
                    "audioButtonAccessibilityHint": BarcodeCountToolbarDefaults.audioButtonAccessibilityHint,
                    "audioButtonAccessibilityLabel": BarcodeCountToolbarDefaults.audioButtonAccessibilityLabel,
                    "vibrationOnButtonText": BarcodeCountToolbarDefaults.vibrationOnButtonText,
                    "vibrationOffButtonText": BarcodeCountToolbarDefaults.vibrationOffButtonText,
                    "vibrationButtonAccessibilityHint": BarcodeCountToolbarDefaults.vibrationButtonAccessibilityHint,
                    "vibrationButtonAccessibilityLabel": BarcodeCountToolbarDefaults.vibrationButtonAccessibilityLabel,
                    "strapModeOnButtonText": BarcodeCountToolbarDefaults.strapModeOnButtonText,
                    "strapModeOffButtonText": BarcodeCountToolbarDefaults.strapModeOffButtonText,
                    "strapModeButtonAccessibilityHint": BarcodeCountToolbarDefaults.strapModeButtonAccessibilityHint,
                    "strapModeButtonAccessibilityLabel": BarcodeCountToolbarDefaults.strapModeButtonAccessibilityLabel,
                    "colorSchemeOnButtonText": BarcodeCountToolbarDefaults.colorSchemeOnButtonText,
                    "colorSchemeOffButtonText": BarcodeCountToolbarDefaults.colorSchemeOffButtonText,
                    "colorSchemeButtonAccessibilityHint": BarcodeCountToolbarDefaults.colorSchemeButtonAccessibilityHint,
                    "colorSchemeButtonAccessibilityLabel": BarcodeCountToolbarDefaults.colorSchemeButtonAccessibilityLabel
                ],
                "recognizedBrush": BarcodeCountView.defaultRecognizedBrush.defaults,
                "unrecognizedBrush": BarcodeCountView.defaultUnrecognizedBrush.defaults,
                "notInListBrush": BarcodeCountView.defaultNotInListBrush.defaults,
                "listButtonAccessibilityHint": BarcodeCountViewDefaults.defaultListButtonAccessibilityHint,
                "listButtonAccessibilityLabel": BarcodeCountViewDefaults.defaultListButtonAccessibilityLabel,
                "exitButtonAccessibilityHint": BarcodeCountViewDefaults.defaultExitButtonAccessibilityHint,
                "exitButtonAccessibilityLabel": BarcodeCountViewDefaults.defaultExitButtonAccessibilityLabel,
                "shutterButtonAccessibilityHint": BarcodeCountViewDefaults.defaultShutterButtonAccessibilityHint,
                "shutterButtonAccessibilityLabel": BarcodeCountViewDefaults.defaultShutterButtonAccessibilityLabel,
                "floatingShutterButtonAccessibilityHint": BarcodeCountViewDefaults.defaultFloatingShutterButtonAccessibilityHint,
                "floatingShutterButtonAccessibilityLabel": BarcodeCountViewDefaults.defaultFloatingShutterButtonAccessibilityLabel,
                "clearHighlightsButtonAccessibilityHint": BarcodeCountViewDefaults.defaultClearHighlightsButtonAccessibilityHint,
                "clearHighlightsButtonAccessibilityLabel": BarcodeCountViewDefaults.defaultClearHighlightsButtonAccessibilityLabel,
                "singleScanButtonAccessibilityHint": BarcodeCountViewDefaults.defaultSingleScanButtonAccessibilityHint,
                "singleScanButtonAccessibilityLabel": BarcodeCountViewDefaults.defaultSingleScanButtonAccessibilityLabel,
                "clearHighlightsButtonText": BarcodeCountViewDefaults.defaultClearHighlightsButtonText,
                "exitButtonText": BarcodeCountViewDefaults.defaultExitButtonText,
                "textForUnrecognizedBarcodesDetectedHint": BarcodeCountViewDefaults.defaultTextForUnrecognizedBarcodesDetectedHint,
                "textForTapShutterToScanHint": BarcodeCountViewDefaults.defaultTextForTapShutterToScanHint,
                "textForScanningHint": BarcodeCountViewDefaults.defaultTextForScanningHint,
                "textForMoveCloserAndRescanHint": BarcodeCountViewDefaults.defaultTextForMoveCloserAndRescanHint,
                "textForMoveFurtherAndRescanHint": BarcodeCountViewDefaults.defaultTextForMoveFurtherAndRescanHint
            ]
        ]
    }
}
