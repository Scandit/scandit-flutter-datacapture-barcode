/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode_defaults.dart';
import '../symbology.dart';
import '../symbology_settings.dart';
import 'barcode_capture_defaults.dart';
import '../composite_type.dart';

class BarcodeCaptureSettings implements Serializable {
  BarcodeCaptureSettings();

  Duration codeDuplicateFilter =
      Duration(milliseconds: BarcodeCaptureDefaults.barcodeCaptureSettingsDefaults.codeDuplicateFilter);

  LocationSelection? locationSelection;

  final Map<String, dynamic> _properties = {};

  final Map<String, SymbologySettings> _symbologies = {};

  Set<Symbology> get enabledSymbologies => _enabledSymbologies();

  Set<CompositeType> enabledCompositeTypes = {};

  @override
  Map<String, dynamic> toMap() {
    return {
      'codeDuplicateFilter': codeDuplicateFilter.inMilliseconds,
      'locationSelection': locationSelection == null ? {'type': 'none'} : locationSelection?.toMap(),
      'properties': _properties,
      'symbologies': _symbologies.map<String, Map<String, dynamic>>((key, value) => MapEntry(key, value.toMap())),
      'enabledCompositeTypes': enabledCompositeTypes.map((e) => e.jsonValue).toList()
    };
  }

  Set<Symbology> _enabledSymbologies() {
    return _symbologies.values.where((element) => element.isEnabled).map((e) => e.symbology).toSet().cast<Symbology>();
  }

  SymbologySettings settingsForSymbology(Symbology symbology) {
    var identifier = symbology.jsonValue;
    if (!_symbologies.containsKey(identifier)) {
      var symbologySettings = BarcodeDefaults.symbologySettingsDefaults[identifier]!;
      _symbologies[identifier] = symbologySettings;
    }
    return _symbologies[identifier]!;
  }

  void setProperty<T>(String name, T value) {
    _properties[name] = value;
  }

  T getProperty<T>(String name) {
    return _properties[name] as T;
  }

  void enableSymbologies(Set<Symbology> symbologies) {
    for (var symbology in symbologies) {
      enableSymbology(symbology, true);
    }
  }

  // ignore: avoid_positional_boolean_parameters
  void enableSymbology(Symbology symbology, bool enabled) {
    settingsForSymbology(symbology).isEnabled = enabled;
  }

  void enableSymbologiesForCompositeTypes(Set<CompositeType> compositeTypes) {
    for (var compositeType in compositeTypes) {
      var symbologies = BarcodeDefaults.compositeTypeDescriptionsDefaults
          .firstWhere((element) => element.types.contains(compositeType));

      enableSymbologies(symbologies.symbologies);
    }
  }
}
