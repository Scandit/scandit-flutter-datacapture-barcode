/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'package:scandit_flutter_datacapture_barcode/src/count/barcode_count_session.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/barcode_count_view.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

/// The BarcodeCount listener is the main way for hooking into BarcodeCount. It provides a callback that is invoked when the state of tracked barcodes changes.
///
/// Added in version 6.17.0
abstract class BarcodeCountListener {
  /// Invoked once scanning phase is over.
  ///
  /// Added in version 6.17.0
  Future<void> didScan(
      BarcodeCount barcodeCount, BarcodeCountSession session, Future<FrameData> Function() getFrameData);
}

/// Added in version 8.3.0
abstract class BarcodeCountExtendedListener extends BarcodeCountListener {
  /// Invoked whenever the session has been updated.
  ///
  /// Added in version 8.3.0
  void didUpdateSession(
      BarcodeCount barcodeCount, BarcodeCountSession session, Future<FrameData> Function() getFrameData);
}
