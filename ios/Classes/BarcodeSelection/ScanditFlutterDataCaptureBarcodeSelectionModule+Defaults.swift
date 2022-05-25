/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import Foundation
import scandit_flutter_datacapture_core
import ScanditBarcodeCapture

extension ScanditFlutterDataCaptureBarcodeSelectionModule {
    var defaults: [String: Any] {
        return [
            "overlay": overlayDefaults,
            "settings": settingsDefaults,
            "feedback": BarcodeSelectionFeedback.default.jsonString,
            "cameraSettings": BarcodeSelection.recommendedCameraSettings.defaults,
            "tapSelection": tapSelectionDefaults,
            "aimerSelection": aimerSelectionDefaults
        ]
    }

    private var overlayDefaults: [String: Any] {
        func createBrushDefaultsForStyle(style: BarcodeSelectionBasicOverlayStyle) -> [String: Any] {
            return [
                "aimedBrush": BarcodeSelectionBasicOverlay.defaultAimedBrush(forStyle: style).defaults,
                "selectingBrush": BarcodeSelectionBasicOverlay.defaultSelectingBrush(forStyle: style).defaults,
                "selectedBrush": BarcodeSelectionBasicOverlay.defaultSelectedBrush(forStyle: style).defaults,
                "trackedBrush": BarcodeSelectionBasicOverlay.defaultTrackedBrush(forStyle: style).defaults
            ]
        }

        return [
            "defaultStyle": BarcodeSelectionBasicOverlayStyle.frame.jsonString,
            "Brushes": [
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
