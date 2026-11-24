/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'barcode_defaults.dart';
import 'composite_type.dart';
import 'symbology.dart';

/// Description specific to a particular composite type ([CompositeType]).
///
/// Added in version 6.7.0
class CompositeTypeDescription {
  final Set<CompositeType> _types;
  final Set<Symbology> _symbologies;

  CompositeTypeDescription._(this._types, this._symbologies);

  /// The composite types ([CompositeType]) described by the description.
  ///
  /// Added in version 6.7.0
  Set<CompositeType> get types => _types;
  /// All symbologies that can be part of a composite code with the given composite type ([CompositeType]).
  ///
  /// Added in version 6.7.0
  Set<Symbology> get symbologies => _symbologies;

  /// A list of descriptions, one for each individual [CompositeType].
  ///
  /// Added in version 8.7.0
  static List<CompositeTypeDescription> get all => BarcodeDefaults.compositeTypeDescriptionsDefaults;

  /// Creates a new composite type description for a given composite type ([CompositeType]).
  ///
  /// Added in version 8.7.0
  factory CompositeTypeDescription.create(Set<CompositeType> types) {
    final descriptions = all;
    if (descriptions.isEmpty) {
      throw StateError('Missing composite type description defaults: CompositeTypeDescription.create() was '
          'called before the barcode defaults finished loading.');
    }
    // Native's ctor unions the AB set when A or B is present and the C set when C is, and all()
    // returns one entry per type - so unioning the matching entries is equivalent (SDC-33600).
    final symbologies = descriptions
        .where((description) => description.types.intersection(types).isNotEmpty)
        .expand((description) => description.symbologies)
        .toSet();
    return CompositeTypeDescription._(types.toSet(), symbologies);
  }

  factory CompositeTypeDescription.fromJSON(Map<String, dynamic> json) {
    return CompositeTypeDescription._(
        (json['types'] as List<dynamic>).map((e) => CompositeTypeSerializer.fromJSON(e as String)).toSet(),
        (json['symbologies'] as List<dynamic>).map((e) => SymbologySerializer.fromJSON(e as String)).toSet());
  }
}
