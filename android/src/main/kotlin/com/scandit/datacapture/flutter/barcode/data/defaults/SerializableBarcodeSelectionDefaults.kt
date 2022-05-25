/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.data.defaults

import com.scandit.datacapture.barcode.selection.capture.BarcodeSelection
import com.scandit.datacapture.barcode.selection.capture.BarcodeSelectionAimerSelection
import com.scandit.datacapture.barcode.selection.capture.BarcodeSelectionSettings
import com.scandit.datacapture.barcode.selection.capture.BarcodeSelectionTapSelection
import com.scandit.datacapture.barcode.selection.capture.toJson
import com.scandit.datacapture.barcode.selection.feedback.BarcodeSelectionFeedback
import com.scandit.datacapture.barcode.selection.ui.overlay.BarcodeSelectionBasicOverlay
import com.scandit.datacapture.barcode.selection.ui.overlay.BarcodeSelectionBasicOverlayStyle
import com.scandit.datacapture.barcode.selection.ui.overlay.toJson
import com.scandit.datacapture.flutter.core.data.SerializableData
import com.scandit.datacapture.flutter.core.data.defaults.SerializableBrushDefaults
import com.scandit.datacapture.flutter.core.data.defaults.SerializableCameraSettingsDefaults
import com.scandit.datacapture.flutter.core.utils.hexString
import org.json.JSONObject

internal class SerializableBarcodeSelectionDefaults(
    private val defaultFeedback: BarcodeSelectionFeedback,
    private val recommendedCameraSettingsDefaults: SerializableCameraSettingsDefaults,
    private val settingsDefaults: SerializableBarcodeSelectionSettingsDefaults,
    private val tapSelectionDefaults: SerializableBarcodeSelectionTapSelectionDefaults,
    private val aimerSelectionDefaults: SerializableBarcodeSelectionAimerSelectionDefaults,
    private val overlayDefaults: SerializableBarcodeSelectionBasicOverlayDefaults
) : SerializableData {
    override fun toJson() = JSONObject(
        mapOf(
            FIELD_OVERLAY to overlayDefaults.toJson(),
            FIELD_SETTINGS to settingsDefaults.toJson(),
            FIELD_FEEDBACK to defaultFeedback.toJson(),
            FIELD_CAMERA_SETTINGS to recommendedCameraSettingsDefaults.toJson(),
            FIELD_TAP_SELECTION to tapSelectionDefaults.toJson(),
            FIELD_AIMER_SELECTION to aimerSelectionDefaults.toJson()
        )
    )

    companion object {
        private const val FIELD_OVERLAY = "overlay"
        private const val FIELD_SETTINGS = "settings"
        private const val FIELD_FEEDBACK = "feedback"
        private const val FIELD_CAMERA_SETTINGS = "cameraSettings"
        private const val FIELD_TAP_SELECTION = "tapSelection"
        private const val FIELD_AIMER_SELECTION = "aimerSelection"

        @JvmStatic
        fun create(): String {
            val barcodeSelection = BarcodeSelection.forDataCaptureContext(
                null,
                BarcodeSelectionSettings()
            )
            val basicOverlay = BarcodeSelectionBasicOverlay.newInstance(barcodeSelection, null)
            return SerializableBarcodeSelectionDefaults(
                defaultFeedback = BarcodeSelectionFeedback.defaultFeedback(),
                recommendedCameraSettingsDefaults = SerializableCameraSettingsDefaults(
                    BarcodeSelection.createRecommendedCameraSettings()
                ),
                settingsDefaults = SerializableBarcodeSelectionSettingsDefaults(
                    BarcodeSelectionSettings()
                ),
                tapSelectionDefaults = SerializableBarcodeSelectionTapSelectionDefaults(
                    BarcodeSelectionTapSelection()
                ),
                aimerSelectionDefaults = SerializableBarcodeSelectionAimerSelectionDefaults(
                    BarcodeSelectionAimerSelection()
                ),
                overlayDefaults = SerializableBarcodeSelectionBasicOverlayDefaults(
                    overlay = basicOverlay
                )
            ).toJson().toString()
        }
    }
}

internal class SerializableBarcodeSelectionSettingsDefaults(
    private val settings: BarcodeSelectionSettings
) : SerializableData {
    override fun toJson() = JSONObject(
        mapOf(
            FIELD_CODE_DUPLICATE_FILTER to settings.codeDuplicateFilter.asMillis(),
            FIELD_SINGLE_BARCODE_AUTO_DETECTION_ENABLED to settings.singleBarcodeAutoDetection,
            FIELD_SELECTION_TYPE to settings.selectionType.toJson()
        )
    )

    companion object {
        private const val FIELD_CODE_DUPLICATE_FILTER = "codeDuplicateFilter"
        private const val FIELD_SINGLE_BARCODE_AUTO_DETECTION_ENABLED =
            "singleBarcodeAutoDetectionEnabled"
        private const val FIELD_SELECTION_TYPE = "selectionType"
    }
}

internal class SerializableBarcodeSelectionBasicOverlayDefaults(
    private val overlay: BarcodeSelectionBasicOverlay
) : SerializableData {
    override fun toJson() = JSONObject(
        mapOf(
            FIELD_DEFAULT_STYLE to overlay.style.toJson(),
            FIELD_BRUSHES to mapOf(
                BarcodeSelectionBasicOverlayStyle.DOT.toJson() to
                    createBrushDefaultsForStyle(BarcodeSelectionBasicOverlayStyle.DOT),
                BarcodeSelectionBasicOverlayStyle.FRAME.toJson() to
                    createBrushDefaultsForStyle(BarcodeSelectionBasicOverlayStyle.FRAME)
            ),
            FIELD_SHOULD_SHOW_HINTS to overlay.shouldShowHints,
            FIELD_FROZEN_BACKGROUND_COLOR to overlay.frozenBackgroundColor.hexString
        )
    )

    companion object {
        private const val FIELD_TRACKED_BRUSH = "trackedBrush"
        private const val FIELD_AIMED_BRUSH = "aimedBrush"
        private const val FIELD_SELECTING_BRUSH = "selectingBrush"
        private const val FIELD_SELECTED_BRUSH = "selectedBrush"
        private const val FIELD_DEFAULT_STYLE = "defaultStyle"
        private const val FIELD_BRUSHES = "Brushes"
        private const val FIELD_SHOULD_SHOW_HINTS = "shouldShowHints"
        private const val FIELD_FROZEN_BACKGROUND_COLOR = "frozenBackgroundColor"
    }

    private fun createBrushDefaultsForStyle(
        style: BarcodeSelectionBasicOverlayStyle
    ): Map<String, Any?> {
        val selection = BarcodeSelection.forDataCaptureContext(null, BarcodeSelectionSettings())
        val overlay = BarcodeSelectionBasicOverlay.newInstance(selection, null, style)
        return mapOf(
            FIELD_AIMED_BRUSH to SerializableBrushDefaults(overlay.aimedBrush).toMap(),
            FIELD_SELECTED_BRUSH to SerializableBrushDefaults(overlay.selectedBrush).toMap(),
            FIELD_SELECTING_BRUSH to SerializableBrushDefaults(overlay.selectingBrush).toMap(),
            FIELD_TRACKED_BRUSH to SerializableBrushDefaults(overlay.trackedBrush).toMap()
        )
    }
}

internal class SerializableBarcodeSelectionTapSelectionDefaults(
    private val tapSelection: BarcodeSelectionTapSelection
) : SerializableData {
    override fun toJson() = JSONObject(
        mapOf(
            FIELD_DEFAULT_FREEZE_BEHAVIOUR to tapSelection.freezeBehavior.toJson(),
            FIELD_DEFAULT_TAP_BEHAVIOUR to tapSelection.tapBehavior.toJson()
        )
    )

    companion object {
        private const val FIELD_DEFAULT_FREEZE_BEHAVIOUR = "defaultFreezeBehaviour"
        private const val FIELD_DEFAULT_TAP_BEHAVIOUR = "defaultTapBehaviour"
    }
}

internal class SerializableBarcodeSelectionAimerSelectionDefaults(
    private val aimerSelection: BarcodeSelectionAimerSelection
) : SerializableData {
    override fun toJson() = JSONObject(
        mapOf(
            FIELD_DEFAULT_SELECTION_STRATEGY to aimerSelection.selectionStrategy.toJson()
        )
    )

    companion object {
        private const val FIELD_DEFAULT_SELECTION_STRATEGY = "defaultSelectionStrategy"
    }
}
