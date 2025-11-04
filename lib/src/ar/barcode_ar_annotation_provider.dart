/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/ar/barcode_ar_annotation.dart';

abstract class BarcodeArAnnotationProvider {
  Future<BarcodeArAnnotation?> annotationForBarcode(Barcode barcode);
}
