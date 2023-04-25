/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_count_defaults.dart';

class BarcodeCountToolbarSettings implements Serializable {
  String audioOnButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.audioOnButtonText;
  String audioOffButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.audioOffButtonText;
  String? audioButtonContentDescription =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.audioButtonContentDescription;
  String? audioButtonAccessibilityHint = BarcodeCountDefaults.viewDefaults.toolbarSettings.audioButtonAccessibilityHint;
  String? audioButtonAccessibilityLabel =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.audioButtonAccessibilityLabel;

  String vibrationOnButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.vibrationOnButtonText;
  String vibrationOffButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.vibrationOffButtonText;
  String? vibrationButtonContentDescription =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.vibrationButtonContentDescription;
  String? vibrationButtonAccessibilityHint =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.vibrationButtonAccessibilityHint;
  String? vibrationButtonAccessibilityLabel =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.vibrationButtonAccessibilityLabel;

  String strapModeOnButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.strapModeOnButtonText;
  String strapModeOffButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.strapModeOffButtonText;
  String? strapModeButtonContentDescription =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.strapModeButtonContentDescription;
  String? strapModeButtonAccessibilityHint =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.strapModeButtonAccessibilityHint;
  String? strapModeButtonAccessibilityLabel =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.strapModeButtonAccessibilityLabel;

  String colorSchemeOnButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.colorSchemeOnButtonText;
  String colorSchemeOffButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.colorSchemeOffButtonText;
  String? colorSchemeButtonContentDescription =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.colorSchemeButtonContentDescription;
  String? colorSchemeButtonAccessibilityHint =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.colorSchemeButtonAccessibilityHint;
  String? colorSchemeButtonAccessibilityLabel =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.colorSchemeButtonAccessibilityLabel;

  @override
  Map<String, dynamic> toMap() {
    return {
      'audioOnButtonText': audioOnButtonText,
      'audioOffButtonText': audioOffButtonText,
      'audioButtonContentDescription': audioButtonContentDescription,
      'audioButtonAccessibilityHint': audioButtonAccessibilityHint,
      'audioButtonAccessibilityLabel': audioButtonAccessibilityLabel,
      'vibrationOnButtonText': vibrationOnButtonText,
      'vibrationOffButtonText': vibrationOffButtonText,
      'vibrationButtonContentDescription': vibrationButtonContentDescription,
      'vibrationButtonAccessibilityHint': vibrationButtonAccessibilityHint,
      'vibrationButtonAccessibilityLabel': vibrationButtonAccessibilityLabel,
      'strapModeOnButtonText': strapModeOnButtonText,
      'strapModeOffButtonText': strapModeOffButtonText,
      'strapModeButtonContentDescription': strapModeButtonContentDescription,
      'strapModeButtonAccessibilityHint': strapModeButtonAccessibilityHint,
      'strapModeButtonAccessibilityLabel': strapModeButtonAccessibilityLabel,
      'colorSchemeOnButtonText': colorSchemeOnButtonText,
      'colorSchemeOffButtonText': colorSchemeOffButtonText,
      'colorSchemeButtonContentDescription': colorSchemeButtonContentDescription,
      'colorSchemeButtonAccessibilityHint': colorSchemeButtonAccessibilityHint,
      'colorSchemeButtonAccessibilityLabel': colorSchemeButtonAccessibilityLabel
    };
  }
}
