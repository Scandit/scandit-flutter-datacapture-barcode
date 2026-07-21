/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../../scandit_flutter_datacapture_barcode.dart';

class BarcodeDefinition implements ScanComponentDefinition<BarcodeIdentifier>, Serializable {
  final BarcodeIdentifier _identifier;
  final Set<Symbology> _symbologies;
  bool _optional = false;
  int _mandatoryInstances = 1;

  @override
  Quadrilateral? location;
  ScanComponentBarcodePreset? preset;
  String? hiddenProperties;
  List<String> valueRegexes = [];
  List<String> anchorRegexes = [];

  BarcodeDefinition(this._identifier, this._symbologies);

  static BarcodeDefinitionBuilder builder(BarcodeIdentifier identifier) {
    return BarcodeDefinitionBuilder._(identifier);
  }

  @override
  BarcodeIdentifier get identifier => _identifier;

  Set<Symbology> get symbologies => _symbologies;

  @override
  bool get optional => _optional;

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

  BarcodeDefinitionBuilder setOptional(bool optional) {
    _optional = optional;
    return this;
  }

  BarcodeDefinitionBuilder setSymbologies(Set<Symbology> symbologies) {
    _symbologies = symbologies;
    return this;
  }

  BarcodeDefinitionBuilder setPreset(ScanComponentBarcodePreset? preset) {
    _preset = preset;
    return this;
  }

  BarcodeDefinitionBuilder setLocation(Quadrilateral? location) {
    _location = location;
    return this;
  }

  BarcodeDefinitionBuilder setHiddenProperties(String hiddenProperties) {
    _hiddenProperties = hiddenProperties;
    return this;
  }

  BarcodeDefinitionBuilder setValueRegexes(List<String> valueRegexes) {
    _valueRegexes = valueRegexes;
    return this;
  }

  BarcodeDefinitionBuilder setAnchorRegexes(List<String> anchorRegexes) {
    _anchorRegexes = anchorRegexes;
    return this;
  }

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
