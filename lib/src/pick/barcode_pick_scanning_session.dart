/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

/// The BarcodePick scanning session holds the ongoing state of a running [BarcodePick].
///
/// Added in version 6.22.0
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

  /// Sets of barcodes represented by their data that are picked.
  ///
  /// Added in version 6.22.0
  Set<String> get pickedItems {
    return _pickedItems;
  }

  /// Sets of barcodes represented by their data that are scanned.
  ///
  /// Added in version 6.22.0
  Set<String> get scannedItems {
    return _scannedItems;
  }
}
