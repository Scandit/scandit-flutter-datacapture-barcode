/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_pick_defaults.dart';
import 'barcode_pick_view_highlight_style.dart';

class BarcodePickViewSettings extends Serializable {
  BarcodePickViewSettings();

  BarcodePickViewHighlightStyle highlightStyle = BarcodePickDefaults.viewSettingsDefaults.highlightStyle;
  bool showLoadingDialog = BarcodePickDefaults.viewSettingsDefaults.showLoadingDialog;
  String loadingDialogText = BarcodePickDefaults.viewSettingsDefaults.loadingDialogText;
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

  @override
  Map<String, dynamic> toMap() {
    return {
      'highlightStyle': highlightStyle.toMap(),
      'shouldShowLoadingDialog': showLoadingDialog,
      'showLoadingDialogText': loadingDialogText,
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
    };
  }
}
