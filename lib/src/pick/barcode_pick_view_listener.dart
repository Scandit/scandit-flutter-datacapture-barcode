/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_pick.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_view.dart';

/// Added in version 6.22.0
abstract class BarcodePickViewListener {
  /// Callback method invoked when the view starts scanning. Called from the main thread.
  ///
  /// Added in version 6.22.0
  void didStartScanning(BarcodePickView view);
  /// Callback method invoked the scanning is freezed. Called from the main thread.
  ///
  /// Added in version 6.22.0
  void didFreezeScanning(BarcodePickView view);
  /// Callback method invoked when the scanning is paused. Called from the main thread.
  ///
  /// Added in version 6.22.0
  void didPauseScanning(BarcodePickView view);
  /// Callback method invoked when the scanning is stopped. Called from the main thread.
  ///
  /// Added in version 6.22.0
  void didStopScanning(BarcodePickView view);
}
