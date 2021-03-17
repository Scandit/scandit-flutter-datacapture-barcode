/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'symbology.dart';
import 'barcode_defaults.dart';

class SymbologyDescription {
  Symbology _symbology;
  String _readableName;
  bool _isAvailable;
  bool _isColorInvertible;
  Range _activeSymbolCountRange;
  Range _defaultSymbolCountRange;
  Set<String> _supportedExtensions;

  SymbologyDescription._(Symbology symbology, String readableName, Range activeSymbolCountRange,
      Range defaultSymbolCountRange, Set<String> supportedExtensions,
      {@required bool isAvailable, @required bool isColorInvertible}) {
    _symbology = symbology;
    _readableName = readableName;
    _activeSymbolCountRange = activeSymbolCountRange;
    _defaultSymbolCountRange = defaultSymbolCountRange;
    _supportedExtensions = supportedExtensions;
    _isAvailable = isAvailable;
    _isColorInvertible = isColorInvertible;
  }

  String get identifier => symbology.jsonValue;
  Symbology get symbology => _symbology;
  String get readableName => _readableName;
  bool get isAvailable => _isAvailable;
  bool get isColorInvertible => _isColorInvertible;
  Range get activeSymbolCountRange => _activeSymbolCountRange;
  Range get defaultSymbolCountRange => _defaultSymbolCountRange;
  Set<String> get supportedExtensions => _supportedExtensions;

  factory SymbologyDescription.fromJSON(Map<String, dynamic> json) => SymbologyDescription._(
      SymbologySerializer.fromJSON(json['identifier'] as String),
      json['readableName'] as String,
      Range.fromJSON(json['activeSymbolCountRange']),
      Range.fromJSON(json['defaultSymbolCountRange']),
      (json['supportedExtensions'] as List<dynamic>).cast<String>().toSet(),
      isAvailable: json['isAvailable'] as bool,
      isColorInvertible: json['isColorInvertible'] as bool);

  factory SymbologyDescription.forIdentifier(String identifier) =>
      SymbologyDescription.forSymbology(SymbologySerializer.fromJSON(identifier));

  factory SymbologyDescription.forSymbology(Symbology symbology) {
    if (symbology == null) {
      return null;
    }

    return BarcodeDefaults.symbologyDescriptionsDefaults
        .firstWhere((element) => element.identifier == symbology.jsonValue);
  }
}

class Range implements Serializable {
  int _minimum;
  int _maximum;
  int _step;

  int get minimum => _minimum;

  int get maximum => _maximum;

  int get step => _step;

  Range(this._minimum, this._maximum, this._step);

  Range.fromJSON(Map<String, dynamic> json) : this(json['minimum'] as int, json['maximum'] as int, json['step'] as int);

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{};
    json['minimum'] = _minimum;
    json['maximum'] = _maximum;
    json['step'] = _step;
    return json;
  }
}
