/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/map_helper.dart';

import 'barcode_check_annotation_trigger.dart';
import 'barcode_check_function_names.dart';
import 'barcode_check_highlight.dart';
import 'barcode_check_info_annotation_anchor.dart';
import 'barcode_check_info_annotation_width_preset.dart';

// ignore: avoid_classes_with_only_static_members
class BarcodeCheckDefaults {
  static MethodChannel channel = const MethodChannel(BarcodeCheckFunctionNames.methodsChannelName);

  static late CameraSettingsDefaults _recommendedCameraSettings;

  static CameraSettingsDefaults get recommendedCameraSettings => _recommendedCameraSettings;

  static late BarcodeCheckFeedbackDefaults _feedbackDefaults;

  static BarcodeCheckFeedbackDefaults get feedbackDefaults => _feedbackDefaults;

  static late BarcodeCheckViewDefaults _view;

  static BarcodeCheckViewDefaults get view => _view;

  static bool _isInitialized = false;

  static Future<void> initializeDefaults() async {
    if (_isInitialized) return;
    var result = await channel.invokeMethod(BarcodeCheckFunctionNames.getDefaults);
    var json = jsonDecode(result as String);
    _recommendedCameraSettings = CameraSettingsDefaults.fromJSON(json['RecommendedCameraSettings']);
    _feedbackDefaults = BarcodeCheckFeedbackDefaults.fromJSON(jsonDecode(json['barcodeCheckFeedback']));
    _view = BarcodeCheckViewDefaults.fromJSON(json['BarcodeCheckView']);

    _isInitialized = true;
  }
}

@immutable
class BarcodeCheckViewDefaults {
  final CameraPosition defaultCameraPosition;
  final bool defaultSoundEnabled;
  final bool defaultHapticsEnabled;
  final Anchor defaultTorchControlPosition;
  final Anchor defaultZoomControlPosition;
  final Anchor defaultCameraSwitchControlPosition;
  final bool defaultShouldShowTorchControl;
  final Brush defaultRectangleHighlightBrush;
  final BarcodeCheckAnnotationTrigger defaultPopoverAnnotationTrigger;
  final double defaultBarcodeCheckPopoverAnnotationButtonTextSize;
  final Color defaultBarcodeCheckPopoverAnnotationButtonTextColor;
  final bool defaultBarcodeCheckPopoverAnnotationButtonEnabled;
  final BarcodeCheckAnnotationTrigger defaultStatusIconAnnotationTrigger;
  final bool defaultStatusIconAnnotationHasTip;
  final ScanditIcon defaultStatusIconAnnotationIcon;
  final Color defaultStatusIconAnnotationTextColor;
  final Color defaultStatusIconAnnotationBackgroundColor;
  final ScanditIcon? defaultHighlightIcon;
  final bool defaultIsEntirePopoverTappable;
  final String? defaultStatusIconAnnotationText;
  final BarcodeCheckCircleHighlightPresetsDefaults circleHighlightPresets;
  final bool defaultShouldShowZoomControl;
  final bool defaultShouldShowCameraSwitchControl;
  final BarcodeCheckInfoAnnotationWidthPreset defaultInfoAnnotationWidth;
  final Color defaultInfoAnnotationBackgroundColor;
  final bool defaultInfoAnnotationHasTip;
  final BarcodeCheckInfoAnnotationAnchor defaultInfoAnnotationAnchor;
  final BarcodeCheckAnnotationTrigger defaultInfoAnnotationTrigger;
  final Color defaultInfoAnnotationHeaderBackgroundColor;
  final double defaultInfoAnnotationHeaderTextSize;
  final Color defaultInfoAnnotationHeaderTextColor;
  final Color defaultInfoAnnotationFooterBackgroundColor;
  final double defaultInfoAnnotationFooterTextSize;
  final Color defaultInfoAnnotationFooterTextColor;
  final double defaultInfoAnnotationBodyElementTextSize;
  final Color defaultInfoAnnotationBodyElementTextColor;
  final bool defaultInfoAnnotationBodyElementLeftIconTappable;
  final bool defaultInfoAnnotationBodyElementRightIconTappable;
  final bool defaultInfoAnnotationEntireAnnotationTappable;
  final ScanditIcon? defaultInfoAnnotationHeaderIcon;
  final String? defaultInfoAnnotationHeaderText;
  final ScanditIcon? defaultInfoAnnotationFooterIcon;
  final String? defaultInfoAnnotationFooterText;
  final String? defaultInfoAnnotationBodyElementText;
  final String? defaultInfoAnnotationBodyElementStyledText;
  final ScanditIcon? defaultInfoAnnotationBodyElementLeftIcon;
  final ScanditIcon? defaultInfoAnnotationBodyElementRightIcon;
  final bool defaultShouldShowMacroModeControl;
  final Anchor defaultMacroModeControlPosition;

  const BarcodeCheckViewDefaults({
    required this.defaultCameraPosition,
    required this.defaultSoundEnabled,
    required this.defaultHapticsEnabled,
    required this.defaultTorchControlPosition,
    required this.defaultZoomControlPosition,
    required this.defaultCameraSwitchControlPosition,
    required this.defaultShouldShowTorchControl,
    required this.defaultRectangleHighlightBrush,
    required this.defaultPopoverAnnotationTrigger,
    required this.defaultBarcodeCheckPopoverAnnotationButtonTextSize,
    required this.defaultBarcodeCheckPopoverAnnotationButtonTextColor,
    required this.defaultStatusIconAnnotationTrigger,
    required this.defaultStatusIconAnnotationHasTip,
    required this.defaultStatusIconAnnotationIcon,
    required this.defaultStatusIconAnnotationTextColor,
    required this.defaultStatusIconAnnotationBackgroundColor,
    required this.defaultHighlightIcon,
    required this.defaultIsEntirePopoverTappable,
    required this.defaultStatusIconAnnotationText,
    required this.circleHighlightPresets,
    required this.defaultShouldShowZoomControl,
    required this.defaultShouldShowCameraSwitchControl,
    required this.defaultInfoAnnotationWidth,
    required this.defaultInfoAnnotationBackgroundColor,
    required this.defaultInfoAnnotationHasTip,
    required this.defaultInfoAnnotationAnchor,
    required this.defaultInfoAnnotationTrigger,
    required this.defaultInfoAnnotationHeaderBackgroundColor,
    required this.defaultInfoAnnotationHeaderTextSize,
    required this.defaultInfoAnnotationHeaderTextColor,
    required this.defaultInfoAnnotationFooterBackgroundColor,
    required this.defaultInfoAnnotationFooterTextSize,
    required this.defaultInfoAnnotationFooterTextColor,
    required this.defaultInfoAnnotationBodyElementTextSize,
    required this.defaultInfoAnnotationBodyElementTextColor,
    required this.defaultInfoAnnotationBodyElementLeftIconTappable,
    required this.defaultInfoAnnotationBodyElementRightIconTappable,
    required this.defaultInfoAnnotationEntireAnnotationTappable,
    required this.defaultInfoAnnotationHeaderIcon,
    required this.defaultInfoAnnotationHeaderText,
    required this.defaultInfoAnnotationFooterIcon,
    required this.defaultInfoAnnotationFooterText,
    required this.defaultInfoAnnotationBodyElementText,
    required this.defaultInfoAnnotationBodyElementStyledText,
    required this.defaultInfoAnnotationBodyElementLeftIcon,
    required this.defaultInfoAnnotationBodyElementRightIcon,
    required this.defaultShouldShowMacroModeControl,
    required this.defaultMacroModeControlPosition,
    required this.defaultBarcodeCheckPopoverAnnotationButtonEnabled,
  });

  factory BarcodeCheckViewDefaults.fromJSON(Map<String, dynamic> json) {
    var defaultRectangleHighlightBrushJson = jsonDecode(json['defaultRectangleHighlightBrush']);
    var defaultRectangleHighlightBrush = NativeBrushDefaults.fromJSON(defaultRectangleHighlightBrushJson).toBrush();

    var defaultPopoverAnnotationTrigger =
        BarcodeCheckAnnotationTriggerSerializer.fromJSON(json['defaultPopoverAnnotationTrigger']);
    var defaultBarcodeCheckPopoverAnnotationButtonTextColor =
        parseColor(json, 'defaultBarcodeCheckPopoverAnnotationButtonTextColor')!;

    var defaultStatusIconAnnotationTrigger =
        BarcodeCheckAnnotationTriggerSerializer.fromJSON(json['defaultStatusIconAnnotationTrigger']);

    var defaultStatusIconAnnotationIcon = ScanditIcon.fromJSON(jsonDecode(json['defaultStatusIconAnnotationIcon']));

    var defaultStatusIconAnnotationTextColor = parseColor(json, 'defaultStatusIconAnnotationTextColor')!;

    var defaultStatusIconAnnotationBackgroundColor = parseColor(json, 'defaultStatusIconAnnotationBackgroundColor')!;

    ScanditIcon? defaultHighlightIcon = parseScanditIcon(json, 'defaultHighlightIcon');

    var circleHighlightPresets =
        BarcodeCheckCircleHighlightPresetsDefaults.fromJSON(json['circleHighlightPresets'] as Map<String, dynamic>);

    ScanditIcon? defaultInfoAnnotationHeaderIcon = parseScanditIcon(json, 'defaultInfoAnnotationHeaderIcon');

    ScanditIcon? defaultInfoAnnotationFooterIcon = parseScanditIcon(json, 'defaultInfoAnnotationFooterIcon');

    ScanditIcon? defaultInfoAnnotationBodyElementLeftIcon =
        parseScanditIcon(json, 'defaultInfoAnnotationBodyElementLeftIcon');

    ScanditIcon? defaultInfoAnnotationBodyElementRightIcon =
        parseScanditIcon(json, 'defaultInfoAnnotationBodyElementRightIcon');

    bool defaultShouldShowMacroModeControl = json['defaultShouldShowMacroModeControl'] ?? false;
    Anchor defaultMacroModeControlPosition =
        parseAnchorOrDefault(json, 'defaultMacroModeControlPosition', Anchor.topRight);

    return BarcodeCheckViewDefaults(
      defaultCameraPosition: CameraPositionDeserializer.cameraPositionFromJSON(json['defaultCameraPosition']),
      defaultSoundEnabled: json['defaultSoundEnabled'],
      defaultHapticsEnabled: json['defaultHapticsEnabled'],
      defaultTorchControlPosition: AnchorDeserializer.fromJSON(json['defaultTorchControlPosition']),
      defaultZoomControlPosition: AnchorDeserializer.fromJSON(json['defaultZoomControlPosition']),
      defaultCameraSwitchControlPosition: AnchorDeserializer.fromJSON(json['defaultCameraSwitchControlPosition']),
      defaultShouldShowTorchControl: json['defaultShouldShowTorchControl'],
      defaultRectangleHighlightBrush: defaultRectangleHighlightBrush,
      defaultPopoverAnnotationTrigger: defaultPopoverAnnotationTrigger,
      defaultBarcodeCheckPopoverAnnotationButtonTextSize:
          parseDouble(json, 'defaultBarcodeCheckPopoverAnnotationButtonTextSize') ?? 0.0,
      defaultBarcodeCheckPopoverAnnotationButtonTextColor: defaultBarcodeCheckPopoverAnnotationButtonTextColor,
      defaultStatusIconAnnotationTrigger: defaultStatusIconAnnotationTrigger,
      defaultStatusIconAnnotationHasTip: json['defaultStatusIconAnnotationHasTip'] as bool,
      defaultStatusIconAnnotationIcon: defaultStatusIconAnnotationIcon,
      defaultStatusIconAnnotationTextColor: defaultStatusIconAnnotationTextColor,
      defaultStatusIconAnnotationBackgroundColor: defaultStatusIconAnnotationBackgroundColor,
      defaultHighlightIcon: defaultHighlightIcon,
      defaultIsEntirePopoverTappable: json['defaultIsEntirePopoverTappable'],
      defaultStatusIconAnnotationText: json['defaultStatusIconAnnotationText'],
      circleHighlightPresets: circleHighlightPresets,
      defaultShouldShowZoomControl: json['defaultShouldShowZoomControl'],
      defaultShouldShowCameraSwitchControl: json['defaultShouldShowCameraSwitchControl'],
      defaultInfoAnnotationWidth:
          BarcodeCheckInfoAnnotationWidthPresetSerializer.fromJSON(json['defaultInfoAnnotationWidth']),
      defaultInfoAnnotationBackgroundColor: ColorDeserializer.fromRgbaHex(json['defaultInfoAnnotationBackgroundColor']),
      defaultInfoAnnotationHasTip: json['defaultInfoAnnotationHasTip'],
      defaultInfoAnnotationAnchor:
          BarcodeCheckInfoAnnotationAnchorSerializer.fromJSON(json['defaultInfoAnnotationAnchor']),
      defaultInfoAnnotationTrigger:
          BarcodeCheckAnnotationTriggerSerializer.fromJSON(json['defaultInfoAnnotationTrigger']),
      defaultInfoAnnotationHeaderBackgroundColor:
          ColorDeserializer.fromRgbaHex(json['defaultInfoAnnotationHeaderBackgroundColor']),
      defaultInfoAnnotationHeaderTextSize: parseDouble(json, 'defaultInfoAnnotationHeaderTextSize') ?? 0.0,
      defaultInfoAnnotationHeaderTextColor: ColorDeserializer.fromRgbaHex(json['defaultInfoAnnotationHeaderTextColor']),
      defaultInfoAnnotationFooterBackgroundColor:
          ColorDeserializer.fromRgbaHex(json['defaultInfoAnnotationFooterBackgroundColor']),
      defaultInfoAnnotationFooterTextSize: parseDouble(json, 'defaultInfoAnnotationFooterTextSize') ?? 0.0,
      defaultInfoAnnotationFooterTextColor: ColorDeserializer.fromRgbaHex(json['defaultInfoAnnotationFooterTextColor']),
      defaultInfoAnnotationBodyElementTextSize: parseDouble(json, 'defaultInfoAnnotationBodyElementTextSize') ?? 0.0,
      defaultInfoAnnotationBodyElementTextColor:
          ColorDeserializer.fromRgbaHex(json['defaultInfoAnnotationBodyElementTextColor']),
      defaultInfoAnnotationBodyElementLeftIconTappable: json['defaultInfoAnnotationBodyElementLeftIconTappable'],
      defaultInfoAnnotationBodyElementRightIconTappable: json['defaultInfoAnnotationBodyElementRightIconTappable'],
      defaultInfoAnnotationEntireAnnotationTappable: json['defaultInfoAnnotationEntireAnnotationTappable'],
      defaultInfoAnnotationHeaderIcon: defaultInfoAnnotationHeaderIcon,
      defaultInfoAnnotationHeaderText: json['defaultInfoAnnotationHeaderText'],
      defaultInfoAnnotationFooterIcon: defaultInfoAnnotationFooterIcon,
      defaultInfoAnnotationFooterText: json['defaultInfoAnnotationFooterText'],
      defaultInfoAnnotationBodyElementText: json['defaultInfoAnnotationBodyElementText'],
      defaultInfoAnnotationBodyElementStyledText: json['defaultInfoAnnotationBodyElementStyledText'],
      defaultInfoAnnotationBodyElementLeftIcon: defaultInfoAnnotationBodyElementLeftIcon,
      defaultInfoAnnotationBodyElementRightIcon: defaultInfoAnnotationBodyElementRightIcon,
      defaultShouldShowMacroModeControl: defaultShouldShowMacroModeControl,
      defaultMacroModeControlPosition: defaultMacroModeControlPosition,
      defaultBarcodeCheckPopoverAnnotationButtonEnabled: json['defaultBarcodeCheckPopoverAnnotationButtonEnabled'],
    );
  }
}

class BarcodeCheckCircleHighlightPresetsDefaults {
  final Map<BarcodeCheckCircleHighlightPreset, BarcodeCheckCircleHighlightDefaults> _circleHighlightPresets;

  const BarcodeCheckCircleHighlightPresetsDefaults(this._circleHighlightPresets);

  factory BarcodeCheckCircleHighlightPresetsDefaults.fromJSON(Map<String, dynamic> json) {
    final presets = json.map((key, value) => MapEntry(BarcodeCheckCircleHighlightPresetSerializer.fromJSON(key),
        BarcodeCheckCircleHighlightDefaults.fromJSON(value)));
    return BarcodeCheckCircleHighlightPresetsDefaults(presets);
  }

  BarcodeCheckCircleHighlightDefaults get(BarcodeCheckCircleHighlightPreset preset) {
    final presetDefault = _circleHighlightPresets[preset];
    if (presetDefault == null) {
      throw ArgumentError('No defaults found for preset ${preset.toString()}');
    }
    return presetDefault;
  }
}

@immutable
class BarcodeCheckCircleHighlightDefaults {
  final Brush defaultBrush;
  final double defaultSize;

  const BarcodeCheckCircleHighlightDefaults(this.defaultBrush, this.defaultSize);

  factory BarcodeCheckCircleHighlightDefaults.fromJSON(Map<String, dynamic> json) {
    final brush = NativeBrushDefaults.fromJSON(jsonDecode(json['brush'])).toBrush();
    final size = (json['size'] as int).toDouble();
    return BarcodeCheckCircleHighlightDefaults(brush, size);
  }
}

@immutable
class BarcodeCheckFeedbackDefaults {
  final Feedback scanned;
  final Feedback tapped;

  const BarcodeCheckFeedbackDefaults(this.scanned, this.tapped);

  factory BarcodeCheckFeedbackDefaults.fromJSON(Map<String, dynamic> json) {
    var scannedJson = json['scanned'];

    Sound? scannedSound;
    Vibration? scannedVibration;

    if (scannedJson.containsKey('sound')) {
      var soundMap = scannedJson['sound'] as Map;
      if (soundMap.isNotEmpty && soundMap.containsKey('resource')) {
        scannedSound = Sound(soundMap['resource']);
      } else {
        scannedSound = Sound(null);
      }
    }
    if (scannedJson.containsKey('vibration')) {
      var vibrationMap = scannedJson['vibration'] as Map;
      if (vibrationMap.isNotEmpty && vibrationMap.containsKey('type')) {
        var vibrationType = vibrationMap['type'];
        switch (vibrationType) {
          case 'selectionHaptic':
            scannedVibration = Vibration.selectionHapticFeedback;
            break;
          case 'successHaptic':
            scannedVibration = Vibration.successHapticFeedback;
            break;
          default:
            scannedVibration = Vibration.defaultVibration;
        }
      } else {
        scannedVibration = Vibration.defaultVibration;
      }
    }
    var scanned = Feedback(scannedVibration, scannedSound);

    var tappedJson = json['tapped'];

    Sound? tappedSound;
    Vibration? tappedVibration;

    if (tappedJson.containsKey('sound')) {
      var soundMap = tappedJson['sound'] as Map;
      if (soundMap.isNotEmpty && soundMap.containsKey('resource')) {
        tappedSound = Sound(soundMap['resource']);
      } else {
        tappedSound = Sound(null);
      }
    }
    if (tappedJson.containsKey('vibration')) {
      var vibrationMap = tappedJson['vibration'] as Map;
      if (vibrationMap.isNotEmpty && vibrationMap.containsKey('type')) {
        var vibrationType = vibrationMap['type'];
        switch (vibrationType) {
          case 'selectionHaptic':
            tappedVibration = Vibration.selectionHapticFeedback;
            break;
          case 'successHaptic':
            tappedVibration = Vibration.successHapticFeedback;
            break;
          default:
            tappedVibration = Vibration.defaultVibration;
        }
      } else {
        tappedVibration = Vibration.defaultVibration;
      }
    }
    var tapped = Feedback(tappedVibration, tappedSound);

    return BarcodeCheckFeedbackDefaults(scanned, tapped);
  }
}
