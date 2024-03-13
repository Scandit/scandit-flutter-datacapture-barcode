/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

abstract class BarcodePickFunctionNames {
  static const String getDefaults = 'getDefaults';
  static const String removeScanningListener = 'removeScanningListener';
  static const String addScanningListener = 'addScanningListener';
  static const String startPickView = 'startPickView';
  static const String releasePickView = 'releasePickView';
  static const String freezePickView = 'freezePickView';
  static const String pausePickView = 'pausePickView';
  static const String addViewUiListener = 'addViewUiListener';
  static const String removeViewUiListener = 'removeViewUiListener';
  static const String addViewListener = 'addViewListener';
  static const String removeViewListener = 'removeViewListener';
  static const String addActionListener = 'addActionListener';
  static const String removeActionListener = 'removeActionListener';
  static const String finishOnProductIdentifierForItems = 'finishOnProductIdentifierForItems';
  static const String finishPickAction = 'finishPickAction';

  static const String methodsChannelName = 'com.scandit.datacapture.barcode.pick/method_channel';
}
