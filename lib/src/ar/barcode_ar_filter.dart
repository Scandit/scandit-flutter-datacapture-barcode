/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';

/// Interface for filtering barcodes in [BarcodeAr].
///
/// Implement this interface to provide custom barcode filtering logic that determines which barcodes should be visible in the [BarcodeArSession]. This allows you to selectively show only barcodes that meet certain criteria (e.g., specific symbologies, data patterns, or business logic).
///
/// The filter is evaluated:
///
/// - Every time barcodes are added to or removed from the session
/// - When the filter is first set or changed via [BarcodeAr.setBarcodeFilter]
///
/// It is **not** re-evaluated when only barcode positions are updated.
///
/// Added in version 8.5.0
abstract class BarcodeArFilter {
  /// Filters the provided barcodes and returns which ones should be visible.
  ///
  /// Param barcodesAll currently visible barcodes.ReturnsA subset of the input barcodes that should be shown to the user. The returned list must only contain barcodes from the input; any other barcodes will be ignored.
  ///
  /// This method is called on an internal recognition thread and must return quickly to avoid impacting frame processing performance.
  ///
  /// Added in version 8.5.0
  Future<List<Barcode>> filterBarcodes(List<Barcode> barcodes);
}
