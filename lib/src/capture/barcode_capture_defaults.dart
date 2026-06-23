/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

// ignore: avoid_classes_with_only_static_members
class BarcodeCaptureDefaults {
  static late CameraSettingsDefaults _cameraSettingsDefaults;

  static late BarcodeCaptureSettingsDefaults _barcodeCaptureSettingsDefaults;

  static late BarcodeCaptureOverlayDefaults _barcodeCaptureOverlayDefaults;

  static CameraSettingsDefaults get cameraSettingsDefaults => _cameraSettingsDefaults;

  static BarcodeCaptureSettingsDefaults get barcodeCaptureSettingsDefaults => _barcodeCaptureSettingsDefaults;

  static BarcodeCaptureOverlayDefaults get barcodeCaptureOverlayDefaults => _barcodeCaptureOverlayDefaults;

  static void initializeDefaults(Map<String, dynamic> barcodeCaptureDefaults) {
    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(barcodeCaptureDefaults['RecommendedCameraSettings']);
    _barcodeCaptureSettingsDefaults =
        BarcodeCaptureSettingsDefaults.fromJSON(barcodeCaptureDefaults['BarcodeCaptureSettings']);
    _barcodeCaptureOverlayDefaults =
        BarcodeCaptureOverlayDefaults.fromJSON(barcodeCaptureDefaults['BarcodeCaptureOverlay'] as Map<String, dynamic>);
  }
}

@immutable
class BarcodeCaptureSettingsDefaults {
  final Duration codeDuplicateFilter;
  final BatterySavingMode batterySaving;
  final ScanIntention scanIntention;

  const BarcodeCaptureSettingsDefaults(this.codeDuplicateFilter, this.batterySaving, this.scanIntention);

  factory BarcodeCaptureSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    var durationInMillis = (json['codeDuplicateFilter'] as num).toInt();

    var duration = const Duration(milliseconds: 1) * durationInMillis;

    return BarcodeCaptureSettingsDefaults(
      duration,
      BatterySavingModeDeserializer.fromJSON(json['batterySaving'] as String),
      ScanIntentionSerializer.fromJSON(json['scanIntention'] as String),
    );
  }
}

@immutable
class BarcodeCaptureOverlayDefaults {
  final Brush defaultBrush;

  const BarcodeCaptureOverlayDefaults(this.defaultBrush);

  factory BarcodeCaptureOverlayDefaults.fromJSON(Map<String, dynamic> json) {
    return BarcodeCaptureOverlayDefaults(
        BrushDefaults.fromJSON(json['DefaultBrush'] as Map<String, dynamic>).toBrush());
  }
}
