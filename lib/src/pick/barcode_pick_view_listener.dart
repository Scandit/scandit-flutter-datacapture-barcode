/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_pick.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_view.dart';

abstract class BarcodePickViewListener {
  void didStartScanning(BarcodePickView view);
  void didFreezeScanning(BarcodePickView view);
  void didPauseScanning(BarcodePickView view);
  void didStopScanning(BarcodePickView view);
}
