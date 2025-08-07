/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'barcode_batch_basic_overlay.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'barcode_batch_function_names.dart';

// ignore: avoid_classes_with_only_static_members
class BarcodeBatchDefaults {
  static const MethodChannel channel = MethodChannel(BarcodeBatchFunctionNames.methodsChannelName);

  static late CameraSettingsDefaults _recommendedCameraSettings;
  static CameraSettingsDefaults get recommendedCameraSettings => _recommendedCameraSettings;

  static late BarcodeBatchBasicOverlayDefaults _barcodeBatchBasicOverlayDefaults;
  static BarcodeBatchBasicOverlayDefaults get barcodeBatchBasicOverlayDefaults => _barcodeBatchBasicOverlayDefaults;

  static bool _isInitialized = false;

  static Future<void> getDefaults() async {
    if (_isInitialized) return;
    var result = await channel.invokeMethod(BarcodeBatchFunctionNames.getBarcodeBatchDefaults);
    var json = jsonDecode(result as String);
    _recommendedCameraSettings =
        CameraSettingsDefaults.fromJSON(json['RecommendedCameraSettings'] as Map<String, dynamic>);
    _barcodeBatchBasicOverlayDefaults =
        BarcodeBatchBasicOverlayDefaults.fromJSON(json['BarcodeBatchBasicOverlay'] as Map<String, dynamic>);
    _isInitialized = true;
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
