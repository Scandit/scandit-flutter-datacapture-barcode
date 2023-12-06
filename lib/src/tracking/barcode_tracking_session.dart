/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'barcode_tracking_function_names.dart';

import 'tracked_barcode.dart';

@immutable
class BarcodeTrackingSession {
  final _BarcodeTrackingSessionController _controller = _BarcodeTrackingSessionController();

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

  BarcodeTrackingSession._(this._addedTrackedBarcodes, this._removedTrackedBarcodes, this._updatedTrackedBarcodes,
      this._trackedBarcodes, this._frameSequenceId);

  factory BarcodeTrackingSession.fromJSON(Map<String, dynamic> json) {
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
    return BarcodeTrackingSession._(
        addedTrackedCodes, removedTrackedCodes, updatedTrackedCodes, trackedCodes, frameSequenceId);
  }

  Future<void> reset() {
    return _controller.reset(_frameSequenceId);
  }
}

class _BarcodeTrackingSessionController {
  late final MethodChannel _methodChannel = _getChannel();

  Future<void> reset(int frameSequenceId) {
    return _methodChannel.invokeMethod(BarcodeTrackingFunctionNames.resetBarcodeTrackingSession, frameSequenceId);
  }

  MethodChannel _getChannel() {
    return MethodChannel('com.scandit.datacapture.barcode.tracking.method/barcode_tracking_listener');
  }
}
