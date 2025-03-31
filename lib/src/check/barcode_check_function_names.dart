/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

abstract class BarcodeCheckFunctionNames {
  static const String getDefaults = 'getBarcodeCheckDefaults';
  static const String updateFeedback = 'updateFeedback';
  static const String resetLatestBarcodeCheckSession = 'resetLatestBarcodeCheckSession';
  static const String applyBarcodeCheckModeSettings = 'applyBarcodeCheckModeSettings';
  static const String removeBarcodeCheckListener = 'removeBarcodeCheckListener';
  static const String addBarcodeCheckListener = 'addBarcodeCheckListener';
  static const String barcodeCheckFinishDidUpdateSession = 'barcodeCheckFinishDidUpdateSession';
  static const String getFrameData = 'getFrameData';
  static const String updateView = "updateView";
  static const String registerBarcodeCheckViewUiListener = 'registerBarcodeCheckViewUiListener';
  static const String unregisterBarcodeCheckViewUiListener = 'unregisterBarcodeCheckViewUiListener';
  static const String registerBarcodeCheckHighlightProvider = 'registerBarcodeCheckHighlightProvider';
  static const String unregisterBarcodeCheckHighlightProvider = 'unregisterBarcodeCheckHighlightProvider';
  static const String registerBarcodeCheckAnnotationProvider = 'registerBarcodeCheckAnnotationProvider';
  static const String unregisterBarcodeCheckAnnotationProvider = 'unregisterBarcodeCheckAnnotationProvider';
  static const String viewStart = 'viewStart';
  static const String viewStop = 'viewStop';
  static const String viewPause = 'viewPause';
  static const String viewReset = 'viewReset';
  static const String finishHighlightForBarcode = 'finishHighlightForBarcode';
  static const String finishAnnotationForBarcode = 'finishAnnotationForBarcode';
  static const String updateAnnotation = 'updateAnnotation';
  static const String updateHighlight = 'updateHighlight';
  static const String updateBarcodeCheckPopoverButtonAtIndex = 'updateBarcodeCheckPopoverButtonAtIndex';

  static const String highlightForBarcodeEvent = 'BarcodeCheckHighlightProvider.highlightForBarcode';
  static const String annotationForBarcodeEvent = 'BarcodeCheckAnnotationProvider.annotationForBarcode';

  static const String didTapPopoverEvent = 'BarcodeCheckPopoverAnnotationListener.didTapPopover';
  static const String didTapPopoverButtonEvent = 'BarcodeCheckPopoverAnnotationListener.didTapPopoverButton';
  static const String didTapInfoAnnotationRightIconEvent =
      'BarcodeCheckInfoAnnotationListener.didTapInfoAnnotationRightIcon';
  static const String didTapInfoAnnotationLeftIconEvent =
      'BarcodeCheckInfoAnnotationListener.didTapInfoAnnotationLeftIcon';
  static const String didTapInfoAnnotationEvent = 'BarcodeCheckInfoAnnotationListener.didTapInfoAnnotation';
  static const String didTapInfoAnnotationHeaderEvent = 'BarcodeCheckInfoAnnotationListener.didTapInfoAnnotationHeader';
  static const String didTapInfoAnnotationFooterEvent = 'BarcodeCheckInfoAnnotationListener.didTapInfoAnnotationFooter';

  static const String methodsChannelName = 'com.scandit.datacapture.barcode.check/method_channel';
}
