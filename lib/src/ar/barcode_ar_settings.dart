/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../symbology.dart';
import '../symbology_settings.dart';
import '../barcode_defaults.dart';
import 'barcode_ar_defaults.dart';

/// Added in version 7.1.0
class BarcodeArSettings implements Serializable {
  final Map<String, dynamic> _properties = {};
  final Map<String, SymbologySettings> _symbologies = {};

  /// Creates a new Barcode AR settings instance. All symbologies are disabled. Make sure to enable the symbologies required by your app before applying the settings to [BarcodeAr] with BarcodeAr.applySettings().
  ///
  /// Added in version 8.6.0
  BarcodeArSettings();

  /// Declares whether or not the barcodes to be tracked are expected to be unique. If enabled optimizations can be used to improve Barcode AR.
  ///
  /// Added in version 8.6.0
  bool expectsOnlyUniqueBarcodes = BarcodeArDefaults.settings.expectsOnlyUniqueBarcodes;

  /// Returns the set of enabled symbologies.
  ///
  /// Added in version 7.1.0
  Set<Symbology> get enabledSymbologies => _enabledSymbologies();

  Set<Symbology> _enabledSymbologies() {
    return _symbologies.values
        .where((symbologySettings) => symbologySettings.isEnabled)
        .map((symbologySettings) => symbologySettings.symbology)
        .toSet()
        .cast<Symbology>();
  }

  /// Gets [SymbologySettings] specific for the given [Symbology].
  ///
  /// Note that modifying the returned object doesn’t automatically apply the changes to [BarcodeAr]. After you made changes to the symbology settings, call BarcodeAr.applySettings() with these [BarcodeArSettings] to apply them.
  ///
  /// Added in version 7.1.0
  SymbologySettings settingsForSymbology(Symbology symbology) {
    var identifier = symbology.toString();
    if (!_symbologies.containsKey(identifier)) {
      var symbologySettings = BarcodeDefaults.defaultSymbologySettingsFor(identifier);
      _symbologies[identifier] = symbologySettings;
    }
    return _symbologies[identifier]!;
  }

  /// Sets property to the provided value. Use this method to set properties that are not yet part of a stable API. Properties set through this method may or may not be used or change in a future release.
  ///
  /// Added in version 7.1.0
  void setProperty<T>(String name, T value) {
    _properties[name] = value;
  }

  /// Retrieves the value of a previously set property.
  ///
  /// Added in version 7.1.0
  T getProperty<T>(String name) {
    return _properties[name] as T;
  }

  /// This function provides a convenient shortcut to enabling decoding of particular symbologies without having to go through [SymbologySettings]. By default, all symbologies are turned off and symbologies need to be explicitly enabled.
  ///
  /// Added in version 7.1.0
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
  /// Added in version 7.1.0
  void enableSymbology(Symbology symbology, bool enabled) {
    settingsForSymbology(symbology).isEnabled = enabled;
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'properties': _properties,
      'expectOnlyUniqueBarcodes': expectsOnlyUniqueBarcodes,
      'symbologies': _symbologies.map((key, value) => MapEntry(key, value.toMap()))
    };
  }
}
