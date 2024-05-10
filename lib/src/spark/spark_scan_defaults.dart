/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:scandit_flutter_datacapture_core/src/battery_saving_mode.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/feedback.dart' as feedback;

import 'spark_scan_function_names.dart';
import 'spark_scan_view_capture_mode.dart';
import 'spark_scan_view_hand_mode.dart';

// ignore: avoid_classes_with_only_static_members
class SparkScanDefaults {
  static MethodChannel mainChannel = MethodChannel(SparkScanFunctionNames.methodsChannelName);

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
  final bool shouldShowScanAreaGuides;
  final bool torchButtonVisible;
  final bool scanningBehaviorButtonVisible;
  final bool handModeButtonVisible;
  final bool barcodeCountButtonVisible;
  final bool fastFindButtonVisible;
  final bool targetModeButtonVisible;
  final bool soundModeButtonVisible;
  final bool hapticModeButtonVisible;
  final String? stopCapturingText;
  final String? startCapturingText;
  final String? resumeCapturingText;
  final String? scanningCapturingText;
  final Color? captureButtonBackgroundColor;
  final Color? captureButtonTintColor;
  final Color? captureButtonActiveBackgroundColor;
  final Color? toolbarBackgroundColor;
  final Color? toolbarIconActiveTintColor;
  final Color? toolbarIconInactiveTintColor;
  final bool zoomSwitchControlVisible;
  final String? targetModeHintText;
  final bool previewSizeControlVisible;

  final SparkScanViewSettingsDefaults viewSettingsDefaults;

  final bool hardwareTriggerSupported;

  SparkScanViewDefaults(
      this.shouldShowScanAreaGuides,
      this.defaultBrush,
      this.torchButtonVisible,
      this.scanningBehaviorButtonVisible,
      this.handModeButtonVisible,
      this.barcodeCountButtonVisible,
      this.fastFindButtonVisible,
      this.targetModeButtonVisible,
      this.soundModeButtonVisible,
      this.hapticModeButtonVisible,
      this.stopCapturingText,
      this.startCapturingText,
      this.resumeCapturingText,
      this.scanningCapturingText,
      this.captureButtonBackgroundColor,
      this.captureButtonTintColor,
      this.captureButtonActiveBackgroundColor,
      this.toolbarBackgroundColor,
      this.toolbarIconActiveTintColor,
      this.toolbarIconInactiveTintColor,
      this.viewSettingsDefaults,
      this.zoomSwitchControlVisible,
      this.targetModeHintText,
      this.hardwareTriggerSupported,
      this.previewSizeControlVisible);

  factory SparkScanViewDefaults.fromJSON(Map<String, dynamic> json) {
    final shouldShowScanAreaGuides = json['shouldShowScanAreaGuides'] as bool;
    final defaultBrush = BrushDefaults.fromJSON(json['brush'] as Map<String, dynamic>).toBrush();
    final torchButtonVisible = json['torchButtonVisible'] as bool;
    final scanningBehaviorButtonVisible = json['scanningBehaviorButtonVisible'] as bool;
    final handModeButtonVisible = json['handModeButtonVisible'] as bool;
    final barcodeCountButtonVisible = json['barcodeCountButtonVisible'] as bool;
    final fastFindButtonVisible = json['fastFindButtonVisible'] as bool;
    final targetModeButtonVisible = json['targetModeButtonVisible'] as bool;
    final soundModeButtonVisible = json['soundModeButtonVisible'] as bool;
    final hapticModeButtonVisible = json['hapticModeButtonVisible'] as bool;
    final stopCapturingText = json['stopCapturingText'] as String?;
    final startCapturingText = json['startCapturingText'] as String?;
    final resumeCapturingText = json['resumeCapturingText'] as String?;
    final scanningCapturingText = json['scanningCapturingText'] as String?;

    Color? captureButtonBackgroundColor;
    if (json['captureButtonBackgroundColor'] != null) {
      captureButtonBackgroundColor = ColorDeserializer.fromRgbaHex(json['captureButtonBackgroundColor']);
    }

    Color? captureButtonTintColor;
    if (json['captureButtonTintColor'] != null) {
      captureButtonTintColor = ColorDeserializer.fromRgbaHex(json['captureButtonTintColor']);
    }

    Color? captureButtonActiveBackgroundColor;
    if (json['captureButtonActiveBackgroundColor'] != null) {
      captureButtonActiveBackgroundColor = ColorDeserializer.fromRgbaHex(json['captureButtonActiveBackgroundColor']);
    }

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
    final targetModeHintText = json['targetModeHintText'] as String?;

    final hardwareTriggerSupported = json['hardwareTriggerSupported'] as bool;

    final previewSizeControlVisible = json['previewSizeControlVisible'] as bool;

    return SparkScanViewDefaults(
        shouldShowScanAreaGuides,
        defaultBrush,
        torchButtonVisible,
        scanningBehaviorButtonVisible,
        handModeButtonVisible,
        barcodeCountButtonVisible,
        fastFindButtonVisible,
        targetModeButtonVisible,
        soundModeButtonVisible,
        hapticModeButtonVisible,
        stopCapturingText,
        startCapturingText,
        resumeCapturingText,
        scanningCapturingText,
        captureButtonBackgroundColor,
        captureButtonTintColor,
        captureButtonActiveBackgroundColor,
        toolbarBackgroundColor,
        toolbarIconActiveTintColor,
        toolbarIconInactiveTintColor,
        sparkScanViewSettingsDefaults,
        zoomSwitchControlVisible,
        targetModeHintText,
        hardwareTriggerSupported,
        previewSizeControlVisible);
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
  final String? cameraTimeoutMessage;
  final String? scanPausedMessage;
  final String? zoomedInMessage;
  final String? zoomedOutMessage;
  final String? torchEnabledMessage;
  final String? torchDisabledMessage;

  SparkScanToastSettingsDefaults(
      this.toastEnabled,
      this.toastBackgroundColor,
      this.toastTextColor,
      this.targetModeEnabledMessage,
      this.targetModeDisabledMessage,
      this.continuousModeEnabledMessage,
      this.continuousModeDisabledMessage,
      this.cameraTimeoutMessage,
      this.scanPausedMessage,
      this.zoomedInMessage,
      this.zoomedOutMessage,
      this.torchEnabledMessage,
      this.torchDisabledMessage);

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
    final cameraTimeoutMessage = json['cameraTimeoutMessage'] as String?;
    final scanPausedMessage = json['scanPausedMessage'] as String?;
    final zoomedInMessage = json['zoomedInMessage'] as String?;
    final zoomedOutMessage = json['zoomedOutMessage'] as String?;
    final torchEnabledMessage = json['torchEnabledMessage'] as String?;
    final torchDisabledMessage = json['torchDisabledMessage'] as String?;

    return SparkScanToastSettingsDefaults(
        toastEnabled,
        toastBackgroundColor,
        toastTextColor,
        targetModeEnabledMessage,
        targetModeDisabledMessage,
        continuousModeEnabledMessage,
        continuousModeDisabledMessage,
        cameraTimeoutMessage,
        scanPausedMessage,
        zoomedInMessage,
        zoomedOutMessage,
        torchEnabledMessage,
        torchDisabledMessage);
  }
}

@immutable
class SparkScanSettingsDefaults {
  final int codeDuplicateFilter;
  final bool singleBarcodeAutoDetection;
  final BatterySavingMode batterySaving;

  SparkScanSettingsDefaults(this.codeDuplicateFilter, this.singleBarcodeAutoDetection, this.batterySaving);

  factory SparkScanSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    return SparkScanSettingsDefaults(
        (json['codeDuplicateFilter'] as num).toInt(),
        json['singleBarcodeAutoDetection'] as bool,
        BatterySavingModeDeserializer.fromJSON(json['batterySaving'] as String));
  }
}

@immutable
class SparkScanFeedbackDefaults {
  final SparkScanBarcodeFeedbackDefaults success;
  final SparkScanBarcodeFeedbackDefaults error;

  SparkScanFeedbackDefaults(this.success, this.error);

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

  SparkScanBarcodeFeedbackDefaults(this.visualFeedbackColor, this.feedbackDefault, this.brush);

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
  final Duration continuousCaptureTimeout;
  final TorchState defaultTorchState;
  final SparkScanScanningMode defaultScanningMode;
  final SparkScanViewHandMode defaultHandMode;
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

  SparkScanViewSettingsDefaults(
      this.triggerButtonCollapseTimeout,
      this.continuousCaptureTimeout,
      this.defaultTorchState,
      this.defaultScanningMode,
      this.defaultHandMode,
      this.holdToScanEnabled,
      this.soundEnabled,
      this.hapticEnabled,
      this.hardwareTriggerEnabled,
      this.hardwareTriggerKeyCode,
      this.visualFeedbackEnabled,
      this.toastSettingsDefaults,
      this.zoomFactorIn,
      this.zoomFactorOut,
      this.inactiveStateTimeout);

  factory SparkScanViewSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    final triggerButtonCollapseTimeout = Duration(seconds: (json['triggerButtonCollapseTimeout'] as num).toInt());
    // Deprecated field. Is coming null from the native side
    final continuousCaptureTimeout = Duration(seconds: 0);
    final defaultTorchState = TorchStateDeserializer.fromJSON(json['defaultTorchState'] as String);
    final defaultScanningMode =
        SparkScanScanningModeSerializer.fromJSON(jsonDecode(json['defaultScanningMode']) as Map<String, dynamic>);
    final defaultHandMode = SparkScanViewHandModeSerializer.fromJSON(json['defaultHandMode'] as String);
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

    return SparkScanViewSettingsDefaults(
        triggerButtonCollapseTimeout,
        continuousCaptureTimeout,
        defaultTorchState,
        defaultScanningMode,
        defaultHandMode,
        holdToScanEnabled,
        soundEnabled,
        hapticEnabled,
        hardwareTriggerEnabled,
        hardwareTriggerKeyCode,
        visualFeedbackEnabled,
        sparkScanToastSettingsDefaults,
        zoomFactorIn,
        zoomFactorOut,
        inactiveStateTimeout);
  }
}
