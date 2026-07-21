/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum BarcodeArInfoAnnotationAnchor {
  top('top'),
  bottom('bottom'),
  left('left'),
  right('right');

  const BarcodeArInfoAnnotationAnchor(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeArInfoAnnotationAnchorSerializer on BarcodeArInfoAnnotationAnchor {
  static BarcodeArInfoAnnotationAnchor fromJSON(String jsonValue) {
    return BarcodeArInfoAnnotationAnchor.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
