/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_mini_preview_size.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/feedback.dart' as feedback;

import '../generated/barcode_generated_defaults.dart';
import 'spark_scan_view_capture_mode.dart';

// Picks the platform-split value of a generated default. Kept private per
// file, mirroring core's and id's own copies.
T _platformDefault<T>({required T android, required T ios}) => Platform.isIOS ? ios : android;

// Builds a Brush from a generated flat {fillColor, strokeColor, strokeWidth}
// default literal - the shape BrushDefaults.fromJSON consumes on the native path.
Brush _buildStaticBrush(Map<String, Object?> json) {
  final fillColor = ColorDeserializer.fromRgbaHex(json['fillColor'] as String? ?? '#00000000');
  final strokeColor = ColorDeserializer.fromRgbaHex(json['strokeColor'] as String? ?? '#00000000');
  final strokeWidth = (json['strokeWidth'] as num?)?.toDouble() ?? 0.0;
  return Brush(fillColor, strokeColor, strokeWidth);
}

SparkScanSettingsDefaults _buildStaticSparkScanSettingsDefaults() {
  return SparkScanSettingsDefaults(
    const Duration(milliseconds: 1) * SparkScanSettingsGeneratedDefaults.codeDuplicateFilter,
    BatterySavingModeDeserializer.fromJSON(SparkScanSettingsGeneratedDefaults.batterySaving),
    ScanIntentionSerializer.fromJSON(SparkScanSettingsGeneratedDefaults.scanIntention),
    SelectionMode.fromJSON(SparkScanSettingsGeneratedDefaults.selectionMode),
  );
}

// SDC-33331 remodelled the SoT SparkScan.Feedback.{success,error} entries to the
// wrapper both native serializers actually emit - {type, barcodeFeedback: {...}} -
// so the generated const's inner 'barcodeFeedback' object is byte-identical to what
// SparkScanBarcodeFeedbackDefaults.fromJSON already consumes on the native path.
// The former hand-rolled reshaping (flat visualFeedbackColor/sound/vibration/brush)
// is obsolete; this is now a direct pass-through.
SparkScanBarcodeFeedbackDefaults _buildStaticSparkScanBarcodeFeedbackDefaults(Map<String, Object?> json) {
  return SparkScanBarcodeFeedbackDefaults.fromJSON((json['barcodeFeedback']! as Map).cast<String, dynamic>());
}

SparkScanFeedbackDefaults _buildStaticSparkScanFeedbackDefaults() {
  return SparkScanFeedbackDefaults(
    _buildStaticSparkScanBarcodeFeedbackDefaults(_platformDefault(
      android: SparkScanFeedbackGeneratedDefaults.successAndroid,
      ios: SparkScanFeedbackGeneratedDefaults.successIos,
    )),
    _buildStaticSparkScanBarcodeFeedbackDefaults(_platformDefault(
      android: SparkScanFeedbackGeneratedDefaults.errorAndroid,
      ios: SparkScanFeedbackGeneratedDefaults.errorIos,
    )),
  );
}

// Builds the statically sourceable portion of SparkScanToastSettingsDefaults.
// The generated toastSettings const deliberately contains only
// {'toastEnabled': true}: every other toast key is genuinely absent from the
// native wire object, so all colours and messages resolve to null - matching
// what SparkScanToastSettingsDefaults.fromJSON produces for absent keys.
SparkScanToastSettingsDefaults _buildStaticSparkScanToastSettingsDefaults() {
  return SparkScanToastSettingsDefaults(
    SparkScanViewSettingsGeneratedDefaults.toastSettings['toastEnabled'] as bool,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  );
}

SparkScanViewSettingsDefaults _buildStaticSparkScanViewSettingsDefaults() {
  return SparkScanViewSettingsDefaults(
    Duration(seconds: SparkScanViewSettingsGeneratedDefaults.triggerButtonCollapseTimeout.toInt()),
    TorchState.fromJSON(SparkScanViewSettingsGeneratedDefaults.defaultTorchState),
    SparkScanScanningModeSerializer.fromJSON(
        SparkScanViewSettingsGeneratedDefaults.defaultScanningMode.cast<String, dynamic>()),
    SparkScanViewSettingsGeneratedDefaults.holdToScanEnabled,
    SparkScanViewSettingsGeneratedDefaults.soundEnabled,
    SparkScanViewSettingsGeneratedDefaults.hapticEnabled,
    SparkScanViewSettingsGeneratedDefaults.hardwareTriggerEnabled,
    // hardwareTriggerKeyCode is absent from the generated consts, i.e. null.
    null,
    SparkScanViewSettingsGeneratedDefaults.visualFeedbackEnabled,
    _buildStaticSparkScanToastSettingsDefaults(),
    SparkScanViewSettingsGeneratedDefaults.zoomFactorIn,
    SparkScanViewSettingsGeneratedDefaults.zoomFactorOut,
    Duration(seconds: SparkScanViewSettingsGeneratedDefaults.inactiveStateTimeout.toInt()),
    CameraPosition.fromJSON(SparkScanViewSettingsGeneratedDefaults.defaultCameraPosition),
    SparkScanMiniPreviewSizeSerializer.fromJSON(SparkScanViewSettingsGeneratedDefaults.defaultMiniPreviewSize),
    SparkScanViewSettingsGeneratedDefaults.periscopeModeEnabled,
  );
}

// Builds the statically sourceable portion of SparkScanViewDefaults. The
// device-probed hardwareTriggerSupported flag and the triggerButtonImage asset
// handle are NOT in the generated consts, so they take the same values the JSON
// path uses for an absent key (false / null) until initializeDefaults replaces
// the whole object - and with it the toast messages - from the native response.
SparkScanViewDefaults _buildStaticSparkScanViewDefaults() {
  // The trigger-button colours are iOS-only: Android's wrapper emits null and
  // lets the platform theme decide.
  return SparkScanViewDefaults(
    _buildStaticBrush(SparkScanViewGeneratedDefaults.brush),
    SparkScanViewGeneratedDefaults.torchControlVisible,
    SparkScanViewGeneratedDefaults.scanningBehaviorButtonVisible,
    SparkScanViewGeneratedDefaults.barcodeCountButtonVisible,
    SparkScanViewGeneratedDefaults.barcodeFindButtonVisible,
    SparkScanViewGeneratedDefaults.labelCaptureButtonVisible,
    SparkScanViewGeneratedDefaults.targetModeButtonVisible,
    SparkScanViewGeneratedDefaults.selectionModeButtonVisible,
    _androidNull(SparkScanViewGeneratedDefaults.toolbarBackgroundColor),
    _androidNull(SparkScanViewGeneratedDefaults.toolbarIconActiveTintColor),
    _androidNull(SparkScanViewGeneratedDefaults.toolbarIconInactiveTintColor),
    _buildStaticSparkScanViewSettingsDefaults(),
    SparkScanViewGeneratedDefaults.zoomSwitchControlVisible,
    false,
    SparkScanViewGeneratedDefaults.previewSizeControlVisible,
    SparkScanViewGeneratedDefaults.cameraSwitchButtonVisible,
    SparkScanViewGeneratedDefaults.previewCloseControlVisible,
    null,
    _staticColorOrNull(_platformDefault(
      android: SparkScanViewGeneratedDefaults.triggerButtonCollapsedColorAndroid,
      ios: SparkScanViewGeneratedDefaults.triggerButtonCollapsedColorIos,
    )),
    _staticColorOrNull(_platformDefault(
      android: SparkScanViewGeneratedDefaults.triggerButtonExpandedColorAndroid,
      ios: SparkScanViewGeneratedDefaults.triggerButtonExpandedColorIos,
    )),
    _staticColorOrNull(_platformDefault(
      android: SparkScanViewGeneratedDefaults.triggerButtonAnimationColorAndroid,
      ios: SparkScanViewGeneratedDefaults.triggerButtonAnimationColorIos,
    )),
    _androidNull(SparkScanViewGeneratedDefaults.triggerButtonTintColor),
    SparkScanViewGeneratedDefaults.triggerButtonVisible,
  );
}

// A generated colour const that is Object? (null on one platform) resolves to
// a null Color rather than a fabricated one.
Color? _staticColorOrNull(Object? hex) => hex == null ? null : ColorDeserializer.fromRgbaHex(hex as String);

// All seven SparkScanView chrome colours exist as C++ constants and are passed
// through by iOS, but the Android wrapper deliberately drops them and emits null
// so the view can resolve its own theme colour (SparkScanViewDefaults.kt:41-53).
// For four of them the SoT cannot record that: they back a compiled C++ constant
// that spark_scan_view_defaults.cc consumes, and one constant cannot hold two
// values - the generator's validator rejects such a split, and test_cpp_wiring
// requires the cppConstant to stay. So the wrapper-level fact lives here. It
// also belongs in dynamic.json's skip registry, which has no Barcode.* entries
// yet (SDC-33331).
Color? _androidNull(String iosHex) => Platform.isIOS ? ColorDeserializer.fromRgbaHex(iosHex) : null;

// ignore: avoid_classes_with_only_static_members
class SparkScanDefaults {
  // Statically sourced from generated/barcode_generated_defaults.dart - byte
  // identical to the native getDefaults() response, available immediately, no
  // method-channel round trip needed. See SDC-32174.
  static final SparkScanSettingsDefaults _sparkScanSettingsDefaults = _buildStaticSparkScanSettingsDefaults();

  static SparkScanSettingsDefaults get sparkScanSettingsDefaults => _sparkScanSettingsDefaults;

  static final SparkScanFeedbackDefaults _sparkScanFeedbackDefaults = _buildStaticSparkScanFeedbackDefaults();

  static SparkScanFeedbackDefaults get sparkScanFeedbackDefaults => _sparkScanFeedbackDefaults;

  // Not `final`: hardwareTriggerSupported, the triggerButtonImage asset handle
  // and the localized toast messages can only come from native, so
  // initializeDefaults still replaces this object.
  static SparkScanViewDefaults _sparkScanViewDefaults = _buildStaticSparkScanViewDefaults();

  static SparkScanViewDefaults get sparkScanViewDefaults => _sparkScanViewDefaults;

  static bool _isInitialized = false;

  // Residual dynamic set: the SparkScanView hardware-trigger probe, the trigger
  // button image and the localized toast messages.
  static void initializeDefaults(Map<String, dynamic> sparkScanDefaults) {
    if (_isInitialized) return;
    _sparkScanViewDefaults = SparkScanViewDefaults.fromJSON(sparkScanDefaults['SparkScanView']);

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
  final bool labelCaptureButtonVisible;
  final bool targetModeButtonVisible;
  final bool selectionModeButtonVisible;
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
      this.labelCaptureButtonVisible,
      this.targetModeButtonVisible,
      this.selectionModeButtonVisible,
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
    final labelCaptureButtonVisible = json['labelCaptureButtonVisible'] as bool;
    final targetModeButtonVisible = json['targetModeButtonVisible'] as bool;
    final selectionModeButtonVisible = json['selectionModeButtonVisible'] as bool;

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
        labelCaptureButtonVisible,
        targetModeButtonVisible,
        selectionModeButtonVisible,
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
  final String? selectionModeOnMessage;
  final String? selectionModeOffMessage;
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
      this.selectionModeOnMessage,
      this.selectionModeOffMessage,
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
    final selectionModeOnMessage = json['selectionModeOnMessage'] as String?;
    final selectionModeOffMessage = json['selectionModeOffMessage'] as String?;
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
        selectionModeOnMessage,
        selectionModeOffMessage,
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
  final Duration codeDuplicateFilter;
  final BatterySavingMode batterySaving;
  final ScanIntention scanIntention;
  final SelectionMode selectionMode;

  const SparkScanSettingsDefaults(this.codeDuplicateFilter, this.batterySaving, this.scanIntention, this.selectionMode);

  factory SparkScanSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    var durationInMillis = (json['codeDuplicateFilter'] as num).toInt();

    var duration = const Duration(milliseconds: 1) * durationInMillis;

    return SparkScanSettingsDefaults(
      duration,
      BatterySavingModeDeserializer.fromJSON(json['batterySaving'] as String),
      ScanIntentionSerializer.fromJSON(json['scanIntention'] as String),
      SelectionMode.fromJSON(json['selectionMode'] as String),
    );
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
  final bool periscopeModeEnabled;

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
      this.defaultMiniPreviewSize,
      this.periscopeModeEnabled);

  factory SparkScanViewSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    final triggerButtonCollapseTimeout = Duration(seconds: (json['triggerButtonCollapseTimeout'] as num).toInt());
    final defaultTorchState = TorchState.fromJSON(json['defaultTorchState'] as String);
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
      defaultCameraPosition = CameraPosition.fromJSON(json['defaultCameraPosition']);
    }

    final defaultMiniPreviewSize =
        SparkScanMiniPreviewSizeSerializer.fromJSON(json['defaultMiniPreviewSize'] as String);

    final periscopeModeEnabled = json['periscopeModeEnabled'] as bool? ?? false;

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
        defaultMiniPreviewSize,
        periscopeModeEnabled);
  }
}
