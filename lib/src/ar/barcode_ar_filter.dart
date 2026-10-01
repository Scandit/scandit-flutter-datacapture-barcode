/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';

abstract class BarcodeArFilter {
  Future<List<Barcode>> filterBarcodes(List<Barcode> barcodes);
}
