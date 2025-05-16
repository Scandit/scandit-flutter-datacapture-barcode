/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'barcode_ar_annotation.dart';
import 'barcode_ar_highlight.dart';

abstract class BarcodeArViewController {
  Future<void> updateAnnotation(BarcodeArAnnotation annotation);
  Future<void> updateHighlight(BarcodeArHighlight highlight);
  Future<void> updateBarcodeArPopoverButtonAtIndex(BarcodeArPopoverAnnotation annotation, int index);
}
