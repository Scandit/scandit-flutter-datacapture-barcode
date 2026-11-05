/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

/// The conditions that trigger an annotation to be displayed.
///
/// Added in version 7.1.0
enum BarcodeArAnnotationTrigger {
  /// The annotation is shown when the user taps on the highlight.
  ///
  /// Added in version 7.1.0
  highlightTap('highlightTap'),
  /// The annotation is shown immediately when the barcode is scanned, and can be hidden and shown again by tapping on the highlight.
  ///
  /// Added in version 7.1.0
  highlightTapAndBarcodeScan('highlightTapAndBarcodeScan'),
  /// The annotation is shown immediately when the barcode is scanned. It cannot be toggled by user interaction and remains visible once shown, as long as the barcode is being scanned.
  ///
  /// Added in version 8.5.0
  barcodeScan('barcodeScan');

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
