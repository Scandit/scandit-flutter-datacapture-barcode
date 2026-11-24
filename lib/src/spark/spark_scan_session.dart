/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/src/usi/scanned_item.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/logging/logging_method_channel.dart';

/// The SparkScan session is responsible for determining the list of *relevant* barcodes by filtering out duplicates. This filtering of duplicates is completely time-based and does not use any information about the location of the barcode. By default, all the codes scanned in a frame are always reported. It is possible to filter out codes recently scanned by changing [SparkScanSettings.codeDuplicateFilter].
///
/// When the SparkScan mode is disabled ([SparkScan.isEnabled]), the session’s duplicate filter is reset.
///
/// The SparkScan session should only be accessed from within didScan() or didUpdateSession() and from the thread these methods are called from. It is not safe to be accessed from anywhere else since it may be concurrently modified.
///
/// Added in version 6.20.0
class SparkScanSession with _PrivateSparkScanSession {
  final _SparkScanSessionController _controller = _SparkScanSessionController();

  final Barcode? _newlyRecognizedBarcode;
  /// Last newly recognized barcode in the last processed frame.
  ///
  /// Added in version 6.26.0
  Barcode? get newlyRecognizedBarcode => _newlyRecognizedBarcode;

  final List<ScannedItem> _newlyRecognizedItems;
  /// An array containing newly recognized items detected in the last processed frame. Each [ScannedItem] represents a logical grouping of scan components (barcodes and text) that were recognized together.
  ///
  /// This API is still in beta and may change in future versions of Scandit Data Capture SDK.
  ///
  /// Added in version 8.1.0
  List<ScannedItem> get newlyRecognizedItems => _newlyRecognizedItems;

  final List<ScannedItem> _allScannedItems;
  /// An array containing all scanned items detected during the current session. Each [ScannedItem] represents a logical grouping of scan components (barcodes and text) that were recognized together.
  ///
  /// This API is still in beta and may change in future versions of Scandit Data Capture SDK.
  ///
  /// Added in version 8.1.0
  List<ScannedItem> get allScannedItems => _allScannedItems;

  final int _frameSequenceId;
  /// The identifier of the current frame sequence.
  ///
  /// As long as there is no interruption of frames coming from the camera, the [SparkScanSession.frameSequenceId] will stay the same. Note that every time target mode is switched on or off, this number will change.
  ///
  /// Added in version 6.20.0
  int get frameSequenceId => _frameSequenceId;

  final int _viewId;

  SparkScanSession._(this._newlyRecognizedBarcode, this._newlyRecognizedItems, this._allScannedItems,
      this._frameSequenceId, String frameId, this._viewId) {
    _frameId = frameId;
  }

  factory SparkScanSession.fromJSON(Map<String, dynamic> event, int viewId) {
    var json = jsonDecode(event['session']);
    return SparkScanSession._(
      json['newlyRecognizedBarcode'] != null ? Barcode.fromJSON(json['newlyRecognizedBarcode']) : null,
      json['newItems'] != null ? (json['newItems'] as List<dynamic>).map((e) => ScannedItem.fromJSON(e)).toList() : [],
      json['allItems'] != null ? (json['allItems'] as List<dynamic>).map((e) => ScannedItem.fromJSON(e)).toList() : [],
      (json['frameSequenceId'] as num).toInt(),
      event['frameId'] ?? '',
      viewId,
    );
  }

  /// Resets the SparkScan session, effectively clearing the history of scanned codes. This affects duplicate filtering: when calling [SparkScanSession.reset] every frame has the same effect as setting the [SparkScanSettings.codeDuplicateFilter] to 0. This function should only be called inside the listeners’ callback.
  ///
  /// Added in version 6.20.0
  Future<void> reset() {
    return _controller.reset(_frameSequenceId, _viewId);
  }
}

mixin _PrivateSparkScanSession {
  String _frameId = "";

  String get frameId => _frameId;
}

class _SparkScanSessionController {
  late final BarcodeMethodHandler methodHandler = _getMethodHandler();

  Future<void> reset(int frameSequenceId, int viewId) {
    return methodHandler.resetSparkScanSession(viewId: viewId);
  }

  BarcodeMethodHandler _getMethodHandler() {
    return BarcodeMethodHandler(const LoggingMethodChannel(BarcodeFunctionNames.methodsChannelName));
  }
}
