/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'spark_scan_defaults.dart';
import 'spark_scan_view_capture_mode.dart';
import 'spark_scan_view_hand_mode.dart';
import 'spark_scan_toast_settings.dart';

class SparkScanViewSettings extends Serializable {
  SparkScanViewSettings();

  Duration triggerButtonCollapseTimeout =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.triggerButtonCollapseTimeout;
  Duration continuousCaptureTimeout =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.continuousCaptureTimeout;

  TorchState defaultTorchState = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultTorchState;
  SparkScanScanningMode defaultScanningMode =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultScanningMode;
  SparkScanViewHandMode defaultHandMode = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultHandMode;
  bool holdToScanEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.holdToScanEnabled;

  bool soundEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.soundEnabled;
  bool hapticEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.hapticEnabled;

  bool hardwareTriggerEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.hardwareTriggerEnabled;
  int? hardwareTriggerKeyCode = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.hardwareTriggerKeyCode;
  bool visualFeedbackEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.visualFeedbackEnabled;

  bool _ignoreDragLimits = true;

  @Deprecated('There is no drag limit anymore.')
  bool get ignoreDragLimits => _ignoreDragLimits;

  @Deprecated('There is no drag limit anymore.')
  set ignoreDragLimits(bool newValue) {
    // ignore set
    _ignoreDragLimits = true;
  }

  double targetZoomFactorOut = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.targetZoomFactorOut;
  double targetZoomFactorIn = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.targetZoomFactorIn;
  SparkScanToastSettings toastSettings = SparkScanToastSettings(); // defaults are loaded automatically

  @override
  Map<String, dynamic> toMap() {
    return {
      'triggerButtonCollapseTimeout': triggerButtonCollapseTimeout.inSeconds,
      'continuousCaptureTimeout': continuousCaptureTimeout.inSeconds,
      'defaultTorchState': defaultTorchState.toString(),
      'defaultScanningMode': defaultScanningMode.toMap(),
      'holdToScanEnabled': holdToScanEnabled,
      'defaultHandMode': defaultHandMode.jsonValue,
      'soundEnabled': soundEnabled,
      'hapticEnabled': hapticEnabled,
      'hardwareTriggerEnabled': hardwareTriggerEnabled,
      'hardwareTriggerKeyCode': hardwareTriggerKeyCode,
      'visualFeedbackEnabled': visualFeedbackEnabled,
      'targetZoomFactorOut': targetZoomFactorOut,
      'targetZoomFactorIn': targetZoomFactorIn
    };
  }
}
