/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode_defaults.dart';
import '../symbology.dart';
import '../symbology_settings.dart';
import 'barcode_selection_defaults.dart';
import '../../scandit_flutter_datacapture_barcode_selection.dart';

class BarcodeSelectionSettings implements Serializable {
  BarcodeSelectionSettings();

  Duration codeDuplicateFilter =
      Duration(milliseconds: BarcodeSelectionDefaults.barcodeSelectionSettingsDefaults.codeDuplicateFilter);

  bool singleBarcodeAutoDetection =
      BarcodeSelectionDefaults.barcodeSelectionSettingsDefaults.singleBarcodeAutoDetectionEnabled;

  BarcodeSelectionType selectionType = BarcodeSelectionDefaults.barcodeSelectionSettingsDefaults.selectionType;

  final Map<String, dynamic> _properties = {};

  final Map<String, SymbologySettings> _symbologies = {};

  Set<Symbology> get enabledSymbologies => _enabledSymbologies();

  @override
  Map<String, dynamic> toMap() {
    return {
      'codeDuplicateFilter': codeDuplicateFilter.inMilliseconds,
      'properties': _properties,
      'symbologies': _symbologies.map<String, Map<String, dynamic>>((key, value) => MapEntry(key, value.toMap())),
      'singleBarcodeAutoDetectionEnabled': singleBarcodeAutoDetection,
      'selectionType': selectionType.toMap()
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
}
