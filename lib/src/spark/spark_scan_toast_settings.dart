/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'spark_scan_defaults.dart';

class SparkScanToastSettings extends Serializable {
  SparkScanToastSettings();

  bool toastEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.toastEnabled;
  Color? toastTextColor =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.toastTextColor;
  Color? toastBackgroundColor =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.toastBackgroundColor;
  String? targetModeEnabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.targetModeEnabledMessage;
  String? targetModeDisabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.targetModeDisabledMessage;
  String? continuousModeEnabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.continuousModeEnabledMessage;
  String? continuousModeDisabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.continuousModeDisabledMessage;
  String? scanPausedMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.scanPausedMessage;
  String? zoomedInMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.zoomedInMessage;
  String? zoomedOutMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.zoomedOutMessage;
  String? torchEnabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.torchEnabledMessage;
  String? torchDisabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.torchDisabledMessage;
  String? userFacingCameraEnabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.userFacingCameraEnabledMessage;
  String? worldFacingCameraEnabledMessage = SparkScanDefaults
      .sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.worldFacingCameraEnabledMessage;

  @override
  Map<String, dynamic> toMap() {
    return {
      'toastEnabled': toastEnabled,
      'toastTextColor': toastTextColor?.jsonValue,
      'toastBackgroundColor': toastBackgroundColor?.jsonValue,
      'targetModeEnabledMessage': targetModeEnabledMessage,
      'targetModeDisabledMessage': targetModeDisabledMessage,
      'continuousModeEnabledMessage': continuousModeEnabledMessage,
      'continuousModeDisabledMessage': continuousModeDisabledMessage,
      'scanPausedMessage': scanPausedMessage,
      'zoomedInMessage': zoomedInMessage,
      'zoomedOutMessage': zoomedOutMessage,
      'torchEnabledMessage': torchEnabledMessage,
      'torchDisabledMessage': torchDisabledMessage,
      'userFacingCameraEnabledMessage': userFacingCameraEnabledMessage,
      'worldFacingCameraEnabledMessage': worldFacingCameraEnabledMessage,
    };
  }
}
