/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum BarcodeCheckAnnotationTrigger {
  highlightTap('highlightTap'),
  highlightTapAndBarcodeScan('highlightTapAndBarcodeScan');

  const BarcodeCheckAnnotationTrigger(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeCheckAnnotationTriggerSerializer on BarcodeCheckAnnotationTrigger {
  static BarcodeCheckAnnotationTrigger fromJSON(String jsonValue) {
    return BarcodeCheckAnnotationTrigger.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
