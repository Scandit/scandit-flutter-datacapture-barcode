/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

class BarcodePickScanningSession {
  final Set<String> _pickedItems;
  final Set<String> _scannedItems;
  BarcodePickScanningSession._(this._pickedItems, this._scannedItems);
  factory BarcodePickScanningSession.fromJSON(Map<String, dynamic> json) {
    return BarcodePickScanningSession._(
      (json['pickedObjects'] as List<dynamic>).whereType<String>().toSet(),
      (json['scannedObjects'] as List<dynamic>).whereType<String>().toSet(),
    );
  }

  Set<String> get pickedItems {
    return _pickedItems;
  }

  Set<String> get scannedItems {
    return _scannedItems;
  }
}
