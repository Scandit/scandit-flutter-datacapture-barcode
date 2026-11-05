/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/map_helper.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/logo_style.dart';

import '../generated/barcode_generated_defaults.dart';
import 'barcode_ar_annotation_trigger.dart';
import 'barcode_ar_highlight.dart';
import 'barcode_ar_info_annotation_anchor.dart';
import 'barcode_ar_info_annotation_width_preset.dart';
import 'barcode_ar_popover_annotation_anchor.dart';
import 'barcode_ar_status_icon_annotation_anchor.dart';

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
// Mirrors BarcodeArFeedbackDefaults.fromJSON's vibration mapping.
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

BarcodeArSettingsDefaults _buildStaticBarcodeArSettingsDefaults() {
  return BarcodeArSettingsDefaults(
      expectsOnlyUniqueBarcodes: BarcodeArSettingsGeneratedDefaults.expectOnlyUniqueBarcodes);
}

BarcodeArFeedbackDefaults _buildStaticBarcodeArFeedbackDefaults() {
  return BarcodeArFeedbackDefaults(
    _buildStaticFeedback(_platformDefault(
      android: BarcodeArFeedbackGeneratedDefaults.scannedAndroid,
      ios: BarcodeArFeedbackGeneratedDefaults.scannedIos,
    )),
    _buildStaticFeedback(_platformDefault(
      android: BarcodeArFeedbackGeneratedDefaults.tappedAndroid,
      ios: BarcodeArFeedbackGeneratedDefaults.tappedIos,
    )),
  );
}

BarcodeArCircleHighlightPresetsDefaults _buildStaticCircleHighlightPresets(Map<String, Object?> json) {
  return BarcodeArCircleHighlightPresetsDefaults(json.map((key, value) {
    final preset = value as Map<String, Object?>;
    return MapEntry(
      BarcodeArCircleHighlightPresetSerializer.fromJSON(key),
      BarcodeArCircleHighlightDefaults(
        _buildStaticBrush(preset['brush'] as Map<String, Object?>),
        (preset['size'] as num).toDouble(),
      ),
    );
  }));
}

BarcodeArViewDefaults _buildStaticBarcodeArViewDefaults() {
  // The highlight brush colours are platform-split: the Android wrapper rounds
  // native's float channels half-up while iOS truncates (#00FFFF73 vs #00FFFF72).
  final highlight = _platformDefault(
    android: BarcodeArViewGeneratedDefaults.highlightAndroid,
    ios: BarcodeArViewGeneratedDefaults.highlightIos,
  );
  const popover = BarcodeArViewGeneratedDefaults.popoverAnnotation;
  const statusIcon = BarcodeArViewGeneratedDefaults.statusIconAnnotation;
  // Platform-split: the info annotation background is white at 80% alpha on
  // Android (0xCC) and fully opaque on iOS.
  final info = _platformDefault(
    android: BarcodeArViewGeneratedDefaults.infoAnnotationAndroid,
    ios: BarcodeArViewGeneratedDefaults.infoAnnotationIos,
  );
  final header = info['header'] as Map<String, Object?>;
  final footer = info['footer'] as Map<String, Object?>;
  final bodyElement = info['bodyElement'] as Map<String, Object?>;
  const responsive = BarcodeArViewGeneratedDefaults.responsiveAnnotation;

  return BarcodeArViewDefaults(
    defaultCameraPosition: CameraPosition.fromJSON(BarcodeArViewGeneratedDefaults.defaultCameraPosition),
    defaultSoundEnabled: BarcodeArViewGeneratedDefaults.soundEnabled,
    defaultHapticsEnabled: BarcodeArViewGeneratedDefaults.hapticEnabled,
    defaultTorchControlPosition: AnchorDeserializer.fromJSON(BarcodeArViewGeneratedDefaults.torchControlPosition),
    defaultZoomControlPosition: AnchorDeserializer.fromJSON(BarcodeArViewGeneratedDefaults.zoomControlPosition),
    defaultCameraSwitchControlPosition:
        AnchorDeserializer.fromJSON(BarcodeArViewGeneratedDefaults.cameraSwitchControlPosition),
    defaultShouldShowTorchControl: BarcodeArViewGeneratedDefaults.shouldShowTorchControl,
    defaultRectangleHighlightBrush: _buildStaticBrush(highlight['rectangleBrush'] as Map<String, Object?>),
    defaultPopoverAnnotationTrigger: BarcodeArAnnotationTriggerSerializer.fromJSON(popover['trigger'] as String),
    defaultBarcodeArPopoverAnnotationButtonTextSize: (popover['buttonTextSize'] as num).toDouble(),
    defaultBarcodeArPopoverAnnotationButtonTextColor:
        ColorDeserializer.fromRgbaHex(popover['buttonTextColor'] as String),
    defaultStatusIconAnnotationTrigger: BarcodeArAnnotationTriggerSerializer.fromJSON(statusIcon['trigger'] as String),
    defaultStatusIconAnnotationAnchor: BarcodeArStatusIconAnnotationAnchor.fromJSON(statusIcon['anchor'] as String),
    defaultLogoStyle: LogoStyleDeserializer.fromJSON(BarcodeArViewGeneratedDefaults.logoStyle),
    defaultLogoAnchor: AnchorDeserializer.fromJSON(BarcodeArViewGeneratedDefaults.logoAnchor),
    defaultLogoOffset: PointWithUnit.fromJSON(BarcodeArViewGeneratedDefaults.logoOffset),
    defaultStatusIconAnnotationHasTip: statusIcon['hasTip'] as bool,
    defaultStatusIconAnnotationIcon:
        ScanditIcon.fromJSON((statusIcon['icon'] as Map<String, Object?>).cast<String, dynamic>()),
    defaultStatusIconAnnotationTextColor: ColorDeserializer.fromRgbaHex(statusIcon['textColor'] as String),
    defaultStatusIconAnnotationBackgroundColor: ColorDeserializer.fromRgbaHex(statusIcon['backgroundColor'] as String),
    defaultHighlightIcon: null,
    defaultIsEntirePopoverTappable: popover['isEntirePopoverTappable'] as bool,
    defaultStatusIconAnnotationText: statusIcon['text'] as String?,
    circleHighlightPresets: _buildStaticCircleHighlightPresets(highlight['circlePresets'] as Map<String, Object?>),
    defaultShouldShowZoomControl: BarcodeArViewGeneratedDefaults.shouldShowZoomControl,
    defaultShouldShowCameraSwitchControl: BarcodeArViewGeneratedDefaults.shouldShowCameraSwitchControl,
    defaultInfoAnnotationWidth: BarcodeArInfoAnnotationWidthPresetSerializer.fromJSON(info['width'] as String),
    defaultInfoAnnotationBackgroundColor: ColorDeserializer.fromRgbaHex(info['backgroundColor'] as String),
    defaultInfoAnnotationHasTip: info['hasTip'] as bool,
    defaultInfoAnnotationAnchor: BarcodeArInfoAnnotationAnchorSerializer.fromJSON(info['anchor'] as String),
    defaultInfoAnnotationTrigger: BarcodeArAnnotationTriggerSerializer.fromJSON(info['trigger'] as String),
    defaultInfoAnnotationHeaderBackgroundColor: ColorDeserializer.fromRgbaHex(header['backgroundColor'] as String),
    defaultInfoAnnotationHeaderTextSize: (header['textSize'] as num).toDouble(),
    defaultInfoAnnotationHeaderTextColor: ColorDeserializer.fromRgbaHex(header['textColor'] as String),
    defaultInfoAnnotationFooterBackgroundColor: ColorDeserializer.fromRgbaHex(footer['backgroundColor'] as String),
    defaultInfoAnnotationFooterTextSize: (footer['textSize'] as num).toDouble(),
    defaultInfoAnnotationFooterTextColor: ColorDeserializer.fromRgbaHex(footer['textColor'] as String),
    defaultInfoAnnotationBodyElementTextSize: (bodyElement['textSize'] as num).toDouble(),
    defaultInfoAnnotationBodyElementTextColor: ColorDeserializer.fromRgbaHex(bodyElement['textColor'] as String),
    defaultInfoAnnotationBodyElementLeftIconTappable: bodyElement['leftIconTappable'] as bool,
    defaultInfoAnnotationBodyElementRightIconTappable: bodyElement['rightIconTappable'] as bool,
    defaultInfoAnnotationEntireAnnotationTappable: info['isEntireAnnotationTappable'] as bool,
    defaultInfoAnnotationHeaderIcon: null,
    defaultInfoAnnotationHeaderText: header['text'] as String?,
    defaultInfoAnnotationFooterIcon: null,
    defaultInfoAnnotationFooterText: footer['text'] as String?,
    defaultInfoAnnotationBodyElementText: bodyElement['text'] as String?,
    defaultInfoAnnotationBodyElementStyledText: bodyElement['styledText'] as String?,
    defaultInfoAnnotationBodyElementLeftIcon: null,
    defaultInfoAnnotationBodyElementRightIcon: null,
    defaultShouldShowMacroModeControl: BarcodeArViewGeneratedDefaults.shouldShowMacroModeControl,
    defaultMacroModeControlPosition:
        AnchorDeserializer.fromJSON(BarcodeArViewGeneratedDefaults.macroModeControlPosition),
    defaultBarcodeArPopoverAnnotationButtonEnabled: popover['buttonEnabled'] as bool,
    defaultBarcodeArPopoverAnnotationAnchor: BarcodeArPopoverAnnotationAnchor.fromJSON(popover['anchor'] as String),
    defaultResponsiveAnnotationThreshold: (responsive['threshold'] as num).toDouble(),
    defaultResponsiveAnnotationTrigger: BarcodeArAnnotationTriggerSerializer.fromJSON(responsive['trigger'] as String),
    defaultHighlightIsPulsing: highlight['isPulsing'] as bool,
  );
}

// ignore: avoid_classes_with_only_static_members
class BarcodeArDefaults {
  static late CameraSettingsDefaults _recommendedCameraSettings;

  static CameraSettingsDefaults get recommendedCameraSettings => _recommendedCameraSettings;

  // Statically sourced from generated/barcode_generated_defaults.dart - byte
  // identical to the native getDefaults() response, available immediately, no
  // method-channel round trip needed. See SDC-32174.
  static final BarcodeArFeedbackDefaults _feedbackDefaults = _buildStaticBarcodeArFeedbackDefaults();

  static BarcodeArFeedbackDefaults get feedbackDefaults => _feedbackDefaults;

  static final BarcodeArViewDefaults _view = _buildStaticBarcodeArViewDefaults();

  static BarcodeArViewDefaults get view => _view;

  static final BarcodeArSettingsDefaults _settings = _buildStaticBarcodeArSettingsDefaults();

  static BarcodeArSettingsDefaults get settings => _settings;

  static bool _isInitialized = false;

  // RecommendedCameraSettings stays fully dynamic - see the id package.
  static void initializeDefaults(Map<String, dynamic> barcodeArDefaults) {
    if (_isInitialized) return;
    _recommendedCameraSettings = CameraSettingsDefaults.fromJSON(barcodeArDefaults['RecommendedCameraSettings']);
    _isInitialized = true;
  }
}

@immutable
class BarcodeArSettingsDefaults {
  final bool expectsOnlyUniqueBarcodes;

  const BarcodeArSettingsDefaults({required this.expectsOnlyUniqueBarcodes});

  factory BarcodeArSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    return BarcodeArSettingsDefaults(
      expectsOnlyUniqueBarcodes: json['expectOnlyUniqueBarcodes'] as bool,
    );
  }
}

@immutable
class BarcodeArViewDefaults {
  final CameraPosition defaultCameraPosition;
  final bool defaultSoundEnabled;
  final bool defaultHapticsEnabled;
  final Anchor defaultTorchControlPosition;
  final Anchor defaultZoomControlPosition;
  final Anchor defaultCameraSwitchControlPosition;
  final bool defaultShouldShowTorchControl;
  final Brush defaultRectangleHighlightBrush;
  final BarcodeArAnnotationTrigger defaultPopoverAnnotationTrigger;
  final double defaultBarcodeArPopoverAnnotationButtonTextSize;
  final Color defaultBarcodeArPopoverAnnotationButtonTextColor;
  final bool defaultBarcodeArPopoverAnnotationButtonEnabled;
  final BarcodeArPopoverAnnotationAnchor defaultBarcodeArPopoverAnnotationAnchor;
  final BarcodeArAnnotationTrigger defaultStatusIconAnnotationTrigger;
  final BarcodeArStatusIconAnnotationAnchor defaultStatusIconAnnotationAnchor;
  final LogoStyle defaultLogoStyle;
  final Anchor defaultLogoAnchor;
  final PointWithUnit defaultLogoOffset;
  final bool defaultStatusIconAnnotationHasTip;
  final ScanditIcon defaultStatusIconAnnotationIcon;
  final Color defaultStatusIconAnnotationTextColor;
  final Color defaultStatusIconAnnotationBackgroundColor;
  final ScanditIcon? defaultHighlightIcon;
  final bool defaultIsEntirePopoverTappable;
  final String? defaultStatusIconAnnotationText;
  final BarcodeArCircleHighlightPresetsDefaults circleHighlightPresets;
  final bool defaultShouldShowZoomControl;
  final bool defaultShouldShowCameraSwitchControl;
  final BarcodeArInfoAnnotationWidthPreset defaultInfoAnnotationWidth;
  final Color defaultInfoAnnotationBackgroundColor;
  final bool defaultInfoAnnotationHasTip;
  final BarcodeArInfoAnnotationAnchor defaultInfoAnnotationAnchor;
  final BarcodeArAnnotationTrigger defaultInfoAnnotationTrigger;
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
  final double defaultResponsiveAnnotationThreshold;
  final BarcodeArAnnotationTrigger defaultResponsiveAnnotationTrigger;
  final bool defaultHighlightIsPulsing;

  const BarcodeArViewDefaults({
    required this.defaultCameraPosition,
    required this.defaultSoundEnabled,
    required this.defaultHapticsEnabled,
    required this.defaultTorchControlPosition,
    required this.defaultZoomControlPosition,
    required this.defaultCameraSwitchControlPosition,
    required this.defaultShouldShowTorchControl,
    required this.defaultRectangleHighlightBrush,
    required this.defaultPopoverAnnotationTrigger,
    required this.defaultBarcodeArPopoverAnnotationButtonTextSize,
    required this.defaultBarcodeArPopoverAnnotationButtonTextColor,
    required this.defaultStatusIconAnnotationTrigger,
    required this.defaultStatusIconAnnotationAnchor,
    required this.defaultLogoStyle,
    required this.defaultLogoAnchor,
    required this.defaultLogoOffset,
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
    required this.defaultBarcodeArPopoverAnnotationButtonEnabled,
    required this.defaultBarcodeArPopoverAnnotationAnchor,
    required this.defaultResponsiveAnnotationThreshold,
    required this.defaultResponsiveAnnotationTrigger,
    required this.defaultHighlightIsPulsing,
  });

  factory BarcodeArViewDefaults.fromJSON(Map<String, dynamic> json) {
    var defaultRectangleHighlightBrushJson = jsonDecode(json['defaultRectangleHighlightBrush']);
    var defaultRectangleHighlightBrush = NativeBrushDefaults.fromJSON(defaultRectangleHighlightBrushJson).toBrush();

    var defaultPopoverAnnotationTrigger =
        BarcodeArAnnotationTriggerSerializer.fromJSON(json['defaultPopoverAnnotationTrigger']);
    var defaultBarcodeArPopoverAnnotationButtonTextColor =
        parseColor(json, 'defaultBarcodeArPopoverAnnotationButtonTextColor')!;

    var defaultStatusIconAnnotationTrigger =
        BarcodeArAnnotationTriggerSerializer.fromJSON(json['defaultStatusIconAnnotationTrigger']);

    var defaultStatusIconAnnotationAnchor =
        BarcodeArStatusIconAnnotationAnchor.fromJSON(json['defaultStatusIconAnnotationAnchor'] as String);

    var defaultLogoStyle = LogoStyleDeserializer.fromJSON(json['defaultLogoStyle']);
    var defaultLogoAnchor = AnchorDeserializer.fromJSON(json['defaultLogoAnchor']);
    var defaultLogoOffset = PointWithUnit.fromJSON(jsonDecode(json['defaultLogoOffset']));

    var defaultStatusIconAnnotationIcon = ScanditIcon.fromJSON(jsonDecode(json['defaultStatusIconAnnotationIcon']));

    var defaultStatusIconAnnotationTextColor = parseColor(json, 'defaultStatusIconAnnotationTextColor')!;

    var defaultStatusIconAnnotationBackgroundColor = parseColor(json, 'defaultStatusIconAnnotationBackgroundColor')!;

    ScanditIcon? defaultHighlightIcon = parseScanditIcon(json, 'defaultHighlightIcon');

    var circleHighlightPresets =
        BarcodeArCircleHighlightPresetsDefaults.fromJSON(json['circleHighlightPresets'] as Map<String, dynamic>);

    ScanditIcon? defaultInfoAnnotationHeaderIcon = parseScanditIcon(json, 'defaultInfoAnnotationHeaderIcon');

    ScanditIcon? defaultInfoAnnotationFooterIcon = parseScanditIcon(json, 'defaultInfoAnnotationFooterIcon');

    ScanditIcon? defaultInfoAnnotationBodyElementLeftIcon =
        parseScanditIcon(json, 'defaultInfoAnnotationBodyElementLeftIcon');

    ScanditIcon? defaultInfoAnnotationBodyElementRightIcon =
        parseScanditIcon(json, 'defaultInfoAnnotationBodyElementRightIcon');

    bool defaultShouldShowMacroModeControl = json['defaultShouldShowMacroModeControl'] ?? false;
    Anchor defaultMacroModeControlPosition =
        parseAnchorOrDefault(json, 'defaultMacroModeControlPosition', Anchor.topRight);

    double defaultResponsiveAnnotationThreshold = parseDouble(json, 'defaultResponsiveAnnotationThreshold') ?? 0.0;
    BarcodeArAnnotationTrigger defaultResponsiveAnnotationTrigger =
        BarcodeArAnnotationTriggerSerializer.fromJSON(json['defaultResponsiveAnnotationTrigger']);

    return BarcodeArViewDefaults(
      defaultCameraPosition: CameraPosition.fromJSON(json['defaultCameraPosition']),
      defaultSoundEnabled: json['defaultSoundEnabled'],
      defaultHapticsEnabled: json['defaultHapticsEnabled'],
      defaultTorchControlPosition: AnchorDeserializer.fromJSON(json['defaultTorchControlPosition']),
      defaultZoomControlPosition: AnchorDeserializer.fromJSON(json['defaultZoomControlPosition']),
      defaultCameraSwitchControlPosition: AnchorDeserializer.fromJSON(json['defaultCameraSwitchControlPosition']),
      defaultShouldShowTorchControl: json['defaultShouldShowTorchControl'],
      defaultRectangleHighlightBrush: defaultRectangleHighlightBrush,
      defaultPopoverAnnotationTrigger: defaultPopoverAnnotationTrigger,
      defaultBarcodeArPopoverAnnotationButtonTextSize:
          parseDouble(json, 'defaultBarcodeArPopoverAnnotationButtonTextSize') ?? 0.0,
      defaultBarcodeArPopoverAnnotationButtonTextColor: defaultBarcodeArPopoverAnnotationButtonTextColor,
      defaultStatusIconAnnotationTrigger: defaultStatusIconAnnotationTrigger,
      defaultStatusIconAnnotationAnchor: defaultStatusIconAnnotationAnchor,
      defaultLogoStyle: defaultLogoStyle,
      defaultLogoAnchor: defaultLogoAnchor,
      defaultLogoOffset: defaultLogoOffset,
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
          BarcodeArInfoAnnotationWidthPresetSerializer.fromJSON(json['defaultInfoAnnotationWidth']),
      defaultInfoAnnotationBackgroundColor: ColorDeserializer.fromRgbaHex(json['defaultInfoAnnotationBackgroundColor']),
      defaultInfoAnnotationHasTip: json['defaultInfoAnnotationHasTip'],
      defaultInfoAnnotationAnchor:
          BarcodeArInfoAnnotationAnchorSerializer.fromJSON(json['defaultInfoAnnotationAnchor']),
      defaultInfoAnnotationTrigger: BarcodeArAnnotationTriggerSerializer.fromJSON(json['defaultInfoAnnotationTrigger']),
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
      defaultBarcodeArPopoverAnnotationButtonEnabled: json['defaultBarcodeArPopoverAnnotationButtonEnabled'],
      defaultBarcodeArPopoverAnnotationAnchor:
          BarcodeArPopoverAnnotationAnchor.fromJSON(json['defaultBarcodeArPopoverAnnotationAnchor']),
      defaultResponsiveAnnotationThreshold: defaultResponsiveAnnotationThreshold,
      defaultResponsiveAnnotationTrigger: defaultResponsiveAnnotationTrigger,
      defaultHighlightIsPulsing: json['defaultHighlightIsPulsing'] ?? false,
    );
  }
}

class BarcodeArCircleHighlightPresetsDefaults {
  final Map<BarcodeArCircleHighlightPreset, BarcodeArCircleHighlightDefaults> _circleHighlightPresets;

  const BarcodeArCircleHighlightPresetsDefaults(this._circleHighlightPresets);

  factory BarcodeArCircleHighlightPresetsDefaults.fromJSON(Map<String, dynamic> json) {
    final presets = json.map((key, value) => MapEntry(
        BarcodeArCircleHighlightPresetSerializer.fromJSON(key), BarcodeArCircleHighlightDefaults.fromJSON(value)));
    return BarcodeArCircleHighlightPresetsDefaults(presets);
  }

  BarcodeArCircleHighlightDefaults get(BarcodeArCircleHighlightPreset preset) {
    final presetDefault = _circleHighlightPresets[preset];
    if (presetDefault == null) {
      throw ArgumentError('No defaults found for preset ${preset.toString()}');
    }
    return presetDefault;
  }
}

@immutable
class BarcodeArCircleHighlightDefaults {
  final Brush defaultBrush;
  final double defaultSize;

  const BarcodeArCircleHighlightDefaults(this.defaultBrush, this.defaultSize);

  factory BarcodeArCircleHighlightDefaults.fromJSON(Map<String, dynamic> json) {
    final brush = NativeBrushDefaults.fromJSON(jsonDecode(json['brush'])).toBrush();
    final size = (json['size'] as int).toDouble();
    return BarcodeArCircleHighlightDefaults(brush, size);
  }
}

@immutable
class BarcodeArFeedbackDefaults {
  final Feedback scanned;
  final Feedback tapped;

  const BarcodeArFeedbackDefaults(this.scanned, this.tapped);

  factory BarcodeArFeedbackDefaults.fromJSON(Map<String, dynamic> json) {
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

    return BarcodeArFeedbackDefaults(scanned, tapped);
  }
}
