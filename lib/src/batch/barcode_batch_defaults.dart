/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

import 'barcode_batch_basic_overlay.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../generated/barcode_generated_defaults.dart';

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

BarcodeBatchBasicOverlayDefaults _buildStaticBarcodeBatchBasicOverlayDefaults() {
  // Brush colours are platform-split: the Android wrapper rounds native's
  // float channels half-up while iOS truncates (#00FFFF73 vs #00FFFF72).
  final brushes = _platformDefault(
    android: BarcodeBatchOverlayGeneratedDefaults.brushesAndroid,
    ios: BarcodeBatchOverlayGeneratedDefaults.brushesIos,
  );
  return BarcodeBatchBasicOverlayDefaults(
    BarcodeBatchBasicOverlayStyleSerializer.fromJSON(BarcodeBatchOverlayGeneratedDefaults.defaultStyle),
    brushes.map((key, value) => MapEntry(
        BarcodeBatchBasicOverlayStyleSerializer.fromJSON(key), _buildStaticBrush(value as Map<String, Object?>))),
  );
}

// ignore: avoid_classes_with_only_static_members
class BarcodeBatchDefaults {
  static late CameraSettingsDefaults _recommendedCameraSettings;
  static CameraSettingsDefaults get recommendedCameraSettings => _recommendedCameraSettings;

  // Statically sourced from generated/barcode_generated_defaults.dart - byte
  // identical to the native getDefaults() response, available immediately, no
  // method-channel round trip needed. See SDC-32174.
  static final BarcodeBatchBasicOverlayDefaults _barcodeBatchBasicOverlayDefaults =
      _buildStaticBarcodeBatchBasicOverlayDefaults();
  static BarcodeBatchBasicOverlayDefaults get barcodeBatchBasicOverlayDefaults => _barcodeBatchBasicOverlayDefaults;

  // RecommendedCameraSettings stays fully dynamic - see the id package.
  static Future<void> initializeDefaults(Map<String, dynamic> barcodeBatchDefaults) async {
    _recommendedCameraSettings = CameraSettingsDefaults.fromJSON(barcodeBatchDefaults['RecommendedCameraSettings']);
  }
}

@immutable
class BarcodeBatchBasicOverlayDefaults {
  final BarcodeBatchBasicOverlayStyle defaultStyle;
  final Map<BarcodeBatchBasicOverlayStyle, Brush> brushes;

  const BarcodeBatchBasicOverlayDefaults(this.defaultStyle, this.brushes);

  factory BarcodeBatchBasicOverlayDefaults.fromJSON(Map<String, dynamic> json) {
    var defaultStyle = BarcodeBatchBasicOverlayStyleSerializer.fromJSON(json['defaultStyle'] as String);
    var brushes = (json['Brushes'] as Map<String, dynamic>).map((key, value) => MapEntry(
        BarcodeBatchBasicOverlayStyleSerializer.fromJSON(key),
        BrushDefaults.fromJSON(value as Map<String, dynamic>).toBrush()));
    return BarcodeBatchBasicOverlayDefaults(defaultStyle, brushes);
  }
}
