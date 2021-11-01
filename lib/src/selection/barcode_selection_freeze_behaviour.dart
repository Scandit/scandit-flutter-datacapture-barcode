/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum BarcodeSelectionFreezeBehavior { manual, manualAndAutomatic }

extension BarcodeSelectionFreezeBehaviorSerializer on BarcodeSelectionFreezeBehavior {
  static BarcodeSelectionFreezeBehavior fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'manual':
        return BarcodeSelectionFreezeBehavior.manual;
      case 'manualAndAutomatic':
        return BarcodeSelectionFreezeBehavior.manualAndAutomatic;
      default:
        throw Exception("Missing BarcodeSelectionFreezeBehavior for name '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case BarcodeSelectionFreezeBehavior.manual:
        return 'manual';
      case BarcodeSelectionFreezeBehavior.manualAndAutomatic:
        return 'manualAndAutomatic';
      default:
        throw Exception("Missing name for enum '$this'");
    }
  }
}
