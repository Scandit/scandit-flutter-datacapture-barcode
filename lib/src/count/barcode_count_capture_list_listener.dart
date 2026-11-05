/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/count/barcode_count_capture_list_session.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/barcode_count_view.dart';

/// The BarcodeCountCaptureList listener is the main way for hooking into [BarcodeCountCaptureList]. It provides a callback that is invoked when the state of target barcodes changes.
///
/// Added in version 6.17.0
abstract class BarcodeCountCaptureListListener {
  /// Called after a frame processed by [BarcodeCountCaptureList] has caused the list to be updated.
  ///
  /// Added in version 6.17.0
  void didUpdateSession(BarcodeCountCaptureList barcodeCountCaptureList, BarcodeCountCaptureListSession session);
}

/// Extended listener interface that adds new methods to [BarcodeCountCaptureListListener] without breaking existing implementations.
///
/// Added in version 8.3.0
abstract class BarcodeCountCaptureListExtendedListener extends BarcodeCountCaptureListListener {
  /// Called after when all the barcodes in the [BarcodeCountCaptureList] have been scanned.
  ///
  /// This method is only available in [BarcodeCountCaptureListExtendedListener]. To use it, implement the extended listener instead of the base listener.
  ///
  /// Added in version 8.3.0
  void didCompleteCaptureList(BarcodeCountCaptureList barcodeCountCaptureList, BarcodeCountCaptureListSession session);
}
