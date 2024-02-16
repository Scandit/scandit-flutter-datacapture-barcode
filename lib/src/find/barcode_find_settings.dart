/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import '../barcode_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../../scandit_flutter_datacapture_barcode.dart';

class BarcodeFindSettings implements Serializable {
  final Map<String, SymbologySettings> _symbologies = {};

  final Map<String, dynamic> _properties = {};

  BarcodeFindSettings();

  SymbologySettings settingsForSymbology(Symbology symbology) {
    var identifier = symbology.toString();
    if (!_symbologies.containsKey(identifier)) {
      var symbologySettings = BarcodeDefaults.symbologySettingsDefaults[identifier]!;
      _symbologies[identifier] = symbologySettings;
    }
    return _symbologies[identifier]!;
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

  Set<Symbology> get enabledSymbologies => _enabledSymbologies();

  Set<Symbology> _enabledSymbologies() {
    return _symbologies.values
        .where((symbologySettings) => symbologySettings.isEnabled)
        .map((symbologySettings) => symbologySettings.symbology)
        .toSet()
        .cast<Symbology>();
  }

  void setProperty<T>(String name, T value) {
    _properties[name] = value;
  }

  T getProperty<T>(String name) {
    return _properties[name] as T;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'symbologies': _symbologies.map<String, Map<String, dynamic>>((key, value) => MapEntry(key, value.toMap())),
      'properties': _properties,
    };
  }
}
