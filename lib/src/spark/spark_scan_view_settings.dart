/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_mini_preview_size.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'spark_scan_defaults.dart';
import 'spark_scan_preview_behavior.dart';
import 'spark_scan_view_capture_mode.dart';
import 'spark_scan_toast_settings.dart';

/// Changing the values of SparkScanViewSettings instance after the creation of [SparkScanView] does not result in applying the changed settings to the corresponding view.
///
/// Added in version 6.20.0
class SparkScanViewSettings extends Serializable {
  /// Constructs a new SparkScan view settings to use when creating an instance of the [SparkScanView].
  ///
  /// Added in version 6.20.0
  SparkScanViewSettings();

  /// The timeout to automatically switch to idle state. When set to negative value timeout is infinite.
  ///
  /// Default is 5 seconds.
  ///
  /// Added in version 6.20.0
  Duration triggerButtonCollapseTimeout =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.triggerButtonCollapseTimeout;

  /// Sets the default torch state of the camera.
  ///
  /// Default is [TorchState.off].
  ///
  /// Added in version 6.20.0
  TorchState defaultTorchState = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultTorchState;
  /// Sets the default scanning mode of the view.
  ///
  /// Default is [SparkScanScanningModeDefault].
  ///
  /// Added in version 6.20.0
  @Deprecated('Use SparkScanSettings.selectionMode plus the scanningBehavior / previewBehavior properties on '
      'SparkScanViewSettings instead. Will be removed in 9.0.')
  SparkScanScanningMode defaultScanningMode =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultScanningMode;

  // ignore: deprecated_member_use_from_same_package
  bool get _isTargetMode => defaultScanningMode is SparkScanScanningModeTarget;

  /// Whether the SparkScan view scans a single barcode per trigger or keeps scanning continuously while the trigger is held. Replaces the embedded `scanningBehavior` field on the deprecated [SparkScanViewSettings.defaultScanningMode].
  ///
  /// Default is [SparkScanScanningBehavior.single].
  ///
  /// Added in version 8.7.0
  SparkScanScanningBehavior get scanningBehavior {
    // ignore: deprecated_member_use_from_same_package
    final mode = defaultScanningMode;
    // ignore: deprecated_member_use_from_same_package
    return mode is SparkScanScanningModeTarget
        ? mode.scanningBehavior
        : (mode as SparkScanScanningModeDefault).scanningBehavior;
  }

  /// Whether the SparkScan view scans a single barcode per trigger or keeps scanning continuously while the trigger is held. Replaces the embedded `scanningBehavior` field on the deprecated [SparkScanViewSettings.defaultScanningMode].
  ///
  /// Default is [SparkScanScanningBehavior.single].
  ///
  /// Added in version 8.7.0
  set scanningBehavior(SparkScanScanningBehavior value) => _replaceScanningMode(value, previewBehavior);

  /// Whether the SparkScan preview returns to its idle state after a scan or stays expanded.
  ///
  /// Replaces the embedded `previewBehavior` field on the deprecated [SparkScanViewSettings.defaultScanningMode].
  ///
  /// Default is SparkScanPreviewBehavior.defaultBehaviour.
  ///
  /// Added in version 8.7.0
  SparkScanPreviewBehavior get previewBehavior {
    // ignore: deprecated_member_use_from_same_package
    final mode = defaultScanningMode;
    // ignore: deprecated_member_use_from_same_package
    return mode is SparkScanScanningModeTarget
        ? mode.previewBehavior
        : (mode as SparkScanScanningModeDefault).previewBehavior;
  }

  /// Whether the SparkScan preview returns to its idle state after a scan or stays expanded.
  ///
  /// Replaces the embedded `previewBehavior` field on the deprecated [SparkScanViewSettings.defaultScanningMode].
  ///
  /// Default is SparkScanPreviewBehavior.defaultBehaviour.
  ///
  /// Added in version 8.7.0
  set previewBehavior(SparkScanPreviewBehavior value) => _replaceScanningMode(scanningBehavior, value);

  void _replaceScanningMode(SparkScanScanningBehavior scanningBehavior, SparkScanPreviewBehavior previewBehavior) {
    // ignore: deprecated_member_use_from_same_package
    defaultScanningMode = _isTargetMode
        // ignore: deprecated_member_use_from_same_package
        ? SparkScanScanningModeTarget.fromPreviewBehavior(scanningBehavior, previewBehavior)
        // ignore: deprecated_member_use_from_same_package
        : SparkScanScanningModeDefault.fromPreviewBehavior(scanningBehavior, previewBehavior);
  }

  /// Indicates whether to keep scanning as long as the scan button is pressed.
  ///
  /// Default is *true*.
  ///
  /// Hold-to-scan is automatically disabled by the SDK when [SparkScanSettings.selectionMode] is set to [SelectionMode.on], since that mode requires explicit user confirmation for every scan. The value of this property is ignored while `SelectionMode.On` is active.
  ///
  /// Added in version 6.20.0
  bool holdToScanEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.holdToScanEnabled;

  /// Indicates whether the feedback should have sound enabled.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.20.0
  bool soundEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.soundEnabled;
  /// Indicates whether the feedback should have haptics enabled.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.20.0
  bool hapticEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.hapticEnabled;

  /// Added in version 6.20.0
  bool hardwareTriggerEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.hardwareTriggerEnabled;
  /// Added in version 6.20.0
  int? hardwareTriggerKeyCode = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.hardwareTriggerKeyCode;
  /// Indicates whether the visual feedback on scan should be displayed.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.20.0
  bool visualFeedbackEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.visualFeedbackEnabled;

  /// The zoom factor to move to when the zoom switch control was tapped.
  ///
  /// Default is 2.
  ///
  /// Added in version 6.23.0
  double zoomFactorIn = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.zoomFactorIn;

  /// The zoom factor to use for the camera.
  ///
  /// Default is 1.
  ///
  /// Added in version 6.23.0
  double zoomFactorOut = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.zoomFactorOut;

  /// The timeout to automatically stop capturing.
  ///
  /// Default is 10 seconds.
  ///
  /// Added in version 6.22.0
  Duration inactiveStateTimeout = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.inactiveStateTimeout;

  /// Sets the toast settings. See [SparkScanToastSettings] for details.
  ///
  /// Added in version 6.20.0
  SparkScanToastSettings toastSettings = SparkScanToastSettings(); // defaults are loaded automatically

  /// Determines whether the [SparkScanView] should always be placed on top of the Flutter content. It only has an effect on iOS.
  ///
  /// The default is true.
  ///
  /// Added in version 6.23.0
  bool shouldShowOnTopAlways = true;

  /// Sets the default camera position.
  ///
  /// Default is [CameraPosition.worldFacing].
  ///
  /// This API is still in beta and may change in future versions of Scandit Data Capture SDK.
  ///
  /// Added in version 6.24.0
  CameraPosition defaultCameraPosition =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultCameraPosition;

  /// Sets the default size of the mini preview.
  ///
  /// Default is [SparkScanMiniPreviewSize.regular].
  ///
  /// Added in version 7.0.0
  SparkScanMiniPreviewSize defaultMiniPreviewSize =
      SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.defaultMiniPreviewSize;

  /// Sets the brush to be used for potential candidates when automatic selection is active — that is, when the [SparkScanSettings.selectionMode] property is set to [SelectionMode.auto], or when the deprecated `ScanIntention.SmartSelection` is used. If null, the default brush will be used.
  ///
  /// The brush’s stroke colour is also used for the aimer’s dwell-progress indicator, falling back to the fill colour when the stroke is transparent.
  ///
  /// Added in version 8.5.0
  Brush? selectionModeCandidateBrush;

  /// Deprecated alias of [SparkScanViewSettings.selectionModeCandidateBrush].
  ///
  /// Added in version 8.1.0
  @Deprecated('Use selectionModeCandidateBrush instead. Will be removed in 9.0.')
  Brush? get smartSelectionCandidateBrush => selectionModeCandidateBrush;

  /// Deprecated alias of [SparkScanViewSettings.selectionModeCandidateBrush].
  ///
  /// Added in version 8.1.0
  @Deprecated('Use selectionModeCandidateBrush instead. Will be removed in 9.0.')
  set smartSelectionCandidateBrush(Brush? value) => selectionModeCandidateBrush = value;

  /// Controls the mirroring of the camera feed to support the use of a periscope device.
  ///
  /// Default is *false*.
  ///
  /// This property only has an effect on iOS. It does not affect the camera feed on Android.
  ///
  /// Added in version 8.3.0
  bool periscopeModeEnabled = SparkScanDefaults.sparkScanViewDefaults.viewSettingsDefaults.periscopeModeEnabled;

  @override
  Map<String, dynamic> toMap() {
    return {
      'triggerButtonCollapseTimeout': triggerButtonCollapseTimeout.inSeconds,
      'defaultTorchState': defaultTorchState.toString(),
      // ignore: deprecated_member_use_from_same_package
      'defaultScanningMode': defaultScanningMode.toMap(),
      'scanningBehavior': scanningBehavior.toString(),
      'previewBehavior': previewBehavior.toString(),
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
