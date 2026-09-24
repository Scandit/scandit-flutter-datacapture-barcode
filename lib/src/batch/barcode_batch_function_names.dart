/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

abstract class BarcodeBatchFunctionNames {
  static const String getBarcodeBatchDefaults = 'getBarcodeBatchDefaults';
  static const String barcodeBatchFinishDidUpdateSession = 'barcodeBatchFinishDidUpdateSession';
  static const String addBarcodeBatchListener = 'addBarcodeBatchListener';
  static const String removeBarcodeBatchListener = 'removeBarcodeBatchListener';
  static const String setWidgetForTrackedBarcode = 'setWidgetForTrackedBarcode';
  static const String setAnchorForTrackedBarcode = 'setAnchorForTrackedBarcode';
  static const String setOffsetForTrackedBarcode = 'setOffsetForTrackedBarcode';
  static const String clearTrackedBarcodeWidgets = 'clearTrackedBarcodeWidgets';
  static const String addBarcodeBatchAdvancedOverlayDelegate = 'addBarcodeBatchAdvancedOverlayDelegate';
  static const String removeBarcodeBatchAdvancedOverlayDelegate = 'removeBarcodeBatchAdvancedOverlayDelegate';
  static const String setBrushForTrackedBarcode = 'setBrushForTrackedBarcode';
  static const String clearTrackedBarcodeBrushes = 'clearTrackedBarcodeBrushes';
  static const String subscribeBTBasicOverlayListener = 'subscribeBarcodeBatchBasicOverlayListener';
  static const String unsubscribeBTBasicOverlayListener = 'unsubscribeBarcodeBatchBasicOverlayListener';
  static const String resetBarcodeBatchSession = 'resetBarcodeBatchSession';
  static const String getLastFrameData = 'getLastFrameData';
  static const String setModeEnabledState = 'setModeEnabledState';
  static const String updateBarcodeBatchMode = 'updateBarcodeBatchMode';
  static const String applyBarcodeBatchModeSettings = 'applyBarcodeBatchModeSettings';
  static const String updateBarcodeBatchBasicOverlay = 'updateBarcodeBatchBasicOverlay';
  static const String updateBarcodeBatchAdvancedOverlay = 'updateBarcodeBatchAdvancedOverlay';

  static const String methodsChannelName = 'com.scandit.datacapture.barcode.batch/method_channel';
}
