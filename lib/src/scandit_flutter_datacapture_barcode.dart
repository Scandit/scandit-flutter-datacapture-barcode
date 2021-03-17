/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import '../src/capture/barcode_capture_defaults.dart';
import '../src/barcode_defaults.dart';
import '../src/tracking/barcode_tracking_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class ScanditFlutterDataCaptureBarcode {
  static Future<void> initialize() async {
    await ScanditFlutterDataCaptureCore.initialize();
    await BarcodeDefaults.initializeDefaults();
    await BarcodeCaptureDefaults.initializeDefaults();
    await BarcodeTrackingDefaults.getDefaults();
  }
}
