/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

enum BarcodeSelectionAimerBehavior {
  toggleSelection('toggleSelection'),
  repeatSelection('repeatSelection');

  const BarcodeSelectionAimerBehavior(this._name);

  @override
  String toString() => _name;

  static BarcodeSelectionAimerBehavior fromJSON(String jsonValue) {
    return BarcodeSelectionAimerBehavior.values.firstWhere((element) => element.toString() == jsonValue);
  }

  final String _name;
}
