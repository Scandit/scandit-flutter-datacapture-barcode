/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'package:scandit_flutter_datacapture_barcode/src/count/barcode_count_session.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/barcode_count_view.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

abstract class BarcodeCountListener {
  Future<void> didScan(BarcodeCount barcodeCount, BarcodeCountSession session, Future<FrameData> getFrameData());
}
