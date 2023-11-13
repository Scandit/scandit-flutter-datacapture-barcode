/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import Foundation
import scandit_flutter_datacapture_core
import ScanditBarcodeCapture

extension ScanditFlutterDataCaptureBarcodeSelection {
    var defaults: [String: Any] {
        return [
            "BarcodeSelectionBasicOverlay": overlayDefaults,
            "BarcodeSelectionSettings": settingsDefaults,
            "Feedback": BarcodeSelectionFeedback.default.jsonString,
            "RecommendedCameraSettings": BarcodeSelection.recommendedCameraSettings.defaults,
            "BarcodeSelectionTapSelection": tapSelectionDefaults,
            "BarcodeSelectionAimerSelection": aimerSelectionDefaults
        ]
    }

    private var overlayDefaults: [String: Any] {
        func createBrushDefaultsForStyle(style: BarcodeSelectionBasicOverlayStyle) -> [String: Any] {
            return [
                "DefaultAimedBrush": BarcodeSelectionBasicOverlay.defaultAimedBrush(forStyle: style).defaults,
                "DefaultSelectingBrush": BarcodeSelectionBasicOverlay.defaultSelectingBrush(forStyle: style).defaults,
                "DefaultSelectedBrush": BarcodeSelectionBasicOverlay.defaultSelectedBrush(forStyle: style).defaults,
                "DefaultTrackedBrush": BarcodeSelectionBasicOverlay.defaultTrackedBrush(forStyle: style).defaults
            ]
        }

        return [
            "defaultStyle": BarcodeSelectionBasicOverlayStyle.frame.jsonString,
            "styles": [
                BarcodeSelectionBasicOverlayStyle.dot.jsonString: createBrushDefaultsForStyle(style: .dot),
                BarcodeSelectionBasicOverlayStyle.frame.jsonString: createBrushDefaultsForStyle(style: .frame)
            ],
            "shouldShowHints": true,
            "frozenBackgroundColor": "00000080"
        ]
    }

    private var settingsDefaults: [String: Any] {
        let settings = BarcodeSelectionSettings()
        return [
            "codeDuplicateFilter": settings.codeDuplicateFilter * 1000,
            "singleBarcodeAutoDetectionEnabled": settings.singleBarcodeAutoDetection,
            "selectionType": settings.selectionType.jsonString
        ]
    }

    private var tapSelectionDefaults: [String: Any] {
        let tapSelection = BarcodeSelectionTapSelection()
        return [
            "defaultFreezeBehaviour": tapSelection.freezeBehavior.jsonString,
            "defaultTapBehaviour": tapSelection.tapBehavior.jsonString
        ]
    }

    private var aimerSelectionDefaults: [String: Any] {
        let aimerSelection = BarcodeSelectionAimerSelection()
        return [
            "defaultSelectionStrategy": aimerSelection.selectionStrategy.jsonString
        ]
    }
}
