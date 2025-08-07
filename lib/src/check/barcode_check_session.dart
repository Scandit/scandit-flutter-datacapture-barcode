/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';

import '../tracked_barcode.dart';
import 'barcode_check_function_names.dart';

class BarcodeCheckSession with _PrivatecBarcodeCheckSession {
  final _BarcodeCheckSessionController _controller = _BarcodeCheckSessionController();

  final List<TrackedBarcode> _addedTrackedBarcodes;
  final List<int> _removedTrackedBarcodes;
  final Map<int, TrackedBarcode> _trackedBarcodes;

  BarcodeCheckSession._(
      this._addedTrackedBarcodes, this._removedTrackedBarcodes, this._trackedBarcodes, String frameId) {
    _frameId = frameId;
  }

  List<TrackedBarcode> get addedTrackedBarcodes => _addedTrackedBarcodes;

  List<int> get removedTrackedBarcodes => _removedTrackedBarcodes;

  Map<int, TrackedBarcode> get trackedBarcodes => _trackedBarcodes;

  factory BarcodeCheckSession.fromJSON(Map<String, dynamic> event) {
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

    return BarcodeCheckSession._(addedTrackedCodes, removedTrackedBarcodes, allTrackedBarcodes, frameId);
  }

  Future<void> reset() {
    return _controller.reset();
  }
}

mixin _PrivatecBarcodeCheckSession {
  String _frameId = "";

  String get frameId => _frameId;
}

class _BarcodeCheckSessionController {
  late final MethodChannel _methodChannel = _getChannel();

  Future<void> reset() {
    return _methodChannel.invokeMethod(BarcodeCheckFunctionNames.resetLatestBarcodeCheckSession);
  }

  MethodChannel _getChannel() {
    return const MethodChannel(BarcodeCheckFunctionNames.methodsChannelName);
  }
}
