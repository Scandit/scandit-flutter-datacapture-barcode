/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

/// Transformer interface for Barcode matching.
///
/// Added in version 8.3.0
abstract class BarcodeDataTransformer {
  /// Invoked for each detected barcode. The implementation should return the same barcode data, which may or may not be transformed from the original, or *null* if the barcode should be ignored entirely. Note that this method is executed on a background thread.
  ///
  /// Added in version 8.3.0
  String? transformBarcodeData(String? data);
}
