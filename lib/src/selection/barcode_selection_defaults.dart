/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import '../../scandit_flutter_datacapture_barcode_selection.dart';
import 'barcode_selection_basic_overlay.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_selection_type.dart';
import 'barcode_selection_function_names.dart';
import 'barcode_selection_tap_behaviour.dart';
import 'barcode_selection_freeze_behaviour.dart';
import 'barcode_selection_strategy.dart';

// ignore: avoid_classes_with_only_static_members
class BarcodeSelectionDefaults {
  static MethodChannel channel = const MethodChannel(BarcodeSelectionFunctionNames.methodsChannelName);

  static late CameraSettingsDefaults _cameraSettingsDefaults;

  static late BarcodeSelectionSettingsDefaults _barcodeSelectionSettingsDefaults;

  static late BarcodeSelectionBasicOverlayDefaults _barcodeCaptureOverlayDefaults;

  static late BarcodeSelectionFeedbackDefaults _barcodeSelectionFeedbackDefaults;

  static late BarcodeSelectionTapSelectionDefaults _barcodeSelectionTapSelectionDefaults;

  static late BarcodeSelectionAimerSelectionDefaults _barcodeSelectionAimerSelectionDefaults;

  static CameraSettingsDefaults get cameraSettingsDefaults => _cameraSettingsDefaults;

  static BarcodeSelectionSettingsDefaults get barcodeSelectionSettingsDefaults => _barcodeSelectionSettingsDefaults;

  static BarcodeSelectionBasicOverlayDefaults get barcodeSelectionBasicOverlayDefaults =>
      _barcodeCaptureOverlayDefaults;

  static BarcodeSelectionFeedbackDefaults get barcodeSelectionFeedbackDefaults => _barcodeSelectionFeedbackDefaults;

  static BarcodeSelectionAimerSelectionDefaults get barcodeSelectionAimerSelectionDefaults =>
      _barcodeSelectionAimerSelectionDefaults;

  static BarcodeSelectionTapSelectionDefaults get barcodeSelectionTapSelectionDefaults =>
      _barcodeSelectionTapSelectionDefaults;

  static bool _isInitialized = false;

  static Future<void> initializeDefaults() async {
    if (_isInitialized) return;
    var result = await channel.invokeMethod(BarcodeSelectionFunctionNames.getBarcodeSelectionDefaults);
    var json = jsonDecode(result as String);
    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(json['RecommendedCameraSettings']);
    _barcodeSelectionSettingsDefaults =
        BarcodeSelectionSettingsDefaults.fromJSON(json['BarcodeSelectionSettings'] as Map<String, dynamic>);
    _barcodeCaptureOverlayDefaults =
        BarcodeSelectionBasicOverlayDefaults.fromJSON(json['BarcodeSelectionBasicOverlay'] as Map<String, dynamic>);
    _barcodeSelectionFeedbackDefaults =
        BarcodeSelectionFeedbackDefaults.fromJSON(jsonDecode(json['Feedback']) as Map<String, dynamic>);
    _barcodeSelectionTapSelectionDefaults =
        BarcodeSelectionTapSelectionDefaults.fromJSON(json['BarcodeSelectionTapSelection'] as Map<String, dynamic>);
    _barcodeSelectionAimerSelectionDefaults =
        BarcodeSelectionAimerSelectionDefaults.fromJSON(json['BarcodeSelectionAimerSelection'] as Map<String, dynamic>);

    _isInitialized = true;
  }
}

@immutable
class BarcodeSelectionTapSelectionDefaults {
  final BarcodeSelectionFreezeBehavior freezeBehavior;
  final BarcodeSelectionTapBehavior tapBehavior;

  const BarcodeSelectionTapSelectionDefaults(this.freezeBehavior, this.tapBehavior);

  factory BarcodeSelectionTapSelectionDefaults.fromJSON(Map<String, dynamic> json) {
    var freezeBehaviour = BarcodeSelectionFreezeBehaviorSerializer.fromJSON(json['defaultFreezeBehaviour']);
    var tapBehaviour = BarcodeSelectionTapBehaviorSerializer.fromJSON(json['defaultTapBehaviour']);
    return BarcodeSelectionTapSelectionDefaults(freezeBehaviour, tapBehaviour);
  }
}

@immutable
class BarcodeSelectionAimerSelectionDefaults {
  final BarcodeSelectionStrategy selectionStrategy;

  const BarcodeSelectionAimerSelectionDefaults(this.selectionStrategy);

  factory BarcodeSelectionAimerSelectionDefaults.fromJSON(Map<String, dynamic> json) {
    var defaultStrategy = jsonDecode(json['defaultSelectionStrategy']);
    var selectionStrategy = BarcodeSelectionStrategyDeserializer.fromJSON(defaultStrategy as Map<String, dynamic>);
    return BarcodeSelectionAimerSelectionDefaults(selectionStrategy);
  }
}

@immutable
class BarcodeSelectionFeedbackDefaults {
  final Feedback selection;

  const BarcodeSelectionFeedbackDefaults(this.selection);

  factory BarcodeSelectionFeedbackDefaults.fromJSON(Map<String, dynamic> json) {
    var selection = json['selection'];

    Sound? sound;
    Vibration? vibration;

    if (selection.containsKey('sound')) {
      var soundMap = selection['sound'] as Map;
      if (soundMap.isNotEmpty && soundMap.containsKey('resource')) {
        sound = Sound(soundMap['resource']);
      } else {
        sound = Sound(null);
      }
    }
    if (selection.containsKey('vibration')) {
      var vibrationMap = selection['vibration'] as Map;
      if (vibrationMap.isNotEmpty && vibrationMap.containsKey('type')) {
        var vibrationType = vibrationMap['type'];
        switch (vibrationType) {
          case 'selectionHaptic':
            vibration = Vibration.selectionHapticFeedback;
            break;
          case 'successHaptic':
            vibration = Vibration.successHapticFeedback;
            break;
          default:
            vibration = Vibration.defaultVibration;
        }
      } else {
        vibration = Vibration.defaultVibration;
      }
    }
    return BarcodeSelectionFeedbackDefaults(Feedback(vibration, sound));
  }
}

@immutable
class BarcodeSelectionSettingsDefaults {
  final int codeDuplicateFilter;
  final bool singleBarcodeAutoDetectionEnabled;
  final BarcodeSelectionType selectionType;

  const BarcodeSelectionSettingsDefaults(this.codeDuplicateFilter, this.selectionType,
      {required this.singleBarcodeAutoDetectionEnabled});

  factory BarcodeSelectionSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    var codeDuplicateFilter = (json['codeDuplicateFilter'] as num).toInt();
    var singleBarcodeAutoDetectionEnabled = json['singleBarcodeAutoDetectionEnabled'] as bool;
    var selectionType =
        BarcodeSelectionTypeDeserializer.fromJSON(jsonDecode(json['selectionType']) as Map<String, dynamic>);
    return BarcodeSelectionSettingsDefaults(codeDuplicateFilter, selectionType,
        singleBarcodeAutoDetectionEnabled: singleBarcodeAutoDetectionEnabled);
  }
}

@immutable
class BarcodeSelectionBasicOverlayDefaults {
  final BarcodeSelectionBasicOverlayStyle defaultStyle;
  final Map<BarcodeSelectionBasicOverlayStyle, BarcodeSelectionBasicOverlayBrushDefaults> brushes;
  final bool shouldShowHints;
  final Color frozenBackgroundColor;

  const BarcodeSelectionBasicOverlayDefaults(
      this.defaultStyle, this.brushes, this.shouldShowHints, this.frozenBackgroundColor);

  factory BarcodeSelectionBasicOverlayDefaults.fromJSON(Map<String, dynamic> json) {
    var defaultStyle = BarcodeSelectionBasicOverlayStyleSerializer.fromJSON(json['defaultStyle'] as String);
    var styles = (json['styles'] as Map<String, dynamic>).map((key, value) => MapEntry(
        BarcodeSelectionBasicOverlayStyleSerializer.fromJSON(key),
        BarcodeSelectionBasicOverlayBrushDefaults.fromJSON(value as Map<String, dynamic>)));
    var frozenBackgroundColor = ColorDeserializer.fromRgbaHex(json['frozenBackgroundColor'] as String);

    return BarcodeSelectionBasicOverlayDefaults(
        defaultStyle, styles, json['shouldShowHints'] as bool, frozenBackgroundColor);
  }
}

@immutable
class BarcodeSelectionBasicOverlayBrushDefaults {
  final Brush aimedBrush;
  final Brush selectingBrush;
  final Brush selectedBrush;
  final Brush trackedBrush;

  const BarcodeSelectionBasicOverlayBrushDefaults(
      this.aimedBrush, this.selectingBrush, this.selectedBrush, this.trackedBrush);

  factory BarcodeSelectionBasicOverlayBrushDefaults.fromJSON(Map<String, dynamic> json) {
    var aimedBrushDefaults = BrushDefaults.fromJSON(json['DefaultAimedBrush'] as Map<String, dynamic>);
    var selectingBrushDefaults = BrushDefaults.fromJSON(json['DefaultSelectingBrush'] as Map<String, dynamic>);
    var selectedBrushDefaults = BrushDefaults.fromJSON(json['DefaultSelectedBrush'] as Map<String, dynamic>);
    var trackedBrushDefaults = BrushDefaults.fromJSON(json['DefaultTrackedBrush'] as Map<String, dynamic>);
    return BarcodeSelectionBasicOverlayBrushDefaults(aimedBrushDefaults.toBrush(), selectingBrushDefaults.toBrush(),
        selectedBrushDefaults.toBrush(), trackedBrushDefaults.toBrush());
  }
}
