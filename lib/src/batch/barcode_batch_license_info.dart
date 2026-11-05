/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import '../symbology.dart';

/// Contains information about barcode-batch-specific licensing.
///
/// Added in version 8.6.0
class BarcodeBatchLicenseInfo {
  final Set<Symbology> _licensedSymbologies;

  /// Which symbologies are licensed and can be used for Barcode Batch.
  ///
  /// Added in version 8.6.0
  Set<Symbology> get licensedSymbologies => _licensedSymbologies;

  BarcodeBatchLicenseInfo._(this._licensedSymbologies);

  factory BarcodeBatchLicenseInfo.fromJSON(Map<String, dynamic> json) {
    final raw = (json['licensedSymbologies'] as List<dynamic>).cast<String>();
    return BarcodeBatchLicenseInfo._(raw.map(SymbologySerializer.fromJSON).toSet());
  }
}
