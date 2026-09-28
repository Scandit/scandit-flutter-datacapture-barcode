/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

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
