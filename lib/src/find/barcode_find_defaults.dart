/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:io' show Platform;
import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../generated/barcode_generated_defaults.dart';

// Picks the platform-split value of a generated default. Kept private per
// file, mirroring core's and id's own copies.
T _platformDefault<T>({required T android, required T ios}) => Platform.isIOS ? ios : android;

// Builds a Feedback from a generated {vibration, sound} default literal,
// mirroring BarcodeFindFeedbackDefaults.fromJSON's vibration mapping.
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
      case 'impactHaptic':
        vibration = Vibration.impactHapticFeedback;
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

BarcodeFindFeedbackDefaults _buildStaticBarcodeFindFeedbackDefaults() {
  return BarcodeFindFeedbackDefaults(
    _buildStaticFeedback(_platformDefault(
      android: BarcodeFindFeedbackGeneratedDefaults.foundAndroid,
      ios: BarcodeFindFeedbackGeneratedDefaults.foundIos,
    )),
    _buildStaticFeedback(BarcodeFindFeedbackGeneratedDefaults.itemListUpdated),
  );
}

BarcodeFindViewSettingsDefaults _buildStaticBarcodeFindViewSettingsDefaults() {
  // The progress-bar colours are platform-split: Android's wrapper emits a
  // 0.9 alpha (#E5) where iOS emits the opaque #FF.
  return BarcodeFindViewSettingsDefaults(
    ColorDeserializer.fromRgbaHex(_platformDefault(
      android: BarcodeFindViewSettingsGeneratedDefaults.progressBarStartColorAndroid,
      ios: BarcodeFindViewSettingsGeneratedDefaults.progressBarStartColorIos,
    )),
    ColorDeserializer.fromRgbaHex(_platformDefault(
      android: BarcodeFindViewSettingsGeneratedDefaults.progressBarFinishColorAndroid,
      ios: BarcodeFindViewSettingsGeneratedDefaults.progressBarFinishColorIos,
    )),
  );
}

// Builds the statically sourceable portion of BarcodeFindViewDefaults. The
// localized `textFor*Hint` strings and the device-probed
// hardwareTriggerSupported flag are NOT in the generated consts, so they take
// the same values the JSON path uses for an absent key (null / false) until
// initializeDefaults replaces the whole object from the native response.
BarcodeFindViewDefaults _buildStaticBarcodeFindViewDefaults() {
  return BarcodeFindViewDefaults(
    BarcodeFindViewGeneratedDefaults.shouldShowCarousel,
    BarcodeFindViewGeneratedDefaults.shouldShowFinishButton,
    BarcodeFindViewGeneratedDefaults.shouldShowHints,
    BarcodeFindViewGeneratedDefaults.shouldShowPauseButton,
    BarcodeFindViewGeneratedDefaults.shouldShowProgressBar,
    BarcodeFindViewGeneratedDefaults.shouldShowUserGuidanceView,
    BarcodeFindViewGeneratedDefaults.shouldShowTorchControl,
    BarcodeFindViewGeneratedDefaults.shouldShowZoomControl,
    false,
    null,
    null,
    null,
    null,
    null,
    null,
    AnchorDeserializer.fromJSON(BarcodeFindViewGeneratedDefaults.torchControlPosition),
    null,
    null,
    LogoStyle.fromJSON(BarcodeFindViewGeneratedDefaults.logoStyle),
    AnchorDeserializer.fromJSON(BarcodeFindViewGeneratedDefaults.logoAnchor),
    FrameSourceState.fromJSON(BarcodeFindViewGeneratedDefaults.cameraStateOnStop),
  );
}

class BarcodeFindDefaults {
  static late CameraSettingsDefaults _cameraSettingsDefaults;

  static CameraSettingsDefaults get cameraSettingsDefaults => _cameraSettingsDefaults;

  // Statically sourced from generated/barcode_generated_defaults.dart - byte
  // identical to the native getDefaults() response, available immediately, no
  // method-channel round trip needed. See SDC-32174.
  static final BarcodeFindFeedbackDefaults _barcodeFindFeedbackDefaults = _buildStaticBarcodeFindFeedbackDefaults();

  static BarcodeFindFeedbackDefaults get barcodeFindFeedbackDefaults => _barcodeFindFeedbackDefaults;

  // Not `final`: the localized hint texts and hardwareTriggerSupported can only
  // come from native, so initializeDefaults still replaces this object.
  static BarcodeFindViewDefaults _barcodeFindViewDefaults = _buildStaticBarcodeFindViewDefaults();

  static BarcodeFindViewDefaults get barcodeFindViewDefaults => _barcodeFindViewDefaults;

  static final BarcodeFindViewSettingsDefaults _barcodeFindViewSettingsDefaults =
      _buildStaticBarcodeFindViewSettingsDefaults();

  static BarcodeFindViewSettingsDefaults get barcodeFindViewSettingsDefaults => _barcodeFindViewSettingsDefaults;

  static bool _isInitialized = false;

  // Residual dynamic set: RecommendedCameraSettings (see the id package) and
  // the BarcodeFindView localized texts / hardware-trigger probe.
  static void initializeDefaults(Map<String, dynamic> barcodeFindDefaults) {
    if (_isInitialized) return;
    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(barcodeFindDefaults['RecommendedCameraSettings']);
    _barcodeFindViewDefaults =
        BarcodeFindViewDefaults.fromJSON(barcodeFindDefaults["BarcodeFindView"] as Map<String, dynamic>);
    _isInitialized = true;
  }
}

@immutable
class BarcodeFindViewSettingsDefaults {
  final Color progressBarStartColor;
  final Color progressBarFinishColor;

  const BarcodeFindViewSettingsDefaults(this.progressBarStartColor, this.progressBarFinishColor);

  factory BarcodeFindViewSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    return BarcodeFindViewSettingsDefaults(
      ColorDeserializer.fromRgbaHex(json['progressBarStartColor'] as String),
      ColorDeserializer.fromRgbaHex(json['progressBarFinishColor'] as String),
    );
  }
}

@immutable
class BarcodeFindViewDefaults {
  final bool shouldShowCarousel;
  final bool shouldShowFinishButton;
  final bool shouldShowHints;
  final bool shouldShowPauseButton;
  final bool shouldShowProgressBar;
  final bool shouldShowUserGuidanceView;
  final bool shouldShowTorchControl;
  final bool shouldShowZoomControl;
  final bool hardwareTriggerSupported;
  final String? textForAllItemsFoundSuccessfullyHint;
  final String? textForCollapseCardsButton;
  final String? textForMoveCloserToBarcodesHint;
  final String? textForPointAtBarcodesToSearchHint;
  final String? textForTapShutterToPauseScreenHint;
  final String? textForTapShutterToResumeSearchHint;
  final Anchor torchControlPosition;
  final String? textForItemListUpdatedHint;
  final String? textForItemListUpdatedWhenPausedHint;
  final LogoStyle logoStyle;
  final Anchor logoAnchor;
  final FrameSourceState cameraStateOnStop;

  const BarcodeFindViewDefaults(
      this.shouldShowCarousel,
      this.shouldShowFinishButton,
      this.shouldShowHints,
      this.shouldShowPauseButton,
      this.shouldShowProgressBar,
      this.shouldShowUserGuidanceView,
      this.shouldShowTorchControl,
      this.shouldShowZoomControl,
      this.hardwareTriggerSupported,
      this.textForAllItemsFoundSuccessfullyHint,
      this.textForCollapseCardsButton,
      this.textForMoveCloserToBarcodesHint,
      this.textForPointAtBarcodesToSearchHint,
      this.textForTapShutterToPauseScreenHint,
      this.textForTapShutterToResumeSearchHint,
      this.torchControlPosition,
      this.textForItemListUpdatedHint,
      this.textForItemListUpdatedWhenPausedHint,
      this.logoStyle,
      this.logoAnchor,
      this.cameraStateOnStop);

  factory BarcodeFindViewDefaults.fromJSON(Map<String, dynamic> json) {
    var torchControlPosition = Anchor.topLeft;
    if (json.containsKey('torchControlPosition')) {
      torchControlPosition = AnchorDeserializer.fromJSON(json['torchControlPosition'] as String);
    }

    var shouldShowTorchControl = false;
    if (json.containsKey('shouldShowTorchControl')) {
      shouldShowTorchControl = json["shouldShowTorchControl"] as bool;
    }

    var shouldShowZoomControl = false;
    if (json.containsKey('shouldShowZoomControl')) {
      shouldShowZoomControl = json["shouldShowZoomControl"] as bool;
    }

    var hardwareTriggerSupported = false;
    if (json.containsKey('hardwareTriggerSupported')) {
      hardwareTriggerSupported = json["hardwareTriggerSupported"] as bool;
    }

    var logoStyle = LogoStyle.fromJSON(json['logoStyle'] as String);
    var logoAnchor = AnchorDeserializer.fromJSON(json['logoAnchor'] as String);

    // cameraStateOnStop is iOS-only; the Android defaults do not emit it.
    var cameraStateOnStop = FrameSourceState.fromJSON(json['cameraStateOnStop'] as String? ?? 'off');

    return BarcodeFindViewDefaults(
      json["shouldShowCarousel"] as bool,
      json["shouldShowFinishButton"] as bool,
      json["shouldShowHints"] as bool,
      json["shouldShowPauseButton"] as bool,
      json["shouldShowProgressBar"] as bool,
      json["shouldShowUserGuidanceView"] as bool,
      shouldShowTorchControl,
      shouldShowZoomControl,
      hardwareTriggerSupported,
      json["textForAllItemsFoundSuccessfullyHint"] as String?,
      json["textForCollapseCardsButton"] as String?,
      json["textForMoveCloserToBarcodesHint"] as String?,
      json["textForPointAtBarcodesToSearchHint"] as String?,
      json["textForTapShutterToPauseScreenHint"] as String?,
      json["textForTapShutterToResumeSearchHint"] as String?,
      torchControlPosition,
      json["textForItemListUpdatedHint"] as String?,
      json["textForItemListUpdatedWhenPausedHint"] as String?,
      logoStyle,
      logoAnchor,
      cameraStateOnStop,
    );
  }
}

@immutable
class BarcodeFindFeedbackDefaults {
  final Feedback found;
  final Feedback itemListUpdated;

  const BarcodeFindFeedbackDefaults(this.found, this.itemListUpdated);

  factory BarcodeFindFeedbackDefaults.fromJSON(Map<String, dynamic> json) {
    var foundJson = json['found'];

    Sound? foundSound;
    Vibration? foundVibration;

    if (foundJson.containsKey('sound')) {
      var soundMap = foundJson['sound'] as Map;
      if (soundMap.isNotEmpty && soundMap.containsKey('resource')) {
        foundSound = Sound(soundMap['resource']);
      } else {
        foundSound = Sound(null);
      }
    }
    if (foundJson.containsKey('vibration')) {
      var vibrationMap = foundJson['vibration'] as Map;
      if (vibrationMap.isNotEmpty && vibrationMap.containsKey('type')) {
        var vibrationType = vibrationMap['type'];
        switch (vibrationType) {
          case 'selectionHaptic':
            foundVibration = Vibration.selectionHapticFeedback;
            break;
          case 'successHaptic':
            foundVibration = Vibration.successHapticFeedback;
            break;
          case 'impactHaptic':
            foundVibration = Vibration.impactHapticFeedback;
            break;
          default:
            foundVibration = Vibration.defaultVibration;
        }
      } else {
        foundVibration = Vibration.defaultVibration;
      }
    }

    var itemListUpdatedJson = json['itemListUpdated'];

    Sound? itemListUpdatedSound;
    Vibration? itemListUpdatedVibration;

    if (itemListUpdatedJson.containsKey('sound')) {
      var soundMap = itemListUpdatedJson['sound'] as Map;
      if (soundMap.isNotEmpty && soundMap.containsKey('resource')) {
        itemListUpdatedSound = Sound(soundMap['resource']);
      } else {
        itemListUpdatedSound = Sound(null);
      }
    }
    if (itemListUpdatedJson.containsKey('vibration')) {
      var vibrationMap = itemListUpdatedJson['vibration'] as Map;
      if (vibrationMap.isNotEmpty && vibrationMap.containsKey('type')) {
        var vibrationType = vibrationMap['type'];
        switch (vibrationType) {
          case 'selectionHaptic':
            itemListUpdatedVibration = Vibration.selectionHapticFeedback;
            break;
          case 'successHaptic':
            itemListUpdatedVibration = Vibration.successHapticFeedback;
            break;
          case 'impactHaptic':
            itemListUpdatedVibration = Vibration.impactHapticFeedback;
            break;
          default:
            itemListUpdatedVibration = Vibration.defaultVibration;
        }
      } else {
        itemListUpdatedVibration = Vibration.defaultVibration;
      }
    }
    return BarcodeFindFeedbackDefaults(
      Feedback(foundVibration, foundSound),
      Feedback(itemListUpdatedVibration, itemListUpdatedSound),
    );
  }
}
