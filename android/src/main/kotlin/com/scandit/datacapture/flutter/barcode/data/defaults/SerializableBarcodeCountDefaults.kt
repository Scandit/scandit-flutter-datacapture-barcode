package com.scandit.datacapture.flutter.barcode.data.defaults

import android.content.Context
import com.scandit.datacapture.barcode.count.capture.BarcodeCountSettings
import com.scandit.datacapture.barcode.count.feedback.BarcodeCountFeedback
import com.scandit.datacapture.barcode.count.ui.view.BarcodeCountToolbarDefaults
import com.scandit.datacapture.barcode.count.ui.view.BarcodeCountView
import com.scandit.datacapture.barcode.count.ui.view.toJson
import com.scandit.datacapture.barcode.filter.capture.BarcodeFilterSettings
import com.scandit.datacapture.flutter.core.data.SerializableData
import com.scandit.datacapture.flutter.core.data.defaults.SerializableBrushDefaults
import com.scandit.datacapture.flutter.core.data.defaults.SerializableCameraSettingsDefaults
import org.json.JSONObject

internal data class SerializableBarcodeCountDefaults(
    private val recommendedCameraSettings: SerializableCameraSettingsDefaults,
    private val barcodeCountSettings: SerializableBarcodeCountSettingsDefaults,
    private val barcodeCountFeedback: BarcodeCountFeedback,
    private val barcodeCountView: SerializableBarcodeCountViewDefaults
) : SerializableData {
    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_RECOMMENDED_CAMERA_SETTINGS to recommendedCameraSettings.toJson(),
            FIELD_BARCODE_COUNT_SETTINGS to barcodeCountSettings.toJson(),
            FIELD_BARCODE_COUNT_FEEDBACK to barcodeCountFeedback.toJson(),
            FIELD_BARCODE_COUNT_VIEW to barcodeCountView.toJson()
        )
    )

    companion object {
        private const val FIELD_RECOMMENDED_CAMERA_SETTINGS = "RecommendedCameraSettings"
        private const val FIELD_BARCODE_COUNT_SETTINGS = "BarcodeCountSettings"
        private const val FIELD_BARCODE_COUNT_FEEDBACK = "BarcodeCountFeedback"
        private const val FIELD_BARCODE_COUNT_VIEW = "BarcodeCountView"
    }
}

internal data class SerializableBarcodeCountViewDefaults(
    private val context: Context,
    private val barcodeCountView: BarcodeCountView
) : SerializableData {
    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_STYLE to barcodeCountView.style.toJson(),
            FIELD_SHOULD_SHOW_USER_GUIDANCE_VIEW to barcodeCountView.shouldShowUserGuidanceView,
            FIELD_SHOULD_SHOW_LIST_BUTTON to barcodeCountView.shouldShowListButton,
            FIELD_SHOULD_SHOW_EXIT_BUTTON to barcodeCountView.shouldShowExitButton,
            FIELD_SHOULD_SHOW_SHUTTER_BUTTON to barcodeCountView.shouldShowShutterButton,
            FIELD_SHOULD_SHOW_HINTS to barcodeCountView.shouldShowHints,
            FIELD_SHOULD_CLEAR_HIGHLIGHTS_BUTTON to
                barcodeCountView.shouldShowClearHighlightsButton,
            FIELD_SHOULD_SHOW_FLOATING_SHUTTER_BUTTON to
                barcodeCountView.shouldShowFloatingShutterButton,
            FIELD_NOT_IN_LIST_BRUSH to SerializableBrushDefaults(
                BarcodeCountView.defaultNotInListBrush()
            ).toJson(),
            FIELD_RECOGNIZED_BRUSH to SerializableBrushDefaults(
                BarcodeCountView.defaultRecognizedBrush()
            ).toJson(),
            FIELD_UNRECOGNIZED_BRUSH to SerializableBrushDefaults(
                BarcodeCountView.defaultUnrecognizedBrush()
            ).toJson(),
            FIELD_SHOULD_SHOW_SCAN_AREA_GUIDES to barcodeCountView.shouldShowScanAreaGuides,
            FIELD_SHOULD_SHOW_SINGLE_SCAN_BUTTON to barcodeCountView.shouldShowSingleScanButton,
            FIELD_SHOULD_SHOW_TOOLBAR to barcodeCountView.shouldShowToolbar,
            FIELD_CLEAR_HIGHLIGHT_BUTTON_TEXT to barcodeCountView.getClearHighlightsButtonText(),
            FIELD_EXIT_BUTTON_TEXT to barcodeCountView.getExitButtonText(),
            FIELD_TEXT_FOR_UNSCANNED_BARCODE_DETECTED_HINT to
                barcodeCountView.getTextForUnrecognizedBarcodesDetectedHint(),
            FIELD_TEXT_FOR_TAP_SHUTTER_TO_SCAN_HINT to
                barcodeCountView.getTextForTapShutterToScanHint(),
            FIELD_TEXT_FOR_SCANNING_HINT to barcodeCountView.getTextForScanningHint(),
            FIELD_TEXT_MOVE_CLOSER_AND_RESCAN_HINT to
                barcodeCountView.getTextForMoveCloserAndRescanHint(),
            FIELD_TEXT_MOVE_FURTHER_AND_RESCAN_HINT to
                barcodeCountView.getTextForMoveFurtherAndRescanHint(),
            FIELD_TOOLBAR_SETTINGS to
                SerializableBarcodeCountToolbarSettingsDefaults(context).toJson(),
            FIELD_LIST_BUTTON_CONTENT_DESCRIPTION to
                barcodeCountView.getListButtonContentDescription(),
            FIELD_EXIT_BUTTON_CONTENT_DESCRIPTION to
                barcodeCountView.getExitButtonContentDescription(),
            FIELD_SHUTTER_BUTTON_CONTENT_DESCRIPTION to
                barcodeCountView.getShutterButtonContentDescription(),
            FIELD_FLOATING_SHUTTER_BUTTON_CONTENT_DESCRIPTION to
                barcodeCountView.getFloatingShutterButtonContentDescription(),
            FIELD_CLEAR_HIGHLIGHTS_BUTTON_CONTENT_DESCRIPTION to
                barcodeCountView.getClearHighlightsButtonContentDescription(),
            FIELD_SINGLE_SCAN_BUTTON_CONTENT_DESCRIPTION to
                barcodeCountView.getSingleScanButtonContentDescription()
        )
    )

    companion object {
        private const val FIELD_STYLE = "style"
        private const val FIELD_SHOULD_SHOW_USER_GUIDANCE_VIEW = "shouldShowUserGuidanceView"
        private const val FIELD_SHOULD_SHOW_LIST_BUTTON = "shouldShowListButton"
        private const val FIELD_SHOULD_SHOW_EXIT_BUTTON = "shouldShowExitButton"
        private const val FIELD_SHOULD_SHOW_SHUTTER_BUTTON = "shouldShowShutterButton"
        private const val FIELD_SHOULD_SHOW_HINTS = "shouldShowHints"
        private const val FIELD_SHOULD_CLEAR_HIGHLIGHTS_BUTTON = "shouldShowClearHighlightsButton"
        private const val FIELD_SHOULD_SHOW_FLOATING_SHUTTER_BUTTON =
            "shouldShowFloatingShutterButton"
        private const val FIELD_NOT_IN_LIST_BRUSH = "notInListBrush"
        private const val FIELD_RECOGNIZED_BRUSH = "recognizedBrush"
        private const val FIELD_UNRECOGNIZED_BRUSH = "unrecognizedBrush"
        private const val FIELD_SHOULD_SHOW_SCAN_AREA_GUIDES = "shouldShowScanAreaGuides"
        private const val FIELD_SHOULD_SHOW_SINGLE_SCAN_BUTTON = "shouldShowSingleScanButton"
        private const val FIELD_SHOULD_SHOW_TOOLBAR = "shouldShowToolbar"
        private const val FIELD_CLEAR_HIGHLIGHT_BUTTON_TEXT = "clearHighlightsButtonText"
        private const val FIELD_EXIT_BUTTON_TEXT = "exitButtonText"
        private const val FIELD_TEXT_FOR_UNSCANNED_BARCODE_DETECTED_HINT =
            "textForUnrecognizedBarcodesDetectedHint"
        private const val FIELD_TEXT_FOR_TAP_SHUTTER_TO_SCAN_HINT = "textForTapShutterToScanHint"
        private const val FIELD_TEXT_FOR_SCANNING_HINT = "textForScanningHint"
        private const val FIELD_TEXT_MOVE_CLOSER_AND_RESCAN_HINT = "textForMoveCloserAndRescanHint"
        private const val FIELD_TEXT_MOVE_FURTHER_AND_RESCAN_HINT =
            "textForMoveFurtherAndRescanHint"
        private const val FIELD_TOOLBAR_SETTINGS = "toolbarSettings"
        private const val FIELD_LIST_BUTTON_CONTENT_DESCRIPTION =
            "listButtonContentDescription"
        private const val FIELD_EXIT_BUTTON_CONTENT_DESCRIPTION =
            "exitButtonContentDescription"
        private const val FIELD_SHUTTER_BUTTON_CONTENT_DESCRIPTION =
            "shutterButtonContentDescription"
        private const val FIELD_FLOATING_SHUTTER_BUTTON_CONTENT_DESCRIPTION =
            "floatingShutterButtonContentDescription"
        private const val FIELD_CLEAR_HIGHLIGHTS_BUTTON_CONTENT_DESCRIPTION =
            "clearHighlightsButtonContentDescription"
        private const val FIELD_SINGLE_SCAN_BUTTON_CONTENT_DESCRIPTION =
            "singleScanButtonContentDescription"
    }
}

internal data class SerializableBarcodeCountSettingsDefaults(
    private val barcodeCountSettings: BarcodeCountSettings
) : SerializableData {

    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_BARCODE_FILTER_SETTINGS to SerializableBarcodeFilterSettingsDefaults(
                barcodeCountSettings.filterSettings
            ).toJson(),
            FIELD_EXPECTS_ONLY_UNIQUE_BARCODES to barcodeCountSettings.expectsOnlyUniqueBarcodes
        )
    )

    companion object {
        private const val FIELD_BARCODE_FILTER_SETTINGS = "BarcodeFilterSettings"
        private const val FIELD_EXPECTS_ONLY_UNIQUE_BARCODES = "expectsOnlyUniqueBarcodes"
    }
}

internal class SerializableBarcodeFilterSettingsDefaults(
    private val barcodeFilterSettings: BarcodeFilterSettings
) : SerializableData {
    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_EXCLUDE_EAN13 to barcodeFilterSettings.excludeEan13,
            FIELD_EXCLUDE_UPCA to barcodeFilterSettings.excludeUpca,
            FIELD_EXCLUDE_REGEX to barcodeFilterSettings.excludedCodesRegex,
            FIELD_EXCLUDED_SYMBOL_COUNTS to barcodeFilterSettings.excludedSymbolCounts,
            FIELD_EXCLUDED_SYMBOLOGIES to barcodeFilterSettings.excludedSymbologies.map { it.name }
        )
    )

    companion object {
        private const val FIELD_EXCLUDE_EAN13 = "excludeEan13"
        private const val FIELD_EXCLUDE_UPCA = "excludeUpca"
        private const val FIELD_EXCLUDE_REGEX = "excludedCodesRegex"
        private const val FIELD_EXCLUDED_SYMBOL_COUNTS = "excludedSymbolCounts"
        private const val FIELD_EXCLUDED_SYMBOLOGIES = "excludedSymbologies"
    }
}

internal class SerializableBarcodeCountToolbarSettingsDefaults(
    private val context: Context,
    private val toolbarDefaults: BarcodeCountToolbarDefaults = BarcodeCountToolbarDefaults()
) : SerializableData {
    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_AUDIO_ON_BUTTON_TEXT to toolbarDefaults.audioOnButtonText(context),
            FIELD_AUDIO_OFF_BUTTON_TEXT to toolbarDefaults.audioOffButtonText(context),
            FIELD_AUDIO_BUTTON_CONTENT_DESCRIPTION to
                toolbarDefaults.audioButtonContentDescription(context),
            FIELD_VIBRATION_ON_BUTTON_TEXT to toolbarDefaults.vibrationOnButtonText(context),
            FIELD_VIBRATION_OFF_BUTTON_TEXT to toolbarDefaults.vibrationOffButtonText(context),
            FIELD_VIBRATION_BUTTON_CONTENT_DESCRIPTION to
                toolbarDefaults.vibrationButtonContentDescription(context),
            FIELD_STRAP_MODE_ON_BUTTON_TEXT to toolbarDefaults.strapModeOnButtonText(context),
            FIELD_STRAP_MODE_OFF_BUTTON_TEXT to toolbarDefaults.strapModeOffButtonText(context),
            FIELD_STRAP_MODE_BUTTON_CONTENT_DESCRIPTION to
                toolbarDefaults.strapModeButtonContentDescription(context),
            FIELD_COLOR_SCHEME_ON_BUTTON_TEXT to toolbarDefaults.colorSchemeOnButtonText(context),
            FIELD_COLOR_SCHEME_OFF_BUTTON_TEXT to toolbarDefaults.colorSchemeOffButtonText(context),
            FIELD_COLOR_SCHEME_BUTTON_CONTENT_DESCRIPTION to
                toolbarDefaults.colorSchemeButtonContentDescription(context)
        )
    )

    companion object {
        private const val FIELD_AUDIO_ON_BUTTON_TEXT = "audioOnButtonText"
        private const val FIELD_AUDIO_OFF_BUTTON_TEXT = "audioOffButtonText"
        private const val FIELD_AUDIO_BUTTON_CONTENT_DESCRIPTION =
            "audioButtonContentDescription"
        private const val FIELD_VIBRATION_ON_BUTTON_TEXT = "vibrationOnButtonText"
        private const val FIELD_VIBRATION_OFF_BUTTON_TEXT = "vibrationOffButtonText"
        private const val FIELD_VIBRATION_BUTTON_CONTENT_DESCRIPTION =
            "vibrationButtonContentDescription"
        private const val FIELD_STRAP_MODE_ON_BUTTON_TEXT = "strapModeOnButtonText"
        private const val FIELD_STRAP_MODE_OFF_BUTTON_TEXT = "strapModeOffButtonText"
        private const val FIELD_STRAP_MODE_BUTTON_CONTENT_DESCRIPTION =
            "strapModeButtonContentDescription"
        private const val FIELD_COLOR_SCHEME_ON_BUTTON_TEXT = "colorSchemeOnButtonText"
        private const val FIELD_COLOR_SCHEME_OFF_BUTTON_TEXT = "colorSchemeOffButtonText"
        private const val FIELD_COLOR_SCHEME_BUTTON_CONTENT_DESCRIPTION =
            "colorSchemeButtonContentDescription"
    }
}
