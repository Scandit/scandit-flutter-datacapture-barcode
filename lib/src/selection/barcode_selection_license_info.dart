/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import '../symbology.dart';

class BarcodeSelectionLicenseInfo {
  final Set<Symbology> _licensedSymbologies;

  Set<Symbology> get licensedSymbologies => _licensedSymbologies;

  BarcodeSelectionLicenseInfo._(this._licensedSymbologies);

  factory BarcodeSelectionLicenseInfo.fromJSON(Map<String, dynamic> json) {
    final raw = (json['licensedSymbologies'] as List<dynamic>).cast<String>();
    return BarcodeSelectionLicenseInfo._(raw.map(SymbologySerializer.fromJSON).toSet());
  }
}
