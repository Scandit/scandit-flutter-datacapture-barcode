/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'spark_scan_defaults.dart';

/// Added in version 6.20.0
class SparkScanToastSettings extends Serializable {
  /// Constructs a new SparkScan toast settings with all parameters specified. When called with no parameters (or all parameters as undefined/null), defaults from native will be used. Parameters not provided will use their default values from the native platform.
  ///
  /// Added in version 8.3.0
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

  /// Should toasts be shown or not.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.20.0
  bool toastEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.toastEnabled;
  /// Text color of the toast. If this property is *null*, a default color will be used.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.20.0
  Color? toastTextColor =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.toastTextColor;
  /// Background color of the toast. If this property is *null*, a default color will be used.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.20.0
  Color? toastBackgroundColor =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.toastBackgroundColor;
  /// Text of the toast when target mode enabled.
  ///
  /// Default is *null*. If this property is *null*, a default message will be shown. If this property is an empty string, the toast will not be shown.
  ///
  /// Added in version 6.20.0
  @Deprecated('Use selectionModeOnMessage instead. Will be removed in 9.0.')
  String? targetModeEnabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.targetModeEnabledMessage;
  /// Text of the toast when target mode disabled.
  ///
  /// Default is *null*. If this property is *null*, a default message will be shown. If this property is an empty string, the toast will not be shown.
  ///
  /// Added in version 6.20.0
  @Deprecated('Use selectionModeOffMessage instead. Will be removed in 9.0.')
  String? targetModeDisabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.targetModeDisabledMessage;
  /// Shown when [SparkScanSettings.selectionMode] is set to [SelectionMode.on]. Replaces the deprecated `TargetModeEnabledMessage`.
  ///
  /// Default is *null*. If this property is *null*, a default message will be shown. If this property is an empty string, the toast will not be shown.
  ///
  /// Added in version 8.5.0
  String? selectionModeOnMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.selectionModeOnMessage;
  /// Shown when [SparkScanSettings.selectionMode] is set to [SelectionMode.off]. Replaces the deprecated `TargetModeDisabledMessage`.
  ///
  /// Default is *null*. If this property is *null*, a default message will be shown. If this property is an empty string, the toast will not be shown.
  ///
  /// Added in version 8.5.0
  String? selectionModeOffMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.selectionModeOffMessage;
  /// Text of the toast when [SparkScanScanningBehavior.continuous] capturing mode enabled.
  ///
  /// Default is *null*. If this property is *null*, a default message will be shown.
  ///
  /// If this property is an empty string, the toast will not be shown.
  ///
  /// Added in version 6.20.0
  String? continuousModeEnabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.continuousModeEnabledMessage;
  /// Text of the toast when [SparkScanScanningBehavior.continuous] capturing mode disabled.
  ///
  /// Default is *null*. If this property is *null*, a default message will be shown.
  ///
  /// If this property is an empty string, the toast will not be shown.
  ///
  /// Added in version 6.20.0
  String? continuousModeDisabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.continuousModeDisabledMessage;
  /// Text of the toast when [SparkScanPreviewBehavior.persistent] capturing mode is enabled and scanning is paused.
  ///
  /// Default is *null*. If this property is *null*, a default message will be shown. If this property is an empty string, the toast will not be shown.
  ///
  /// Added in version 6.23.0
  String? scanPausedMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.scanPausedMessage;
  /// Text of the toast when zooming in.
  ///
  /// Default is *null*. If this property is *null*, a default message will be shown. If this property is an empty string, the toast will not be shown.
  ///
  /// Added in version 6.23.0
  String? zoomedInMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.zoomedInMessage;
  /// Text of the toast when zooming out.
  ///
  /// Default is *null*. If this property is *null*, a default message will be shown. If this property is an empty string, the toast will not be shown.
  ///
  /// Added in version 6.23.0
  String? zoomedOutMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.zoomedOutMessage;
  /// Text of the toast when torch is enabled.
  ///
  /// Default is *null*. If this property is *null*, a default message will be shown. If this property is an empty string, the toast will not be shown.
  ///
  /// Added in version 6.23.0
  String? torchEnabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.torchEnabledMessage;
  /// Text of the toast when torch is disabled.
  ///
  /// Default is *null*. If this property is *null*, a default message will be shown. If this property is an empty string, the toast will not be shown.
  ///
  /// Added in version 6.23.0
  String? torchDisabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.torchDisabledMessage;
  /// Text of the toast when user facing camera is enabled.
  ///
  /// Default is *null*. If this property is *null*, a default message will be shown. If this property is an empty string, the toast will not be shown.
  ///
  /// Added in version 6.24.0
  String? userFacingCameraEnabledMessage =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.toastSettingsDefaults.userFacingCameraEnabledMessage;
  /// Text of the toast when world facing camera is enabled.
  ///
  /// Default is *null*. If this property is *null*, a default message will be shown. If this property is an empty string, the toast will not be shown.
  ///
  /// Added in version 6.24.0
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
