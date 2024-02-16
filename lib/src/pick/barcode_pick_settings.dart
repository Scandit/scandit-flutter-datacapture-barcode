/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../aruco_dictionary.dart';
import 'barcode_pick_defaults.dart';
import '../symbology.dart';
import '../symbology_settings.dart';

class BarcodePickSettings implements Serializable {
  final Map<String, SymbologySettings> _symbologies = {};

  final Map<String, dynamic> _properties = {};

  ArucoDictionary? _arucoDictionary;

  BarcodePickSettings();

  bool soundEnabled = BarcodePickDefaults.barcodePickSettings.soundEnabled;
  bool cachingEnabled = BarcodePickDefaults.barcodePickSettings.cachingEnabled;
  bool hapticsEnabled = BarcodePickDefaults.barcodePickSettings.hapticsEnabled;

  SymbologySettings settingsForSymbology(Symbology symbology) {
    var identifier = symbology.toString();
    if (!_symbologies.containsKey(identifier)) {
      var symbologySettings = BarcodePickDefaults.symbologySettingsDefaults[identifier]!;
      _symbologies[identifier] = symbologySettings;
    }
    return _symbologies[identifier]!;
  }

  Set<Symbology> get enabledSymbologies => _enabledSymbologies();

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

  Set<Symbology> _enabledSymbologies() {
    return _symbologies.values.where((element) => element.isEnabled).map((e) => e.symbology).toSet().cast<Symbology>();
  }

  void setArucoDictionary(ArucoDictionary dictionary) {
    _arucoDictionary = dictionary;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'properties': _properties,
      'symbologies': _symbologies.map<String, Map<String, dynamic>>((key, value) => MapEntry(key, value.toMap())),
      'soundEnabled': soundEnabled,
      'hapticEnabled': hapticsEnabled,
      'cachingEnabled': cachingEnabled,
      'arucoDictionary': _arucoDictionary?.toMap()
    };
  }
}
