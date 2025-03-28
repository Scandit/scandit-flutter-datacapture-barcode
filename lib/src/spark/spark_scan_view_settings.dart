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
  SparkScanScanningMode defaultScanningMode =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultScanningMode;

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

  double _targetZoomFactorOut = 0.0;

  @Deprecated('Use zoomFactorOut instead')
  double get targetZoomFactorOut => _targetZoomFactorOut;

  @Deprecated('Use zoomFactorOut instead')
  set targetZoomFactorOut(double newValue) {
    // ignore set
    _targetZoomFactorOut = 0.0;
  }

  double _targetZoomFactorIn = 0.0;

  @Deprecated('Use zoomFactorIn instead')
  double get targetZoomFactorIn => _targetZoomFactorIn;

  @Deprecated('Use zoomFactorIn instead')
  set targetZoomFactorIn(double newValue) {
    // ignore set
    _targetZoomFactorIn = 0.0;
  }

  double zoomFactorIn = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.zoomFactorIn;

  double zoomFactorOut = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.zoomFactorOut;

  Duration inactiveStateTimeout = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.inactiveStateTimeout;

  SparkScanToastSettings toastSettings = SparkScanToastSettings(); // defaults are loaded automatically

  bool shouldShowOnTopAlways = true;

  CameraPosition defaultCameraPosition =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultCameraPosition;

  SparkScanMiniPreviewSize defaultMiniPreviewSize =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultMiniPreviewSize;

  @override
  Map<String, dynamic> toMap() {
    return {
      'triggerButtonCollapseTimeout': triggerButtonCollapseTimeout.inSeconds,
      'defaultTorchState': defaultTorchState.toString(),
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
    };
  }
}
