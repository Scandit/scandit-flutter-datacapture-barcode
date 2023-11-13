/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum BarcodeSelectionTapBehavior { toggleSelection, repeatSelection }

extension BarcodeSelectionTapBehaviorSerializer on BarcodeSelectionTapBehavior {
  static BarcodeSelectionTapBehavior fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'toggleSelection':
        return BarcodeSelectionTapBehavior.toggleSelection;
      case 'repeatSelection':
        return BarcodeSelectionTapBehavior.repeatSelection;
      default:
        throw Exception("Missing BarcodeSelectionTapBehavior for name '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case BarcodeSelectionTapBehavior.toggleSelection:
        return 'toggleSelection';
      case BarcodeSelectionTapBehavior.repeatSelection:
        return 'repeatSelection';
      default:
        throw Exception("Missing name for enum '$this'");
    }
  }
}
