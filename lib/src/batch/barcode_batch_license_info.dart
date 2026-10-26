/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import '../symbology.dart';

class BarcodeBatchLicenseInfo {
  final Set<Symbology> _licensedSymbologies;

  Set<Symbology> get licensedSymbologies => _licensedSymbologies;

  BarcodeBatchLicenseInfo._(this._licensedSymbologies);

  factory BarcodeBatchLicenseInfo.fromJSON(Map<String, dynamic> json) {
    final raw = (json['licensedSymbologies'] as List<dynamic>).cast<String>();
    return BarcodeBatchLicenseInfo._(raw.map(SymbologySerializer.fromJSON).toSet());
  }
}
