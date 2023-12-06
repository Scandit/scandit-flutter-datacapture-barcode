/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'capture/barcode_capture_defaults.dart';
import 'barcode_defaults.dart';
import 'count/barcode_count_defaults.dart';
import 'tracking/barcode_tracking_defaults.dart';
import 'selection/barcode_selection_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

// ignore: avoid_classes_with_only_static_members
class ScanditFlutterDataCaptureBarcode {
  static Future<void> initialize() async {
    await ScanditFlutterDataCaptureCore.initialize();
    await BarcodeDefaults.initializeDefaults();
    await BarcodeCaptureDefaults.initializeDefaults();
    await BarcodeTrackingDefaults.getDefaults();
    await BarcodeSelectionDefaults.initializeDefaults();
    await BarcodeCountDefaults.initializeDefaults();
  }
}
