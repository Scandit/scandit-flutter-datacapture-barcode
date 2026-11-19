/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum BarcodeSelectionTapBehavior {
  toggleSelection('toggleSelection'),
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
