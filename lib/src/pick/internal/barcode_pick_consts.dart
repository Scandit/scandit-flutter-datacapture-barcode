/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

abstract class BarcodePickFunctionNames {
  static const String getDefaults = 'getDefaults';
  static const String removeScanningListener = 'removeScanningListener';
  static const String addScanningListener = 'addScanningListener';
  static const String addBarcodePickListener = 'addBarcodePickListener';
  static const String removeBarcodePickListener = 'removeBarcodePickListener';
  // view actions
  static const String startPickView = 'startPickView';
  static const String stopPickView = 'stopPickView';
  static const String freezePickView = 'freezePickView';
  static const String releasePickView = 'releasePickView';

  static const String addViewUiListener = 'addViewUiListener';
  static const String removeViewUiListener = 'removeViewUiListener';
  static const String addViewListener = 'addViewListener';
  static const String removeViewListener = 'removeViewListener';
  static const String addActionListener = 'addActionListener';
  static const String removeActionListener = 'removeActionListener';
  static const String finishOnProductIdentifierForItems = 'finishOnProductIdentifierForItems';
  static const String finishPickAction = 'finishPickAction';

  static const String finishViewForRequest = 'finishBarcodePickViewHighlightStyleCustomViewProviderViewForRequest';
  static const String finishStyleForRequest = 'finishBarcodePickViewHighlightStyleAsyncProviderStyleForRequest';

  static const String methodsChannelName = 'com.scandit.datacapture.barcode.pick/method_channel';
}

class BarcodePickEventNames {
  static const String didUpdateSession = 'BarcodePickListener.didUpdateSession';
  static const String didCompleteScanningSession = 'BarcodePickScanningListener.didCompleteScanningSession';
  static const String didUpdateScanningSession = 'BarcodePickScanningListener.didUpdateScanningSession';

  static const viewDidStartScanning = 'BarcodePickViewListener.didStartScanning';
  static const viewDidFreezeScanning = 'BarcodePickViewListener.didFreezeScanning';
  static const viewDidPauseScanning = 'BarcodePickViewListener.didPauseScanning';
  static const viewDidStopScanning = 'BarcodePickViewListener.didStopScanning';

  static const viewUiDidTapFinishButton = 'BarcodePickViewUiListener.didTapFinishButton';

  static const actionDidPick = 'BarcodePickActionListener.didPick';
  static const actionDidUnpick = 'BarcodePickActionListener.didUnpick';

  static const viewForRequest = 'BarcodePickViewHighlightStyleCustomViewProvider.viewForRequest';
  static const styleForRequest = 'BarcodePickViewHighlightStyleAsyncProvider.styleForRequest';
}
