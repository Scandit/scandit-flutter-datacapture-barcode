/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum BarcodeArInfoAnnotationWidthPreset {
  small('small'),
  medium('medium'),
  large('large');

  const BarcodeArInfoAnnotationWidthPreset(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeArInfoAnnotationWidthPresetSerializer on BarcodeArInfoAnnotationWidthPreset {
  static BarcodeArInfoAnnotationWidthPreset fromJSON(String jsonValue) {
    return BarcodeArInfoAnnotationWidthPreset.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
