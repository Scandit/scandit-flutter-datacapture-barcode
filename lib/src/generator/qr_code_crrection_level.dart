/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

enum QrCodeErrorCorrectionLevel {
  low('low'),
  medium('medium'),
  quartile('quartile'),
  high('high');

  const QrCodeErrorCorrectionLevel(this._name);

  @override
  String toString() => _name;

  final String _name;
}
