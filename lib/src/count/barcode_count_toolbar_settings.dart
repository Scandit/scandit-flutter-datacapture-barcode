/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_count_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart' show buildToolbarSettings;

/// Added in version 6.17.0
class BarcodeCountToolbarSettings implements Serializable {
  /// If populated sets the text of the audio setting button when in “on” state. Otherwise a default “Audio on” value will be used.
  ///
  /// Added in version 6.17.0
  String audioOnButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.audioOnButtonText;
  /// If populated sets the text of the audio setting button when in “off” state. Otherwise a default “Audio off” value will be used.
  ///
  /// Added in version 6.17.0
  String audioOffButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.audioOffButtonText;
  /// If populated sets the content description of the audio setting button. Otherwise a default “Audio” value will be used.
  ///
  /// This property is applied only when running on Android.
  ///
  /// Added in version 6.17.0
  String? audioButtonContentDescription =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.audioButtonContentDescription;
  /// If populated sets the accessibility hint of the audio setting button. Otherwise a default “Audio” value will be used.
  ///
  /// This property is applied only when running on iOS.
  ///
  /// Added in version 6.17.0
  String? audioButtonAccessibilityHint = BarcodeCountDefaults.viewDefaults.toolbarSettings.audioButtonAccessibilityHint;
  /// If populated sets the accessibility label of the audio setting button. Otherwise a default “Audio” value will be used.
  ///
  /// This property is applied only when running on iOS.
  ///
  /// Added in version 6.17.0
  String? audioButtonAccessibilityLabel =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.audioButtonAccessibilityLabel;

  /// If populated sets the text of the vibration setting button when in “on” state. Otherwise a default “Haptic on” value will be used.
  ///
  /// Added in version 6.17.0
  String vibrationOnButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.vibrationOnButtonText;
  /// If populated sets the text of the vibration setting button when in “off” state. Otherwise a default “Haptic off” value will be used.
  ///
  /// Added in version 6.17.0
  String vibrationOffButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.vibrationOffButtonText;
  /// If populated sets the content description of the vibration setting button. Otherwise a default “Vibration” value will be used.
  ///
  /// This property is applied only when running on Android.
  ///
  /// Added in version 6.17.0
  String? vibrationButtonContentDescription =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.vibrationButtonContentDescription;
  /// If populated sets the accessibility hint of the vibration setting button. Otherwise a default “Vibration” value will be used.
  ///
  /// This property is applied only when running on iOS.
  ///
  /// Added in version 6.17.0
  String? vibrationButtonAccessibilityHint =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.vibrationButtonAccessibilityHint;
  /// If populated sets the accessibility label of the vibration setting button. Otherwise a default “Vibration” value will be used.
  ///
  /// This property is applied only when running on iOS.
  ///
  /// Added in version 6.17.0
  String? vibrationButtonAccessibilityLabel =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.vibrationButtonAccessibilityLabel;

  /// If populated sets the text of the strap mode setting button when in “on” state. Otherwise a default “Strap mode” value will be used.
  ///
  /// Added in version 6.17.0
  String strapModeOnButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.strapModeOnButtonText;
  /// If populated sets the text of the strap mode setting button when in “off” state. Otherwise a default “Strap mode” value will be used.
  ///
  /// Added in version 6.17.0
  String strapModeOffButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.strapModeOffButtonText;
  /// If populated sets the content description of the strap mode setting button. Otherwise a default “Strap mode” value will be used.
  ///
  /// This property is applied only when running on Android.
  ///
  /// Added in version 6.17.0
  String? strapModeButtonContentDescription =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.strapModeButtonContentDescription;
  /// If populated sets the accessibility hint of the strap mode setting button. Otherwise a default “Strap mode” value will be used.
  ///
  /// This property is applied only when running on iOS.
  ///
  /// Added in version 6.17.0
  String? strapModeButtonAccessibilityHint =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.strapModeButtonAccessibilityHint;
  /// If populated sets the accessibility label of the strap mode setting button. Otherwise a default “Strap mode” value will be used.
  ///
  /// This property is applied only when running on iOS.
  ///
  /// Added in version 6.17.0
  String? strapModeButtonAccessibilityLabel =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.strapModeButtonAccessibilityLabel;

  /// If populated sets the text of the color scheme setting button when in “on” state. Otherwise a default “Color scheme” value will be used.
  ///
  /// Added in version 6.17.0
  String colorSchemeOnButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.colorSchemeOnButtonText;
  /// If populated sets the text of the color scheme setting button when in “off” state. Otherwise a default “Color scheme” value will be used.
  ///
  /// Added in version 6.17.0
  String colorSchemeOffButtonText = BarcodeCountDefaults.viewDefaults.toolbarSettings.colorSchemeOffButtonText;
  /// If populated sets the content description of the color scheme setting button. Otherwise a default “Color scheme” value will be used.
  ///
  /// This property is applied only when running on Android.
  ///
  /// Added in version 6.17.0
  String? colorSchemeButtonContentDescription =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.colorSchemeButtonContentDescription;
  /// If populated sets the accessibility hint of the color scheme setting button. Otherwise a default “Color scheme” value will be used.
  ///
  /// This property is applied only when running on iOS.
  ///
  /// Added in version 6.17.0
  String? colorSchemeButtonAccessibilityHint =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.colorSchemeButtonAccessibilityHint;
  /// If populated sets the accessibility label of the color scheme setting button. Otherwise a default “Color scheme” value will be used.
  ///
  /// This property is applied only when running on iOS.
  ///
  /// Added in version 6.17.0
  String? colorSchemeButtonAccessibilityLabel =
      BarcodeCountDefaults.viewDefaults.toolbarSettings.colorSchemeButtonAccessibilityLabel;

  /// Creates an instance of BarcodeCountToolbarSettings.
  ///
  /// Added in version 8.3.0
  BarcodeCountToolbarSettings();

  @override
  Map<String, dynamic> toMap() {
    return buildToolbarSettings(
      audioOnButtonText: audioOnButtonText,
      audioOffButtonText: audioOffButtonText,
      audioButtonContentDescription: audioButtonContentDescription,
      audioButtonAccessibilityHint: audioButtonAccessibilityHint,
      audioButtonAccessibilityLabel: audioButtonAccessibilityLabel,
      vibrationOnButtonText: vibrationOnButtonText,
      vibrationOffButtonText: vibrationOffButtonText,
      vibrationButtonContentDescription: vibrationButtonContentDescription,
      vibrationButtonAccessibilityHint: vibrationButtonAccessibilityHint,
      vibrationButtonAccessibilityLabel: vibrationButtonAccessibilityLabel,
      strapModeOnButtonText: strapModeOnButtonText,
      strapModeOffButtonText: strapModeOffButtonText,
      strapModeButtonContentDescription: strapModeButtonContentDescription,
      strapModeButtonAccessibilityHint: strapModeButtonAccessibilityHint,
      strapModeButtonAccessibilityLabel: strapModeButtonAccessibilityLabel,
      colorSchemeOnButtonText: colorSchemeOnButtonText,
      colorSchemeOffButtonText: colorSchemeOffButtonText,
      colorSchemeButtonContentDescription: colorSchemeButtonContentDescription,
      colorSchemeButtonAccessibilityHint: colorSchemeButtonAccessibilityHint,
      colorSchemeButtonAccessibilityLabel: colorSchemeButtonAccessibilityLabel,
    );
  }
}
