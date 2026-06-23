/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

abstract class BarcodeArFunctionNames {
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

  static const String didCreateBarcodeArCustomHighlight = 'BarcodeArCustomHighlight.create';
  static const String didUpdateBarcodeArCustomHighlight = 'BarcodeArCustomHighlight.update';
  static const String didDisposeBarcodeArCustomHighlight = 'BarcodeArCustomHighlight.dispose';
  static const String showBarcodeArCustomHighlight = 'BarcodeArCustomHighlight.show';
  static const String hideBarcodeArCustomHighlight = 'BarcodeArCustomHighlight.hide';

  static const String didCreateBarcodeArCustomAnnotation = 'BarcodeArCustomAnnotation.create';
  static const String didUpdateBarcodeArCustomAnnotation = 'BarcodeArCustomAnnotation.update';
  static const String didDisposeBarcodeArCustomAnnotation = 'BarcodeArCustomAnnotation.dispose';
  static const String showBarcodeArCustomAnnotation = 'BarcodeArCustomAnnotation.show';
  static const String hideBarcodeArCustomAnnotation = 'BarcodeArCustomAnnotation.hide';
}
