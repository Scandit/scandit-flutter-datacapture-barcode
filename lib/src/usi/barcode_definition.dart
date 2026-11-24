/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../../scandit_flutter_datacapture_barcode.dart';

/// A class that holds the definition for a barcode expected to be scanned as part of a certain [ScanItemDefinition].
///
/// Added in version 8.1.0
class BarcodeDefinition implements ScanComponentDefinition<BarcodeIdentifier>, Serializable {
  final BarcodeIdentifier _identifier;
  final Set<Symbology> _symbologies;
  bool _optional = false;
  int _mandatoryInstances = 1;

  /// The expected location of the barcode.
  ///
  /// Added in version 8.1.0
  @override
  Quadrilateral? location;
  /// A preset to be applied to the barcode definition.
  ///
  /// Added in version 8.1.0
  ScanComponentBarcodePreset? preset;
  /// A list of hidden properties to set on the barcode definition.
  ///
  /// Added in version 8.1.0
  String? hiddenProperties;
  /// A list of value regexes to use when searching for the barcode.
  ///
  /// Added in version 8.1.0
  List<String> valueRegexes = [];
  /// A list of anchor regexes to use when searching for the barcode.
  ///
  /// Added in version 8.1.0
  List<String> anchorRegexes = [];

  /// A constructor that receives the identifier and symbologies for the barcode definition.
  ///
  /// Added in version 8.1.0
  BarcodeDefinition(this._identifier, this._symbologies);

  /// Creates a builder object that can be used to fluently create a BarcodeDefinition instance.
  ///
  /// Added in version 8.1.0
  static BarcodeDefinitionBuilder builder(BarcodeIdentifier identifier) {
    return BarcodeDefinitionBuilder._(identifier);
  }

  /// The unique identifier for this component.
  ///
  /// Added in version 8.1.0
  @override
  BarcodeIdentifier get identifier => _identifier;

  /// The list of symbologies that the barcode could be using.
  ///
  /// Added in version 8.1.0
  Set<Symbology> get symbologies => _symbologies;

  /// Whether the barcode is optional.
  ///
  /// Added in version 8.1.0
  @override
  bool get optional => _optional;

  /// Whether the barcode is optional.
  ///
  /// Added in version 8.1.0
  @override
  set optional(bool value) {
    _optional = value;
    _mandatoryInstances = value ? 0 : 1;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'barcode',
      'identifier': _identifier.toMap()['identifier'],
      'symbologies': _symbologies.map((s) => s.toString()).toList(),
      'optional': _optional,
      'mandatoryInstances': _mandatoryInstances,
      if (location != null) 'location': location!.toMap(),
      if (preset != null) 'preset': preset.toString(),
      if (hiddenProperties?.isNotEmpty == true) 'hiddenProperties': hiddenProperties,
      if (valueRegexes.isNotEmpty) 'valueRegexes': valueRegexes,
      if (anchorRegexes.isNotEmpty) 'anchorRegexes': anchorRegexes,
    };
  }
}

/// A fluent builder class for creating [BarcodeDefinition] objects with a convenient, chainable interface. This builder provides methods to add various field types and configure their properties in a structured manner.
///
/// Added in version 8.1.0
class BarcodeDefinitionBuilder {
  final BarcodeIdentifier _identifier;
  Set<Symbology> _symbologies = {};
  bool _optional = false;
  ScanComponentBarcodePreset? _preset;
  Quadrilateral? _location;
  String _hiddenProperties = '';
  List<String> _valueRegexes = [];
  List<String> _anchorRegexes = [];

  BarcodeDefinitionBuilder._(this._identifier);

  /// Sets whether the barcode component is optional in the item definition. Returns the builder for configuring the rest of the properties.
  ///
  /// Added in version 8.1.0
  BarcodeDefinitionBuilder setOptional(bool optional) {
    _optional = optional;
    return this;
  }

  /// Sets the barcode symbologies for the component. Returns the builder for configuring the rest of the properties.
  ///
  /// Added in version 8.1.0
  BarcodeDefinitionBuilder setSymbologies(Set<Symbology> symbologies) {
    _symbologies = symbologies;
    return this;
  }

  /// Sets a predefined preset for the component. Returns the builder for configuring the rest of the properties.
  ///
  /// Added in version 8.1.0
  BarcodeDefinitionBuilder setPreset(ScanComponentBarcodePreset? preset) {
    _preset = preset;
    return this;
  }

  /// Sets an expected location for the barcode. Returns the builder for configuring the rest of the properties.
  ///
  /// Added in version 8.1.0
  BarcodeDefinitionBuilder setLocation(Quadrilateral? location) {
    _location = location;
    return this;
  }

  /// Sets the hidden properties for the component. Returns the builder for configuring the rest of the properties.
  ///
  /// Added in version 8.1.0
  BarcodeDefinitionBuilder setHiddenProperties(String hiddenProperties) {
    _hiddenProperties = hiddenProperties;
    return this;
  }

  /// Sets the value regexes for the barcode. Returns the builder for configuring the rest of the properties.
  ///
  /// Added in version 8.1.0
  BarcodeDefinitionBuilder setValueRegexes(List<String> valueRegexes) {
    _valueRegexes = valueRegexes;
    return this;
  }

  /// Sets the anchor regexes for the barcode. Returns the builder for configuring the rest of the properties.
  ///
  /// Added in version 8.1.0
  BarcodeDefinitionBuilder setAnchorRegexes(List<String> anchorRegexes) {
    _anchorRegexes = anchorRegexes;
    return this;
  }

  /// Builds the [BarcodeDefinition] object.
  ///
  /// Added in version 8.1.0
  BarcodeDefinition build() {
    final definition = BarcodeDefinition(_identifier, _symbologies);
    definition.optional = _optional;
    definition.preset = _preset;
    definition.location = _location;
    definition.hiddenProperties = _hiddenProperties;
    definition.valueRegexes = _valueRegexes;
    definition.anchorRegexes = _anchorRegexes;
    return definition;
  }
}
