/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_count_defaults.dart';

class BarcodeCountMappingFlowSettings implements Serializable {
  String scanBarcodesGuidanceText = BarcodeCountDefaults.viewDefaults.mappingFlowSettings.scanBarcodesGuidanceText;
  String nextButtonText = BarcodeCountDefaults.viewDefaults.mappingFlowSettings.nextButtonText;
  String stepBackGuidanceText = BarcodeCountDefaults.viewDefaults.mappingFlowSettings.stepBackGuidanceText;
  String redoScanButtonText = BarcodeCountDefaults.viewDefaults.mappingFlowSettings.redoScanButtonText;
  String restartButtonText = BarcodeCountDefaults.viewDefaults.mappingFlowSettings.restartButtonText;
  String finishButtonText = BarcodeCountDefaults.viewDefaults.mappingFlowSettings.finishButtonText;

  BarcodeCountMappingFlowSettings();

  @override
  Map<String, dynamic> toMap() {
    return {
      'scanBarcodesGuidanceText': scanBarcodesGuidanceText,
      'nextButtonText': nextButtonText,
      'stepBackGuidanceText': stepBackGuidanceText,
      'redoScanButtonText': redoScanButtonText,
      'restartButtonText': restartButtonText,
      'finishButtonText': finishButtonText,
    };
  }
}
