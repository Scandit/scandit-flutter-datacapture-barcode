/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

/// Enum used to specify what happens when the user taps a barcode.
///
/// Added in version 6.10.0
enum BarcodeSelectionTapBehavior {
  /// Tapping an unselected barcode selects it. Tapping an already selected barcode will unselect it.
  ///
  /// Added in version 6.10.0
  toggleSelection('toggleSelection'),
  /// Tapping an unselected barcode selects it. Tapping on an already selected barcode will increment the count returned by [BarcodeSelectionSession.getCount].
  ///
  /// Added in version 6.10.0
  repeatSelection('repeatSelection');

  const BarcodeSelectionTapBehavior(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeSelectionTapBehaviorSerializer on BarcodeSelectionTapBehavior {
  static BarcodeSelectionTapBehavior fromJSON(String jsonValue) {
    return BarcodeSelectionTapBehavior.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
