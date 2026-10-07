/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/map_helper.dart';

import 'barcode_pick_defaults.dart';
import 'ui/barcode_pick_view_highlight_style.dart';

class BarcodePickViewSettings extends Serializable {
  BarcodePickViewSettings();

  BarcodePickViewHighlightStyle highlightStyle = BarcodePickDefaults.viewSettingsDefaults.highlightStyle;
  bool showLoadingDialog = BarcodePickDefaults.viewSettingsDefaults.showLoadingDialog;
  String loadingDialogTextForPicking = BarcodePickDefaults.viewSettingsDefaults.loadingDialogTextForPicking;
  String loadingDialogTextForUnpicking = BarcodePickDefaults.viewSettingsDefaults.loadingDialogTextForUnpicking;
  bool showGuidelines = BarcodePickDefaults.viewSettingsDefaults.showGuidelines;
  String initialGuidelineText = BarcodePickDefaults.viewSettingsDefaults.initialGuidelineText;
  String moveCloserGuidelineText = BarcodePickDefaults.viewSettingsDefaults.moveCloserGuidelineText;
  bool showHints = BarcodePickDefaults.viewSettingsDefaults.showHints;
  String onFirstItemToPickFoundHintText = BarcodePickDefaults.viewSettingsDefaults.onFirstItemToPickFoundHintText;
  String onFirstItemPickCompletedHintText = BarcodePickDefaults.viewSettingsDefaults.onFirstItemPickCompletedHintText;
  String onFirstUnmarkedItemPickCompletedHintText =
      BarcodePickDefaults.viewSettingsDefaults.onFirstUnmarkedItemPickCompletedHintText;
  String onFirstItemUnpickCompletedHintText =
      BarcodePickDefaults.viewSettingsDefaults.onFirstItemUnpickCompletedHintText;
  bool showFinishButton = BarcodePickDefaults.viewSettingsDefaults.showFinishButton;
  bool showPauseButton = BarcodePickDefaults.viewSettingsDefaults.showPauseButton;
  bool showZoomButton = BarcodePickDefaults.viewSettingsDefaults.showZoomButton;
  Anchor zoomButtonPosition = BarcodePickDefaults.viewSettingsDefaults.zoomButtonPosition;
  bool showTorchButton = BarcodePickDefaults.viewSettingsDefaults.showTorchButton;
  Anchor torchButtonPosition = BarcodePickDefaults.viewSettingsDefaults.torchButtonPosition;
  String tapShutterToPauseGuidelineText = BarcodePickDefaults.viewSettingsDefaults.tapShutterToPauseGuidelineText;
  DoubleWithUnit? uiButtonsOffset = BarcodePickDefaults.viewSettingsDefaults.uiButtonsOffset;
  bool hardwareTriggerEnabled = BarcodePickDefaults.viewSettingsDefaults.hardwareTriggerEnabled;
  int? hardwareTriggerKeyCode = BarcodePickDefaults.viewSettingsDefaults.hardwareTriggerKeyCode;
  BarcodeFilterHighlightSettings? filterHighlightSettings =
      BarcodePickDefaults.viewSettingsDefaults.filterHighlightSettings;

  @override
  Map<String, dynamic> toMap() {
    return {
      'highlightStyle': highlightStyle.toMap(),
      'shouldShowLoadingDialog': showLoadingDialog,
      'showLoadingDialogTextForPicking': loadingDialogTextForPicking,
      'showLoadingDialogTextForUnpicking': loadingDialogTextForUnpicking,
      'shouldShowGuidelines': showGuidelines,
      'initialGuidelineText': initialGuidelineText,
      'moveCloserGuidelineText': moveCloserGuidelineText,
      'shouldShowHints': showHints,
      'onFirstItemToPickFoundHintText': onFirstItemToPickFoundHintText,
      'onFirstItemPickCompletedHintText': onFirstItemPickCompletedHintText,
      'onFirstUnmarkedItemPickCompletedHintText': onFirstUnmarkedItemPickCompletedHintText,
      'onFirstItemUnpickCompletedHintText': onFirstItemUnpickCompletedHintText,
      'showFinishButton': showFinishButton,
      'showPauseButton': showPauseButton,
      'showZoomButton': showZoomButton,
      'zoomButtonPosition': zoomButtonPosition.toString(),
      'showTorchButton': showTorchButton,
      'torchButtonPosition': torchButtonPosition.toString(),
      'tapShutterToPauseGuidelineText': tapShutterToPauseGuidelineText,
      'hardwareTriggerEnabled': hardwareTriggerEnabled,
      'hardwareTriggerKeyCode': hardwareTriggerKeyCode,
      'filterHighlightSettings': filterHighlightSettings?.toMap(),
      'uiButtonsOffset': jsonEncodeOrNull(uiButtonsOffset),
    };
  }
}
