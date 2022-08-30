/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

abstract class BarcodeCaptureFunctionNames {
  static const String barcodeCaptureFinishDidScan = 'finishDidScan';
  static const String barcodeCaptureFinishDidUpdateSession = 'finishDidUpdateSession';
  static const String addBarcodeCaptureListener = 'addBarcodeCaptureListener';
  static const String removeBarcodeCaptureListener = 'removeBarcodeCaptureListener';
  static const String getBarcodeCaptureDefaults = 'getBarcodeCaptureDefaults';
  static const String resetBarcodeCaptureSession = 'resetBarcodeCaptureSession';
  static const String getLastFrameData = 'getLastFrameData';
}
