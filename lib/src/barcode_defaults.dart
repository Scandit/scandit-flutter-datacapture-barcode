/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'package:flutter/services.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/logging/logging_method_channel.dart';
import 'package:scandit_flutter_datacapture_barcode/src/ar/barcode_ar_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/batch/barcode_batch_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/capture/barcode_capture_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/barcode_count_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/selection/barcode_selection_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_defaults.dart';

import 'symbology.dart';
import 'symbology_description.dart';
import 'symbology_settings.dart';
import 'barcode_function_names.dart';
import 'composite_type_description.dart';

// ignore: avoid_classes_with_only_static_members
class BarcodeDefaults {
  static late List<SymbologyDescription> _symbologyDescriptionsDefaults;
  static late Map<String, SymbologySettings> _symbologySettingsDefaults;
  static late List<CompositeTypeDescription> _compositeTypeDescriptionsDefaults;

  static MethodChannel channel = const LoggingMethodChannel(BarcodeFunctionNames.methodsChannelName);

  static bool _isInitialized = false;

  // Most of this package's defaults are now sourced statically from
  // generated/barcode_generated_defaults.dart (see SDC-32174) and are readable
  // before this ever runs. What is left on the native round trip: the
  // symbology/composite-type descriptions and the per-symbology
  // SymbologySettings map below (the generated stub is empty), every mode's
  // RecommendedCameraSettings, the device-probed hardware-trigger flags, the
  // localized view texts, and the default icon asset handles - so the fan-out
  // below is unchanged and each sub-module picks up its own residual keys. The
  // native call is the narrow getDynamicDefaults endpoint, which returns exactly
  // those residual keys. It is the only defaults endpoint - the full-blob
  // getDefaults was removed in SDC-32178.
  static Future<dynamic> initializeDefaults() async {
    if (_isInitialized) return;

    var result = await channel.invokeMethod(BarcodeFunctionNames.getDynamicDefaults);
    Map<String, dynamic> defaults = jsonDecode(result as String);
    _loadBarcodeDefaults(defaults['Barcode'] as Map<String, dynamic>);
    BarcodeCaptureDefaults.initializeDefaults(defaults['BarcodeCapture'] as Map<String, dynamic>);
    BarcodeSelectionDefaults.initializeDefaults(defaults['BarcodeSelection'] as Map<String, dynamic>);
    BarcodeBatchDefaults.initializeDefaults(defaults['BarcodeBatch'] as Map<String, dynamic>);
    SparkScanDefaults.initializeDefaults(defaults['SparkScan'] as Map<String, dynamic>);
    BarcodeCountDefaults.initializeDefaults(defaults['BarcodeCount'] as Map<String, dynamic>);
    BarcodePickDefaults.initializeDefaults(defaults['BarcodePick'] as Map<String, dynamic>);
    BarcodeFindDefaults.initializeDefaults(defaults['BarcodeFind'] as Map<String, dynamic>);
    BarcodeArDefaults.initializeDefaults(defaults['BarcodeAr'] as Map<String, dynamic>);
    _isInitialized = true;
  }

  static void _loadBarcodeDefaults(Map<String, dynamic> defaults) {
    _symbologyDescriptionsDefaults = (defaults['SymbologyDescriptions'] as List<dynamic>)
        .map((e) => SymbologyDescription.fromJSON(jsonDecode(e)))
        .toList()
        .cast<SymbologyDescription>();
    _symbologySettingsDefaults = (defaults['SymbologySettings'] as Map<String, dynamic>).map((key, value) =>
        MapEntry(key, SymbologySettings.fromJSON(SymbologySerializer.fromJSON(key), jsonDecode(value))));
    _compositeTypeDescriptionsDefaults = (defaults['CompositeTypeDescriptions'] as List<dynamic>)
        .map((e) => CompositeTypeDescription.fromJSON(jsonDecode(e)))
        .toList()
        .cast<CompositeTypeDescription>();
  }

  static List<SymbologyDescription> get symbologyDescriptionsDefaults => _symbologyDescriptionsDefaults;

  /// The map itself is unmodifiable, but the [SymbologySettings] values are not:
  /// mutating one still changes the process-wide default. Seed a settings object
  /// with [defaultSymbologySettingsFor] instead of writing to these (SDC-32039).
  static Map<String, SymbologySettings> get symbologySettingsDefaults =>
      Map<String, SymbologySettings>.unmodifiable(_symbologySettingsDefaults);

  /// A fresh copy of the defaults for [identifier], for seeding a settings object.
  ///
  /// The defaults map is built once per process and its values are mutable, so
  /// handing them out directly made every mode's settings alias the same
  /// SymbologySettings instances: enabling a symbology for one mode enabled it
  /// for all the others, and disabling it disabled it everywhere (SDC-32039).
  /// Throws [StateError] if [identifier] has no entry in the native defaults,
  /// matching the shared JS frameworks, which raise
  /// `Missing symbology defaults for <symbology>` for the same condition.
  static SymbologySettings defaultSymbologySettingsFor(String identifier) {
    final defaults = _symbologySettingsDefaults[identifier];
    if (defaults == null) {
      throw StateError('Missing symbology defaults for $identifier');
    }
    return SymbologySettings.fromJSON(defaults.symbology, defaults.toMap());
  }

  static List<CompositeTypeDescription> get compositeTypeDescriptionsDefaults => _compositeTypeDescriptionsDefaults;
}
