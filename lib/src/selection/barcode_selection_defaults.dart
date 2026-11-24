/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../scandit_flutter_datacapture_barcode_selection.dart';
import 'barcode_selection_basic_overlay.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../generated/barcode_generated_defaults.dart';
import 'barcode_selection_type.dart';
import 'barcode_selection_tap_behaviour.dart';
import 'barcode_selection_freeze_behaviour.dart';
import 'barcode_selection_strategy.dart';

// Picks the platform-split value of a generated default. Kept private per
// file, mirroring core's and id's own copies.
T _platformDefault<T>({required T android, required T ios}) => Platform.isIOS ? ios : android;

// Builds a Brush from a generated flat {fillColor, strokeColor, strokeWidth}
// default literal - the shape BrushDefaults.fromJSON consumes on the native path.
Brush _buildStaticBrush(Map<String, Object?> json) {
  final fillColor = ColorDeserializer.fromRgbaHex(json['fillColor'] as String? ?? '#00000000');
  final strokeColor = ColorDeserializer.fromRgbaHex(json['strokeColor'] as String? ?? '#00000000');
  final strokeWidth = (json['strokeWidth'] as num?)?.toDouble() ?? 0.0;
  return Brush(fillColor, strokeColor, strokeWidth);
}

// Builds a Feedback from a generated {vibration, sound} default literal.
Feedback _buildStaticFeedback(Map<String, Object?> json) {
  final vibrationJson = json['vibration'] as Map<String, Object?>?;
  final soundJson = json['sound'] as Map<String, Object?>?;

  Vibration? vibration;
  if (vibrationJson != null) {
    switch (vibrationJson['type']) {
      case 'selectionHaptic':
        vibration = Vibration.selectionHapticFeedback;
        break;
      case 'successHaptic':
        vibration = Vibration.successHapticFeedback;
        break;
      default:
        vibration = Vibration.defaultVibration;
    }
  }

  Sound? sound;
  if (soundJson != null) {
    sound = soundJson.containsKey('resource') ? Sound(soundJson['resource'] as String?) : Sound(null);
  }

  return Feedback(vibration, sound);
}

BarcodeSelectionTapSelectionDefaults _buildStaticBarcodeSelectionTapSelectionDefaults() {
  return BarcodeSelectionTapSelectionDefaults(
    BarcodeSelectionFreezeBehaviorSerializer.fromJSON(
        BarcodeSelectionTapSelectionGeneratedDefaults.defaultFreezeBehaviour),
    BarcodeSelectionTapBehaviorSerializer.fromJSON(BarcodeSelectionTapSelectionGeneratedDefaults.defaultTapBehaviour),
    BarcodeSelectionTapSelectionGeneratedDefaults.shouldFreezeOnDoubleTap,
  );
}

BarcodeSelectionAimerSelectionDefaults _buildStaticBarcodeSelectionAimerSelectionDefaults() {
  return BarcodeSelectionAimerSelectionDefaults(
    BarcodeSelectionStrategyDeserializer.fromJSON(
        BarcodeSelectionAimerSelectionGeneratedDefaults.defaultSelectionStrategy.cast<String, dynamic>()),
    BarcodeSelectionAimerBehavior.fromJSON(BarcodeSelectionAimerSelectionGeneratedDefaults.defaultAimerBehavior),
  );
}

BarcodeSelectionSettingsDefaults _buildStaticBarcodeSelectionSettingsDefaults() {
  // The generated selectionType const carries only {'type': 'tapSelection'} -
  // no freezeBehavior/tapBehavior - which is exactly the default-constructed
  // BarcodeSelectionTapSelection the JSON deserializer falls back to (it seeds
  // itself from barcodeSelectionTapSelectionDefaults).
  return BarcodeSelectionSettingsDefaults(
    BarcodeSelectionSettingsGeneratedDefaults.codeDuplicateFilter,
    BarcodeSelectionSettingsGeneratedDefaults.selectionType['type'] == 'aimerSelection'
        ? BarcodeSelectionAimerSelection()
        : BarcodeSelectionTapSelection(),
    singleBarcodeAutoDetectionEnabled: BarcodeSelectionSettingsGeneratedDefaults.singleBarcodeAutoDetectionEnabled,
    swipeGesturesEnabled: BarcodeSelectionSettingsGeneratedDefaults.swipeGesturesEnabled,
    tapGestureForSelectionEnabled: BarcodeSelectionSettingsGeneratedDefaults.tapGestureForSelectionEnabled,
  );
}

BarcodeSelectionBasicOverlayBrushDefaults _buildStaticBrushesForStyle(Map<String, Object?> json) {
  return BarcodeSelectionBasicOverlayBrushDefaults(
    // Keys mirror native's accessor names (BarcodeSelectionBasicOverlay::
    // defaultAimedBrush() et al.) and the payload both serializers emit.
    _buildStaticBrush(json['DefaultAimedBrush'] as Map<String, Object?>),
    _buildStaticBrush(json['DefaultSelectingBrush'] as Map<String, Object?>),
    _buildStaticBrush(json['DefaultSelectedBrush'] as Map<String, Object?>),
    _buildStaticBrush(json['DefaultTrackedBrush'] as Map<String, Object?>),
  );
}

BarcodeSelectionBasicOverlayDefaults _buildStaticBarcodeSelectionBasicOverlayDefaults() {
  // Brush colours are platform-split: the Android wrapper rounds native's
  // float channels half-up while iOS truncates (#26D482B3 vs #26D382B2).
  return BarcodeSelectionBasicOverlayDefaults(
    BarcodeSelectionBasicOverlayStyleSerializer.fromJSON(BarcodeSelectionBasicOverlayGeneratedDefaults.defaultStyle),
    {
      BarcodeSelectionBasicOverlayStyle.frame: _buildStaticBrushesForStyle(_platformDefault(
        android: BarcodeSelectionBasicOverlayGeneratedDefaults.brushesForStyleFrameAndroid,
        ios: BarcodeSelectionBasicOverlayGeneratedDefaults.brushesForStyleFrameIos,
      )),
      BarcodeSelectionBasicOverlayStyle.dot: _buildStaticBrushesForStyle(_platformDefault(
        android: BarcodeSelectionBasicOverlayGeneratedDefaults.brushesForStyleDotAndroid,
        ios: BarcodeSelectionBasicOverlayGeneratedDefaults.brushesForStyleDotIos,
      )),
    },
    BarcodeSelectionBasicOverlayGeneratedDefaults.shouldShowHints,
    // Native's float alpha 0.5 lands on the rounding boundary: Android rounds
    // half-up to 0x80, iOS truncates to 0x7F.
    ColorDeserializer.fromRgbaHex(_platformDefault(
      android: BarcodeSelectionBasicOverlayGeneratedDefaults.frozenBackgroundColorAndroid,
      ios: BarcodeSelectionBasicOverlayGeneratedDefaults.frozenBackgroundColorIos,
    )),
  );
}

BarcodeSelectionFeedbackDefaults _buildStaticBarcodeSelectionFeedbackDefaults() {
  return BarcodeSelectionFeedbackDefaults(_buildStaticFeedback(_platformDefault(
    android: BarcodeSelectionFeedbackGeneratedDefaults.selectionAndroid,
    ios: BarcodeSelectionFeedbackGeneratedDefaults.selectionIos,
  )));
}

// ignore: avoid_classes_with_only_static_members
class BarcodeSelectionDefaults {
  static late CameraSettingsDefaults _cameraSettingsDefaults;

  // Statically sourced from generated/barcode_generated_defaults.dart - byte
  // identical to the native getDefaults() response, available immediately, no
  // method-channel round trip needed. See SDC-32174.
  static final BarcodeSelectionSettingsDefaults _barcodeSelectionSettingsDefaults =
      _buildStaticBarcodeSelectionSettingsDefaults();

  static final BarcodeSelectionBasicOverlayDefaults _barcodeCaptureOverlayDefaults =
      _buildStaticBarcodeSelectionBasicOverlayDefaults();

  static final BarcodeSelectionFeedbackDefaults _barcodeSelectionFeedbackDefaults =
      _buildStaticBarcodeSelectionFeedbackDefaults();

  static final BarcodeSelectionTapSelectionDefaults _barcodeSelectionTapSelectionDefaults =
      _buildStaticBarcodeSelectionTapSelectionDefaults();

  static final BarcodeSelectionAimerSelectionDefaults _barcodeSelectionAimerSelectionDefaults =
      _buildStaticBarcodeSelectionAimerSelectionDefaults();

  static CameraSettingsDefaults get cameraSettingsDefaults => _cameraSettingsDefaults;

  static BarcodeSelectionSettingsDefaults get barcodeSelectionSettingsDefaults => _barcodeSelectionSettingsDefaults;

  static BarcodeSelectionBasicOverlayDefaults get barcodeSelectionBasicOverlayDefaults =>
      _barcodeCaptureOverlayDefaults;

  static BarcodeSelectionFeedbackDefaults get barcodeSelectionFeedbackDefaults => _barcodeSelectionFeedbackDefaults;

  static BarcodeSelectionAimerSelectionDefaults get barcodeSelectionAimerSelectionDefaults =>
      _barcodeSelectionAimerSelectionDefaults;

  static BarcodeSelectionTapSelectionDefaults get barcodeSelectionTapSelectionDefaults =>
      _barcodeSelectionTapSelectionDefaults;

  // RecommendedCameraSettings stays fully dynamic - see the id package.
  static void initializeDefaults(Map<String, dynamic> barcodeSelectionDefaults) {
    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(barcodeSelectionDefaults['RecommendedCameraSettings']);
  }
}

@immutable
class BarcodeSelectionTapSelectionDefaults {
  final BarcodeSelectionFreezeBehavior freezeBehavior;
  final BarcodeSelectionTapBehavior tapBehavior;
  final bool shouldFreezeOnDoubleTap;

  const BarcodeSelectionTapSelectionDefaults(this.freezeBehavior, this.tapBehavior, this.shouldFreezeOnDoubleTap);

  factory BarcodeSelectionTapSelectionDefaults.fromJSON(Map<String, dynamic> json) {
    var freezeBehaviour = BarcodeSelectionFreezeBehaviorSerializer.fromJSON(json['defaultFreezeBehaviour']);
    var tapBehaviour = BarcodeSelectionTapBehaviorSerializer.fromJSON(json['defaultTapBehaviour']);
    var shouldFreezeOnDoubleTap = json['shouldFreezeOnDoubleTap'] as bool? ?? true;
    return BarcodeSelectionTapSelectionDefaults(freezeBehaviour, tapBehaviour, shouldFreezeOnDoubleTap);
  }
}

@immutable
class BarcodeSelectionAimerSelectionDefaults {
  final BarcodeSelectionStrategy selectionStrategy;
  final BarcodeSelectionAimerBehavior aimerBehavior;

  const BarcodeSelectionAimerSelectionDefaults(this.selectionStrategy, this.aimerBehavior);

  factory BarcodeSelectionAimerSelectionDefaults.fromJSON(Map<String, dynamic> json) {
    var defaultStrategy = jsonDecode(json['defaultSelectionStrategy']);
    var selectionStrategy = BarcodeSelectionStrategyDeserializer.fromJSON(defaultStrategy as Map<String, dynamic>);
    var aimerBehavior = json.containsKey('defaultAimerBehavior')
        ? BarcodeSelectionAimerBehavior.fromJSON(json['defaultAimerBehavior'] as String)
        : BarcodeSelectionAimerBehavior.repeatSelection;
    return BarcodeSelectionAimerSelectionDefaults(selectionStrategy, aimerBehavior);
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
  final bool swipeGesturesEnabled;
  final bool tapGestureForSelectionEnabled;

  const BarcodeSelectionSettingsDefaults(this.codeDuplicateFilter, this.selectionType,
      {required this.singleBarcodeAutoDetectionEnabled,
      required this.swipeGesturesEnabled,
      required this.tapGestureForSelectionEnabled});

  factory BarcodeSelectionSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    var codeDuplicateFilter = (json['codeDuplicateFilter'] as num).toInt();
    var singleBarcodeAutoDetectionEnabled = json['singleBarcodeAutoDetectionEnabled'] as bool;
    var selectionType =
        BarcodeSelectionTypeDeserializer.fromJSON(jsonDecode(json['selectionType']) as Map<String, dynamic>);
    var swipeGesturesEnabled = json['swipeGesturesEnabled'] as bool? ?? true;
    var tapGestureForSelectionEnabled = json['tapGestureForSelectionEnabled'] as bool;
    return BarcodeSelectionSettingsDefaults(codeDuplicateFilter, selectionType,
        singleBarcodeAutoDetectionEnabled: singleBarcodeAutoDetectionEnabled,
        swipeGesturesEnabled: swipeGesturesEnabled,
        tapGestureForSelectionEnabled: tapGestureForSelectionEnabled);
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
