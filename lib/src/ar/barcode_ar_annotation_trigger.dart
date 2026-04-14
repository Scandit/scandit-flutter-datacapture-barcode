/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum BarcodeArAnnotationTrigger {
  highlightTap('highlightTap'),
  highlightTapAndBarcodeScan('highlightTapAndBarcodeScan');

  const BarcodeArAnnotationTrigger(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeArAnnotationTriggerSerializer on BarcodeArAnnotationTrigger {
  static BarcodeArAnnotationTrigger fromJSON(String jsonValue) {
    return BarcodeArAnnotationTrigger.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
