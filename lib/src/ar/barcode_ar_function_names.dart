/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

abstract class BarcodeArFunctionNames {
  static const String getDefaults = 'getBarcodeArDefaults';
  static const String updateFeedback = 'updateFeedback';
  static const String resetLatestBarcodeArSession = 'resetLatestBarcodeArSession';
  static const String applyBarcodeArModeSettings = 'applyBarcodeArModeSettings';
  static const String removeBarcodeArListener = 'removeBarcodeArListener';
  static const String addBarcodeArListener = 'addBarcodeArListener';
  static const String barcodeArFinishDidUpdateSession = 'barcodeArFinishDidUpdateSession';
  static const String getFrameData = 'getFrameData';
  static const String updateView = "updateView";
  static const String registerBarcodeArViewUiListener = 'registerBarcodeArViewUiListener';
  static const String unregisterBarcodeArViewUiListener = 'unregisterBarcodeArViewUiListener';
  static const String registerBarcodeArHighlightProvider = 'registerBarcodeArHighlightProvider';
  static const String unregisterBarcodeArHighlightProvider = 'unregisterBarcodeArHighlightProvider';
  static const String registerBarcodeArAnnotationProvider = 'registerBarcodeArAnnotationProvider';
  static const String unregisterBarcodeArAnnotationProvider = 'unregisterBarcodeArAnnotationProvider';
  static const String viewStart = 'viewStart';
  static const String viewStop = 'viewStop';
  static const String viewPause = 'viewPause';
  static const String viewReset = 'viewReset';
  static const String finishHighlightForBarcode = 'finishHighlightForBarcode';
  static const String finishAnnotationForBarcode = 'finishAnnotationForBarcode';
  static const String updateAnnotation = 'updateAnnotation';
  static const String updateHighlight = 'updateHighlight';
  static const String updateBarcodeArPopoverButtonAtIndex = 'updateBarcodeArPopoverButtonAtIndex';

  static const String highlightForBarcodeEvent = 'BarcodeArHighlightProvider.highlightForBarcode';
  static const String annotationForBarcodeEvent = 'BarcodeArAnnotationProvider.annotationForBarcode';

  static const String didTapPopoverEvent = 'BarcodeArPopoverAnnotationListener.didTapPopover';
  static const String didTapPopoverButtonEvent = 'BarcodeArPopoverAnnotationListener.didTapPopoverButton';
  static const String didTapInfoAnnotationRightIconEvent =
      'BarcodeArInfoAnnotationListener.didTapInfoAnnotationRightIcon';
  static const String didTapInfoAnnotationLeftIconEvent =
      'BarcodeArInfoAnnotationListener.didTapInfoAnnotationLeftIcon';
  static const String didTapInfoAnnotationEvent = 'BarcodeArInfoAnnotationListener.didTapInfoAnnotation';
  static const String didTapInfoAnnotationHeaderEvent = 'BarcodeArInfoAnnotationListener.didTapInfoAnnotationHeader';
  static const String didTapInfoAnnotationFooterEvent = 'BarcodeArInfoAnnotationListener.didTapInfoAnnotationFooter';

  static const String methodsChannelName = 'com.scandit.datacapture.barcode.ar/method_channel';
}
