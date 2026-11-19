/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'barcode_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

// ignore: avoid_classes_with_only_static_members
class ScanditFlutterDataCaptureBarcode {
  static Future<void> initialize() async {
    await ScanditFlutterDataCaptureCore.initialize();
    await BarcodeDefaults.initializeDefaults();
  }
}
