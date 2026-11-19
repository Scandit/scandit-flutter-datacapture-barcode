/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';

import 'barcode_batch_basic_overlay.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

// ignore: avoid_classes_with_only_static_members
class BarcodeBatchDefaults {
  static late CameraSettingsDefaults _recommendedCameraSettings;
  static CameraSettingsDefaults get recommendedCameraSettings => _recommendedCameraSettings;

  static late BarcodeBatchBasicOverlayDefaults _barcodeBatchBasicOverlayDefaults;
  static BarcodeBatchBasicOverlayDefaults get barcodeBatchBasicOverlayDefaults => _barcodeBatchBasicOverlayDefaults;

  static Future<void> initializeDefaults(Map<String, dynamic> barcodeBatchDefaults) async {
    _recommendedCameraSettings = CameraSettingsDefaults.fromJSON(barcodeBatchDefaults['RecommendedCameraSettings']);
    _barcodeBatchBasicOverlayDefaults =
        BarcodeBatchBasicOverlayDefaults.fromJSON(barcodeBatchDefaults['BarcodeBatchBasicOverlay']);
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
