/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_mini_preview_size.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/feedback.dart' as feedback;

import 'spark_scan_function_names.dart';
import 'spark_scan_view_capture_mode.dart';

// ignore: avoid_classes_with_only_static_members
class SparkScanDefaults {
  static MethodChannel mainChannel = const MethodChannel(SparkScanFunctionNames.methodsChannelName);

  static late SparkScanSettingsDefaults _sparkScanSettingsDefaults;

  static SparkScanSettingsDefaults get sparkScanSettingsDefaults => _sparkScanSettingsDefaults;

  static late SparkScanFeedbackDefaults _sparkScanFeedbackDefaults;

  static SparkScanFeedbackDefaults get sparkScanFeedbackDefaults => _sparkScanFeedbackDefaults;

  static late SparkScanViewDefaults _sparkScanViewDefaults;

  static SparkScanViewDefaults get sparkScanViewDefaults => _sparkScanViewDefaults;

  static bool _isInitialized = false;

  static Future<void> initializeDefaults() async {
    if (_isInitialized) return;
    var result = await mainChannel.invokeMethod(SparkScanFunctionNames.getSparkScanDefaults);
    var json = jsonDecode(result as String);
    _sparkScanSettingsDefaults = SparkScanSettingsDefaults.fromJSON(json['SparkScanSettings'] as Map<String, dynamic>);
    _sparkScanFeedbackDefaults = SparkScanFeedbackDefaults.fromJSON(json['Feedback']);
    _sparkScanViewDefaults = SparkScanViewDefaults.fromJSON(json['SparkScanView']);

    _isInitialized = true;
  }
}

@immutable
class SparkScanViewDefaults {
  final Brush defaultBrush;
  final bool torchControlVisible;
  final bool scanningBehaviorButtonVisible;
  final bool barcodeCountButtonVisible;
  final bool barcodeFindButtonVisible;
  final bool targetModeButtonVisible;
  final bool soundModeButtonVisible;
  final bool hapticModeButtonVisible;
  final Color? toolbarBackgroundColor;
  final Color? toolbarIconActiveTintColor;
  final Color? toolbarIconInactiveTintColor;
  final bool zoomSwitchControlVisible;
  final bool previewSizeControlVisible;

  final SparkScanViewSettingsDefaults viewSettingsDefaults;

  final bool hardwareTriggerSupported;
  final bool cameraSwitchButtonVisible;

  final bool previewCloseControlVisible;
  final String? triggerButtonImage;

  final Color? triggerButtonCollapsedColor;
  final Color? triggerButtonExpandedColor;
  final Color? triggerButtonAnimationColor;
  final Color? triggerButtonTintColor;
  final bool triggerButtonVisible;

  const SparkScanViewDefaults(
      this.defaultBrush,
      this.torchControlVisible,
      this.scanningBehaviorButtonVisible,
      this.barcodeCountButtonVisible,
      this.barcodeFindButtonVisible,
      this.targetModeButtonVisible,
      this.soundModeButtonVisible,
      this.hapticModeButtonVisible,
      this.toolbarBackgroundColor,
      this.toolbarIconActiveTintColor,
      this.toolbarIconInactiveTintColor,
      this.viewSettingsDefaults,
      this.zoomSwitchControlVisible,
      this.hardwareTriggerSupported,
      this.previewSizeControlVisible,
      this.cameraSwitchButtonVisible,
      this.previewCloseControlVisible,
      this.triggerButtonImage,
      this.triggerButtonCollapsedColor,
      this.triggerButtonExpandedColor,
      this.triggerButtonAnimationColor,
      this.triggerButtonTintColor,
      this.triggerButtonVisible);

  factory SparkScanViewDefaults.fromJSON(Map<String, dynamic> json) {
    final defaultBrush = BrushDefaults.fromJSON(json['brush'] as Map<String, dynamic>).toBrush();
    final torchControlVisible = json['torchControlVisible'] as bool;
    final scanningBehaviorButtonVisible = json['scanningBehaviorButtonVisible'] as bool;
    final barcodeCountButtonVisible = json['barcodeCountButtonVisible'] as bool;
    final barcodeFindButtonVisible = json['barcodeFindButtonVisible'] as bool;
    final targetModeButtonVisible = json['targetModeButtonVisible'] as bool;

    Color? toolbarBackgroundColor;
    if (json['toolbarBackgroundColor'] != null) {
      toolbarBackgroundColor = ColorDeserializer.fromRgbaHex(json['toolbarBackgroundColor']);
    }

    Color? toolbarIconActiveTintColor;
    if (json['toolbarIconActiveTintColor'] != null) {
      toolbarIconActiveTintColor = ColorDeserializer.fromRgbaHex(json['toolbarIconActiveTintColor']);
    }

    Color? toolbarIconInactiveTintColor;
    if (json['toolbarIconInactiveTintColor'] != null) {
      toolbarIconInactiveTintColor = ColorDeserializer.fromRgbaHex(json['toolbarIconInactiveTintColor']);
    }

    final sparkScanViewSettingsDefaults =
        SparkScanViewSettingsDefaults.fromJSON(jsonDecode(json["SparkScanViewSettings"]));
    final zoomSwitchControlVisible = json['zoomSwitchControlVisible'] as bool;

    final hardwareTriggerSupported = json['hardwareTriggerSupported'] as bool;

    final previewSizeControlVisible = json['previewSizeControlVisible'] as bool;

    final cameraSwitchButtonVisible = json['cameraSwitchButtonVisible'] as bool;

    final previewCloseControlVisible = json['previewCloseControlVisible'] as bool;

    final triggerButtonImage = json['triggerButtonImage'] as String?;

    Color? triggerButtonCollapsedColor;
    if (json['triggerButtonCollapsedColor'] != null) {
      triggerButtonCollapsedColor = ColorDeserializer.fromRgbaHex(json['triggerButtonCollapsedColor']);
    }

    Color? triggerButtonExpandedColor;
    if (json['triggerButtonExpandedColor'] != null) {
      triggerButtonExpandedColor = ColorDeserializer.fromRgbaHex(json['triggerButtonExpandedColor']);
    }

    Color? triggerButtonAnimationColor;
    if (json['triggerButtonAnimationColor'] != null) {
      triggerButtonAnimationColor = ColorDeserializer.fromRgbaHex(json['triggerButtonAnimationColor']);
    }

    Color? triggerButtonTintColor;
    if (json['triggerButtonTintColor'] != null) {
      triggerButtonTintColor = ColorDeserializer.fromRgbaHex(json['triggerButtonTintColor']);
    }

    final triggerButtonVisible = json['triggerButtonVisible'] as bool;

    return SparkScanViewDefaults(
        defaultBrush,
        torchControlVisible,
        scanningBehaviorButtonVisible,
        barcodeCountButtonVisible,
        barcodeFindButtonVisible,
        targetModeButtonVisible,
        false,
        false,
        toolbarBackgroundColor,
        toolbarIconActiveTintColor,
        toolbarIconInactiveTintColor,
        sparkScanViewSettingsDefaults,
        zoomSwitchControlVisible,
        hardwareTriggerSupported,
        previewSizeControlVisible,
        cameraSwitchButtonVisible,
        previewCloseControlVisible,
        triggerButtonImage,
        triggerButtonCollapsedColor,
        triggerButtonExpandedColor,
        triggerButtonAnimationColor,
        triggerButtonTintColor,
        triggerButtonVisible);
  }
}

@immutable
class SparkScanToastSettingsDefaults {
  final bool toastEnabled;
  final Color? toastBackgroundColor;
  final Color? toastTextColor;
  final String? targetModeEnabledMessage;
  final String? targetModeDisabledMessage;
  final String? continuousModeEnabledMessage;
  final String? continuousModeDisabledMessage;
  final String? scanPausedMessage;
  final String? zoomedInMessage;
  final String? zoomedOutMessage;
  final String? torchEnabledMessage;
  final String? torchDisabledMessage;
  final String? userFacingCameraEnabledMessage;
  final String? worldFacingCameraEnabledMessage;

  const SparkScanToastSettingsDefaults(
      this.toastEnabled,
      this.toastBackgroundColor,
      this.toastTextColor,
      this.targetModeEnabledMessage,
      this.targetModeDisabledMessage,
      this.continuousModeEnabledMessage,
      this.continuousModeDisabledMessage,
      this.scanPausedMessage,
      this.zoomedInMessage,
      this.zoomedOutMessage,
      this.torchEnabledMessage,
      this.torchDisabledMessage,
      this.userFacingCameraEnabledMessage,
      this.worldFacingCameraEnabledMessage);

  factory SparkScanToastSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    final toastEnabled = json['toastEnabled'] as bool;

    Color? toastBackgroundColor;
    if (json['toastBackgroundColor'] != null) {
      toastBackgroundColor = ColorDeserializer.fromRgbaHex(json['toastBackgroundColor']);
    }

    Color? toastTextColor;
    if (json['toastTextColor'] != null) {
      toastTextColor = ColorDeserializer.fromRgbaHex(json['toastTextColor']);
    }

    final targetModeEnabledMessage = json['targetModeEnabledMessage'] as String?;
    final targetModeDisabledMessage = json['targetModeDisabledMessage'] as String?;
    final continuousModeEnabledMessage = json['continuousModeEnabledMessage'] as String?;
    final continuousModeDisabledMessage = json['continuousModeDisabledMessage'] as String?;
    final scanPausedMessage = json['scanPausedMessage'] as String?;
    final zoomedInMessage = json['zoomedInMessage'] as String?;
    final zoomedOutMessage = json['zoomedOutMessage'] as String?;
    final torchEnabledMessage = json['torchEnabledMessage'] as String?;
    final torchDisabledMessage = json['torchDisabledMessage'] as String?;
    final userFacingCameraEnabledMessage = json['userFacingCameraEnabledMessage'] as String?;
    final worldFacingCameraEnabledMessage = json['worldFacingCameraEnabledMessage'] as String?;

    return SparkScanToastSettingsDefaults(
        toastEnabled,
        toastBackgroundColor,
        toastTextColor,
        targetModeEnabledMessage,
        targetModeDisabledMessage,
        continuousModeEnabledMessage,
        continuousModeDisabledMessage,
        scanPausedMessage,
        zoomedInMessage,
        zoomedOutMessage,
        torchEnabledMessage,
        torchDisabledMessage,
        userFacingCameraEnabledMessage,
        worldFacingCameraEnabledMessage);
  }
}

@immutable
class SparkScanSettingsDefaults {
  final int codeDuplicateFilter;
  final BatterySavingMode batterySaving;
  final ScanIntention scanIntention;

  const SparkScanSettingsDefaults(this.codeDuplicateFilter, this.batterySaving, this.scanIntention);

  factory SparkScanSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    return SparkScanSettingsDefaults(
        (json['codeDuplicateFilter'] as num).toInt(),
        BatterySavingModeDeserializer.fromJSON(json['batterySaving'] as String),
        ScanIntentionSerializer.fromJSON(json['scanIntention'] as String));
  }
}

@immutable
class SparkScanFeedbackDefaults {
  final SparkScanBarcodeFeedbackDefaults success;
  final SparkScanBarcodeFeedbackDefaults error;

  const SparkScanFeedbackDefaults(this.success, this.error);

  factory SparkScanFeedbackDefaults.fromJSON(Map<String, dynamic> json) {
    var error = SparkScanBarcodeFeedbackDefaults.fromJSON(jsonDecode(json['error'])['barcodeFeedback']);
    var success = SparkScanBarcodeFeedbackDefaults.fromJSON(jsonDecode(json['success'])['barcodeFeedback']);
    return SparkScanFeedbackDefaults(success, error);
  }
}

@immutable
class SparkScanBarcodeFeedbackDefaults {
  final Color visualFeedbackColor;
  final feedback.Feedback? feedbackDefault;
  final Brush brush;

  const SparkScanBarcodeFeedbackDefaults(this.visualFeedbackColor, this.feedbackDefault, this.brush);

  factory SparkScanBarcodeFeedbackDefaults.fromJSON(Map<String, dynamic> json) {
    var visualFeedbackColor = ColorDeserializer.fromRgbaHex(json['visualFeedbackColor']);
    feedback.Feedback? feedbackDefault;
    if (json.containsKey('feedback')) {
      feedbackDefault = feedback.FeedbackDeserializer.fromJson(json['feedback'] as Map<String, dynamic>);
    }
    var brush = NativeBrushDefaults.fromJSON(json['brush'] as Map<String, dynamic>).toBrush();
    return SparkScanBarcodeFeedbackDefaults(visualFeedbackColor, feedbackDefault, brush);
  }
}

class SparkScanViewSettingsDefaults {
  final Duration triggerButtonCollapseTimeout;
  final TorchState defaultTorchState;
  final SparkScanScanningMode defaultScanningMode;

  final bool holdToScanEnabled;
  final bool soundEnabled;
  final bool hapticEnabled;

  final bool hardwareTriggerEnabled;
  final int? hardwareTriggerKeyCode;
  final bool visualFeedbackEnabled;
  final SparkScanToastSettingsDefaults toastSettingsDefaults;
  final double zoomFactorOut;
  final double zoomFactorIn;
  final Duration inactiveStateTimeout;

  final CameraPosition defaultCameraPosition;

  final SparkScanMiniPreviewSize defaultMiniPreviewSize;

  SparkScanViewSettingsDefaults(
      this.triggerButtonCollapseTimeout,
      this.defaultTorchState,
      this.defaultScanningMode,
      this.holdToScanEnabled,
      this.soundEnabled,
      this.hapticEnabled,
      this.hardwareTriggerEnabled,
      this.hardwareTriggerKeyCode,
      this.visualFeedbackEnabled,
      this.toastSettingsDefaults,
      this.zoomFactorIn,
      this.zoomFactorOut,
      this.inactiveStateTimeout,
      this.defaultCameraPosition,
      this.defaultMiniPreviewSize);

  factory SparkScanViewSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    final triggerButtonCollapseTimeout = Duration(seconds: (json['triggerButtonCollapseTimeout'] as num).toInt());
    final defaultTorchState = TorchStateDeserializer.fromJSON(json['defaultTorchState'] as String);
    final defaultScanningMode =
        SparkScanScanningModeSerializer.fromJSON(jsonDecode(json['defaultScanningMode']) as Map<String, dynamic>);

    var holdToScanEnabled = false;
    if (json.containsKey('holdToScanEnabled')) {
      holdToScanEnabled = json['holdToScanEnabled'] as bool;
    }
    final soundEnabled = json['soundEnabled'] as bool;

    final hapticEnabled = json['hapticEnabled'] as bool;

    final hardwareTriggerEnabled = json['hardwareTriggerEnabled'] as bool;
    int? hardwareTriggerKeyCode;
    if (json.containsKey('hardwareTriggerKeyCode')) {
      hardwareTriggerKeyCode = (json['hardwareTriggerKeyCode'] as num).toInt();
    }

    var visualFeedbackEnabled = false;

    if (json.containsKey('visualFeedbackEnabled')) {
      visualFeedbackEnabled = json['visualFeedbackEnabled'] as bool;
    }

    final sparkScanToastSettingsDefaults = SparkScanToastSettingsDefaults.fromJSON(jsonDecode(json["toastSettings"]));

    final zoomFactorIn = (json['zoomFactorIn'] as num).toDouble();
    final zoomFactorOut = (json['zoomFactorOut'] as num).toDouble();

    final Duration inactiveStateTimeout = Duration(seconds: (json['inactiveStateTimeout'] as num).toInt());

    CameraPosition defaultCameraPosition = CameraPosition.worldFacing;
    if (json.containsKey('defaultCameraPosition')) {
      defaultCameraPosition = CameraPositionDeserializer.cameraPositionFromJSON(json['defaultCameraPosition']);
    }

    final defaultMiniPreviewSize =
        SparkScanMiniPreviewSizeSerializer.fromJSON(json['defaultMiniPreviewSize'] as String);

    return SparkScanViewSettingsDefaults(
        triggerButtonCollapseTimeout,
        defaultTorchState,
        defaultScanningMode,
        holdToScanEnabled,
        soundEnabled,
        hapticEnabled,
        hardwareTriggerEnabled,
        hardwareTriggerKeyCode,
        visualFeedbackEnabled,
        sparkScanToastSettingsDefaults,
        zoomFactorIn,
        zoomFactorOut,
        inactiveStateTimeout,
        defaultCameraPosition,
        defaultMiniPreviewSize);
  }
}
