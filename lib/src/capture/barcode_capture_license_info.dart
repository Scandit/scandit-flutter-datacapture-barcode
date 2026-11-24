/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import '../symbology.dart';

/// Contains information about barcode-capture-specific licensing.
///
/// Added in version 8.6.0
class BarcodeCaptureLicenseInfo {
  final Set<Symbology> _licensedSymbologies;

  /// Which symbologies are licensed and can be used for barcode capture.
  ///
  /// Added in version 8.6.0
  Set<Symbology> get licensedSymbologies => _licensedSymbologies;

  BarcodeCaptureLicenseInfo._(this._licensedSymbologies);

  factory BarcodeCaptureLicenseInfo.fromJSON(Map<String, dynamic> json) {
    final raw = (json['licensedSymbologies'] as List<dynamic>).cast<String>();
    return BarcodeCaptureLicenseInfo._(raw.map(SymbologySerializer.fromJSON).toSet());
  }
}
