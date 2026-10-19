/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode.dart';

abstract class BarcodeSelectionBrushProvider {
  Brush? brushForBarcode(Barcode barcode);
}
