/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'barcode_tracking_function_names.dart';

// ignore: avoid_classes_with_only_static_members
class BarcodeTrackingDefaults {
  static final MethodChannel channel =
      MethodChannel('com.scandit.datacapture.barcode.tracking.method/barcode_tracking_defaults');

  static late CameraSettingsDefaults _recommendedCameraSettings;
  static CameraSettingsDefaults get recommendedCameraSettings => _recommendedCameraSettings;

  static late BarcodeTrackingBasicOverlayDefaults _barcodeTrackingBasicOverlayDefaults;
  static BarcodeTrackingBasicOverlayDefaults get barcodeTrackingBasicOverlayDefaults =>
      _barcodeTrackingBasicOverlayDefaults;

  static bool _isInitialized = false;

  static Future<void> getDefaults() async {
    if (_isInitialized) return;
    var result = await channel.invokeMethod(BarcodeTrackingFunctionNames.getBarcodeTrackingDefaults);
    var json = jsonDecode(result as String);
    _recommendedCameraSettings =
        CameraSettingsDefaults.fromJSON(json['RecommendedCameraSettings'] as Map<String, dynamic>);
    _barcodeTrackingBasicOverlayDefaults =
        BarcodeTrackingBasicOverlayDefaults.fromJSON(json['BarcodeTrackingBasicOverlay'] as Map<String, dynamic>);
    _isInitialized = true;
  }
}

@immutable
class BarcodeTrackingBasicOverlayDefaults {
  final BrushDefaults defaultBrush;

  BarcodeTrackingBasicOverlayDefaults(this.defaultBrush);

  factory BarcodeTrackingBasicOverlayDefaults.fromJSON(Map<String, dynamic> json) {
    var defaultBrush = BrushDefaults.fromJSON(json['DefaultBrush'] as Map<String, dynamic>);
    return BarcodeTrackingBasicOverlayDefaults(defaultBrush);
  }
}
