/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_pick.dart';

/// Will be notified when a scanning session is updated.
///
/// Added in version 6.22.0
abstract class BarcodePickScanningListener {
  /// This method will be called whenever an item is picked or unpicked or new items scanned.
  ///
  /// Added in version 6.22.0
  void didUpdateScanningSession(BarcodePick barcodePick, BarcodePickScanningSession session);
  /// This method will be called when scanning session is completed.
  ///
  /// That is, when BarcodePickView.release() is called.
  ///
  /// Added in version 6.22.0
  void didCompleteScanningSession(BarcodePick barcodePick, BarcodePickScanningSession session);
}
