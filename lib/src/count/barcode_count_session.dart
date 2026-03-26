/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_spatial_grid.dart';
import 'package:scandit_flutter_datacapture_barcode/src/cluster.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';

class BarcodeCountSession with _PrivateBarcodeCountSession {
  final _BarcodeCountSessionController _controller = _BarcodeCountSessionController();

  final List<Barcode> _recognizedBarcodes;

  List<Barcode> get recognizedBarcodes => _recognizedBarcodes;

  final int _frameSequenceId;

  int get frameSequenceId => _frameSequenceId;

  final List<Barcode> _additionalBarcodes;

  List<Barcode> get additionalBarcodes => _additionalBarcodes;

  final List<Cluster> _recognizedClusters;

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

  Future<void> reset() {
    return _controller.reset(_viewId, _frameSequenceId);
  }

  Future<BarcodeSpatialGrid?> getSpatialMap() {
    return _controller.getSpatialMap(_viewId);
  }

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
    return BarcodeMethodHandler(const MethodChannel(BarcodeFunctionNames.methodsChannelName));
  }
}
