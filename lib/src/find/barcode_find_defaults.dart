/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'barcode_find_function_names.dart';

class BarcodeFindDefaults {
  static MethodChannel mainChannel = MethodChannel(BarcodeFindFunctionNames.methodsChannelName);

  static late CameraSettingsDefaults _cameraSettingsDefaults;

  static CameraSettingsDefaults get cameraSettingsDefaults => _cameraSettingsDefaults;

  static late BarcodeFindFeedbackDefaults _barcodeFindFeedbackDefaults;

  static BarcodeFindFeedbackDefaults get barcodeFindFeedbackDefaults => _barcodeFindFeedbackDefaults;

  static late BarcodeFindViewDefaults _barcodeFindViewDefaults;

  static BarcodeFindViewDefaults get barcodeFindViewDefaults => _barcodeFindViewDefaults;

  static bool _isInitialized = false;

  static Future<void> initializeDefaults() async {
    if (_isInitialized) return;
    var result = await mainChannel.invokeMethod(BarcodeFindFunctionNames.getBarcodeFindDefaults);
    var json = jsonDecode(result as String);

    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(json['RecommendedCameraSettings']);
    _barcodeFindFeedbackDefaults =
        BarcodeFindFeedbackDefaults.fromJSON(jsonDecode(json["BarcodeFindFeedback"]) as Map<String, dynamic>);
    _barcodeFindViewDefaults = BarcodeFindViewDefaults.fromJSON(json["BarcodeFindView"] as Map<String, dynamic>);

    _isInitialized = true;
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
  final String? textForAllItemsFoundSuccessfullyHint;
  final String? textForCollapseCardsButton;
  final String? textForMoveCloserToBarcodesHint;
  final String? textForPointAtBarcodesToSearchHint;
  final String? textForTapShutterToPauseScreenHint;
  final String? textForTapShutterToResumeSearchHint;
  final Anchor torchControlPosition;
  final String? textForItemListUpdatedHint;
  final String? textForItemListUpdatedWhenPausedHint;

  BarcodeFindViewDefaults(
      this.shouldShowCarousel,
      this.shouldShowFinishButton,
      this.shouldShowHints,
      this.shouldShowPauseButton,
      this.shouldShowProgressBar,
      this.shouldShowUserGuidanceView,
      this.shouldShowTorchControl,
      this.textForAllItemsFoundSuccessfullyHint,
      this.textForCollapseCardsButton,
      this.textForMoveCloserToBarcodesHint,
      this.textForPointAtBarcodesToSearchHint,
      this.textForTapShutterToPauseScreenHint,
      this.textForTapShutterToResumeSearchHint,
      this.torchControlPosition,
      this.textForItemListUpdatedHint,
      this.textForItemListUpdatedWhenPausedHint);

  factory BarcodeFindViewDefaults.fromJSON(Map<String, dynamic> json) {
    var torchControlPosition = Anchor.topLeft;
    if (json.containsKey('torchControlPosition')) {
      torchControlPosition = AnchorDeserializer.fromJSON(json['torchControlPosition'] as String);
    }

    var shouldShowTorchControl = false;
    if (json.containsKey('shouldShowTorchControl')) {
      shouldShowTorchControl = json["shouldShowTorchControl"] as bool;
    }

    return BarcodeFindViewDefaults(
      json["shouldShowCarousel"] as bool,
      json["shouldShowFinishButton"] as bool,
      json["shouldShowHints"] as bool,
      json["shouldShowPauseButton"] as bool,
      json["shouldShowProgressBar"] as bool,
      json["shouldShowUserGuidanceView"] as bool,
      shouldShowTorchControl,
      json["textForAllItemsFoundSuccessfullyHint"] as String?,
      json["textForCollapseCardsButton"] as String?,
      json["textForMoveCloserToBarcodesHint"] as String?,
      json["textForPointAtBarcodesToSearchHint"] as String?,
      json["textForTapShutterToPauseScreenHint"] as String?,
      json["textForTapShutterToResumeSearchHint"] as String?,
      torchControlPosition,
      json["textForItemListUpdatedHint"] as String?,
      json["textForItemListUpdatedWhenPausedHint"] as String?,
    );
  }
}

@immutable
class BarcodeFindFeedbackDefaults {
  final Feedback found;
  final Feedback itemListUpdated;

  BarcodeFindFeedbackDefaults(this.found, this.itemListUpdated);

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
