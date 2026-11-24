/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

/// The level of error correction to use in generating a QR code, specifying how much the code can be damaged while remaining readable.
///
/// Added in version 7.2.0
enum QrCodeErrorCorrectionLevel {
  /// “Low” (up to 7% damage)
  ///
  /// Added in version 7.2.0
  low('low'),
  /// “Medium” (up to 15% damage) (default if not set)
  ///
  /// Added in version 7.2.0
  medium('medium'),
  /// “Quartile” (up to 25% damage)
  ///
  /// Added in version 7.2.0
  quartile('quartile'),
  /// “High” (up to 30% damage)
  ///
  /// Added in version 7.2.0
  high('high');

  const QrCodeErrorCorrectionLevel(this._name);

  @override
  String toString() => _name;

  final String _name;
}
