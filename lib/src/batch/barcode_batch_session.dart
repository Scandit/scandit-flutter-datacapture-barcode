/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/logging/logging_method_channel.dart';

import '../tracked_barcode.dart';

/// The batch session contains all the currently tracked barcodes and changes that were made specifically in the last processed frame.
///
/// The batch session should only be accessed from within didUpdateSession() to which it is provided as an argument. It is not safe to be accessed from anywhere else since it may be concurrently modified.Specifically no reference to [BarcodeBatchSession.trackedBarcodes], [BarcodeBatchSession.addedTrackedBarcodes], [BarcodeBatchSession.removedTrackedBarcodes] or [BarcodeBatchSession.updatedTrackedBarcodes] should be kept and traversed outside of didUpdateSession(). Instead a copy of the lists should be made to avoid concurrent modification. The individual tracked barcodes can be referenced without copying as they are not further modified.
///
/// Added in version 7.0.0
class BarcodeBatchSession with _PrivatecBarcodeBatchSession {
  final _BarcodeBatchSessionController _controller = _BarcodeBatchSessionController();

  final List<TrackedBarcode> _addedTrackedBarcodes;
  /// Newly tracked barcodes.
  ///
  /// Added in version 7.0.0
  List<TrackedBarcode> get addedTrackedBarcodes => _addedTrackedBarcodes;

  final List<int> _removedTrackedBarcodes;
  /// The identifiers of lost tracked barcodes that were removed.
  ///
  /// Added in version 7.0.0
  List<int> get removedTrackedBarcodes => _removedTrackedBarcodes;

  final List<TrackedBarcode> _updatedTrackedBarcodes;
  /// Updated tracked barcodes (new location).
  ///
  /// Added in version 7.0.0
  List<TrackedBarcode> get updatedTrackedBarcodes => _updatedTrackedBarcodes;

  final Map<int, TrackedBarcode> _trackedBarcodes;
  /// A map from identifiers to tracked barcodes. It contains all currently tracked barcodes.
  ///
  /// Added in version 7.0.0
  Map<int, TrackedBarcode> get trackedBarcodes => _trackedBarcodes;

  final int _frameSequenceId;
  /// The identifier of the current frame sequence.
  ///
  /// As long as there is no interruptions of frames coming from the camera, the [BarcodeBatchSession.frameSequenceId] will stay the same.
  ///
  /// Added in version 7.0.0
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

    return BarcodeBatchSession._(addedTrackedCodes, removedTrackedCodes, updatedTrackedCodes, trackedCodes,
        frameSequenceId, eventJson['frameId']);
  }

  /// Resets the Barcode Batch session, effectively clearing the history of tracked barcodes. This function should only be called inside the listeners’ callback.
  ///
  /// Added in version 7.0.0
  Future<void> reset() {
    return _controller.reset(_frameSequenceId);
  }
}

mixin _PrivatecBarcodeBatchSession {
  String _frameId = "";

  String get frameId => _frameId;
}

class _BarcodeBatchSessionController {
  late final BarcodeMethodHandler barcodeMethodHandler = _getMethodHandler();

  Future<void> reset(int frameSequenceId) {
    return barcodeMethodHandler.resetBarcodeBatchSession();
  }

  BarcodeMethodHandler _getMethodHandler() {
    return BarcodeMethodHandler(const LoggingMethodChannel(BarcodeFunctionNames.methodsChannelName));
  }
}
