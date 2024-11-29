/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_defaults.dart';

import 'capture/barcode_capture_defaults.dart';
import 'barcode_defaults.dart';
import 'count/barcode_count_defaults.dart';
import 'find/barcode_find_defaults.dart';
import 'pick/barcode_pick_defaults.dart';
import 'batch/barcode_batch_defaults.dart';
import 'selection/barcode_selection_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

// ignore: avoid_classes_with_only_static_members
class ScanditFlutterDataCaptureBarcode {
  static Future<void> initialize() async {
    await ScanditFlutterDataCaptureCore.initialize();
    await BarcodeDefaults.initializeDefaults();
    await BarcodeCaptureDefaults.initializeDefaults();
    await BarcodeBatchDefaults.getDefaults();
    await BarcodeSelectionDefaults.initializeDefaults();
    await BarcodeCountDefaults.initializeDefaults();
    await SparkScanDefaults.initializeDefaults();
    await BarcodeFindDefaults.initializeDefaults();
    await BarcodePickDefaults.initializeDefaults();
  }
}
