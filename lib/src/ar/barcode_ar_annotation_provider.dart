/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/ar/barcode_ar_annotation.dart';

/// An object used to retrieve the annotations for scanned barcodes.
///
/// Added in version 7.1.0
abstract class BarcodeArAnnotationProvider {
  /// Asks the provider for an annotation to display for the given barcode. If *null* is provided, no annotation will be shown.
  ///
  /// Added in version 7.1.0
  Future<BarcodeArAnnotation?> annotationForBarcode(Barcode barcode);
}
