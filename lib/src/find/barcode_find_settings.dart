/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import '../barcode_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../../scandit_flutter_datacapture_barcode.dart';

/// Added in version 6.22.0
class BarcodeFindSettings implements Serializable {
  final Map<String, SymbologySettings> _symbologies = {};

  final Map<String, dynamic> _properties = {};

  /// Creates a new barcode find settings instance. All symbologies are disabled. Make sure to enable the symbologies required by your app before applying the settings to [BarcodeFind] with BarcodeFind.applySettings().
  ///
  /// Added in version 6.22.0
  BarcodeFindSettings();

  /// Gets [SymbologySettings] specific for the given [Symbology].
  ///
  /// Note that modifying the returned object doesn’t automatically apply the changes to [BarcodeFind]. After you made changes to the symbology settings, call BarcodeFind.applySettings() with these [BarcodeFindSettings] to apply them.
  ///
  /// Added in version 6.22.0
  SymbologySettings settingsForSymbology(Symbology symbology) {
    var identifier = symbology.toString();
    if (!_symbologies.containsKey(identifier)) {
      var symbologySettings = BarcodeDefaults.defaultSymbologySettingsFor(identifier);
      _symbologies[identifier] = symbologySettings;
    }
    return _symbologies[identifier]!;
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

  /// Returns the set of enabled symbologies.
  ///
  /// Added in version 6.22.0
  Set<Symbology> get enabledSymbologies => _enabledSymbologies();

  Set<Symbology> _enabledSymbologies() {
    return _symbologies.values
        .where((symbologySettings) => symbologySettings.isEnabled)
        .map((symbologySettings) => symbologySettings.symbology)
        .toSet()
        .cast<Symbology>();
  }

  /// Sets property to the provided value. Use this method to set properties that are not yet part of a stable API. Properties set through this method may or may not be used or change in a future release.
  ///
  /// Added in version 6.22.0
  void setProperty<T>(String name, T value) {
    _properties[name] = value;
  }

  /// Retrieves the value of a previously set property. In case the property does not exist, an [ArgumentException](https://learn.microsoft.com/en-us/dotnet/api/system.argumentexception) is thrown.
  ///
  /// Added in version 6.22.0
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
