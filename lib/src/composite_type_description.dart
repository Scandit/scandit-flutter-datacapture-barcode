/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'composite_type.dart';
import 'symbology.dart';

class CompositeTypeDescription {
  final Set<CompositeType> _types;
  final Set<Symbology> _symbologies;

  CompositeTypeDescription._(this._types, this._symbologies);

  Set<CompositeType> get types => _types;
  Set<Symbology> get symbologies => _symbologies;

  factory CompositeTypeDescription.fromJSON(Map<String, dynamic> json) {
    return CompositeTypeDescription._(
        (json['types'] as List<dynamic>).map((e) => CompositeTypeSerializer.fromJSON(e as String)).toSet(),
        (json['symbologies'] as List<dynamic>).map((e) => SymbologySerializer.fromJSON(e as String)).toSet());
  }
}
