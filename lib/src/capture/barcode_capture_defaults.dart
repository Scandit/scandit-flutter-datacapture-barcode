/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../generated/barcode_generated_defaults.dart';

// Builds a Brush from a generated flat {fillColor, strokeColor, strokeWidth}
// default literal - the shape BrushDefaults.fromJSON consumes on the native
// path. Kept private per file, mirroring core's and id's own copies.
Brush _buildStaticBrush(Map<String, Object?> json) {
  final fillColor = ColorDeserializer.fromRgbaHex(json['fillColor'] as String? ?? '#00000000');
  final strokeColor = ColorDeserializer.fromRgbaHex(json['strokeColor'] as String? ?? '#00000000');
  final strokeWidth = (json['strokeWidth'] as num?)?.toDouble() ?? 0.0;
  return Brush(fillColor, strokeColor, strokeWidth);
}

BarcodeCaptureSettingsDefaults _buildStaticBarcodeCaptureSettingsDefaults() {
  return BarcodeCaptureSettingsDefaults(
    const Duration(milliseconds: 1) * BarcodeCaptureSettingsGeneratedDefaults.codeDuplicateFilter,
    BatterySavingModeDeserializer.fromJSON(BarcodeCaptureSettingsGeneratedDefaults.batterySaving),
    ScanIntentionSerializer.fromJSON(BarcodeCaptureSettingsGeneratedDefaults.scanIntention),
    SelectionMode.fromJSON(BarcodeCaptureSettingsGeneratedDefaults.selectionMode),
  );
}

BarcodeCaptureOverlayDefaults _buildStaticBarcodeCaptureOverlayDefaults() {
  return BarcodeCaptureOverlayDefaults(_buildStaticBrush(BarcodeCaptureOverlayGeneratedDefaults.defaultBrush));
}

// ignore: avoid_classes_with_only_static_members
class BarcodeCaptureDefaults {
  static late CameraSettingsDefaults _cameraSettingsDefaults;

  // Statically sourced from generated/barcode_generated_defaults.dart - byte
  // identical to the native getDefaults() response, available immediately, no
  // method-channel round trip needed. See SDC-32174.
  static final BarcodeCaptureSettingsDefaults _barcodeCaptureSettingsDefaults =
      _buildStaticBarcodeCaptureSettingsDefaults();

  static final BarcodeCaptureOverlayDefaults _barcodeCaptureOverlayDefaults =
      _buildStaticBarcodeCaptureOverlayDefaults();

  static CameraSettingsDefaults get cameraSettingsDefaults => _cameraSettingsDefaults;

  static BarcodeCaptureSettingsDefaults get barcodeCaptureSettingsDefaults => _barcodeCaptureSettingsDefaults;

  static BarcodeCaptureOverlayDefaults get barcodeCaptureOverlayDefaults => _barcodeCaptureOverlayDefaults;

  // RecommendedCameraSettings is intentionally NOT staticized (iOS resolves it
  // against the running device model), so it stays fully dynamic - see the id
  // package for the full rationale.
  static void initializeDefaults(Map<String, dynamic> barcodeCaptureDefaults) {
    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(barcodeCaptureDefaults['RecommendedCameraSettings']);
  }
}

@immutable
class BarcodeCaptureSettingsDefaults {
  final Duration codeDuplicateFilter;
  final BatterySavingMode batterySaving;
  final ScanIntention scanIntention;
  final SelectionMode selectionMode;

  const BarcodeCaptureSettingsDefaults(
      this.codeDuplicateFilter, this.batterySaving, this.scanIntention, this.selectionMode);

  factory BarcodeCaptureSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    var durationInMillis = (json['codeDuplicateFilter'] as num).toInt();

    var duration = const Duration(milliseconds: 1) * durationInMillis;

    return BarcodeCaptureSettingsDefaults(
      duration,
      BatterySavingModeDeserializer.fromJSON(json['batterySaving'] as String),
      ScanIntentionSerializer.fromJSON(json['scanIntention'] as String),
      SelectionMode.fromJSON(json['selectionMode'] as String),
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
