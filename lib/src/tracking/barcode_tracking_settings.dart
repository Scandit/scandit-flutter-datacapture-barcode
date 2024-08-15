/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import '../symbology.dart';
import '../symbology_settings.dart';
import '../barcode_defaults.dart';

@Deprecated('Setting a scenario is no longer recommended, use the BarcodeTrackingSettings empty constructor instead.')
enum BarcodeTrackingScenario {
  a('A'),
  b('B');

  const BarcodeTrackingScenario(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeTrackingScenarioSerializer on BarcodeTrackingScenario {
  static BarcodeTrackingScenario fromJSON(String jsonValue) {
    return BarcodeTrackingScenario.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

class BarcodeTrackingSettings implements Serializable {
  final BarcodeTrackingScenario? _scenario;
  final Map<String, dynamic> _properties = {};
  final Map<String, SymbologySettings> _symbologies = {};

  Set<Symbology> get enabledSymbologies => _enabledSymbologies();

  BarcodeTrackingSettings() : this.forScenario(null);
  BarcodeTrackingSettings._(this._scenario);
  @Deprecated('Setting a scenario is no longer recommended, use the BarcodeTrackingSettings empty constructor instead.')
  BarcodeTrackingSettings.forScenario(BarcodeTrackingScenario? scenario) : this._(scenario);

  SymbologySettings settingsForSymbology(Symbology symbology) {
    var identifier = symbology.toString();
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

  Set<Symbology> _enabledSymbologies() {
    return _symbologies.values
        .where((symbologySettings) => symbologySettings.isEnabled)
        .map((symbologySettings) => symbologySettings.symbology)
        .toSet()
        .cast<Symbology>();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'properties': _properties,
      'symbologies': _symbologies.map((key, value) => MapEntry(key, value.toMap()))
    };
    if (_scenario != null) {
      json['scenario'] = _scenario.toString();
    }
    return json;
  }
}
