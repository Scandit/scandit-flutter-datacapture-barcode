/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

/// Enum used to specify what happens when the user aims a barcode.
///
/// Added in version 8.5.0
enum BarcodeSelectionAimerBehavior {
  /// Aiming and tapping an unselected barcode select it. Aiming and tapping an already selected barcode unselect it. The behavior does not apply when using [BarcodeSelectionAutoSelectionStrategy]. In this case, [BarcodeSelectionAimerBehavior.repeatSelection] is always in used.
  ///
  /// Added in version 8.5.0
  toggleSelection('toggleSelection'),
  /// Aiming an unselected barcode selects it. Aiming on an already selected barcode will increment the count returned by [BarcodeSelectionSession.getCount].
  ///
  /// Added in version 8.5.0
  repeatSelection('repeatSelection');

  const BarcodeSelectionAimerBehavior(this._name);

  @override
  String toString() => _name;

  static BarcodeSelectionAimerBehavior fromJSON(String jsonValue) {
    return BarcodeSelectionAimerBehavior.values.firstWhere((element) => element.toString() == jsonValue);
  }

  final String _name;
}
