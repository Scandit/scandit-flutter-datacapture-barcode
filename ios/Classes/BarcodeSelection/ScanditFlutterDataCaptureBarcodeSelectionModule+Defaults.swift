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
            let selection = BarcodeSelection(context: nil, settings: BarcodeSelectionSettings())
            let overlay = BarcodeSelectionBasicOverlay(barcodeSelection: selection, style: style)
            return [
                "aimedBrush": overlay.aimedBrush.defaults,
                "selectingBrush": overlay.selectingBrush.defaults,
                "selectedBrush": overlay.selectedBrush.defaults,
                "trackedBrush": overlay.trackedBrush.defaults
            ]
        }

        let selection = BarcodeSelection(context: nil, settings: BarcodeSelectionSettings())
        let overlay = BarcodeSelectionBasicOverlay(barcodeSelection: selection)
        return [
            "defaultStyle": overlay.style.jsonString,
            "Brushes": [
                BarcodeSelectionBasicOverlayStyle.dot.jsonString: createBrushDefaultsForStyle(style: .dot),
                BarcodeSelectionBasicOverlayStyle.frame.jsonString: createBrushDefaultsForStyle(style: .frame)
            ],
            "shouldShowHints": overlay.shouldShowHints
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
