/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode_defaults.dart';
import '../symbology.dart';
import '../symbology_settings.dart';
import 'spark_scan_defaults.dart';

class SparkScanSettings implements Serializable {
  SparkScanSettings();

  Duration codeDuplicateFilter =
      Duration(milliseconds: SparkScanDefaults.sparkScanSettingsDefaults.codeDuplicateFilter);

  BatterySavingMode batterySaving = SparkScanDefaults.sparkScanSettingsDefaults.batterySaving;

  final Map<String, dynamic> _properties = {};

  final Map<String, SymbologySettings> _symbologies = {};

  Set<Symbology> get enabledSymbologies => _enabledSymbologies();

  bool _singleBarcodeAutoDetection = SparkScanDefaults.sparkScanSettingsDefaults.singleBarcodeAutoDetection;

  @Deprecated(
      'With the recent improvements introduced in the target mode, selection of barcodes is easier and more reliable. Given that, this method is outdated and not needed anymore.')
  bool get singleBarcodeAutoDetection => _singleBarcodeAutoDetection;

  @Deprecated(
      'With the recent improvements introduced in the target mode, selection of barcodes is easier and more reliable. Given that, this method is outdated and not needed anymore.')
  set singleBarcodeAutoDetection(bool newValue) {
    _singleBarcodeAutoDetection = newValue;
  }

  Set<Symbology> _enabledSymbologies() {
    return _symbologies.values.where((element) => element.isEnabled).map((e) => e.symbology).toSet().cast<Symbology>();
  }

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

  @override
  Map<String, dynamic> toMap() {
    return {
      'codeDuplicateFilter': codeDuplicateFilter.inMilliseconds,
      'properties': _properties,
      'batterySaving': batterySaving.toString(),
      'symbologies': _symbologies.map<String, Map<String, dynamic>>((key, value) => MapEntry(key, value.toMap())),
    };
  }
}
