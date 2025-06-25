/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_pick.dart';

abstract class BarcodePickScanningListener {
  void didUpdateScanningSession(BarcodePick barcodePick, BarcodePickScanningSession session);
  void didCompleteScanningSession(BarcodePick barcodePick, BarcodePickScanningSession session);
}
