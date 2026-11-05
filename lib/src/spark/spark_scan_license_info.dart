/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import '../symbology.dart';

/// Contains information about spark-scan-specific licensing.
///
/// Added in version 8.6.0
class SparkScanLicenseInfo {
  final Set<Symbology> _licensedSymbologies;

  /// Which symbologies are licensed and can be used for SparkScan.
  ///
  /// Added in version 8.6.0
  Set<Symbology> get licensedSymbologies => _licensedSymbologies;

  SparkScanLicenseInfo._(this._licensedSymbologies);

  factory SparkScanLicenseInfo.fromJSON(Map<String, dynamic> json) {
    final raw = (json['licensedSymbologies'] as List<dynamic>).cast<String>();
    return SparkScanLicenseInfo._(raw.map(SymbologySerializer.fromJSON).toSet());
  }
}
