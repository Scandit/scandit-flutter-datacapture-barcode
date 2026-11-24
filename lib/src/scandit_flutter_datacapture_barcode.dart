/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'barcode_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'internal/generated/barcode_log_metadata.dart';

// ignore: avoid_classes_with_only_static_members
/// The container class of the module. Includes only one method, which initializes the barcode and the core plugins.
///
/// Added in version 6.7.0
class ScanditFlutterDataCaptureBarcode {
  /// Initializes the core and the barcode plugins. You need to invoke this method before accessing any of the Scandit Data Capture SDK functionality.
  ///
  /// Added in version 6.7.0
  static Future<void> initialize() async {
    await ScanditFlutterDataCaptureCore.initialize();
    registerBarcodeLogMetadata();
    await BarcodeDefaults.initializeDefaults();
  }
}
