/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_pick.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_session.dart';

abstract class BarcodePickListener {
  Future<void> didUpdateSession(BarcodePick barcodePick, BarcodePickSession session);
}
