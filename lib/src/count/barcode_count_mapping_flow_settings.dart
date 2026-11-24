/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_count_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show buildBarcodeCountMappingFlowSettings;

/// Settings used with the BarcodeCount mapping flow.
///
/// Added in version 8.3.0
class BarcodeCountMappingFlowSettings implements Serializable {
  /// Text displayed for the initial guidance during the mapping flow. Defaults to “Tap shutter to scan all codes in batches”.
  ///
  /// Added in version 8.3.0
  String scanBarcodesGuidanceText = BarcodeCountDefaults.viewDefaults.mappingFlowSettings.scanBarcodesGuidanceText;
  /// Text displayed on the “Next” button. Defaults to “Next”.
  ///
  /// Added in version 8.3.0
  String nextButtonText = BarcodeCountDefaults.viewDefaults.mappingFlowSettings.nextButtonText;
  /// Text displayed during the mapping flow on the last screen. Defaults to “Step back to fit all codes into camera view”.
  ///
  /// Added in version 8.3.0
  String stepBackGuidanceText = BarcodeCountDefaults.viewDefaults.mappingFlowSettings.stepBackGuidanceText;
  /// Text displayed on the “Redo map” button. Defaults to “Redo map”.
  ///
  /// Added in version 8.3.0
  String redoScanButtonText = BarcodeCountDefaults.viewDefaults.mappingFlowSettings.redoScanButtonText;
  /// Text displayed on the “Restart” button. Defaults to “Restart”.
  ///
  /// Added in version 8.3.0
  String restartButtonText = BarcodeCountDefaults.viewDefaults.mappingFlowSettings.restartButtonText;
  /// Text displayed on the “Finish” button. Defaults to “Finish”.
  ///
  /// Added in version 8.3.0
  String finishButtonText = BarcodeCountDefaults.viewDefaults.mappingFlowSettings.finishButtonText;

  /// Creates a new BarcodeCountMappingFlowSettings instance.
  ///
  /// Added in version 8.3.0
  BarcodeCountMappingFlowSettings();

  @override
  Map<String, dynamic> toMap() {
    return buildBarcodeCountMappingFlowSettings(
      scanBarcodesGuidanceText: scanBarcodesGuidanceText,
      nextButtonText: nextButtonText,
      stepBackGuidanceText: stepBackGuidanceText,
      redoScanButtonText: redoScanButtonText,
      restartButtonText: restartButtonText,
      finishButtonText: finishButtonText,
    );
  }
}
