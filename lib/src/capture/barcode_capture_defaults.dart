/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_capture_function_names.dart';

// ignore: avoid_classes_with_only_static_members
class BarcodeCaptureDefaults {
  static MethodChannel channel =
      MethodChannel('com.scandit.datacapture.barcode.capture.method/barcode_capture_defaults');

  static CameraSettingsDefaults _cameraSettingsDefaults;

  static BarcodeCaptureSettingsDefaults _barcodeCaptureSettingsDefaults;

  static BarcodeCaptureOverlayDefaults _barcodeCaptureOverlayDefaults;

  static CameraSettingsDefaults get cameraSettingsDefaults => _cameraSettingsDefaults;

  static BarcodeCaptureSettingsDefaults get barcodeCaptureSettingsDefaults => _barcodeCaptureSettingsDefaults;

  static BarcodeCaptureOverlayDefaults get barcodeCaptureOverlayDefaults => _barcodeCaptureOverlayDefaults;

  static bool _isInitialized = false;

  static Future<void> initializeDefaults() async {
    if (_isInitialized) return;
    var result = await channel.invokeMethod(BarcodeCaptureFunctionNames.getBarcodeCaptureDefaults);
    var json = jsonDecode(result as String);
    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(json['RecommendedCameraSettings']);
    _barcodeCaptureSettingsDefaults =
        BarcodeCaptureSettingsDefaults((json['BarcodeCaptureSettings']['codeDuplicateFilter'] as num).toInt());
    _barcodeCaptureOverlayDefaults =
        BarcodeCaptureOverlayDefaults.fromJSON(json['BarcodeCaptureOverlay'] as Map<String, dynamic>);

    _isInitialized = true;
  }
}

@immutable
class BarcodeCaptureSettingsDefaults {
  final int codeDuplicateFilter;

  BarcodeCaptureSettingsDefaults(this.codeDuplicateFilter);
}

@immutable
class BarcodeCaptureOverlayDefaults {
  final BrushDefaults defaultBrush;

  BarcodeCaptureOverlayDefaults(this.defaultBrush);

  factory BarcodeCaptureOverlayDefaults.fromJSON(Map<String, dynamic> json) {
    var defaultBrush = BrushDefaults.fromJSON(json['DefaultBrush'] as Map<String, dynamic>);
    return BarcodeCaptureOverlayDefaults(defaultBrush);
  }
}
