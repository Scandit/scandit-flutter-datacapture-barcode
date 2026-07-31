/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'spark_scan_defaults.dart';

class SparkScanToastSettings extends Serializable {
  SparkScanToastSettings(
      {bool? toastEnabled,
      Color? toastTextColor,
      Color? toastBackgroundColor,
      String? targetModeEnabledMessage,
      String? targetModeDisabledMessage,
      String? selectionModeOnMessage,
      String? selectionModeOffMessage,
      String? continuousModeEnabledMessage,
      String? continuousModeDisabledMessage,
      String? scanPausedMessage,
      String? zoomedInMessage,
      String? zoomedOutMessage,
      String? torchEnabledMessage,
      String? torchDisabledMessage,
      String? userFacingCameraEnabledMessage,
      String? worldFacingCameraEnabledMessage}) {
    if (toastEnabled != null) this.toastEnabled = toastEnabled;
    if (toastTextColor != null) this.toastTextColor = toastTextColor;
    if (toastBackgroundColor != null) this.toastBackgroundColor = toastBackgroundColor;
    // ignore: deprecated_member_use_from_same_package
    if (targetModeEnabledMessage != null) this.targetModeEnabledMessage = targetModeEnabledMessage;
    // ignore: deprecated_member_use_from_same_package
    if (targetModeDisabledMessage != null) this.targetModeDisabledMessage = targetModeDisabledMessage;
    if (selectionModeOnMessage != null) this.selectionModeOnMessage = selectionModeOnMessage;
    if (selectionModeOffMessage != null) this.selectionModeOffMessage = selectionModeOffMessage;
    if (continuousModeEnabledMessage != null) this.continuousModeEnabledMessage = continuousModeEnabledMessage;
    if (continuousModeDisabledMessage != null) this.continuousModeDisabledMessage = continuousModeDisabledMessage;
    if (scanPausedMessage != null) this.scanPausedMessage = scanPausedMessage;
    if (zoomedInMessage != null) this.zoomedInMessage = zoomedInMessage;
    if (zoomedOutMessage != null) this.zoomedOutMessage = zoomedOutMessage;
    if (torchEnabledMessage != null) this.torchEnabledMessage = torchEnabledMessage;
    if (torchDisabledMessage != null) this.torchDisabledMessage = torchDisabledMessage;
    if (userFacingCameraEnabledMessage != null) this.userFacingCameraEnabledMessage = userFacingCameraEnabledMessage;
    if (worldFacingCameraEnabledMessage != null) this.worldFacingCameraEnabledMessage = worldFacingCameraEnabledMessage;
  }

  bool toastEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.toastEnabled;
  Color? toastTextColor =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.toastTextColor;
  Color? toastBackgroundColor =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.toastBackgroundColor;
  @Deprecated('Use selectionModeOnMessage instead. Will be removed in 9.0.')
  String? targetModeEnabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.targetModeEnabledMessage;
  @Deprecated('Use selectionModeOffMessage instead. Will be removed in 9.0.')
  String? targetModeDisabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.targetModeDisabledMessage;
  String? selectionModeOnMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.selectionModeOnMessage;
  String? selectionModeOffMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.selectionModeOffMessage;
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
      // ignore: deprecated_member_use_from_same_package
      'targetModeEnabledMessage': targetModeEnabledMessage,
      // ignore: deprecated_member_use_from_same_package
      'targetModeDisabledMessage': targetModeDisabledMessage,
      'selectionModeOnMessage': selectionModeOnMessage,
      'selectionModeOffMessage': selectionModeOffMessage,
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
