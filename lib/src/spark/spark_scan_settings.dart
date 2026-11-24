/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/capture_preset.dart';
import 'package:scandit_flutter_datacapture_barcode/src/composite_type.dart';
import 'package:scandit_flutter_datacapture_barcode/src/usi/scan_item_definition.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode_defaults.dart';
import '../symbology.dart';
import '../symbology_settings.dart';
import 'spark_scan_defaults.dart';

/// Holds all the SparkScan settings, such as enabled symbologies and scan intention.
///
/// For the settings to take effect, they must be applied to a [SparkScan] instance using SparkScan.applySettings().
///
/// By default, all types of barcodes (symbologies) are disabled. To scan barcodes, you need to manually enable all the symbologies you want to scan in your application.
///
/// The following lines of code show how to enable [Symbology.code128] and apply the settings to [SparkScan].
///
/// ```dart
/// var settings = SparkScanSettings();
/// settings.enableSymbology(Symbology.code128, true);
/// sparkScan.applySettings(settings);
/// ```
///
/// Added in version 6.20.0
class SparkScanSettings implements Serializable {
  /// Constructs new Spark Scan settings based on the provided presets, enabling relevant symbologies and optimizations. See [CapturePreset] for more information on how to use capture presets.
  ///
  /// Added in version 8.3.0
  SparkScanSettings({Set<CapturePreset>? capturePresets}) : _capturePresets = capturePresets;

  Duration _codeDuplicateFilter = SparkScanDefaults.sparkScanSettingsDefaults.codeDuplicateFilter;
  bool _codeDuplicateFilterExplicitlySet = false;

  /// Determines the time interval in which codes with the same symbology/data are filtered out as duplicates. Use this property to change the interval or completely turn off duplicate filtering:
  ///
  /// - Setting this property to the special value -2 (default from SDK version 7.1.0) will result in a behavior that depends on [SparkScanSettings.scanIntention]. - If [ScanIntention.smart] (default from 8.1), it enables the Smart Duplicate Filter algorithm that intelligently reports a duplicate when the user intends to scan it again, reducing errors and speeding up the workflow. - If [ScanIntention.manual], it acts as when setting [SparkScanSettings.codeDuplicateFilter] to 1.5s (check the following). This behavior applies also to the cases in which the Android device doesn’t support [ScanIntention.smart].
  /// - Since SDK version 8.5, when [SparkScanSettings.selectionMode] is [SelectionMode.on] and this property is left at its smart default (-2), the filter is internally treated as 0 (filtering disabled) so the user can re-select the same barcode via the selection gesture. Setting this property to any value explicitly — including -2 — opts out of this override.
  /// - Setting this property to the special value -1 means that the same code will not be reported again until the scanning has been stopped.
  ///
  /// - Setting this property to a value of 0 means that the same code will be reported every time it is found.
  /// - Setting this property to a value larger than zero indicates the time that must pass between the same code to be reported again.
  ///
  /// Added in version 6.20.0
  Duration get codeDuplicateFilter => _codeDuplicateFilter;

  /// Determines the time interval in which codes with the same symbology/data are filtered out as duplicates. Use this property to change the interval or completely turn off duplicate filtering:
  ///
  /// - Setting this property to the special value -2 (default from SDK version 7.1.0) will result in a behavior that depends on [SparkScanSettings.scanIntention]. - If [ScanIntention.smart] (default from 8.1), it enables the Smart Duplicate Filter algorithm that intelligently reports a duplicate when the user intends to scan it again, reducing errors and speeding up the workflow. - If [ScanIntention.manual], it acts as when setting [SparkScanSettings.codeDuplicateFilter] to 1.5s (check the following). This behavior applies also to the cases in which the Android device doesn’t support [ScanIntention.smart].
  /// - Since SDK version 8.5, when [SparkScanSettings.selectionMode] is [SelectionMode.on] and this property is left at its smart default (-2), the filter is internally treated as 0 (filtering disabled) so the user can re-select the same barcode via the selection gesture. Setting this property to any value explicitly — including -2 — opts out of this override.
  /// - Setting this property to the special value -1 means that the same code will not be reported again until the scanning has been stopped.
  ///
  /// - Setting this property to a value of 0 means that the same code will be reported every time it is found.
  /// - Setting this property to a value larger than zero indicates the time that must pass between the same code to be reported again.
  ///
  /// Added in version 6.20.0
  set codeDuplicateFilter(Duration newValue) {
    _codeDuplicateFilter = newValue;
    _codeDuplicateFilterExplicitlySet = true;
  }

  /// The battery saving mode to use with SparkScan. Default to [BatterySavingMode.auto], automatically enabling the battery saving mode when a higher than usual consumption of the battery is detected, balancing performance and battery lifetime.
  ///
  /// Added in version 6.21.0
  BatterySavingMode batterySaving = SparkScanDefaults.sparkScanSettingsDefaults.batterySaving;

  final Map<String, dynamic> _properties = {};

  final Map<String, SymbologySettings> _symbologies = {};

  /// Returns the set of enabled symbologies.
  ///
  /// Added in version 6.20.0
  Set<Symbology> get enabledSymbologies => _enabledSymbologies();

  /// The scan intention algorithm to use with SparkScan. Defaults to [ScanIntention.smart]. Setting this property to `ScanIntention.SmartSelection` is deprecated in 8.5 and will be removed in a future release; the smart-selection behavior will be exposed through a `SelectionMode.Auto` setting on `SparkScanSettings` in a future framework release.
  ///
  /// While [SparkScanSettings.selectionMode] is set to [SelectionMode.on], this property is recorded but does not take effect — the SDK forces smart selection internally so that the aimer is shown and the tap-to-confirm contract of [SelectionMode.on] holds. The value supplied here is remembered and applied automatically when [SparkScanSettings.selectionMode] leaves [SelectionMode.on].
  ///
  /// Added in version 6.24.0
  ScanIntention scanIntention = SparkScanDefaults.sparkScanSettingsDefaults.scanIntention;

  /// Controls whether the aimed-at barcode is scanned without user confirmation. Defaults to [SelectionMode.auto], letting the SDK decide dynamically — the recommended replacement for the deprecated `ScanIntention.SmartSelection`.
  ///
  /// Set to [SelectionMode.off] to scan barcodes automatically as soon as they are aimed at. Set to [SelectionMode.on] to always require an explicit tap on the SparkScan trigger button to confirm the scan.
  ///
  /// [SelectionMode.auto] requires [SparkScanSettings.scanIntention] to be set to [ScanIntention.smart]; with [ScanIntention.manual] it behaves like [SelectionMode.off]. Automatic selection only activates on devices that support Smart.
  ///
  /// When [SelectionMode.on] is active, the hold-to-scan gesture on the trigger button is automatically disabled by the SDK — continuous scanning would contradict the explicit-confirmation contract of Selection On. [SparkScanViewSettings.holdToScanEnabled] is ignored in this mode and integrators do not need to disable it themselves.
  ///
  /// Added in version 8.5.0
  SelectionMode selectionMode = SparkScanDefaults.sparkScanSettingsDefaults.selectionMode;

  /// The enabled composite types ([CompositeType]). To enable composite codes scanning it is also needed to enable the symbologies that make up the specific type of composite code through [SparkScanSettings.enableSymbologiesForCompositeTypes].
  ///
  /// Added in version 8.3.0
  Set<CompositeType> enabledCompositeTypes = {};

  /// A list of [ScanItemDefinition] objects used to configure this settings instance using item-based scanning API. If you set this property, the [SparkScanSettings.enabledSymbologies] property will be ignored. If set to null, the [SparkScanSettings.enabledSymbologies] property will be used.
  ///
  /// This API is still in beta and may change in future versions of Scandit Data Capture SDK.
  ///
  /// Added in version 8.1.0
  List<ScanItemDefinition>? itemDefinitions;

  final Set<CapturePreset>? _capturePresets;

  Set<Symbology> _enabledSymbologies() {
    return _symbologies.values.where((element) => element.isEnabled).map((e) => e.symbology).toSet().cast<Symbology>();
  }

  /// Gets [SymbologySettings] specific for the given [Symbology].
  ///
  /// Note that modifying the returned object doesn’t automatically apply the changes to [SparkScan]. After you made changes to the symbology settings, call SparkScan.applySettings() with these [SparkScanSettings] to apply them.
  ///
  /// Added in version 6.20.0
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
  /// Added in version 6.20.0
  void setProperty<T>(String name, T value) {
    _properties[name] = value;
  }

  /// Retrieves the value of a previously set property.
  ///
  /// Added in version 6.20.0
  T getProperty<T>(String name) {
    return _properties[name] as T;
  }

  /// Provides a convenient shortcut to enable decoding of particular symbologies without having to go through [SymbologySettings]. By default, all symbologies are turned off and symbologies need to be explicitly enabled.
  ///
  /// Added in version 6.20.0
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
  /// Added in version 6.20.0
  void enableSymbology(Symbology symbology, bool enabled) {
    settingsForSymbology(symbology).isEnabled = enabled;
  }

  /// Enables all symbologies needed for the given composite types ([CompositeType]). To enable composite codes scanning it is also needed to enable the composite types through [SparkScanSettings.enabledCompositeTypes]. By default, all symbologies are turned off and symbologies need to be explicitly enabled.
  ///
  /// Added in version 8.3.0
  void enableSymbologiesForCompositeTypes(Set<CompositeType> compositeTypes) {
    for (var compositeType in compositeTypes) {
      var symbologies = BarcodeDefaults.compositeTypeDescriptionsDefaults.firstWhere(
        (element) => element.types.contains(compositeType),
      );

      enableSymbologies(symbologies.symbologies);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'codeDuplicateFilter': codeDuplicateFilter.inMilliseconds,
      'codeDuplicateFilterExplicitlySet': _codeDuplicateFilterExplicitlySet,
      'properties': _properties,
      'batterySaving': batterySaving.toString(),
      'symbologies': _symbologies.map<String, Map<String, dynamic>>((key, value) => MapEntry(key, value.toMap())),
      'scanIntention': scanIntention.toString(),
      'selectionMode': selectionMode.toString(),
      'scanItemDefinitions': itemDefinitions?.map((e) => e.toMap()).toList(),
      'capturePresets': _capturePresets?.map((e) => e.toString()).toList(),
      'enabledCompositeTypes': enabledCompositeTypes.map((e) => e.toString()).toList(),
    };
  }
}
