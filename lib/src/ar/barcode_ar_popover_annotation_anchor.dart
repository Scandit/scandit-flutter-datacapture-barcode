/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum BarcodeArPopoverAnnotationAnchor {
  top('top'),
  bottom('bottom'),
  left('left'),
  right('right');

  const BarcodeArPopoverAnnotationAnchor(this._name);

  @override
  String toString() => _name;

  final String _name;

  static BarcodeArPopoverAnnotationAnchor fromJSON(String jsonValue) {
    return BarcodeArPopoverAnnotationAnchor.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
