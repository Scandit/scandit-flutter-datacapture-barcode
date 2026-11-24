/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'symbology.dart';
import 'barcode_defaults.dart';

/// Description specific to a particular barcode symbology ([Symbology]).
///
/// Added in version 6.7.0
class SymbologyDescription {
  late Symbology _symbology;
  late String _readableName;
  late bool _isAvailable;
  late bool _isColorInvertible;
  late Range _activeSymbolCountRange;
  late Range _defaultSymbolCountRange;
  late Set<String> _supportedExtensions;

  SymbologyDescription._(Symbology symbology, String readableName, Range activeSymbolCountRange,
      Range defaultSymbolCountRange, Set<String> supportedExtensions,
      {required bool isAvailable, required bool isColorInvertible}) {
    _symbology = symbology;
    _readableName = readableName;
    _activeSymbolCountRange = activeSymbolCountRange;
    _defaultSymbolCountRange = defaultSymbolCountRange;
    _supportedExtensions = supportedExtensions;
    _isAvailable = isAvailable;
    _isColorInvertible = isColorInvertible;
  }

  /// Identifier of the [Symbology] associated with this description.
  ///
  /// Added in version 6.7.0
  String get identifier => symbology.toString();
  /// The [Symbology] associated with this description.
  ///
  /// Added in version 6.7.0
  Symbology get symbology => _symbology;
  /// The human readable name of the [Symbology] associated with this description.
  ///
  /// Added in version 6.7.0
  String get readableName => _readableName;
  /// Determines whether the [Symbology] associated with this description is available.
  ///
  /// Added in version 6.7.0
  bool get isAvailable => _isAvailable;
  /// Determines whether decoding of color-inverted (bright on dark) codes for the [Symbology] associated with this description is available.
  ///
  /// Added in version 6.7.0
  bool get isColorInvertible => _isColorInvertible;
  /// The supported active symbol count range for the [Symbology] associated with this description.
  ///
  /// Added in version 6.7.0
  Range get activeSymbolCountRange => _activeSymbolCountRange;
  /// The default symbol count range for the [Symbology] associated with this description.
  ///
  /// Added in version 6.7.0
  Range get defaultSymbolCountRange => _defaultSymbolCountRange;
  /// A list of extensions supported by the [Symbology] associated with this description.
  ///
  /// Added in version 6.7.0
  Set<String> get supportedExtensions => _supportedExtensions;

  factory SymbologyDescription.fromJSON(Map<String, dynamic> json) => SymbologyDescription._(
      SymbologySerializer.fromJSON(json['identifier'] as String),
      json['readableName'] as String,
      Range.fromJSON(json['activeSymbolCountRange']),
      Range.fromJSON(json['defaultSymbolCountRange']),
      (json['supportedExtensions'] as List<dynamic>).cast<String>().toSet(),
      isAvailable: json['isAvailable'] as bool,
      isColorInvertible: json['isColorInvertible'] as bool);

  /// Gets the symbology description for a given [SymbologyDescription.identifier].
  ///
  /// Added in version 6.7.0
  static SymbologyDescription? forIdentifier(String identifier) {
    Symbology? symbology;
    try {
      symbology = SymbologySerializer.fromJSON(identifier);
    } on StateError {
      symbology = null;
    }
    if (symbology == null) {
      return null;
    }

    return SymbologyDescription.forSymbology(symbology);
  }

  /// Creates a new symbology description for a given barcode symbology ([Symbology]).
  ///
  /// Added in version 6.7.0
  factory SymbologyDescription.forSymbology(Symbology symbology) {
    return BarcodeDefaults.symbologyDescriptionsDefaults
        .firstWhere((element) => element.identifier == symbology.toString());
  }
}

/// Added in version 6.7.0
class Range implements Serializable {
  int _minimum;
  int _maximum;
  int _step;

  /// Minimum of the range.
  ///
  /// Added in version 6.7.0
  int get minimum => _minimum;

  /// Maximum of the range.
  ///
  /// Added in version 6.7.0
  int get maximum => _maximum;

  /// Step of the range.
  ///
  /// Added in version 6.7.0
  int get step => _step;

  /// Creates a new range object.
  ///
  /// Added in version 6.7.0
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
