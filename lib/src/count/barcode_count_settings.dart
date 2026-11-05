/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../../scandit_flutter_datacapture_barcode.dart';
import '../barcode_defaults.dart';
import 'barcode_count_defaults.dart';

/// Added in version 6.17.0
class BarcodeCountSettings implements Serializable {
  final Map<String, SymbologySettings> _symbologies = {};

  final Map<String, dynamic> _properties = {};

  late final bool _scanPreviewEnabled;

  /// Declares whether or not the mode will be disabled automatically when the provided capture list has been completed. If no list has been provided, this has no effect.
  ///
  /// Default value is *false*.
  ///
  /// Added in version 8.3.0
  bool disableModeWhenCaptureListCompleted =
      BarcodeCountDefaults.barcodeCountSettingsDefaults.disableModeWhenCaptureListCompleted;

  /// Clustering mode allows smart grouping of neighbouring barcodes. Default to [ClusteringMode.disabled].
  ///
  /// Added in version 8.3.0
  ClusteringMode clusteringMode = BarcodeCountDefaults.barcodeCountSettingsDefaults.clusteringMode;

  /// Use this property to enable barcode mapping.
  ///
  /// Default value is *false*.
  ///
  /// The Barcode Count mapping API is still in beta and may change in future versions of Scandit Data Capture SDK.
  ///
  /// Added in version 8.3.0
  bool mappingEnabled = BarcodeCountDefaults.barcodeCountSettingsDefaults.mappingEnabled;

  /// Creates a new barcode count settings instance. This initializer allows enabling or disabling the scan preview at construction. When using the default initializer, scan preview is disabled by default.
  ///
  /// Scan preview allows you to see the barcodes that are being detected before pressing the shutter button, but these won’t be added to the scanning result yet. Pressing the shutter button will scan the barcodes that are visible in the preview.
  ///
  /// When scan preview is enabled, basic scanning, scanning against a list, status mode, group scanning, and the not-in-list action are supported. Filtering is not supported with scan preview.
  ///
  /// The Barcode Count scan preview API is still in beta and may change in future versions of Scandit Data Capture SDK.
  ///
  /// Added in version 6.17.0
  BarcodeCountSettings({bool? scanPreviewEnabled}) {
    _scanPreviewEnabled = scanPreviewEnabled ?? BarcodeCountDefaults.barcodeCountSettingsDefaults.scanPreviewEnabled;
  }

  /// Gets [SymbologySettings] specific for the given [Symbology].
  ///
  /// Note that modifying the returned object doesn’t automatically apply the changes to [BarcodeCount]. After you made changes to the symbology settings, call BarcodeCount.applySettings() with these [BarcodeCountSettings] to apply them.
  ///
  /// Added in version 6.17.0
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
  /// Added in version 6.17.0
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
  /// Added in version 6.17.0
  void enableSymbology(Symbology symbology, bool enabled) {
    settingsForSymbology(symbology).isEnabled = enabled;
  }

  /// Returns the set of enabled symbologies.
  ///
  /// Added in version 6.17.0
  Set<Symbology> get enabledSymbologies => _enabledSymbologies();

  Set<Symbology> _enabledSymbologies() {
    return _symbologies.values
        .where((symbologySettings) => symbologySettings.isEnabled)
        .map((symbologySettings) => symbologySettings.symbology)
        .toSet()
        .cast<Symbology>();
  }

  final BarcodeFilterSettings _filterSettings = BarcodeCountDefaults.barcodeCountSettingsDefaults.barcodeFilterSettings;

  /// Returns the current settings for barcode filtering.
  ///
  /// Added in version 6.17.0
  BarcodeFilterSettings get filterSettings => _filterSettings;

  /// Declares whether or not the barcodes to be tracked are expected to be unique. If enabled optimizations can be used to improve Barcode Count.
  ///
  /// Default value is *false*.
  ///
  /// Do not enable this if you are expecting to scan multiple barcodes with the same content within one batch.
  ///
  /// Added in version 6.17.0
  bool expectsOnlyUniqueBarcodes = BarcodeCountDefaults.barcodeCountSettingsDefaults.expectsOnlyUniqueBarcodes;

  /// Sets property to the provided value. Use this method to set properties that are not yet part of a stable API. Properties set through this method may or may not be used or change in a future release.
  ///
  /// Added in version 6.17.0
  void setProperty<T>(String name, T value) {
    _properties[name] = value;
  }

  /// Retrieves the value of a previously set property.
  ///
  /// Added in version 6.17.0
  T getProperty<T>(String name) {
    return _properties[name] as T;
  }

  /// Returns the state of the scan preview. Can only be set during initialization.
  ///
  /// Added in version 8.3.0
  bool get scanPreviewEnabled => _scanPreviewEnabled;

  @override
  Map<String, dynamic> toMap() {
    return {
      'symbologies': _symbologies.map<String, Map<String, dynamic>>((key, value) => MapEntry(key, value.toMap())),
      'properties': _properties,
      'expectOnlyUniqueBarcodes': expectsOnlyUniqueBarcodes,
      'barcodeFilterSettings': _filterSettings.toMap(),
      'disableModeWhenCaptureListCompleted': disableModeWhenCaptureListCompleted,
      'clusteringMode': clusteringMode.toString(),
      'scanPreviewEnabled': _scanPreviewEnabled,
    };
  }
}
