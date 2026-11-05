/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode.dart';

/// Interface for applying custom brushes to recognized barcodes.
///
/// Added in version 8.5.0
abstract class BarcodeSelectionBrushProvider {
  /// Returns the brush to apply to the given barcode. A non-*null* brush returned by this method overrides any other brush set for the barcode.
  ///
  /// Added in version 8.5.0
  Brush? brushForBarcode(Barcode barcode);
}
