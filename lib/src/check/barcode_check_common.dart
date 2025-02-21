/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'barcode_check_annotation.dart';
import 'barcode_check_highlight.dart';

abstract class BarcodeCheckViewController {
  Future<void> updateAnnotation(BarcodeCheckAnnotation annotation);
  Future<void> updateHighlight(BarcodeCheckHighlight highlight);
  Future<void> updateBarcodeCheckPopoverButtonAtIndex(BarcodeCheckPopoverAnnotation annotation, int index);
}
