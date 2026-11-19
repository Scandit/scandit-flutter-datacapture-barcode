/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import '../symbology.dart';

class BarcodeCaptureLicenseInfo {
  final Set<Symbology> _licensedSymbologies;

  Set<Symbology> get licensedSymbologies => _licensedSymbologies;

  BarcodeCaptureLicenseInfo._(this._licensedSymbologies);

  factory BarcodeCaptureLicenseInfo.fromJSON(Map<String, dynamic> json) {
    final raw = (json['licensedSymbologies'] as List<dynamic>).cast<String>();
    return BarcodeCaptureLicenseInfo._(raw.map(SymbologySerializer.fromJSON).toSet());
  }
}
