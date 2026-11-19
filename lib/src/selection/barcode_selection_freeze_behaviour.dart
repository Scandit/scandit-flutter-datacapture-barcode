/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum BarcodeSelectionFreezeBehavior {
  manual('manual'),
  manualAndAutomatic('manualAndAutomatic');

  const BarcodeSelectionFreezeBehavior(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeSelectionFreezeBehaviorSerializer on BarcodeSelectionFreezeBehavior {
  static BarcodeSelectionFreezeBehavior fromJSON(String jsonValue) {
    return BarcodeSelectionFreezeBehavior.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
