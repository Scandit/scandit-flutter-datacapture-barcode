/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

/// Transformer interface for Barcode Find.
///
/// Added in version 6.23.0
abstract class BarcodeFindTransformer {
  /// Invoked for each detected barcode. The implementation should return the same barcode data, which may or may not be transformed from the original, or *null* if the barcode should be ignored entirely. Note that this method is executed on a background thread.
  ///
  /// Added in version 6.23.0
  String? transformBarcodeData(String? data);
}
