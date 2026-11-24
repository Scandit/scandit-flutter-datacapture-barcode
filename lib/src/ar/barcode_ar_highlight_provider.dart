/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/ar/barcode_ar_highlight.dart';

/// An object used to retrieve the highlights for scanned barcodes.
///
/// Added in version 7.1.0
abstract class BarcodeArHighlightProvider {
  /// Asks the provider for a highlight to display for the given barcode. If *null* is provided, no highlight will be shown.
  ///
  /// Added in version 7.1.0
  Future<BarcodeArHighlight?> highlightForBarcode(Barcode barcode);
}
