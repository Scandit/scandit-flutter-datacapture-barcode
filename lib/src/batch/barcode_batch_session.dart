/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'barcode_batch_function_names.dart';

import 'tracked_barcode.dart';

class BarcodeBatchSession with _PrivatecBarcodeBatchSession {
  final _BarcodeBatchSessionController _controller = _BarcodeBatchSessionController();

  final List<TrackedBarcode> _addedTrackedBarcodes;
  List<TrackedBarcode> get addedTrackedBarcodes => _addedTrackedBarcodes;

  final List<int> _removedTrackedBarcodes;
  List<int> get removedTrackedBarcodes => _removedTrackedBarcodes;

  final List<TrackedBarcode> _updatedTrackedBarcodes;
  List<TrackedBarcode> get updatedTrackedBarcodes => _updatedTrackedBarcodes;

  final Map<int, TrackedBarcode> _trackedBarcodes;
  Map<int, TrackedBarcode> get trackedBarcodes => _trackedBarcodes;

  final int _frameSequenceId;
  int get frameSequenceId => _frameSequenceId;

  BarcodeBatchSession._(this._addedTrackedBarcodes, this._removedTrackedBarcodes, this._updatedTrackedBarcodes,
      this._trackedBarcodes, this._frameSequenceId, String frameId) {
    _frameId = frameId;
  }

  factory BarcodeBatchSession.fromJSON(Map<String, dynamic> eventJson) {
    var json = jsonDecode(eventJson['session']);
    var frameSequenceId = json['frameSequenceId'] as int;
    var addedTrackedCodes = (json['addedTrackedBarcodes'] as List)
        .map((trackedCodeJSON) => TrackedBarcode.fromJSON(trackedCodeJSON, sessionFrameSequenceId: frameSequenceId))
        .toList();
    var updatedTrackedCodes = (json['updatedTrackedBarcodes'] as List)
        .map((trackedCodeJSON) => TrackedBarcode.fromJSON(trackedCodeJSON, sessionFrameSequenceId: frameSequenceId))
        .toList();
    var removedTrackedCodes = (json['removedTrackedBarcodes'] as List)
        // ignore: unnecessary_lambdas
        .map((id) => int.parse(id))
        .toList();
    var trackedCodes = (json['trackedBarcodes'] as Map).cast<String, Map<String, dynamic>>().map<int, TrackedBarcode>(
        (key, value) =>
            MapEntry(int.parse(key), TrackedBarcode.fromJSON(value, sessionFrameSequenceId: frameSequenceId)));

    return BarcodeBatchSession._(
      addedTrackedCodes,
      removedTrackedCodes,
      updatedTrackedCodes,
      trackedCodes,
      frameSequenceId,
      eventJson['frameId'],
    );
  }

  Future<void> reset() {
    return _controller.reset(_frameSequenceId);
  }
}

mixin _PrivatecBarcodeBatchSession {
  String _frameId = "";

  String get frameId => _frameId;
}

class _BarcodeBatchSessionController {
  late final MethodChannel _methodChannel = _getChannel();

  Future<void> reset(int frameSequenceId) {
    return _methodChannel.invokeMethod(BarcodeBatchFunctionNames.resetBarcodeBatchSession, frameSequenceId);
  }

  MethodChannel _getChannel() {
    return const MethodChannel(BarcodeBatchFunctionNames.methodsChannelName);
  }
}
