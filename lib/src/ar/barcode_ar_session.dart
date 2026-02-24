/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';

import '../tracked_barcode.dart';
import 'barcode_ar_function_names.dart';

class BarcodeArSession with _PrivatecBarcodeArSession {
  final _BarcodeArSessionController _controller = _BarcodeArSessionController();

  final List<TrackedBarcode> _addedTrackedBarcodes;
  final List<int> _removedTrackedBarcodes;
  final Map<int, TrackedBarcode> _trackedBarcodes;

  BarcodeArSession._(this._addedTrackedBarcodes, this._removedTrackedBarcodes, this._trackedBarcodes, String frameId) {
    _frameId = frameId;
  }

  List<TrackedBarcode> get addedTrackedBarcodes => _addedTrackedBarcodes;

  List<int> get removedTrackedBarcodes => _removedTrackedBarcodes;

  Map<int, TrackedBarcode> get trackedBarcodes => _trackedBarcodes;

  factory BarcodeArSession.fromJSON(Map<String, dynamic> event) {
    final json = jsonDecode(event['session']);

    final allTrackedBarcodes = (json['allTrackedBarcodes'] as Map<String, dynamic>)
        .map((key, value) => MapEntry(int.parse(key), TrackedBarcode.fromJSON(value)));
    var addedTrackedCodes = (json['addedTrackedBarcodes'] as List)
        .map((trackedCodeJSON) => TrackedBarcode.fromJSON(trackedCodeJSON))
        .toList();
    List<int> removedTrackedBarcodes = [];
    if (json['removedTrackedBarcodes'] != null) {
      removedTrackedBarcodes = (json['removedTrackedBarcodes'] as List).map((id) => int.parse(id)).toList();
    }
    final frameId = event['frameId'] as String;

    return BarcodeArSession._(addedTrackedCodes, removedTrackedBarcodes, allTrackedBarcodes, frameId);
  }

  Future<void> reset() {
    return _controller.reset();
  }
}

mixin _PrivatecBarcodeArSession {
  String _frameId = "";

  String get frameId => _frameId;
}

class _BarcodeArSessionController {
  late final MethodChannel _methodChannel = _getChannel();

  Future<void> reset() {
    return _methodChannel.invokeMethod(BarcodeArFunctionNames.resetLatestBarcodeArSession);
  }

  MethodChannel _getChannel() {
    return const MethodChannel(BarcodeArFunctionNames.methodsChannelName);
  }
}
