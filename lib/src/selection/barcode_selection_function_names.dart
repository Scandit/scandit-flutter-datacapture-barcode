/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

abstract class BarcodeSelectionFunctionNames {
  static const String getBarcodeSelectionDefaults = 'getBarcodeSelectionDefaults';
  static const String getBarcodeSelectionSessionCount = 'getBarcodeSelectionSessionCount';
  static const String resetBarcodeSelectionSession = 'resetBarcodeSelectionSession';
  static const String addListener = 'addBarcodeSelectionListener';
  static const String removeListener = 'removeBarcodeSelectionListener';
  static const String unfreezeCamera = 'unfreezeCamera';
  static const String resetMode = 'resetMode';
  static const String barcodeSelectionFinishDidUpdateSelection = 'finishDidUpdateSelection';
  static const String barcodeSelectionFinishDidUpdateSession = 'finishDidUpdateSession';
  static const String getLastFrameData = 'getLastFrameData';
  static const String setModeEnabledState = 'setModeEnabledState';
  static const String updateBarcodeSelectionMode = 'updateBarcodeSelectionMode';
  static const String applyBarcodeSelectionModeSettings = 'applyBarcodeSelectionModeSettings';
  static const String updateBarcodeSelectionBasicOverlay = 'updateBarcodeSelectionBasicOverlay';
  static const String updateFeedback = 'updateFeedback';

  static const String methodsChannelName = 'com.scandit.datacapture.barcode.selection/method_channel';
}
