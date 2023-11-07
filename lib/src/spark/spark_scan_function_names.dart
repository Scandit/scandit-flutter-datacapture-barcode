/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

abstract class SparkScanFunctionNames {
  static const String sparkScanFinishDidScan = 'finishDidScan';
  static const String sparkScanFinishDidUpdateSession = 'finishDidUpdateSession';
  static const String addSparkScanListener = 'addSparkScanListener';
  static const String removeSparkScanListener = 'removeSparkScanListener';
  static const String getSparkScanDefaults = 'getSparkScanDefaults';
  static const String resetSparkScanSession = 'resetSparkScanSession';
  static const String getLastFrameData = 'getLastFrameData';
  static const String updateSparkScanMode = 'updateSparkScanMode';
  static const String addSparkScanViewUiListener = 'addSparkScanViewUiListener';
  static const String removeSparkScanViewUiListener = 'removeSparkScanViewUiListener';
  static const String startScanning = 'sparkScanViewStartScanning';
  static const String pauseScanning = 'sparkScanViewPauseScanning';
  static const String sparkScanViewEmitFeedback = 'sparkScanViewEmitFeedback';
  static const String updateView = 'sparkScanViewUpdate';
  static const String showToast = 'showToast';
  static const String onWidgetPaused = "onWidgetPaused";

  static const String methodsChannelName = 'com.scandit.datacapture.barcode.spark/method_channel';
}
