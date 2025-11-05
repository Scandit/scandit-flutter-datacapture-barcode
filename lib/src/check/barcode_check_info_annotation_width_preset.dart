/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum BarcodeCheckInfoAnnotationWidthPreset {
  small('small'),
  medium('medium'),
  large('large');

  const BarcodeCheckInfoAnnotationWidthPreset(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeCheckInfoAnnotationWidthPresetSerializer on BarcodeCheckInfoAnnotationWidthPreset {
  static BarcodeCheckInfoAnnotationWidthPreset fromJSON(String jsonValue) {
    return BarcodeCheckInfoAnnotationWidthPreset.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
