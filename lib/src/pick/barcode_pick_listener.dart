/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_pick.dart';

/// A listener that will be called every frame.
///
/// Added in version 7.3.0
abstract class BarcodePickListener {
  /// This method will be called every time a frame is processed. An updated session object is passed.
  ///
  /// Added in version 7.3.0
  Future<void> didUpdateSession(BarcodePick barcodePick, BarcodePickSession session);
}
