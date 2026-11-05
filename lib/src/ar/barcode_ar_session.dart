/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/logging/logging_method_channel.dart';

import '../tracked_barcode.dart';

/// The Barcode AR session holds the ongoing state of a running [BarcodeAr].
///
/// Added in version 7.1.0
class BarcodeArSession with _PrivatecBarcodeArSession {
  final _BarcodeArSessionController _controller = _BarcodeArSessionController();

  final List<TrackedBarcode> _addedTrackedBarcodes;
  final List<int> _removedTrackedBarcodes;
  final Map<int, TrackedBarcode> _trackedBarcodes;

  BarcodeArSession._(
      this._addedTrackedBarcodes, this._removedTrackedBarcodes, this._trackedBarcodes, String? frameId, this._viewId) {
    _frameId = frameId;
  }

  /// Newly tracked barcodes.
  ///
  /// Added in version 7.1.0
  List<TrackedBarcode> get addedTrackedBarcodes => _addedTrackedBarcodes;

  /// An array of identifiers of lost barcodes that were removed in the last frame.
  ///
  /// Added in version 7.1.0
  List<int> get removedTrackedBarcodes => _removedTrackedBarcodes;

  /// A map from identifiers to barcodes. It contains all currently tracked barcodes.
  ///
  /// Added in version 7.1.0
  Map<int, TrackedBarcode> get trackedBarcodes => _trackedBarcodes;

  final int _viewId;

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
    final frameId = event['frameId'] as String?;
    final viewId = event['viewId'] as int;

    return BarcodeArSession._(addedTrackedCodes, removedTrackedBarcodes, allTrackedBarcodes, frameId, viewId);
  }

  /// Resets the session, clearing all barcodes and their states.
  ///
  /// Added in version 7.1.0
  Future<void> reset() {
    return _controller.reset(_viewId);
  }
}

mixin _PrivatecBarcodeArSession {
  String? _frameId;

  String? get frameId => _frameId;
}

class _BarcodeArSessionController {
  late final BarcodeMethodHandler _barcodeMethodHandler = _getBarcodeMethodHandler();

  Future<void> reset(int viewId) {
    return _barcodeMethodHandler.resetBarcodeArSession(viewId: viewId);
  }

  BarcodeMethodHandler _getBarcodeMethodHandler() {
    return BarcodeMethodHandler(const LoggingMethodChannel(BarcodeFunctionNames.methodsChannelName));
  }
}
