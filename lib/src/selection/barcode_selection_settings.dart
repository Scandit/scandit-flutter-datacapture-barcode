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

/// Holds all the barcode selection related settings, such as enabled symbologies and tap behavior. For the settings to take effect, they must be applied to a barcode selection ([BarcodeSelection]) instance using BarcodeSelection.applySettings().
///
/// Added in version 6.10.0
class BarcodeSelectionSettings implements Serializable {
  /// Creates a new barcode selection settings instance. All symbologies are disabled. Make sure to enable the symbologies required by your app before applying the settings to [BarcodeSelection] with BarcodeSelection.applySettings().
  ///
  /// Added in version 6.10.0
  BarcodeSelectionSettings();

  /// Determines the time interval in which codes with the same symbology/data are considered not automatically selectable again (automatic selection can happen through [BarcodeSelectionSettings.singleBarcodeAutoDetection]). By default, when the same code (data, symbology) stays in view after just having been selected (manually or automatically) it will not be automatically selected again for 500 milliseconds. This property has no influence on manual selection by tapping. Use this property to change the interval or completely turn off duplicate filtering:
  ///
  /// - Setting this property to value smaller than zero, means that the same code will not be automatically selectable again until the selection has been stopped.
  /// - Setting this property to a value of zero means that the same code will be automatically selectable again immediately. In use cases that includes automatic selection this is likely never wanted.
  /// - Setting this property to a value larger than zero indicates the time that must pass between the same code to be automatically selected again.
  ///
  /// Added in version 6.10.0
  Duration codeDuplicateFilter =
      Duration(milliseconds: BarcodeSelectionDefaults.barcodeSelectionSettingsDefaults.codeDuplicateFilter);

  /// If true, when a single barcode is tracked it’s automatically selected. Defaults to *false*.
  ///
  /// Added in version 6.10.0
  bool singleBarcodeAutoDetection =
      BarcodeSelectionDefaults.barcodeSelectionSettingsDefaults.singleBarcodeAutoDetectionEnabled;

  /// This setting is used to define the method that [BarcodeSelection] will use to select barcodes. Defaults to [BarcodeSelectionTapSelection].
  ///
  /// Added in version 6.10.0
  BarcodeSelectionType selectionType = BarcodeSelectionDefaults.barcodeSelectionSettingsDefaults.selectionType;

  /// If true, user can swipe right to select all barcodes in the view or swipe left to deselect all barcodes in the view. Defaults to *true*.
  ///
  /// Added in version 8.4.0
  bool swipeGesturesEnabled = BarcodeSelectionDefaults.barcodeSelectionSettingsDefaults.swipeGesturesEnabled;

  /// If false, selection through tap is disabled. Defaults to *true*. This property only has its effect when used with manual aimer selection.
  ///
  /// Added in version 8.6.0
  bool tapGestureForSelectionEnabled =
      BarcodeSelectionDefaults.barcodeSelectionSettingsDefaults.tapGestureForSelectionEnabled;

  final Map<String, dynamic> _properties = {};

  final Map<String, SymbologySettings> _symbologies = {};

  /// Returns the set of enabled symbologies.
  ///
  /// Added in version 6.10.0
  Set<Symbology> get enabledSymbologies => _enabledSymbologies();

  @override
  Map<String, dynamic> toMap() {
    return {
      'codeDuplicateFilter': codeDuplicateFilter.inMilliseconds,
      'properties': _properties,
      'symbologies': _symbologies.map<String, Map<String, dynamic>>((key, value) => MapEntry(key, value.toMap())),
      'singleBarcodeAutoDetectionEnabled': singleBarcodeAutoDetection,
      'selectionType': selectionType.toMap(),
      'swipeGesturesEnabled': swipeGesturesEnabled,
      'tapGestureForSelectionEnabled': tapGestureForSelectionEnabled,
    };
  }

  Set<Symbology> _enabledSymbologies() {
    return _symbologies.values.where((element) => element.isEnabled).map((e) => e.symbology).toSet().cast<Symbology>();
  }

  /// Gets [SymbologySettings] specific for the given [Symbology].
  ///
  /// Note that modifying the returned object doesn’t automatically apply the changes to [BarcodeSelection]. After you made changes to the symbology settings, call BarcodeSelection.applySettings() with these [BarcodeSelectionSettings] to apply them.
  ///
  /// Added in version 6.10.0
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
  /// Added in version 6.10.0
  void setProperty<T>(String name, T value) {
    _properties[name] = value;
  }

  /// Retrieves the value of a previously set property.
  ///
  /// Added in version 6.10.0
  T getProperty<T>(String name) {
    return _properties[name] as T;
  }

  /// This function provides a convenient shortcut to enabling decoding of particular symbologies without having to go through [SymbologySettings]. By default, all symbologies are turned off and symbologies need to be explicitly enabled.
  ///
  /// Added in version 6.10.0
  void enableSymbologies(Set<Symbology> symbologies) {
    for (var symbology in symbologies) {
      enableSymbology(symbology, true);
    }
  }

  // ignore: avoid_positional_boolean_parameters
  /// This function provides a convenient shortcut to enabling/disabling decoding of a particular symbology without having to go through [SymbologySettings].
  ///
  /// Some 1d barcode symbologies allow you to encode variable-length data. By default, the Scandit Data Capture SDK only scans barcodes in a certain length range.
  ///
  /// If your application requires scanning of one of these symbologies, and the length is falling outside the default range, you may need to adjust the active symbol counts ([SymbologySettings.activeSymbolCounts]) for the symbology in addition to enabling it.
  ///
  /// Added in version 6.10.0
  void enableSymbology(Symbology symbology, bool enabled) {
    settingsForSymbology(symbology).isEnabled = enabled;
  }
}
