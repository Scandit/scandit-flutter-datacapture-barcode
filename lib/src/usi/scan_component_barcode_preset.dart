/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

enum ScanComponentBarcodePreset {
  customBarcode('customBarcode'),
  imeiOneBarcode('imeiOneBarcode'),
  imeiTwoBarcode('imeiTwoBarcode'),
  partNumberBarcode('partNumberBarcode'),
  serialNumberBarcode('serialNumberBarcode');

  const ScanComponentBarcodePreset(this._name);

  @override
  String toString() => _name;

  final String _name;

  static ScanComponentBarcodePreset fromJSON(String jsonValue) {
    return ScanComponentBarcodePreset.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
