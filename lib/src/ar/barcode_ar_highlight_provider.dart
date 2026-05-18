/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/ar/barcode_ar_highlight.dart';

abstract class BarcodeArHighlightProvider {
  Future<BarcodeArHighlight?> highlightForBarcode(Barcode barcode);
}
