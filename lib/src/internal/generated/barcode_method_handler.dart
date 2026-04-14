/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

// THIS FILE IS GENERATED. DO NOT EDIT MANUALLY.
// Generator: scripts/bridge_generator/generate.py
// Schema: scripts/bridge_generator/schemas/barcode.json

import 'package:flutter/services.dart';

/// Generated Barcode method handler for Flutter.
/// Routes all Barcode method calls through a single executeBarcode entry point.
class BarcodeMethodHandler {
  final MethodChannel _methodChannel;

  BarcodeMethodHandler(this._methodChannel);

  /// Single entry point for all Barcode operations.
  /// Routes to appropriate native command based on moduleName and methodName.
  Future<dynamic> executeBarcode(String moduleName, String methodName, Map<String, dynamic> params) async {
    final arguments = {'moduleName': moduleName, 'methodName': methodName, ...params};
    return await _methodChannel.invokeMethod('executeBarcode', arguments);
  }

  /// Creates a new barcode generator instance
  Future<void> createBarcodeGenerator({required String barcodeGeneratorJson}) async {
    final params = {'barcodeGeneratorJson': barcodeGeneratorJson};
    return await executeBarcode('BarcodeGeneratorModule', 'createBarcodeGenerator', params);
  }

  /// Generates a barcode image from base64 encoded data
  Future<String> generateFromBaseEncodedData({
    required String generatorId,
    required String data,
    required int imageWidth,
  }) async {
    final params = {'generatorId': generatorId, 'data': data, 'imageWidth': imageWidth};
    final result = await executeBarcode('BarcodeGeneratorModule', 'generateFromBase64EncodedData', params);
    return result;
  }

  /// Generates a barcode image from a text string
  Future<String> generateFromString({
    required String generatorId,
    required String text,
    required int imageWidth,
  }) async {
    final params = {'generatorId': generatorId, 'text': text, 'imageWidth': imageWidth};
    final result = await executeBarcode('BarcodeGeneratorModule', 'generateFromString', params);
    return result;
  }

  /// Generates a barcode image from byte array data and returns raw bytes
  Future<Uint8List?> generateFromBaseEncodedDataToBytes({
    required String generatorId,
    required Uint8List data,
    required int imageWidth,
  }) async {
    final params = {'generatorId': generatorId, 'data': data, 'imageWidth': imageWidth};
    final result = await executeBarcode('BarcodeGeneratorModule', 'generateFromBase64EncodedDataToBytes', params);
    if (result == null) return null;
    return result as Uint8List;
  }

  /// Generates a barcode image from a text string and returns raw bytes
  Future<Uint8List?> generateFromStringToBytes({
    required String generatorId,
    required String text,
    required int imageWidth,
  }) async {
    final params = {'generatorId': generatorId, 'text': text, 'imageWidth': imageWidth};
    final result = await executeBarcode('BarcodeGeneratorModule', 'generateFromStringToBytes', params);
    if (result == null) return null;
    return result as Uint8List;
  }

  /// Disposes the barcode generator and releases resources
  Future<void> disposeBarcodeGenerator({required String generatorId}) async {
    final params = {'generatorId': generatorId};
    return await executeBarcode('BarcodeGeneratorModule', 'disposeBarcodeGenerator', params);
  }

  /// Resets the barcode capture session
  Future<void> resetBarcodeCaptureSession() async {
    return await executeBarcode('BarcodeCaptureModule', 'resetBarcodeCaptureSession', {});
  }

  /// Register persistent event listener for barcode capture events
  Future<void> registerBarcodeCaptureListenerForEvents({required int modeId}) async {
    final params = {'modeId': modeId};
    return await executeBarcode('BarcodeCaptureModule', 'registerBarcodeCaptureListenerForEvents', params);
  }

  /// Unregister event listener for barcode capture events
  Future<void> unregisterBarcodeCaptureListenerForEvents({required int modeId}) async {
    final params = {'modeId': modeId};
    return await executeBarcode('BarcodeCaptureModule', 'unregisterBarcodeCaptureListenerForEvents', params);
  }

  /// Finish callback for barcode capture did update session event
  Future<void> finishBarcodeCaptureDidUpdateSession({required int modeId, required bool enabled}) async {
    final params = {'modeId': modeId, 'enabled': enabled};
    return await executeBarcode('BarcodeCaptureModule', 'finishBarcodeCaptureDidUpdateSession', params);
  }

  /// Finish callback for barcode capture did scan event
  Future<void> finishBarcodeCaptureDidScan({required int modeId, required bool enabled}) async {
    final params = {'modeId': modeId, 'enabled': enabled};
    return await executeBarcode('BarcodeCaptureModule', 'finishBarcodeCaptureDidScan', params);
  }

  /// Sets the enabled state of the barcode capture mode
  Future<void> setBarcodeCaptureModeEnabledState({required int modeId, required bool enabled}) async {
    final params = {'modeId': modeId, 'enabled': enabled};
    return await executeBarcode('BarcodeCaptureModule', 'setBarcodeCaptureModeEnabledState', params);
  }

  /// Updates the barcode capture mode configuration
  Future<void> updateBarcodeCaptureMode({required String modeJson}) async {
    final params = {'modeJson': modeJson};
    return await executeBarcode('BarcodeCaptureModule', 'updateBarcodeCaptureMode', params);
  }

  /// Applies new settings to the barcode capture mode
  Future<void> applyBarcodeCaptureModeSettings({required int modeId, required String modeSettingsJson}) async {
    final params = {'modeId': modeId, 'modeSettingsJson': modeSettingsJson};
    return await executeBarcode('BarcodeCaptureModule', 'applyBarcodeCaptureModeSettings', params);
  }

  /// Updates the barcode capture overlay configuration
  Future<void> updateBarcodeCaptureOverlay({required int viewId, required String overlayJson}) async {
    final params = {'viewId': viewId, 'overlayJson': overlayJson};
    return await executeBarcode('BarcodeCaptureModule', 'updateBarcodeCaptureOverlay', params);
  }

  /// Updates the barcode capture feedback configuration
  Future<void> updateBarcodeCaptureFeedback({required int modeId, required String feedbackJson}) async {
    final params = {'modeId': modeId, 'feedbackJson': feedbackJson};
    return await executeBarcode('BarcodeCaptureModule', 'updateBarcodeCaptureFeedback', params);
  }

  /// Unfreezes the camera in barcode selection mode
  Future<void> unfreezeCameraInBarcodeSelection({required int modeId}) async {
    final params = {'modeId': modeId};
    return await executeBarcode('BarcodeSelectionModule', 'unfreezeCameraInBarcodeSelection', params);
  }

  /// Resets the barcode selection
  Future<void> resetBarcodeSelection({required int modeId}) async {
    final params = {'modeId': modeId};
    return await executeBarcode('BarcodeSelectionModule', 'resetBarcodeSelection', params);
  }

  /// Selects the aimed barcode
  Future<void> selectAimedBarcode({required int modeId}) async {
    final params = {'modeId': modeId};
    return await executeBarcode('BarcodeSelectionModule', 'selectAimedBarcode', params);
  }

  /// Unselects specified barcodes
  Future<void> unselectBarcodes({required int modeId, required String barcodesJson}) async {
    final params = {'modeId': modeId, 'barcodesJson': barcodesJson};
    return await executeBarcode('BarcodeSelectionModule', 'unselectBarcodes', params);
  }

  /// Sets whether a barcode can be selected
  Future<void> setSelectBarcodeEnabled({
    required int modeId,
    required String barcodeJson,
    required bool enabled,
  }) async {
    final params = {'modeId': modeId, 'barcodeJson': barcodeJson, 'enabled': enabled};
    return await executeBarcode('BarcodeSelectionModule', 'setSelectBarcodeEnabled', params);
  }

  /// Increases the count for specified barcodes
  Future<void> increaseCountForBarcodes({required int modeId, required String barcodeJson}) async {
    final params = {'modeId': modeId, 'barcodeJson': barcodeJson};
    return await executeBarcode('BarcodeSelectionModule', 'increaseCountForBarcodes', params);
  }

  /// Sets the enabled state of the barcode selection mode
  Future<void> setBarcodeSelectionModeEnabledState({required int modeId, required bool enabled}) async {
    final params = {'modeId': modeId, 'enabled': enabled};
    return await executeBarcode('BarcodeSelectionModule', 'setBarcodeSelectionModeEnabledState', params);
  }

  /// Updates the barcode selection mode configuration
  Future<void> updateBarcodeSelectionMode({required int modeId, required String modeJson}) async {
    final params = {'modeId': modeId, 'modeJson': modeJson};
    return await executeBarcode('BarcodeSelectionModule', 'updateBarcodeSelectionMode', params);
  }

  /// Applies new settings to the barcode selection mode
  Future<void> applyBarcodeSelectionModeSettings({required int modeId, required String modeSettingsJson}) async {
    final params = {'modeId': modeId, 'modeSettingsJson': modeSettingsJson};
    return await executeBarcode('BarcodeSelectionModule', 'applyBarcodeSelectionModeSettings', params);
  }

  /// Updates the barcode selection feedback configuration
  Future<void> updateBarcodeSelectionFeedback({required int modeId, required String feedbackJson}) async {
    final params = {'modeId': modeId, 'feedbackJson': feedbackJson};
    return await executeBarcode('BarcodeSelectionModule', 'updateBarcodeSelectionFeedback', params);
  }

  /// Gets the count for a barcode in the selection session
  Future<num> getCountForBarcodeInBarcodeSelectionSession({
    required int modeId,
    required String selectionIdentifier,
  }) async {
    final params = {'modeId': modeId, 'selectionIdentifier': selectionIdentifier};
    final result = await executeBarcode(
      'BarcodeSelectionModule',
      'getCountForBarcodeInBarcodeSelectionSession',
      params,
    );
    return result as num;
  }

  /// Resets the barcode selection session
  Future<void> resetBarcodeSelectionSession({required int modeId}) async {
    final params = {'modeId': modeId};
    return await executeBarcode('BarcodeSelectionModule', 'resetBarcodeSelectionSession', params);
  }

  /// Finish callback for barcode selection did select event
  Future<void> finishBarcodeSelectionDidSelect({required int modeId, required bool enabled}) async {
    final params = {'modeId': modeId, 'enabled': enabled};
    return await executeBarcode('BarcodeSelectionModule', 'finishBarcodeSelectionDidSelect', params);
  }

  /// Finish callback for barcode selection did update session event
  Future<void> finishBarcodeSelectionDidUpdateSession({required int modeId, required bool enabled}) async {
    final params = {'modeId': modeId, 'enabled': enabled};
    return await executeBarcode('BarcodeSelectionModule', 'finishBarcodeSelectionDidUpdateSession', params);
  }

  /// Register persistent event listener for barcode selection events
  Future<void> registerBarcodeSelectionListenerForEvents({required int modeId}) async {
    final params = {'modeId': modeId};
    return await executeBarcode('BarcodeSelectionModule', 'registerBarcodeSelectionListenerForEvents', params);
  }

  /// Unregister event listener for barcode selection events
  Future<void> unregisterBarcodeSelectionListenerForEvents({required int modeId}) async {
    final params = {'modeId': modeId};
    return await executeBarcode('BarcodeSelectionModule', 'unregisterBarcodeSelectionListenerForEvents', params);
  }

  /// Sets the text for aim to select auto hint
  Future<void> setTextForAimToSelectAutoHint({required String text}) async {
    final params = {'text': text};
    return await executeBarcode('BarcodeSelectionModule', 'setTextForAimToSelectAutoHint', params);
  }

  /// Removes the aimed barcode brush provider
  Future<void> removeAimedBarcodeBrushProvider() async {
    return await executeBarcode('BarcodeSelectionModule', 'removeAimedBarcodeBrushProvider', {});
  }

  /// Sets the aimed barcode brush provider
  Future<void> setAimedBarcodeBrushProvider() async {
    return await executeBarcode('BarcodeSelectionModule', 'setAimedBarcodeBrushProvider', {});
  }

  /// Finish callback for aimed barcode brush
  Future<void> finishBrushForAimedBarcodeCallback({required String selectionIdentifier, String? brushJson}) async {
    final params = {'selectionIdentifier': selectionIdentifier, if (brushJson != null) 'brushJson': brushJson};
    return await executeBarcode('BarcodeSelectionModule', 'finishBrushForAimedBarcodeCallback', params);
  }

  /// Removes the tracked barcode brush provider
  Future<void> removeTrackedBarcodeBrushProvider() async {
    return await executeBarcode('BarcodeSelectionModule', 'removeTrackedBarcodeBrushProvider', {});
  }

  /// Sets the tracked barcode brush provider
  Future<void> setTrackedBarcodeBrushProvider() async {
    return await executeBarcode('BarcodeSelectionModule', 'setTrackedBarcodeBrushProvider', {});
  }

  /// Finish callback for tracked barcode brush
  Future<void> finishBrushForTrackedBarcodeCallback({required String selectionIdentifier, String? brushJson}) async {
    final params = {'selectionIdentifier': selectionIdentifier, if (brushJson != null) 'brushJson': brushJson};
    return await executeBarcode('BarcodeSelectionModule', 'finishBrushForTrackedBarcodeCallback', params);
  }

  /// Updates the barcode selection basic overlay configuration
  Future<void> updateBarcodeSelectionBasicOverlay({required String overlayJson}) async {
    final params = {'overlayJson': overlayJson};
    return await executeBarcode('BarcodeSelectionModule', 'updateBarcodeSelectionBasicOverlay', params);
  }

  /// Resets the barcode batch session
  Future<void> resetBarcodeBatchSession() async {
    return await executeBarcode('BarcodeBatchModule', 'resetBarcodeBatchSession', {});
  }

  /// Register persistent event listener for barcode batch events
  Future<void> registerBarcodeBatchListenerForEvents({required int modeId}) async {
    final params = {'modeId': modeId};
    return await executeBarcode('BarcodeBatchModule', 'registerBarcodeBatchListenerForEvents', params);
  }

  /// Unregister event listener for barcode batch events
  Future<void> unregisterBarcodeBatchListenerForEvents({required int modeId}) async {
    final params = {'modeId': modeId};
    return await executeBarcode('BarcodeBatchModule', 'unregisterBarcodeBatchListenerForEvents', params);
  }

  /// Finish callback for barcode batch did update session event
  Future<void> finishBarcodeBatchDidUpdateSessionCallback({required int modeId, required bool enabled}) async {
    final params = {'modeId': modeId, 'enabled': enabled};
    return await executeBarcode('BarcodeBatchModule', 'finishBarcodeBatchDidUpdateSessionCallback', params);
  }

  /// Sets the enabled state of the barcode batch mode
  Future<void> setBarcodeBatchModeEnabledState({required int modeId, required bool enabled}) async {
    final params = {'modeId': modeId, 'enabled': enabled};
    return await executeBarcode('BarcodeBatchModule', 'setBarcodeBatchModeEnabledState', params);
  }

  /// Updates the barcode batch mode configuration
  Future<void> updateBarcodeBatchMode({required String modeJson}) async {
    final params = {'modeJson': modeJson};
    return await executeBarcode('BarcodeBatchModule', 'updateBarcodeBatchMode', params);
  }

  /// Applies new settings to the barcode batch mode
  Future<void> applyBarcodeBatchModeSettings({required int modeId, required String modeSettingsJson}) async {
    final params = {'modeId': modeId, 'modeSettingsJson': modeSettingsJson};
    return await executeBarcode('BarcodeBatchModule', 'applyBarcodeBatchModeSettings', params);
  }

  /// Sets the brush for a tracked barcode in basic overlay
  Future<void> setBrushForTrackedBarcode({
    required int dataCaptureViewId,
    String? brushJson,
    required int trackedBarcodeIdentifier,
  }) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      if (brushJson != null) 'brushJson': brushJson,
      'trackedBarcodeIdentifier': trackedBarcodeIdentifier,
    };
    return await executeBarcode('BarcodeBatchModule', 'setBrushForTrackedBarcode', params);
  }

  /// Clears all tracked barcode brushes in basic overlay
  Future<void> clearTrackedBarcodeBrushes({required int dataCaptureViewId}) async {
    final params = {'dataCaptureViewId': dataCaptureViewId};
    return await executeBarcode('BarcodeBatchModule', 'clearTrackedBarcodeBrushes', params);
  }

  /// Register persistent event listener for barcode batch basic overlay events
  Future<void> registerListenerForBasicOverlayEvents({required int dataCaptureViewId}) async {
    final params = {'dataCaptureViewId': dataCaptureViewId};
    return await executeBarcode('BarcodeBatchModule', 'registerListenerForBasicOverlayEvents', params);
  }

  /// Unregister event listener for barcode batch basic overlay events
  Future<void> unregisterListenerForBasicOverlayEvents({required int dataCaptureViewId}) async {
    final params = {'dataCaptureViewId': dataCaptureViewId};
    return await executeBarcode('BarcodeBatchModule', 'unregisterListenerForBasicOverlayEvents', params);
  }

  /// Updates the barcode batch basic overlay configuration
  Future<void> updateBarcodeBatchBasicOverlay({required int dataCaptureViewId, required String overlayJson}) async {
    final params = {'dataCaptureViewId': dataCaptureViewId, 'overlayJson': overlayJson};
    return await executeBarcode('BarcodeBatchModule', 'updateBarcodeBatchBasicOverlay', params);
  }

  /// Sets the view for a tracked barcode in advanced overlay using byte array
  Future<void> setViewForTrackedBarcodeFromBytes({
    required int dataCaptureViewId,
    Uint8List? viewBytes,
    required int trackedBarcodeIdentifier,
  }) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      if (viewBytes != null) 'viewBytes': viewBytes,
      'trackedBarcodeIdentifier': trackedBarcodeIdentifier,
    };
    return await executeBarcode('BarcodeBatchModule', 'setViewForTrackedBarcodeFromBytes', params);
  }

  /// Updates the size of a tracked barcode view in advanced overlay
  Future<void> updateSizeOfTrackedBarcodeView({
    required int trackedBarcodeIdentifier,
    required int width,
    required int height,
  }) async {
    final params = {'trackedBarcodeIdentifier': trackedBarcodeIdentifier, 'width': width, 'height': height};
    return await executeBarcode('BarcodeBatchModule', 'updateSizeOfTrackedBarcodeView', params);
  }

  /// Sets the anchor for a tracked barcode in advanced overlay
  Future<void> setAnchorForTrackedBarcode({
    required int dataCaptureViewId,
    required String anchorJson,
    required int trackedBarcodeIdentifier,
  }) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      'anchorJson': anchorJson,
      'trackedBarcodeIdentifier': trackedBarcodeIdentifier,
    };
    return await executeBarcode('BarcodeBatchModule', 'setAnchorForTrackedBarcode', params);
  }

  /// Sets the offset for a tracked barcode in advanced overlay
  Future<void> setOffsetForTrackedBarcode({
    required int dataCaptureViewId,
    required String offsetJson,
    required int trackedBarcodeIdentifier,
  }) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      'offsetJson': offsetJson,
      'trackedBarcodeIdentifier': trackedBarcodeIdentifier,
    };
    return await executeBarcode('BarcodeBatchModule', 'setOffsetForTrackedBarcode', params);
  }

  /// Clears all tracked barcode views in advanced overlay
  Future<void> clearTrackedBarcodeViews({required int dataCaptureViewId}) async {
    final params = {'dataCaptureViewId': dataCaptureViewId};
    return await executeBarcode('BarcodeBatchModule', 'clearTrackedBarcodeViews', params);
  }

  /// Register persistent event listener for barcode batch advanced overlay events
  Future<void> registerListenerForAdvancedOverlayEvents({required int dataCaptureViewId}) async {
    final params = {'dataCaptureViewId': dataCaptureViewId};
    return await executeBarcode('BarcodeBatchModule', 'registerListenerForAdvancedOverlayEvents', params);
  }

  /// Unregister event listener for barcode batch advanced overlay events
  Future<void> unregisterListenerForAdvancedOverlayEvents({required int dataCaptureViewId}) async {
    final params = {'dataCaptureViewId': dataCaptureViewId};
    return await executeBarcode('BarcodeBatchModule', 'unregisterListenerForAdvancedOverlayEvents', params);
  }

  /// Updates the barcode batch advanced overlay configuration
  Future<void> updateBarcodeBatchAdvancedOverlay({required int dataCaptureViewId, required String overlayJson}) async {
    final params = {'dataCaptureViewId': dataCaptureViewId, 'overlayJson': overlayJson};
    return await executeBarcode('BarcodeBatchModule', 'updateBarcodeBatchAdvancedOverlay', params);
  }

  /// Updates the BarcodeCount view configuration
  Future<void> updateBarcodeCountView({required int viewId, required String viewJson}) async {
    final params = {'viewId': viewId, 'viewJson': viewJson};
    return await executeBarcode('BarcodeCountModule', 'updateBarcodeCountView', params);
  }

  /// Register persistent event listener for BarcodeCount view events
  Future<void> registerBarcodeCountViewListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'registerBarcodeCountViewListener', params);
  }

  /// Unregister event listener for BarcodeCount view events
  Future<void> unregisterBarcodeCountViewListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'unregisterBarcodeCountViewListener', params);
  }

  /// Register persistent event listener for BarcodeCount view UI events
  Future<void> registerBarcodeCountViewUiListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'registerBarcodeCountViewUiListener', params);
  }

  /// Unregister event listener for BarcodeCount view UI events
  Future<void> unregisterBarcodeCountViewUiListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'unregisterBarcodeCountViewUiListener', params);
  }

  /// Clears all barcode highlights in the BarcodeCount view
  Future<void> clearBarcodeCountHighlights({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'clearBarcodeCountHighlights', params);
  }

  /// Finish callback for recognized barcode brush
  Future<void> finishBarcodeCountBrushForRecognizedBarcode({
    required int viewId,
    String? brushJson,
    required int trackedBarcodeId,
  }) async {
    final params = {
      'viewId': viewId,
      if (brushJson != null) 'brushJson': brushJson,
      'trackedBarcodeId': trackedBarcodeId,
    };
    return await executeBarcode('BarcodeCountModule', 'finishBarcodeCountBrushForRecognizedBarcode', params);
  }

  /// Finish callback for recognized barcode not in list brush
  Future<void> finishBarcodeCountBrushForRecognizedBarcodeNotInList({
    required int viewId,
    String? brushJson,
    required int trackedBarcodeId,
  }) async {
    final params = {
      'viewId': viewId,
      if (brushJson != null) 'brushJson': brushJson,
      'trackedBarcodeId': trackedBarcodeId,
    };
    return await executeBarcode('BarcodeCountModule', 'finishBarcodeCountBrushForRecognizedBarcodeNotInList', params);
  }

  /// Finish callback for accepted barcode brush
  Future<void> finishBarcodeCountBrushForAcceptedBarcode({
    required int viewId,
    String? brushJson,
    required int trackedBarcodeId,
  }) async {
    final params = {
      'viewId': viewId,
      if (brushJson != null) 'brushJson': brushJson,
      'trackedBarcodeId': trackedBarcodeId,
    };
    return await executeBarcode('BarcodeCountModule', 'finishBarcodeCountBrushForAcceptedBarcode', params);
  }

  /// Finish callback for rejected barcode brush
  Future<void> finishBarcodeCountBrushForRejectedBarcode({
    required int viewId,
    String? brushJson,
    required int trackedBarcodeId,
  }) async {
    final params = {
      'viewId': viewId,
      if (brushJson != null) 'brushJson': brushJson,
      'trackedBarcodeId': trackedBarcodeId,
    };
    return await executeBarcode('BarcodeCountModule', 'finishBarcodeCountBrushForRejectedBarcode', params);
  }

  /// Shows the BarcodeCount view
  Future<void> showBarcodeCountView({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'showBarcodeCountView', params);
  }

  /// Hides the BarcodeCount view
  Future<void> hideBarcodeCountView({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'hideBarcodeCountView', params);
  }

  /// Enables hardware trigger for BarcodeCount
  Future<void> enableBarcodeCountHardwareTrigger({required int viewId, int? hardwareTriggerKeyCode}) async {
    final params = {
      'viewId': viewId,
      if (hardwareTriggerKeyCode != null) 'hardwareTriggerKeyCode': hardwareTriggerKeyCode,
    };
    return await executeBarcode('BarcodeCountModule', 'enableBarcodeCountHardwareTrigger', params);
  }

  /// Updates the BarcodeCount mode configuration
  Future<void> updateBarcodeCountMode({required int viewId, required String barcodeCountJson}) async {
    final params = {'viewId': viewId, 'barcodeCountJson': barcodeCountJson};
    return await executeBarcode('BarcodeCountModule', 'updateBarcodeCountMode', params);
  }

  /// Resets the BarcodeCount mode
  Future<void> resetBarcodeCount({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'resetBarcodeCount', params);
  }

  /// Register persistent event listener for BarcodeCount mode events
  Future<void> registerBarcodeCountListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'registerBarcodeCountListener', params);
  }

  /// Register persistent event listener for BarcodeCount mode events
  Future<void> registerBarcodeCountAsyncListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'registerBarcodeCountAsyncListener', params);
  }

  /// Unregister event listener for BarcodeCount mode events
  Future<void> unregisterBarcodeCountListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'unregisterBarcodeCountListener', params);
  }

  /// Unregister event listener for BarcodeCount mode events
  Future<void> unregisterBarcodeCountAsyncListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'unregisterBarcodeCountAsyncListener', params);
  }

  /// Finish callback for BarcodeCount on scan event
  Future<void> finishBarcodeCountOnScan({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'finishBarcodeCountOnScan', params);
  }

  /// Finish callback for BarcodeCount on session updated event
  Future<void> finishBarcodeCountOnSessionUpdated({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'finishBarcodeCountOnSessionUpdated', params);
  }

  /// Starts the BarcodeCount scanning phase
  Future<void> startBarcodeCountScanningPhase({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'startBarcodeCountScanningPhase', params);
  }

  /// Ends the BarcodeCount scanning phase
  Future<void> endBarcodeCountScanningPhase({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'endBarcodeCountScanningPhase', params);
  }

  /// Sets the capture list for BarcodeCount
  Future<void> setBarcodeCountCaptureList({
    required int viewId,
    required String captureListJson,
    required bool hasTransformer,
  }) async {
    final params = {'viewId': viewId, 'captureListJson': captureListJson, 'hasTransformer': hasTransformer};
    return await executeBarcode('BarcodeCountModule', 'setBarcodeCountCaptureList', params);
  }

  /// Submits the barcode data transformer result for BarcodeCount
  Future<void> submitBarcodeDataTransformerResult({required int viewId, String? transformedData}) async {
    final params = {'viewId': viewId, if (transformedData != null) 'transformedData': transformedData};
    return await executeBarcode('BarcodeCountModule', 'submitBarcodeDataTransformerResult', params);
  }

  /// Sets the enabled state of the BarcodeCount mode
  Future<void> setBarcodeCountModeEnabledState({required int viewId, required bool isEnabled}) async {
    final params = {'viewId': viewId, 'isEnabled': isEnabled};
    return await executeBarcode('BarcodeCountModule', 'setBarcodeCountModeEnabledState', params);
  }

  /// Updates the BarcodeCount feedback configuration
  Future<void> updateBarcodeCountFeedback({required int viewId, required String feedbackJson}) async {
    final params = {'viewId': viewId, 'feedbackJson': feedbackJson};
    return await executeBarcode('BarcodeCountModule', 'updateBarcodeCountFeedback', params);
  }

  /// Resets the BarcodeCount session
  Future<void> resetBarcodeCountSession({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'resetBarcodeCountSession', params);
  }

  /// Gets the BarcodeCount spatial map
  Future<Map<String, dynamic>?> getBarcodeCountSpatialMap({required int viewId}) async {
    final params = {'viewId': viewId};
    final result = await executeBarcode('BarcodeCountModule', 'getBarcodeCountSpatialMap', params);
    if (result == null) return null;
    return (result as Map).cast<String, dynamic>();
  }

  /// Gets the BarcodeCount spatial map with hints for expected grid dimensions
  Future<Map<String, dynamic>?> getBarcodeCountSpatialMapWithHints({
    required int viewId,
    required int expectedNumberOfRows,
    required int expectedNumberOfColumns,
  }) async {
    final params = {
      'viewId': viewId,
      'expectedNumberOfRows': expectedNumberOfRows,
      'expectedNumberOfColumns': expectedNumberOfColumns,
    };
    final result = await executeBarcode('BarcodeCountModule', 'getBarcodeCountSpatialMapWithHints', params);
    if (result == null) return null;
    return (result as Map).cast<String, dynamic>();
  }

  /// Adds a barcode count status provider
  Future<void> addBarcodeCountStatusProvider({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeCountModule', 'addBarcodeCountStatusProvider', params);
  }

  /// Submits the barcode count status provider callback
  Future<void> submitBarcodeCountStatusProviderCallback({required int viewId, required String statusJson}) async {
    final params = {'viewId': viewId, 'statusJson': statusJson};
    return await executeBarcode('BarcodeCountModule', 'submitBarcodeCountStatusProviderCallback', params);
  }

  /// Updates the SparkScan view configuration
  Future<void> updateSparkScanView({required int viewId, required String viewJson}) async {
    final params = {'viewId': viewId, 'viewJson': viewJson};
    return await executeBarcode('SparkScanModule', 'updateSparkScanView', params);
  }

  /// Shows the SparkScan view
  Future<void> showSparkScanView({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'showSparkScanView', params);
  }

  /// Brings the SparkScan view to the front
  Future<void> bringSparkScanViewToFront({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'bringSparkScanViewToFront', params);
  }

  /// Hides the SparkScan view
  Future<void> hideSparkScanView({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'hideSparkScanView', params);
  }

  /// Disposes the SparkScan view
  Future<void> disposeSparkScanView({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'disposeSparkScanView', params);
  }

  /// Shows a toast message in the SparkScan view
  Future<void> showSparkScanViewToast({required int viewId, required String text}) async {
    final params = {'viewId': viewId, 'text': text};
    return await executeBarcode('SparkScanModule', 'showSparkScanViewToast', params);
  }

  /// Stops scanning in the SparkScan view
  Future<void> stopSparkScanViewScanning({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'stopSparkScanViewScanning', params);
  }

  /// Handles host pause event for SparkScan view
  Future<void> onHostPauseSparkScanView({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'onHostPauseSparkScanView', params);
  }

  /// Starts scanning in the SparkScan view
  Future<void> startSparkScanViewScanning({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'startSparkScanViewScanning', params);
  }

  /// Pauses scanning in the SparkScan view
  Future<void> pauseSparkScanViewScanning({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'pauseSparkScanViewScanning', params);
  }

  /// Prepares the SparkScan view for scanning
  Future<void> prepareSparkScanViewScanning({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'prepareSparkScanViewScanning', params);
  }

  /// Register persistent event listener for SparkScan feedback delegate events
  Future<void> registerSparkScanFeedbackDelegateForEvents({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'registerSparkScanFeedbackDelegateForEvents', params);
  }

  /// Unregister event listener for SparkScan feedback delegate events
  Future<void> unregisterSparkScanFeedbackDelegateForEvents({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'unregisterSparkScanFeedbackDelegateForEvents', params);
  }

  /// Submits feedback for a scanned barcode
  Future<void> submitSparkScanFeedbackForBarcode({required int viewId, String? feedbackJson}) async {
    final params = {'viewId': viewId, if (feedbackJson != null) 'feedbackJson': feedbackJson};
    return await executeBarcode('SparkScanModule', 'submitSparkScanFeedbackForBarcode', params);
  }

  /// Submits feedback for a scanned item
  Future<void> submitSparkScanFeedbackForScannedItem({required int viewId, String? feedbackJson}) async {
    final params = {'viewId': viewId, if (feedbackJson != null) 'feedbackJson': feedbackJson};
    return await executeBarcode('SparkScanModule', 'submitSparkScanFeedbackForScannedItem', params);
  }

  /// Register persistent event listener for SparkScan view events
  Future<void> registerSparkScanViewListenerEvents({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'registerSparkScanViewListenerEvents', params);
  }

  /// Unregister event listener for SparkScan view events
  Future<void> unregisterSparkScanViewListenerEvents({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'unregisterSparkScanViewListenerEvents', params);
  }

  /// Resets the SparkScan session
  Future<void> resetSparkScanSession({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'resetSparkScanSession', params);
  }

  /// Updates the SparkScan mode configuration
  Future<void> updateSparkScanMode({required int viewId, required String modeJson}) async {
    final params = {'viewId': viewId, 'modeJson': modeJson};
    return await executeBarcode('SparkScanModule', 'updateSparkScanMode', params);
  }

  /// Register persistent event listener for SparkScan mode events
  Future<void> registerSparkScanListenerForEvents({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'registerSparkScanListenerForEvents', params);
  }

  /// Unregister event listener for SparkScan mode events
  Future<void> unregisterSparkScanListenerForEvents({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('SparkScanModule', 'unregisterSparkScanListenerForEvents', params);
  }

  /// Finish callback for SparkScan did update session event
  Future<void> finishSparkScanDidUpdateSession({required int viewId, required bool isEnabled}) async {
    final params = {'viewId': viewId, 'isEnabled': isEnabled};
    return await executeBarcode('SparkScanModule', 'finishSparkScanDidUpdateSession', params);
  }

  /// Finish callback for SparkScan did scan event
  Future<void> finishSparkScanDidScan({required int viewId, required bool isEnabled}) async {
    final params = {'viewId': viewId, 'isEnabled': isEnabled};
    return await executeBarcode('SparkScanModule', 'finishSparkScanDidScan', params);
  }

  /// Sets the enabled state of the SparkScan mode
  Future<void> setSparkScanModeEnabledState({required int viewId, required bool isEnabled}) async {
    final params = {'viewId': viewId, 'isEnabled': isEnabled};
    return await executeBarcode('SparkScanModule', 'setSparkScanModeEnabledState', params);
  }

  /// Starts the BarcodePick view scanning
  Future<void> pickViewStart({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'pickViewStart', params);
  }

  /// Freezes the BarcodePick view scanning
  Future<void> pickViewFreeze({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'pickViewFreeze', params);
  }

  /// Stops the BarcodePick view scanning
  Future<void> pickViewStop({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'pickViewStop', params);
  }

  /// Resets the BarcodePick view
  Future<void> pickViewReset({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'pickViewReset', params);
  }

  /// Pauses the BarcodePick view scanning
  Future<void> pickViewPause({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'pickViewPause', params);
  }

  /// Resumes the BarcodePick view scanning
  Future<void> pickViewResume({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'pickViewResume', params);
  }

  /// Finish callback for pick action
  Future<void> finishPickAction({required int viewId, required String itemData, required bool actionResult}) async {
    final params = {'viewId': viewId, 'itemData': itemData, 'actionResult': actionResult};
    return await executeBarcode('BarcodePickModule', 'finishPickAction', params);
  }

  /// Updates the BarcodePick view configuration
  Future<void> updatePickView({required int viewId, required String json}) async {
    final params = {'viewId': viewId, 'json': json};
    return await executeBarcode('BarcodePickModule', 'updatePickView', params);
  }

  /// Register persistent event listener for BarcodePick mode events
  Future<void> addBarcodePickListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'addBarcodePickListener', params);
  }

  /// Unregister event listener for BarcodePick mode events
  Future<void> removeBarcodePickListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'removeBarcodePickListener', params);
  }

  /// Register persistent event listener for BarcodePick scanning events
  Future<void> addBarcodePickScanningListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'addBarcodePickScanningListener', params);
  }

  /// Unregister event listener for BarcodePick scanning events
  Future<void> removeBarcodePickScanningListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'removeBarcodePickScanningListener', params);
  }

  /// Register persistent event listener for BarcodePick action events
  Future<void> addPickActionListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'addPickActionListener', params);
  }

  /// Unregister event listener for BarcodePick action events
  Future<void> removePickActionListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'removePickActionListener', params);
  }

  /// Register persistent event listener for BarcodePick view lifecycle events
  Future<void> addPickViewListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'addPickViewListener', params);
  }

  /// Unregister event listener for BarcodePick view lifecycle events
  Future<void> removePickViewListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'removePickViewListener', params);
  }

  /// Register persistent event listener for BarcodePick view UI events
  Future<void> registerBarcodePickViewUiListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'registerBarcodePickViewUiListener', params);
  }

  /// Unregister event listener for BarcodePick view UI events
  Future<void> unregisterBarcodePickViewUiListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'unregisterBarcodePickViewUiListener', params);
  }

  /// Register persistent event listener for product identifier provider events
  Future<void> registerOnProductIdentifierForItemsListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'registerOnProductIdentifierForItemsListener', params);
  }

  /// Unregister event listener for product identifier provider events
  Future<void> unregisterOnProductIdentifierForItemsListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'unregisterOnProductIdentifierForItemsListener', params);
  }

  /// Finish callback for product identifier for items
  Future<void> finishOnProductIdentifierForItems({required int viewId, required String itemsJson}) async {
    final params = {'viewId': viewId, 'itemsJson': itemsJson};
    return await executeBarcode('BarcodePickModule', 'finishOnProductIdentifierForItems', params);
  }

  /// Finish callback for barcode pick view highlight style custom view provider view for request
  Future<void> finishBarcodePickViewHighlightStyleCustomViewProviderViewForRequest({
    required int viewId,
    required int requestId,
    Map<String, dynamic>? response,
  }) async {
    final params = {'viewId': viewId, 'requestId': requestId, if (response != null) 'response': response};
    return await executeBarcode(
      'BarcodePickModule',
      'finishBarcodePickViewHighlightStyleCustomViewProviderViewForRequest',
      params,
    );
  }

  /// Finish callback for barcode pick view highlight style async provider style for request
  Future<void> finishBarcodePickViewHighlightStyleAsyncProviderStyleForRequest({
    required int viewId,
    required int requestId,
    String? responseJson,
  }) async {
    final params = {'viewId': viewId, 'requestId': requestId, if (responseJson != null) 'responseJson': responseJson};
    return await executeBarcode(
      'BarcodePickModule',
      'finishBarcodePickViewHighlightStyleAsyncProviderStyleForRequest',
      params,
    );
  }

  /// Release the BarcodePick view
  Future<void> pickViewRelease({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodePickModule', 'pickViewRelease', params);
  }

  /// Register persistent event listener for BarcodeFind view UI events
  Future<void> registerBarcodeFindViewListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'registerBarcodeFindViewListener', params);
  }

  /// Unregister event listener for BarcodeFind view UI events
  Future<void> unregisterBarcodeFindViewListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'unregisterBarcodeFindViewListener', params);
  }

  /// Updates the BarcodeFind view configuration
  Future<void> updateFindView({required int viewId, required String barcodeFindViewJson}) async {
    final params = {'viewId': viewId, 'barcodeFindViewJson': barcodeFindViewJson};
    return await executeBarcode('BarcodeFindModule', 'updateFindView', params);
  }

  /// Starts searching in the BarcodeFind view
  Future<void> barcodeFindViewStartSearching({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'barcodeFindViewStartSearching', params);
  }

  /// Stops searching in the BarcodeFind view
  Future<void> barcodeFindViewStopSearching({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'barcodeFindViewStopSearching', params);
  }

  /// Pauses searching in the BarcodeFind view
  Future<void> barcodeFindViewPauseSearching({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'barcodeFindViewPauseSearching', params);
  }

  /// Shows the BarcodeFind view
  Future<void> showFindView({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'showFindView', params);
  }

  /// Hides the BarcodeFind view
  Future<void> hideFindView({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'hideFindView', params);
  }

  /// Updates the BarcodeFind mode configuration
  Future<void> updateFindMode({required int viewId, required String barcodeFindJson}) async {
    final params = {'viewId': viewId, 'barcodeFindJson': barcodeFindJson};
    return await executeBarcode('BarcodeFindModule', 'updateFindMode', params);
  }

  /// Starts the BarcodeFind mode
  Future<void> barcodeFindModeStart({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'barcodeFindModeStart', params);
  }

  /// Pauses the BarcodeFind mode
  Future<void> barcodeFindModePause({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'barcodeFindModePause', params);
  }

  /// Stops the BarcodeFind mode
  Future<void> barcodeFindModeStop({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'barcodeFindModeStop', params);
  }

  /// Sets the item list for BarcodeFind
  Future<void> barcodeFindSetItemList({required int viewId, required String itemsJson}) async {
    final params = {'viewId': viewId, 'itemsJson': itemsJson};
    return await executeBarcode('BarcodeFindModule', 'barcodeFindSetItemList', params);
  }

  /// Register persistent event listener for BarcodeFind mode events
  Future<void> registerBarcodeFindListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'registerBarcodeFindListener', params);
  }

  /// Unregister event listener for BarcodeFind mode events
  Future<void> unregisterBarcodeFindListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'unregisterBarcodeFindListener', params);
  }

  /// Sets the enabled state of the BarcodeFind mode
  Future<void> setBarcodeFindModeEnabledState({required int viewId, required bool enabled}) async {
    final params = {'viewId': viewId, 'enabled': enabled};
    return await executeBarcode('BarcodeFindModule', 'setBarcodeFindModeEnabledState', params);
  }

  /// Sets the barcode transformer for BarcodeFind
  Future<void> setBarcodeTransformer({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'setBarcodeTransformer', params);
  }

  /// Unsets the barcode transformer for BarcodeFind
  Future<void> unsetBarcodeTransformer({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeFindModule', 'unsetBarcodeTransformer', params);
  }

  /// Submits the barcode transformer result
  Future<void> submitBarcodeFindTransformerResult({required int viewId, String? transformedBarcode}) async {
    final params = {'viewId': viewId, if (transformedBarcode != null) 'transformedBarcode': transformedBarcode};
    return await executeBarcode('BarcodeFindModule', 'submitBarcodeFindTransformerResult', params);
  }

  /// Updates the BarcodeFind feedback configuration
  Future<void> updateBarcodeFindFeedback({required int viewId, required String feedbackJson}) async {
    final params = {'viewId': viewId, 'feedbackJson': feedbackJson};
    return await executeBarcode('BarcodeFindModule', 'updateBarcodeFindFeedback', params);
  }

  /// Register persistent event listener for BarcodeAr view UI events
  Future<void> registerBarcodeArViewUiListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'registerBarcodeArViewUiListener', params);
  }

  /// Unregister event listener for BarcodeAr view UI events
  Future<void> unregisterBarcodeArViewUiListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'unregisterBarcodeArViewUiListener', params);
  }

  /// Register persistent event listener for BarcodeAr annotation provider events
  Future<void> registerBarcodeArAnnotationProvider({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'registerBarcodeArAnnotationProvider', params);
  }

  /// Unregister event listener for BarcodeAr annotation provider events
  Future<void> unregisterBarcodeArAnnotationProvider({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'unregisterBarcodeArAnnotationProvider', params);
  }

  /// Register persistent event listener for BarcodeAr highlight provider events
  Future<void> registerBarcodeArHighlightProvider({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'registerBarcodeArHighlightProvider', params);
  }

  /// Unregister event listener for BarcodeAr highlight provider events
  Future<void> unregisterBarcodeArHighlightProvider({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'unregisterBarcodeArHighlightProvider', params);
  }

  /// Handles custom highlight click event
  Future<void> onCustomHighlightClicked({required int viewId, required String barcodeId}) async {
    final params = {'viewId': viewId, 'barcodeId': barcodeId};
    return await executeBarcode('BarcodeArModule', 'onCustomHighlightClicked', params);
  }

  /// Starts the BarcodeAr view
  Future<void> barcodeArViewStart({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'barcodeArViewStart', params);
  }

  /// Stops the BarcodeAr view
  Future<void> barcodeArViewStop({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'barcodeArViewStop', params);
  }

  /// Pauses the BarcodeAr view
  Future<void> barcodeArViewPause({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'barcodeArViewPause', params);
  }

  /// Resets the BarcodeAr view
  Future<void> barcodeArViewReset({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'barcodeArViewReset', params);
  }

  /// Updates the BarcodeAr view configuration
  Future<void> updateBarcodeArView({required int viewId, required String viewJson}) async {
    final params = {'viewId': viewId, 'viewJson': viewJson};
    return await executeBarcode('BarcodeArModule', 'updateBarcodeArView', params);
  }

  /// Finish callback for BarcodeAr annotation for barcode
  Future<void> finishBarcodeArAnnotationForBarcode({required int viewId, required String annotationJson}) async {
    final params = {'viewId': viewId, 'annotationJson': annotationJson};
    return await executeBarcode('BarcodeArModule', 'finishBarcodeArAnnotationForBarcode', params);
  }

  /// Finish callback for BarcodeAr highlight for barcode
  Future<void> finishBarcodeArHighlightForBarcode({required int viewId, required String highlightJson}) async {
    final params = {'viewId': viewId, 'highlightJson': highlightJson};
    return await executeBarcode('BarcodeArModule', 'finishBarcodeArHighlightForBarcode', params);
  }

  /// Updates the BarcodeAr highlight
  Future<void> updateBarcodeArHighlight({required int viewId, required String highlightJson}) async {
    final params = {'viewId': viewId, 'highlightJson': highlightJson};
    return await executeBarcode('BarcodeArModule', 'updateBarcodeArHighlight', params);
  }

  /// Updates the BarcodeAr annotation
  Future<void> updateBarcodeArAnnotation({required int viewId, required String annotationJson}) async {
    final params = {'viewId': viewId, 'annotationJson': annotationJson};
    return await executeBarcode('BarcodeArModule', 'updateBarcodeArAnnotation', params);
  }

  /// Updates the BarcodeAr popover button at specific index
  Future<void> updateBarcodeArPopoverButtonAtIndex({required int viewId, required String updateJson}) async {
    final params = {'viewId': viewId, 'updateJson': updateJson};
    return await executeBarcode('BarcodeArModule', 'updateBarcodeArPopoverButtonAtIndex', params);
  }

  /// Applies BarcodeAr settings
  Future<void> applyBarcodeArSettings({required int viewId, required String settings}) async {
    final params = {'viewId': viewId, 'settings': settings};
    return await executeBarcode('BarcodeArModule', 'applyBarcodeArSettings', params);
  }

  /// Updates the BarcodeAr mode configuration
  Future<void> updateBarcodeArMode({required int viewId, required String modeJson}) async {
    final params = {'viewId': viewId, 'modeJson': modeJson};
    return await executeBarcode('BarcodeArModule', 'updateBarcodeArMode', params);
  }

  /// Updates the BarcodeAr feedback configuration
  Future<void> updateBarcodeArFeedback({required int viewId, required String feedbackJson}) async {
    final params = {'viewId': viewId, 'feedbackJson': feedbackJson};
    return await executeBarcode('BarcodeArModule', 'updateBarcodeArFeedback', params);
  }

  /// Register persistent event listener for BarcodeAr mode events
  Future<void> registerBarcodeArListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'registerBarcodeArListener', params);
  }

  /// Unregister event listener for BarcodeAr mode events
  Future<void> unregisterBarcodeArListener({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'unregisterBarcodeArListener', params);
  }

  /// Finish callback for BarcodeAr did update session event
  Future<void> finishBarcodeArOnDidUpdateSession({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'finishBarcodeArOnDidUpdateSession', params);
  }

  /// Resets the BarcodeAr session
  Future<void> resetBarcodeArSession({required int viewId}) async {
    final params = {'viewId': viewId};
    return await executeBarcode('BarcodeArModule', 'resetBarcodeArSession', params);
  }

  /// Creates a Barcode instance from BarcodeInfo
  Future<String> createFromBarcodeInfo({required String barcodeInfoJson}) async {
    final params = {'barcodeInfoJson': barcodeInfoJson};
    final result = await executeBarcode('BarcodeModule', 'createFromBarcodeInfo', params);
    return result;
  }
}
