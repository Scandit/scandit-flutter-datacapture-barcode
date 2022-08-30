/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

abstract class BarcodeTrackingFunctionNames {
  static const String getBarcodeTrackingDefaults = 'getBarcodeTrackingDefaults';
  static const String barcodeTrackingFinishDidUpdateSession = 'barcodeTrackingFinishDidUpdateSession';
  static const String addBarcodeTrackingListener = 'addBarcodeTrackingListener';
  static const String removeBarcodeTrackingListener = 'removeBarcodeTrackingListener';
  static const String setWidgetForTrackedBarcode = 'setWidgetForTrackedBarcode';
  static const String setAnchorForTrackedBarcode = 'setAnchorForTrackedBarcode';
  static const String setOffsetForTrackedBarcode = 'setOffsetForTrackedBarcode';
  static const String clearTrackedBarcodeWidgets = 'clearTrackedBarcodeWidgets';
  static const String addBarcodeTrackingAdvancedOverlayDelegate = 'addBarcodeTrackingAdvancedOverlayDelegate';
  static const String removeBarcodeTrackingAdvancedOverlayDelegate = 'removeBarcodeTrackingAdvancedOverlayDelegate';
  static const String setBrushForTrackedBarcode = 'setBrushForTrackedBarcode';
  static const String clearTrackedBarcodeBrushes = 'clearTrackedBarcodeBrushes';
  static const String subscribeBTBasicOverlayListener = 'subscribeBarcodeTrackingBasicOverlayListener';
  static const String unsubscribeBTBasicOverlayListener = 'unsubscribeBarcodeTrackingBasicOverlayListener';
  static const String finishBrushForTrackedBarcodeCallback = 'finishBrushForTrackedBarcodeCallback';
  static const String resetBarcodeTrackingSession = 'resetBarcodeTrackingSession';
  static const String getLastFrameData = 'getLastFrameData';
}
