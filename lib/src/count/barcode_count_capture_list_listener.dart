/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/count/barcode_count_capture_list_session.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/barcode_count_view.dart';

abstract class BarcodeCountCaptureListListener {
  void didUpdateSession(BarcodeCountCaptureList barcodeCountCaptureList, BarcodeCountCaptureListSession session);
}
