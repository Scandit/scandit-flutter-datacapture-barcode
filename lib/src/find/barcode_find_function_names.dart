/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

abstract class BarcodeFindFunctionNames {
  static const String getBarcodeFindDefaults = 'getBarcodeFindDefaults';
  static const String updateFindView = 'updateFindView';
  static const String updateFindMode = 'updateFindMode';
  static const String registerBarcodeFindListener = 'registerBarcodeFindListener';
  static const String unregisterBarcodeFindListener = 'unregisterBarcodeFindListener';
  static const String registerBarcodeFindViewListener = 'registerBarcodeFindViewListener';
  static const String unregisterBarcodeFindViewListener = 'unregisterBarcodeFindViewListener';
  static const String barcodeFindViewOnPause = 'barcodeFindViewOnPause';
  static const String barcodeFindViewOnResume = 'barcodeFindViewOnResume';
  static const String barcodeFindSetItemList = 'barcodeFindSetItemList';
  static const String barcodeFindViewStopSearching = 'barcodeFindViewStopSearching';
  static const String barcodeFindViewStartSearching = 'barcodeFindViewStartSearching';
  static const String barcodeFindViewPauseSearching = 'barcodeFindViewPauseSearching';
  static const String barcodeFindModeStart = 'barcodeFindModeStart';
  static const String barcodeFindModePause = 'barcodeFindModePause';
  static const String barcodeFindModeStop = 'barcodeFindModeStop';
  static const String setModeEnabledState = 'setModeEnabledState';
  static const String setBarcodeTransformer = 'setBarcodeTransformer';
  static const String submitBarcodeTransformerResult = 'submitBarcodeTransformerResult';

  static const String methodsChannelName = 'com.scandit.datacapture.barcode.find/method_channel';
}
