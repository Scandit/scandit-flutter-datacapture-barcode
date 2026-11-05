/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_spatial_grid.dart';
import 'package:scandit_flutter_datacapture_barcode/src/cluster.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/logging/logging_method_channel.dart';

/// The count session contains all the currently tracked barcodes and changes that were made specifically in the last processed frame.
///
/// The count session should only be accessed from within didScan() to which it is provided as an argument. It is not safe to be accessed from anywhere else since it may be concurrently modified.Specifically no reference to [BarcodeCountSession.recognizedBarcodes] should be kept and traversed outside of didScan(). Instead a copy of the lists should be made to avoid concurrent modification. The individual tracked barcodes can be referenced without copying as they are not further modified.
///
/// Added in version 6.17.0
class BarcodeCountSession with _PrivateBarcodeCountSession {
  final _BarcodeCountSessionController _controller = _BarcodeCountSessionController();

  final List<Barcode> _recognizedBarcodes;

  /// A list containing all currently recognized barcodes.
  ///
  /// Added in version 7.0.0
  List<Barcode> get recognizedBarcodes => _recognizedBarcodes;

  final int _frameSequenceId;

  /// The identifier of the current frame sequence.
  ///
  /// As long as there is no interruptions of frames coming from the camera, the [BarcodeCountSession.frameSequenceId] will stay the same.
  ///
  /// Added in version 6.17.0
  int get frameSequenceId => _frameSequenceId;

  final List<Barcode> _additionalBarcodes;

  /// The array of additional barcodes injected with [BarcodeCount.setAdditionalBarcodes].
  ///
  /// Added in version 6.17.0
  List<Barcode> get additionalBarcodes => _additionalBarcodes;

  final List<Cluster> _recognizedClusters;

  /// A list containing all currently recognized clusters.
  ///
  /// Added in version 8.3.0
  List<Cluster> get recognizedClusters => _recognizedClusters;

  final int _viewId;

  BarcodeCountSession._(this._recognizedBarcodes, this._additionalBarcodes, this._recognizedClusters,
      this._frameSequenceId, String frameId, this._viewId) {
    _frameId = frameId;
  }

  factory BarcodeCountSession.fromJSON(Map<String, dynamic> event) {
    final json = jsonDecode(event['session']);
    final frameSequenceId = json['frameSequenceId'] as int;
    final recognizedBarcodesJson = json['recognizedBarcodes'] as List<dynamic>;
    final recognizedClustersJson = (json['recognizedClusters'] ?? []) as List<dynamic>;
    final hasClusters = recognizedClustersJson.isNotEmpty;

    // Only build the barcode map if clusters are present
    final List<Barcode> trackedCodes;
    final List<Cluster> recognizedClusters;

    if (hasClusters) {
      final Map<String, Barcode> barcodeMap = {};
      trackedCodes = [];
      for (final barcodeJson in recognizedBarcodesJson) {
        final barcode = Barcode.fromJSON(barcodeJson as Map<String, dynamic>);
        final identifier = barcodeJson['identifier'] as String;
        barcodeMap[identifier] = barcode;
        trackedCodes.add(barcode);
      }
      recognizedClusters = recognizedClustersJson.cast<Map<String, dynamic>>().map((e) {
        e['_barcodeMap'] = barcodeMap;
        return Cluster.fromJSON(e);
      }).toList();
    } else {
      trackedCodes = recognizedBarcodesJson.map((e) => Barcode.fromJSON(e as Map<String, dynamic>)).toList();
      recognizedClusters = [];
    }

    final additionalBarcodes = (json['additionalBarcodes'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((e) => Barcode.fromJSON(e))
        .toList()
        .cast<Barcode>();

    final frameId = event['frameId'] as String;
    final viewId = event['viewId'] as int;

    return BarcodeCountSession._(
        trackedCodes, additionalBarcodes, recognizedClusters, frameSequenceId, frameId, viewId);
  }

  /// Resets the barcode count session, effectively clearing the history of recognized barcodes. This function should only be called inside the listeners’ callback.
  ///
  /// Added in version 6.17.0
  Future<void> reset() {
    return _controller.reset(_viewId, _frameSequenceId);
  }

  /// Computes the spatial map with the current session data. If a value is returned by this method the scanning is automatically suspended. Returns *null* if [BarcodeCountSettings.mappingEnabled] is *false*.
  ///
  /// The Barcode Count mapping API is still in beta and may change in future versions of Scandit Data Capture SDK.
  ///
  /// Added in version 8.3.0
  Future<BarcodeSpatialGrid?> getSpatialMap() {
    return _controller.getSpatialMap(_viewId);
  }

  /// Computes the spatial map with the current session data, using the passed values as hints. If a value is returned by this method the scanning is automatically suspended. Returns *null* if [BarcodeCountSettings.mappingEnabled] is *false*.
  ///
  /// The Barcode Count mapping API is still in beta and may change in future versions of Scandit Data Capture SDK.
  ///
  /// Added in version 8.3.0
  Future<BarcodeSpatialGrid?> getSpatialMapWithHints(int expectedNumberOfRows, int expectedNumberOfColumns) {
    return _controller.getSpatialMapWithHints(_viewId, expectedNumberOfRows, expectedNumberOfColumns);
  }
}

mixin _PrivateBarcodeCountSession {
  String _frameId = "";

  String get frameId => _frameId;
}

class _BarcodeCountSessionController {
  late final BarcodeMethodHandler _methodHandler = _getMethodHandler();

  Future<void> reset(int viewId, int frameSequenceId) {
    return _methodHandler.resetBarcodeCountSession(viewId: viewId);
  }

  Future<BarcodeSpatialGrid?> getSpatialMap(int viewId) async {
    final result = await _methodHandler.getBarcodeCountSpatialMap(viewId: viewId);
    if (result == null) {
      return null;
    }
    return BarcodeSpatialGrid.fromJSON(result);
  }

  Future<BarcodeSpatialGrid?> getSpatialMapWithHints(
      int viewId, int expectedNumberOfRows, int expectedNumberOfColumns) async {
    final result = await _methodHandler.getBarcodeCountSpatialMapWithHints(
        viewId: viewId, expectedNumberOfRows: expectedNumberOfRows, expectedNumberOfColumns: expectedNumberOfColumns);
    if (result == null) {
      return null;
    }
    return BarcodeSpatialGrid.fromJSON(result);
  }

  BarcodeMethodHandler _getMethodHandler() {
    return BarcodeMethodHandler(const LoggingMethodChannel(BarcodeFunctionNames.methodsChannelName));
  }
}
