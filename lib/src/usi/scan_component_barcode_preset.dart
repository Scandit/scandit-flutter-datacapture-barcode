/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

/// A preset to be applied to a [BarcodeDefinition].
///
/// Added in version 8.1.0
enum ScanComponentBarcodePreset {
  /// Added in version 8.1.0
  customBarcode('customBarcode'),
  /// Added in version 8.1.0
  imeiOneBarcode('imeiOneBarcode'),
  /// Added in version 8.1.0
  imeiTwoBarcode('imeiTwoBarcode'),
  /// Added in version 8.1.0
  partNumberBarcode('partNumberBarcode'),
  /// Added in version 8.1.0
  serialNumberBarcode('serialNumberBarcode');

  const ScanComponentBarcodePreset(this._name);

  @override
  String toString() => _name;

  final String _name;

  static ScanComponentBarcodePreset fromJSON(String jsonValue) {
    return ScanComponentBarcodePreset.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
