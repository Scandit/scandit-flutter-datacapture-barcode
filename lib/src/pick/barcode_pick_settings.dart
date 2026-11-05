/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../aruco_dictionary.dart';
import '../barcode_filter_settings.dart';
import 'barcode_pick_defaults.dart';
import '../symbology.dart';
import '../symbology_settings.dart';

/// Contains the scanning options for an [BarcodePick] mode.
///
/// Added in version 6.22.0
class BarcodePickSettings implements Serializable {
  final Map<String, SymbologySettings> _symbologies = {};

  final Map<String, dynamic> _properties = {};

  ArucoDictionary? _arucoDictionary;

  /// Constructs a new instance with default values.
  ///
  /// Added in version 6.22.0
  BarcodePickSettings();

  /// Enables or disables the audio feedback. By default *true*.
  ///
  /// Added in version 6.22.0
  bool soundEnabled = BarcodePickDefaults.barcodePickSettings.soundEnabled;
  /// Enables or disables the caching of scanned barcodes to a specific product identifier. Once enabled, the request for product identifier won’t be made if scanned barcodes could be found in cache. By default *true*.
  ///
  /// Added in version 6.22.0
  bool cachingEnabled = BarcodePickDefaults.barcodePickSettings.cachingEnabled;
  /// Enables or disables the haptic feedback. By default *true*.
  ///
  /// Added in version 6.22.0
  bool hapticsEnabled = BarcodePickDefaults.barcodePickSettings.hapticsEnabled;
  /// Sets and access the barcode filter settings.
  ///
  /// Added in version 8.3.0
  BarcodeFilterSettings filterSettings = BarcodePickDefaults.barcodePickSettings.filterSettings;

  /// Gets [SymbologySettings] specific for the given [Symbology].
  ///
  /// Added in version 6.22.0
  SymbologySettings settingsForSymbology(Symbology symbology) {
    var identifier = symbology.toString();
    if (!_symbologies.containsKey(identifier)) {
      var symbologySettings = BarcodePickDefaults.defaultSymbologySettingsFor(identifier);
      _symbologies[identifier] = symbologySettings;
    }
    return _symbologies[identifier]!;
  }

  /// Returns the set of enabled symbologies.
  ///
  /// Added in version 6.22.0
  Set<Symbology> get enabledSymbologies => _enabledSymbologies();

  /// Sets property to the provided value. Use this method to set properties that are not yet part of a stable API. Properties set through this method may or may not be used or change in a future release.
  ///
  /// Added in version 6.22.0
  void setProperty<T>(String name, T value) {
    _properties[name] = value;
  }

  /// Retrieves the value of a previously set property.
  ///
  /// Added in version 6.22.0
  T getProperty<T>(String name) {
    return _properties[name] as T;
  }

  /// This function provides a convenient shortcut to enabling decoding of particular symbologies without having to go through [SymbologySettings]. By default, all symbologies are turned off and symbologies need to be explicitly enabled.
  ///
  /// Added in version 6.22.0
  void enableSymbologies(Set<Symbology> symbologies) {
    for (var symbology in symbologies) {
      enableSymbology(symbology, true);
    }
  }

  // ignore: avoid_positional_boolean_parameters
  /// This function provides a convenient shortcut to enabling/disabling decoding of a particular symbology without having to go through [SymbologySettings].
  ///
  /// Some 1d barcode symbologies allow you to encode variable-length data. By default, the Scandit Data Capture SDK only scans barcodes in a certain length range.If your application requires scanning of one of these symbologies, and the length is falling outside the default range, you may need to adjust the active symbol counts ([SymbologySettings.activeSymbolCounts]) for the symbology in addition to enabling it.
  ///
  /// Added in version 6.22.0
  void enableSymbology(Symbology symbology, bool enabled) {
    settingsForSymbology(symbology).isEnabled = enabled;
  }

  Set<Symbology> _enabledSymbologies() {
    return _symbologies.values.where((element) => element.isEnabled).map((e) => e.symbology).toSet().cast<Symbology>();
  }

  /// Sets the [ArucoDictionary] to be used while scanning ArUco codes. When the symbology is enabled the dictionary [ArucoDictionaryPreset.arucoDictionaryPreset_5X5_1000] is loaded as default.
  ///
  /// Added in version 6.22.0
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
      'arucoDictionary': _arucoDictionary?.toMap(),
      'filterSettings': filterSettings.toMap()
    };
  }
}
