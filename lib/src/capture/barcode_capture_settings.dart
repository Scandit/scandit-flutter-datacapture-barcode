/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode_defaults.dart';
import '../symbology.dart';
import '../symbology_settings.dart';
import 'barcode_capture_defaults.dart';
import '../composite_type.dart';
import '../aruco_dictionary.dart';

/// Holds all the barcode recognition related settings, such as enabled symbologies and location selection. For the settings to take effect, they must be applied to a barcode capture ([BarcodeCapture]) instance using BarcodeCapture.applySettings().
///
/// By default, all types of barcodes (symbologies) are disabled. To scan barcodes, you need to manually enable all the symbologies you want to scan in your application.
///
/// The following lines of code show how to enable [Symbology.code128] and apply the settings to barcode capture ([BarcodeCapture]).
///
/// ```dart
/// var settings = BarcodeCaptureSettings();
/// settings.enableSymbology(Symbology.code128, true);
/// barcodeCapture.applySettings(settings);
/// ```
///
/// Added in version 6.7.0
class BarcodeCaptureSettings implements Serializable {
  /// Creates new default settings instance. Recognition is setup for recognizing codes in the full image. Symbologies are all disabled. Before passing the settings to the [BarcodeCapture] instance, make sure to enable the symbologies required by your application.
  ///
  /// Added in version 6.7.0
  BarcodeCaptureSettings();

  Duration _codeDuplicateFilter = BarcodeCaptureDefaults.barcodeCaptureSettingsDefaults.codeDuplicateFilter;
  bool _codeDuplicateFilterExplicitlySet = false;

  /// Determines the time interval in which codes with the same symbology/data are filtered out as duplicates. Use this property to change the interval or completely turn off duplicate filtering:
  ///
  /// - Setting this property to the special value -2 (default from SDK version 7.1.0) will result in a behavior that depends on [BarcodeCaptureSettings.scanIntention]. - If [ScanIntention.smart] (default from 7.0), it enables the Smart Duplicate Filter algorithm that intelligently reports a duplicate when the user intends to scan it again, reducing errors and speeding up the workflow. - If [ScanIntention.manual], it acts as when setting [BarcodeCaptureSettings.codeDuplicateFilter] to 1.5s (check the following). This behavior applies also to the cases in which the Android device doesn’t support [ScanIntention.smart].
  /// - Since SDK version 8.5, when [BarcodeCaptureSettings.selectionMode] is [SelectionMode.on] and this property is left at its smart default (-2), the filter is internally treated as 0 (filtering disabled) so the user can re-select the same barcode via the selection gesture. Setting this property to any value explicitly — including -2 — opts out of this override.
  /// - Setting this property to the special value -1 means that the same code will not be reported again until the scanning has been stopped.
  ///
  /// - Setting this property to a value of 0 means that the same code will be reported every time it is found.
  /// - Setting this property to a value larger than zero indicates the time that must pass between the same code to be reported again.
  ///
  /// The filtering is reset any time the capture mode is disabled ([DataCaptureMode.isEnabled] is set to false) as this is when the session is cleaned and restarts from zero.
  ///
  /// Added in version 6.7.0
  Duration get codeDuplicateFilter => _codeDuplicateFilter;

  /// Determines the time interval in which codes with the same symbology/data are filtered out as duplicates. Use this property to change the interval or completely turn off duplicate filtering:
  ///
  /// - Setting this property to the special value -2 (default from SDK version 7.1.0) will result in a behavior that depends on [BarcodeCaptureSettings.scanIntention]. - If [ScanIntention.smart] (default from 7.0), it enables the Smart Duplicate Filter algorithm that intelligently reports a duplicate when the user intends to scan it again, reducing errors and speeding up the workflow. - If [ScanIntention.manual], it acts as when setting [BarcodeCaptureSettings.codeDuplicateFilter] to 1.5s (check the following). This behavior applies also to the cases in which the Android device doesn’t support [ScanIntention.smart].
  /// - Since SDK version 8.5, when [BarcodeCaptureSettings.selectionMode] is [SelectionMode.on] and this property is left at its smart default (-2), the filter is internally treated as 0 (filtering disabled) so the user can re-select the same barcode via the selection gesture. Setting this property to any value explicitly — including -2 — opts out of this override.
  /// - Setting this property to the special value -1 means that the same code will not be reported again until the scanning has been stopped.
  ///
  /// - Setting this property to a value of 0 means that the same code will be reported every time it is found.
  /// - Setting this property to a value larger than zero indicates the time that must pass between the same code to be reported again.
  ///
  /// The filtering is reset any time the capture mode is disabled ([DataCaptureMode.isEnabled] is set to false) as this is when the session is cleaned and restarts from zero.
  ///
  /// Added in version 6.7.0
  set codeDuplicateFilter(Duration newValue) {
    _codeDuplicateFilter = newValue;
    _codeDuplicateFilterExplicitlySet = true;
  }

  /// Defines the strategy with which to select one out of many visible barcodes. By default, this property is *null* and code selection is disabled.
  ///
  /// Added in version 6.7.0
  LocationSelection? locationSelection;

  final Map<String, dynamic> _properties = {};

  final Map<String, SymbologySettings> _symbologies = {};

  ArucoDictionary? _arucoDictionary;

  /// Returns the set of enabled symbologies.
  ///
  /// Added in version 6.7.0
  Set<Symbology> get enabledSymbologies => _enabledSymbologies();

  /// The enabled composite types ([CompositeType]). To enable composite codes scanning it is also needed to enable the symbologies that make up the specific type of composite code through [BarcodeCaptureSettings.enableSymbologiesForCompositeTypes].
  ///
  /// Added in version 6.7.0
  Set<CompositeType> enabledCompositeTypes = {};

  /// The battery saving mode to use with BarcodeCapture. Defaults to [BatterySavingMode.auto], to automatically enable the battery saving mode when a higher than usual consumption of the battery is detected, balancing performance and battery lifetime. Sets to [BatterySavingMode.off] to revert to the standard performance.
  ///
  /// Added in version 6.26.0
  BatterySavingMode batterySaving = BarcodeCaptureDefaults.barcodeCaptureSettingsDefaults.batterySaving;

  /// The scan intention algorithm to use with BarcodeCapture. Defaults to [ScanIntention.smart], enabling the automatic algorithm that intelligently identifies and then scans the barcode that the user intends to capture, reducing errors. Sets to [ScanIntention.manual] to disable.
  ///
  /// When the deprecated `ScanIntention.SmartSelection` is used, the progress indicator drawn on scan candidates uses the stroke color of the brush set on [BarcodeCaptureOverlay].
  ///
  /// A frame source that supplies a single image requires [ScanIntention.manual]. [ScanIntention.smart] has to observe a barcode across several frames before it returns it.
  ///
  /// While [BarcodeCaptureSettings.selectionMode] is set to [SelectionMode.on], this property is recorded but does not take effect — the SDK forces smart selection internally so that the aimer is shown and the tap-to-confirm contract of [SelectionMode.on] holds. The value supplied here is remembered and applied automatically when [BarcodeCaptureSettings.selectionMode] leaves [SelectionMode.on].
  ///
  /// Added in version 6.24.0
  ScanIntention scanIntention = BarcodeCaptureDefaults.barcodeCaptureSettingsDefaults.scanIntention;

  /// Controls whether the aimed-at barcode is scanned without user confirmation. Defaults to [SelectionMode.off] — barcodes are scanned automatically when aimed at. Set to [SelectionMode.on] to always require an explicit tap on the preview to confirm the scan.
  ///
  /// Set to [SelectionMode.auto] to let the SDK decide dynamically.
  ///
  /// [SelectionMode.auto] is the recommended replacement for the deprecated `ScanIntention.SmartSelection`.
  ///
  /// When [SelectionMode.on] is used, we recommend making it explicit to the user that they need to tap the preview to scan — for example via a toast message or similar UI hint.
  ///
  /// [SelectionMode.auto] requires [BarcodeCaptureSettings.scanIntention] to be set to [ScanIntention.smart]; with [ScanIntention.manual] it behaves like [SelectionMode.off]. Automatic selection only activates on devices that support Smart.
  ///
  /// Added in version 8.5.0
  SelectionMode selectionMode = BarcodeCaptureDefaults.barcodeCaptureSettingsDefaults.selectionMode;

  @override
  Map<String, dynamic> toMap() {
    return {
      'codeDuplicateFilter': codeDuplicateFilter.inMilliseconds,
      'codeDuplicateFilterExplicitlySet': _codeDuplicateFilterExplicitlySet,
      'locationSelection': locationSelection == null ? {'type': 'none'} : locationSelection?.toMap(),
      'properties': _properties,
      'symbologies': _symbologies.map<String, Map<String, dynamic>>((key, value) => MapEntry(key, value.toMap())),
      'enabledCompositeTypes': enabledCompositeTypes.map((e) => e.toString()).toList(),
      'batterySaving': batterySaving.toString(),
      'scanIntention': scanIntention.toString(),
      'selectionMode': selectionMode.toString(),
      'arucoDictionary': _arucoDictionary?.toMap()
    };
  }

  Set<Symbology> _enabledSymbologies() {
    return _symbologies.values.where((element) => element.isEnabled).map((e) => e.symbology).toSet().cast<Symbology>();
  }

  /// Gets [SymbologySettings] specific for the given [Symbology].
  ///
  /// Note that modifying the returned object doesn’t automatically apply the changes to [BarcodeCapture]. After you made changes to the symbology settings, call BarcodeCapture.applySettings() with these [BarcodeCaptureSettings] to apply them.
  ///
  /// Added in version 6.7.0
  SymbologySettings settingsForSymbology(Symbology symbology) {
    var identifier = symbology.toString();
    if (!_symbologies.containsKey(identifier)) {
      var symbologySettings = BarcodeDefaults.defaultSymbologySettingsFor(identifier);
      _symbologies[identifier] = symbologySettings;
    }
    return _symbologies[identifier]!;
  }

  /// Sets a property to the provided value. Use this method to set properties that are not yet part of a stable API. Properties set through this method may or may not be used or change in a future release.
  ///
  /// Added in version 6.7.0
  void setProperty<T>(String name, T value) {
    _properties[name] = value;
  }

  /// Retrieves the value of a previously set property. In case the property does not exist, an [ArgumentException](https://learn.microsoft.com/en-us/dotnet/api/system.argumentexception) is thrown.
  ///
  /// Added in version 6.7.0
  T getProperty<T>(String name) {
    return _properties[name] as T;
  }

  /// Provides a convenient shortcut to enable decoding of particular symbologies without having to go through [SymbologySettings]. By default, all symbologies are turned off and symbologies need to be explicitly enabled.
  ///
  /// Added in version 6.7.0
  void enableSymbologies(Set<Symbology> symbologies) {
    for (var symbology in symbologies) {
      enableSymbology(symbology, true);
    }
  }

  // ignore: avoid_positional_boolean_parameters
  /// Provides a convenient shortcut to enable/disable decoding of a particular symbology without having to go through [SymbologySettings].
  ///
  /// Some 1d barcode symbologies allow you to encode variable-length data. By default, the Scandit Data Capture SDK only scans barcodes in a certain length range.
  ///
  /// If your application requires scanning of one of these symbologies, and the length is falling outside the default range, you may need to adjust the active symbol counts ([SymbologySettings.activeSymbolCounts]) for the symbology in addition to enabling it.
  ///
  /// Added in version 6.7.0
  void enableSymbology(Symbology symbology, bool enabled) {
    settingsForSymbology(symbology).isEnabled = enabled;
  }

  /// Enables all symbologies needed for the given composite types ([CompositeType]). To enable composite codes scanning it is also needed to enable the composite types through [BarcodeCaptureSettings.enabledCompositeTypes]. By default, all symbologies are turned off and symbologies need to be explicitly enabled.
  ///
  /// Added in version 6.7.0
  void enableSymbologiesForCompositeTypes(Set<CompositeType> compositeTypes) {
    for (var compositeType in compositeTypes) {
      var symbologies = BarcodeDefaults.compositeTypeDescriptionsDefaults.firstWhere(
        (element) => element.types.contains(compositeType),
      );

      enableSymbologies(symbologies.symbologies);
    }
  }

  /// Sets the [ArucoDictionary] to be used while scanning ArUco codes. When the symbology is enabled the dictionary [ArucoDictionaryPreset.arucoDictionaryPreset_5X5_1000] is loaded as default.
  ///
  /// Added in version 8.3.0
  void setArucoDictionary(ArucoDictionary dictionary) {
    _arucoDictionary = dictionary;
  }
}
