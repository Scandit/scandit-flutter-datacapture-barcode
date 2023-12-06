/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'package:flutter/services.dart';

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

  static MethodChannel channel = MethodChannel('com.scandit.datacapture.barcode.method/barcode_defaults');

  static bool _isInitialized = false;

  static Future<dynamic> initializeDefaults() async {
    if (_isInitialized) return;

    var result = await channel.invokeMethod(BarcodeFunctionNames.getDefaults);
    Map<String, dynamic> defaults = jsonDecode(result as String);
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

    _isInitialized = true;
  }

  static List<SymbologyDescription> get symbologyDescriptionsDefaults => _symbologyDescriptionsDefaults;
  static Map<String, SymbologySettings> get symbologySettingsDefaults => _symbologySettingsDefaults;
  static List<CompositeTypeDescription> get compositeTypeDescriptionsDefaults => _compositeTypeDescriptionsDefaults;
}
