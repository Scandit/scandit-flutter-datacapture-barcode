/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_mini_preview_size.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'spark_scan_defaults.dart';
import 'spark_scan_view_capture_mode.dart';
import 'spark_scan_toast_settings.dart';

class SparkScanViewSettings extends Serializable {
  SparkScanViewSettings();

  Duration triggerButtonCollapseTimeout =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.triggerButtonCollapseTimeout;

  TorchState defaultTorchState = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultTorchState;
  @Deprecated('Use SparkScanSettings.selectionMode instead. Will be removed in 9.0.')
  SparkScanScanningMode defaultScanningMode =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultScanningMode;

  bool holdToScanEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.holdToScanEnabled;

  bool soundEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.soundEnabled;
  bool hapticEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.hapticEnabled;

  bool hardwareTriggerEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.hardwareTriggerEnabled;
  int? hardwareTriggerKeyCode = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.hardwareTriggerKeyCode;
  bool visualFeedbackEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.visualFeedbackEnabled;

  double zoomFactorIn = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.zoomFactorIn;

  double zoomFactorOut = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.zoomFactorOut;

  Duration inactiveStateTimeout = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.inactiveStateTimeout;

  SparkScanToastSettings toastSettings = SparkScanToastSettings(); // defaults are loaded automatically

  bool shouldShowOnTopAlways = true;

  CameraPosition defaultCameraPosition =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultCameraPosition;

  SparkScanMiniPreviewSize defaultMiniPreviewSize =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultMiniPreviewSize;

  Brush? selectionModeCandidateBrush;

  @Deprecated('Use selectionModeCandidateBrush instead. Will be removed in 9.0.')
  Brush? get smartSelectionCandidateBrush => selectionModeCandidateBrush;

  @Deprecated('Use selectionModeCandidateBrush instead. Will be removed in 9.0.')
  set smartSelectionCandidateBrush(Brush? value) => selectionModeCandidateBrush = value;

  bool periscopeModeEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.periscopeModeEnabled;

  @override
  Map<String, dynamic> toMap() {
    return {
      'triggerButtonCollapseTimeout': triggerButtonCollapseTimeout.inSeconds,
      'defaultTorchState': defaultTorchState.toString(),
      // ignore: deprecated_member_use_from_same_package
      'defaultScanningMode': defaultScanningMode.toMap(),
      'holdToScanEnabled': holdToScanEnabled,
      'soundEnabled': soundEnabled,
      'hapticEnabled': hapticEnabled,
      'hardwareTriggerEnabled': hardwareTriggerEnabled,
      'hardwareTriggerKeyCode': hardwareTriggerKeyCode,
      'visualFeedbackEnabled': visualFeedbackEnabled,
      'zoomFactorIn': zoomFactorIn,
      'zoomFactorOut': zoomFactorOut,
      'inactiveStateTimeout': inactiveStateTimeout.inSeconds,
      'shouldShowOnTopAlways': shouldShowOnTopAlways,
      'defaultCameraPosition': defaultCameraPosition.toString(),
      'defaultMiniPreviewSize': defaultMiniPreviewSize.toString(),
      'selectionModeCandidateBrush': selectionModeCandidateBrush?.toMap(),
      'periscopeModeEnabled': periscopeModeEnabled,
    };
  }
}
