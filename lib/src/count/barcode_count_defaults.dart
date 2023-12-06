/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import '../../scandit_flutter_datacapture_barcode.dart';
import 'barcode_count_function_names.dart';
import 'barcode_count_view.dart';

// ignore: avoid_classes_with_only_static_members
class BarcodeCountDefaults {
  static MethodChannel channel = MethodChannel('com.scandit.datacapture.barcode.count.method/barcode_count_defaults');

  static late CameraSettingsDefaults _cameraSettingsDefaults;

  static CameraSettingsDefaults get cameraSettingsDefaults => _cameraSettingsDefaults;

  static late BarcodeCountSettingsDefaults _barcodeCountSettingsDefaults;

  static BarcodeCountSettingsDefaults get barcodeCountSettingsDefaults => _barcodeCountSettingsDefaults;

  static late BarcodeCountFeedbackDefaults _barcodeCountFeedbackDefaults;

  static BarcodeCountFeedbackDefaults get barcodeCountFeedbackDefaults => _barcodeCountFeedbackDefaults;

  static late BarcodeCountViewDefaults _viewDefaults;

  static BarcodeCountViewDefaults get viewDefaults => _viewDefaults;

  static bool _isInitialized = false;

  static Future<void> initializeDefaults() async {
    if (_isInitialized) return;
    var result = await channel.invokeMethod(BarcodeCountFunctionNames.getDefaults);
    var json = jsonDecode(result as String);
    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(json['RecommendedCameraSettings']);

    _barcodeCountSettingsDefaults =
        BarcodeCountSettingsDefaults.fromJSON(json["BarcodeCountSettings"] as Map<String, dynamic>);
    _barcodeCountFeedbackDefaults =
        BarcodeCountFeedbackDefaults.fromJSON(jsonDecode(json["BarcodeCountFeedback"]) as Map<String, dynamic>);
    _viewDefaults = BarcodeCountViewDefaults.fromJSON(json["BarcodeCountView"] as Map<String, dynamic>);

    _isInitialized = true;
  }
}

@immutable
class BarcodeCountViewDefaults {
  final BarcodeCountViewStyle style;
  final bool shouldShowUserGuidanceView;
  final bool shouldShowListButton;
  final bool shouldShowExitButton;
  final bool shouldShowShutterButton;
  final bool shouldShowHints;
  final bool shouldShowClearHighlightsButton;
  final bool shouldShowSingleScanButton;
  final bool shouldShowFloatingShutterButton;
  final bool shouldShowToolbar;
  final Brush defaultNotInListBrush;
  final Brush defaultRecognizedBrush;
  final Brush defaultUnrecognizedBrush;
  final bool shouldShowScanAreaGuides;
  final String clearHighlightsButtonText;
  final String exitButtonText;
  final String textForUnrecognizedBarcodesDetectedHint;
  final String textForTapShutterToScanHint;
  final String textForScanningHint;
  final String textForMoveCloserAndRescanHint;
  final String textForMoveFurtherAndRescanHint;
  final BarcodeCountToolbarSettingsDefaults toolbarSettings;
  final String listButtonAccessibilityHint;
  final String listButtonAccessibilityLabel;
  final String listButtonContentDescription;
  final String exitButtonAccessibilityHint;
  final String exitButtonAccessibilityLabel;
  final String exitButtonContentDescription;
  final String shutterButtonAccessibilityHint;
  final String shutterButtonAccessibilityLabel;
  final String shutterButtonContentDescription;
  final String floatingShutterButtonAccessibilityHint;
  final String floatingShutterButtonAccessibilityLabel;
  final String floatingShutterButtonContentDescription;
  final String clearHighlightsButtonAccessibilityHint;
  final String clearHighlightsButtonAccessibilityLabel;
  final String clearHighlightsButtonContentDescription;
  final String singleScanButtonAccessibilityHint;
  final String singleScanButtonAccessibilityLabel;
  final String singleScanButtonContentDescription;

  BarcodeCountViewDefaults(
      this.style,
      this.shouldShowUserGuidanceView,
      this.shouldShowListButton,
      this.shouldShowExitButton,
      this.shouldShowShutterButton,
      this.shouldShowHints,
      this.shouldShowClearHighlightsButton,
      this.shouldShowSingleScanButton,
      this.shouldShowFloatingShutterButton,
      this.shouldShowToolbar,
      this.defaultNotInListBrush,
      this.defaultRecognizedBrush,
      this.defaultUnrecognizedBrush,
      this.shouldShowScanAreaGuides,
      this.clearHighlightsButtonText,
      this.exitButtonText,
      this.textForUnrecognizedBarcodesDetectedHint,
      this.textForTapShutterToScanHint,
      this.textForScanningHint,
      this.textForMoveCloserAndRescanHint,
      this.textForMoveFurtherAndRescanHint,
      this.toolbarSettings,
      this.listButtonAccessibilityHint,
      this.listButtonAccessibilityLabel,
      this.listButtonContentDescription,
      this.exitButtonAccessibilityHint,
      this.exitButtonAccessibilityLabel,
      this.exitButtonContentDescription,
      this.shutterButtonAccessibilityHint,
      this.shutterButtonAccessibilityLabel,
      this.shutterButtonContentDescription,
      this.floatingShutterButtonAccessibilityHint,
      this.floatingShutterButtonAccessibilityLabel,
      this.floatingShutterButtonContentDescription,
      this.clearHighlightsButtonAccessibilityHint,
      this.clearHighlightsButtonAccessibilityLabel,
      this.clearHighlightsButtonContentDescription,
      this.singleScanButtonAccessibilityHint,
      this.singleScanButtonAccessibilityLabel,
      this.singleScanButtonContentDescription);

  factory BarcodeCountViewDefaults.fromJSON(Map<String, dynamic> json) {
    final style = BarcodeCountViewStyleSerializer.fromJSON(json['style'] as String);
    final shouldShowUserGuidanceView = json['shouldShowUserGuidanceView'] as bool;
    final shouldShowListButton = json['shouldShowListButton'] as bool;
    final shouldShowExitButton = json['shouldShowExitButton'] as bool;
    final shouldShowShutterButton = json['shouldShowShutterButton'] as bool;
    final shouldShowHints = json['shouldShowHints'] as bool;
    final shouldShowClearHighlightsButton = json['shouldShowClearHighlightsButton'] as bool;
    final shouldShowSingleScanButton = json['shouldShowSingleScanButton'] as bool;
    final shouldShowFloatingShutterButton = json['shouldShowFloatingShutterButton'] as bool;
    final shouldShowToolbar = json['shouldShowToolbar'] as bool;
    final defaultNotInListBrush = BrushDefaults.fromJSON(json['notInListBrush'] as Map<String, dynamic>).toBrush();
    final defaultRecognizedBrush = BrushDefaults.fromJSON(json['recognizedBrush'] as Map<String, dynamic>).toBrush();
    final defaultUnrecognizedBrush =
        BrushDefaults.fromJSON(json['unrecognizedBrush'] as Map<String, dynamic>).toBrush();

    final shouldShowScanAreaGuides = json['shouldShowScanAreaGuides'] as bool;
    final clearHighlightsButtonText = json['clearHighlightsButtonText'];
    final exitButtonText = json['exitButtonText'];
    final textForUnrecognizedBarcodesDetectedHint = json['textForUnrecognizedBarcodesDetectedHint'];
    final textForTapShutterToScanHint = json['textForTapShutterToScanHint'];
    final textForScanningHint = json['textForScanningHint'];
    final textForMoveCloserAndRescanHint = json['textForMoveCloserAndRescanHint'];
    final textForMoveFurtherAndRescanHint = json['textForMoveFurtherAndRescanHint'];

    final toolbarSettings =
        BarcodeCountToolbarSettingsDefaults.fromJSON(json['toolbarSettings'] as Map<String, dynamic>);

    var listButtonAccessibilityHint = '';
    if (json.containsKey('listButtonAccessibilityHint')) {
      listButtonAccessibilityHint = json['listButtonAccessibilityHint'];
    }

    var listButtonAccessibilityLabel = '';
    if (json.containsKey('listButtonAccessibilityLabel')) {
      listButtonAccessibilityLabel = json['listButtonAccessibilityLabel'];
    }

    var listButtonContentDescription = '';
    if (json.containsKey('listButtonContentDescription')) {
      listButtonContentDescription = json['listButtonContentDescription'];
    }

    var exitButtonAccessibilityHint = '';
    if (json.containsKey('exitButtonAccessibilityHint')) {
      exitButtonAccessibilityHint = json['exitButtonAccessibilityHint'];
    }

    var exitButtonAccessibilityLabel = '';
    if (json.containsKey('exitButtonAccessibilityLabel')) {
      exitButtonAccessibilityLabel = json['exitButtonAccessibilityLabel'];
    }

    var exitButtonContentDescription = '';
    if (json.containsKey('exitButtonContentDescription')) {
      exitButtonAccessibilityLabel = json['exitButtonContentDescription'];
    }

    var shutterButtonAccessibilityHint = '';
    if (json.containsKey('shutterButtonAccessibilityHint')) {
      shutterButtonAccessibilityHint = json['shutterButtonAccessibilityHint'];
    }

    var shutterButtonAccessibilityLabel = '';
    if (json.containsKey('shutterButtonAccessibilityLabel')) {
      shutterButtonAccessibilityLabel = json['shutterButtonAccessibilityLabel'];
    }

    var shutterButtonContentDescription = '';
    if (json.containsKey('shutterButtonContentDescription')) {
      shutterButtonContentDescription = json['shutterButtonContentDescription'];
    }

    var floatingShutterButtonAccessibilityHint = '';
    if (json.containsKey('floatingShutterButtonAccessibilityHint')) {
      floatingShutterButtonAccessibilityHint = json['floatingShutterButtonAccessibilityHint'];
    }

    var floatingShutterButtonAccessibilityLabel = '';
    if (json.containsKey('floatingShutterButtonAccessibilityLabel')) {
      floatingShutterButtonAccessibilityLabel = json['floatingShutterButtonAccessibilityLabel'];
    }

    var floatingShutterButtonContentDescription = '';
    if (json.containsKey('floatingShutterButtonContentDescription')) {
      floatingShutterButtonContentDescription = json['floatingShutterButtonContentDescription'];
    }

    var clearHighlightsButtonAccessibilityHint = '';
    if (json.containsKey('clearHighlightsButtonAccessibilityHint')) {
      clearHighlightsButtonAccessibilityHint = json['clearHighlightsButtonAccessibilityHint'];
    }

    var clearHighlightsButtonAccessibilityLabel = '';
    if (json.containsKey('clearHighlightsButtonAccessibilityLabel')) {
      clearHighlightsButtonAccessibilityLabel = json['clearHighlightsButtonAccessibilityLabel'];
    }

    var clearHighlightsButtonContentDescription = '';
    if (json.containsKey('clearHighlightsButtonContentDescription')) {
      clearHighlightsButtonContentDescription = json['clearHighlightsButtonContentDescription'];
    }

    var singleScanButtonAccessibilityHint = '';
    if (json.containsKey('singleScanButtonAccessibilityHint')) {
      singleScanButtonAccessibilityHint = json['singleScanButtonAccessibilityHint'];
    }

    var singleScanButtonAccessibilityLabel = '';
    if (json.containsKey('singleScanButtonAccessibilityLabel')) {
      singleScanButtonAccessibilityLabel = json['singleScanButtonAccessibilityLabel'];
    }

    var singleScanButtonContentDescription = '';
    if (json.containsKey('singleScanButtonContentDescription')) {
      singleScanButtonContentDescription = json['singleScanButtonContentDescription'];
    }

    return BarcodeCountViewDefaults(
        style,
        shouldShowUserGuidanceView,
        shouldShowListButton,
        shouldShowExitButton,
        shouldShowShutterButton,
        shouldShowHints,
        shouldShowClearHighlightsButton,
        shouldShowSingleScanButton,
        shouldShowFloatingShutterButton,
        shouldShowToolbar,
        defaultNotInListBrush,
        defaultRecognizedBrush,
        defaultUnrecognizedBrush,
        shouldShowScanAreaGuides,
        clearHighlightsButtonText,
        exitButtonText,
        textForUnrecognizedBarcodesDetectedHint,
        textForTapShutterToScanHint,
        textForScanningHint,
        textForMoveCloserAndRescanHint,
        textForMoveFurtherAndRescanHint,
        toolbarSettings,
        listButtonAccessibilityHint,
        listButtonAccessibilityLabel,
        listButtonContentDescription,
        exitButtonAccessibilityHint,
        exitButtonAccessibilityLabel,
        exitButtonContentDescription,
        shutterButtonAccessibilityHint,
        shutterButtonAccessibilityLabel,
        shutterButtonContentDescription,
        floatingShutterButtonAccessibilityHint,
        floatingShutterButtonAccessibilityLabel,
        floatingShutterButtonContentDescription,
        clearHighlightsButtonAccessibilityHint,
        clearHighlightsButtonAccessibilityLabel,
        clearHighlightsButtonContentDescription,
        singleScanButtonAccessibilityHint,
        singleScanButtonAccessibilityLabel,
        singleScanButtonContentDescription);
  }
}

@immutable
class BarcodeCountSettingsDefaults {
  final BarcodeFilterSettings barcodeFilterSettings;
  final bool expectsOnlyUniqueBarcodes;

  BarcodeCountSettingsDefaults(this.barcodeFilterSettings, this.expectsOnlyUniqueBarcodes);

  factory BarcodeCountSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    return BarcodeCountSettingsDefaults(
        BarcodeFilterSettings.fromJSON(json['BarcodeFilterSettings']), json['expectsOnlyUniqueBarcodes'] as bool);
  }
}

@immutable
class BarcodeCountToolbarSettingsDefaults {
  final String audioOnButtonText;
  final String audioOffButtonText;
  final String? audioButtonContentDescription;
  final String? audioButtonAccessibilityHint;
  final String? audioButtonAccessibilityLabel;
  final String vibrationOnButtonText;
  final String vibrationOffButtonText;
  final String? vibrationButtonContentDescription;
  final String? vibrationButtonAccessibilityHint;
  final String? vibrationButtonAccessibilityLabel;
  final String strapModeOnButtonText;
  final String strapModeOffButtonText;
  final String? strapModeButtonContentDescription;
  final String? strapModeButtonAccessibilityHint;
  final String? strapModeButtonAccessibilityLabel;
  final String colorSchemeOnButtonText;
  final String colorSchemeOffButtonText;
  final String? colorSchemeButtonContentDescription;
  final String? colorSchemeButtonAccessibilityHint;
  final String? colorSchemeButtonAccessibilityLabel;

  BarcodeCountToolbarSettingsDefaults._(
      this.audioOnButtonText,
      this.audioOffButtonText,
      this.audioButtonContentDescription,
      this.audioButtonAccessibilityHint,
      this.audioButtonAccessibilityLabel,
      this.vibrationOnButtonText,
      this.vibrationOffButtonText,
      this.vibrationButtonContentDescription,
      this.vibrationButtonAccessibilityHint,
      this.vibrationButtonAccessibilityLabel,
      this.strapModeOnButtonText,
      this.strapModeOffButtonText,
      this.strapModeButtonContentDescription,
      this.strapModeButtonAccessibilityHint,
      this.strapModeButtonAccessibilityLabel,
      this.colorSchemeOnButtonText,
      this.colorSchemeOffButtonText,
      this.colorSchemeButtonContentDescription,
      this.colorSchemeButtonAccessibilityHint,
      this.colorSchemeButtonAccessibilityLabel);

  factory BarcodeCountToolbarSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    final String audioOnButtonText = json['audioOnButtonText'];
    final String audioOffButtonText = json['audioOffButtonText'];

    String? audioButtonContentDescription;

    if (json.containsKey('audioButtonContentDescription')) {
      audioButtonContentDescription = json['audioButtonContentDescription'];
    }

    String? audioButtonAccessibilityHint;
    if (json.containsKey('audioButtonAccessibilityHint')) {
      audioButtonAccessibilityHint = json['audioButtonAccessibilityHint'];
    }

    String? audioButtonAccessibilityLabel;
    if (json.containsKey('audioButtonAccessibilityLabel')) {
      audioButtonAccessibilityLabel = json['audioButtonAccessibilityLabel'];
    }

    final String vibrationOnButtonText = json['vibrationOnButtonText'];
    final String vibrationOffButtonText = json['vibrationOffButtonText'];
    String? vibrationButtonContentDescription;
    if (json.containsKey('vibrationButtonContentDescription')) {
      vibrationButtonContentDescription = json['vibrationButtonContentDescription'];
    }

    String? vibrationButtonAccessibilityHint;
    if (json.containsKey('vibrationButtonAccessibilityHint')) {
      vibrationButtonAccessibilityHint = json['vibrationButtonAccessibilityHint'];
    }

    String? vibrationButtonAccessibilityLabel;
    if (json.containsKey('vibrationButtonAccessibilityLabel')) {
      vibrationButtonAccessibilityLabel = json['vibrationButtonAccessibilityLabel'];
    }

    final String strapModeOnButtonText = json['strapModeOnButtonText'];
    final String strapModeOffButtonText = json['strapModeOffButtonText'];
    String? strapModeButtonContentDescription;
    if (json.containsKey('strapModeButtonContentDescription')) {
      strapModeButtonContentDescription = json['strapModeButtonContentDescription'];
    }
    String? strapModeButtonAccessibilityHint;
    if (json.containsKey('strapModeButtonAccessibilityHint')) {
      strapModeButtonAccessibilityHint = json['strapModeButtonAccessibilityHint'];
    }
    String? strapModeButtonAccessibilityLabel;
    if (json.containsKey('strapModeButtonAccessibilityLabel')) {
      strapModeButtonAccessibilityLabel = json['strapModeButtonAccessibilityLabel'];
    }

    final String colorSchemeOnButtonText = json['colorSchemeOnButtonText'];
    final String colorSchemeOffButtonText = json['colorSchemeOffButtonText'];
    String? colorSchemeButtonContentDescription;
    if (json.containsKey('colorSchemeButtonContentDescription')) {
      colorSchemeButtonContentDescription = json['colorSchemeButtonContentDescription'];
    }
    String? colorSchemeButtonAccessibilityHint;
    if (json.containsKey('colorSchemeButtonAccessibilityHint')) {
      colorSchemeButtonAccessibilityHint = json['colorSchemeButtonAccessibilityHint'];
    }
    String? colorSchemeButtonAccessibilityLabel;
    if (json.containsKey('colorSchemeButtonAccessibilityLabel')) {
      colorSchemeButtonAccessibilityLabel = json['colorSchemeButtonAccessibilityLabel'];
    }

    return BarcodeCountToolbarSettingsDefaults._(
        audioOnButtonText,
        audioOffButtonText,
        audioButtonContentDescription,
        audioButtonAccessibilityHint,
        audioButtonAccessibilityLabel,
        vibrationOnButtonText,
        vibrationOffButtonText,
        vibrationButtonContentDescription,
        vibrationButtonAccessibilityHint,
        vibrationButtonAccessibilityLabel,
        strapModeOnButtonText,
        strapModeOffButtonText,
        strapModeButtonContentDescription,
        strapModeButtonAccessibilityHint,
        strapModeButtonAccessibilityLabel,
        colorSchemeOnButtonText,
        colorSchemeOffButtonText,
        colorSchemeButtonContentDescription,
        colorSchemeButtonAccessibilityHint,
        colorSchemeButtonAccessibilityLabel);
  }
}

@immutable
class BarcodeCountFeedbackDefaults {
  final Feedback success;
  final Feedback failure;

  BarcodeCountFeedbackDefaults(this.success, this.failure);

  factory BarcodeCountFeedbackDefaults.fromJSON(Map<String, dynamic> json) {
    var successJson = json['success'];

    Sound? successSound;
    Vibration? successVibration;

    if (successJson.containsKey('sound')) {
      var soundMap = successJson['sound'] as Map;
      if (soundMap.isNotEmpty && soundMap.containsKey('resource')) {
        successSound = Sound(soundMap['resource']);
      } else {
        successSound = Sound(null);
      }
    }
    if (successJson.containsKey('vibration')) {
      var vibrationMap = successJson['vibration'] as Map;
      if (vibrationMap.isNotEmpty && vibrationMap.containsKey('type')) {
        var vibrationType = vibrationMap['type'];
        switch (vibrationType) {
          case 'selectionHaptic':
            successVibration = Vibration.selectionHapticFeedback;
            break;
          case 'successHaptic':
            successVibration = Vibration.successHapticFeedback;
            break;
          default:
            successVibration = Vibration.defaultVibration;
        }
      } else {
        successVibration = Vibration.defaultVibration;
      }
    }
    var success = Feedback(successVibration, successSound);

    var failureJson = json['failure'];

    Sound? failureSound;
    Vibration? failureVibration;

    if (failureJson.containsKey('sound')) {
      var soundMap = failureJson['sound'] as Map;
      if (soundMap.isNotEmpty && soundMap.containsKey('resource')) {
        failureSound = Sound(soundMap['resource']);
      } else {
        failureSound = Sound(null);
      }
    }
    if (failureJson.containsKey('vibration')) {
      var vibrationMap = failureJson['vibration'] as Map;
      if (vibrationMap.isNotEmpty && vibrationMap.containsKey('type')) {
        var vibrationType = vibrationMap['type'];
        switch (vibrationType) {
          case 'selectionHaptic':
            failureVibration = Vibration.selectionHapticFeedback;
            break;
          case 'successHaptic':
            failureVibration = Vibration.successHapticFeedback;
            break;
          default:
            failureVibration = Vibration.defaultVibration;
        }
      } else {
        failureVibration = Vibration.defaultVibration;
      }
    }
    var failure = Feedback(failureVibration, failureSound);

    return BarcodeCountFeedbackDefaults(success, failure);
  }
}
