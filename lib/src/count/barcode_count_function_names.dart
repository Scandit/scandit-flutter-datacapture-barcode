/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

abstract class BarcodeCountFunctionNames {
  static const String getDefaults = 'getBarcodeCountDefaults';
  static const String resetBarcodeCountSession = 'resetBarcodeCountSession';
  static const String barcodeCountFinishOnScan = 'barcodeCountFinishOnScan';
  static const String addBarcodeCountListener = 'addBarcodeCountListener';
  static const String removeBarcodeCountListener = 'removeBarcodeCountListener';
  static const String getBarcodeCountLastFrameData = 'getBarcodeCountLastFrameData';
  static const String resetMode = 'resetBarcodeCount';
  static const String startScanningPhase = 'startScanningPhase';
  static const String endScanningPhase = 'endScanningPhase';
  static const String setBarcodeCountCaptureList = 'setBarcodeCountCaptureList';
  static const String updateBarcodeCountMode = 'updateBarcodeCountMode';

  static const String addBarcodeCountViewListener = 'addBarcodeCountViewListener';
  static const String removeBarcodeCountViewListener = 'removeBarcodeCountViewListener';
  static const String addBarcodeCountViewUiListener = 'addBarcodeCountViewUiListener';
  static const String removeBarcodeCountViewUiListener = 'removeBarcodeCountViewUiListener';
  static const String clearHighlights = 'clearHighlights';
  static const String updateBarcodeCountView = 'updateBarcodeCountView';

  static const String finishBrushForRecognizedBarcodeEvent = 'finishBrushForRecognizedBarcodeEvent';
  static const String finishBrushForRecognizedBarcodeNotInListEvent = 'finishBrushForRecognizedBarcodeNotInListEvent';
  static const String finishBrushForUnrecognizedBarcodeEvent = 'finishBrushForUnrecognizedBarcodeEvent';
}
