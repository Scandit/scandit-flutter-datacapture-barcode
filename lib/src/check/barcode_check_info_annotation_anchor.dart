/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum BarcodeCheckInfoAnnotationAnchor {
  top('top'),
  bottom('bottom'),
  left('left'),
  right('right');

  const BarcodeCheckInfoAnnotationAnchor(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeCheckInfoAnnotationAnchorSerializer on BarcodeCheckInfoAnnotationAnchor {
  static BarcodeCheckInfoAnnotationAnchor fromJSON(String jsonValue) {
    return BarcodeCheckInfoAnnotationAnchor.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
