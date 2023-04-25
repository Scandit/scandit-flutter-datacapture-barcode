/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../../scandit_flutter_datacapture_barcode.dart';
import '../../scandit_flutter_datacapture_barcode_tracking.dart';
import 'barcode_count_function_names.dart';

@immutable
class BarcodeCountSession {
  final _BarcodeCountSessionController _controller = _BarcodeCountSessionController();

  final Map<int, TrackedBarcode> _recognizedBarcodes;

  Map<int, TrackedBarcode> get recognizedBarcodes => _recognizedBarcodes;

  final int _frameSequenceId;

  int get frameSequenceId => _frameSequenceId;

  final List<Barcode> _additionalBarcodes;

  List<Barcode> get additionalBarcodes => _additionalBarcodes;

  BarcodeCountSession._(this._recognizedBarcodes, this._additionalBarcodes, this._frameSequenceId);

  factory BarcodeCountSession.fromJSON(Map<String, dynamic> json) {
    var frameSequenceId = json['frameSequenceId'] as int;
    var trackedCodes = (json['recognizedBarcodes'] as Map)
        .cast<String, Map<String, dynamic>>()
        .map<int, TrackedBarcode>((key, value) =>
            MapEntry(int.parse(key), TrackedBarcode.fromJSON(value, sessionFrameSequenceId: frameSequenceId)));
    var additionalBarcodes = (json['additionalBarcodes'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((e) => Barcode.fromJSON(e))
        .toList()
        .cast<Barcode>();

    return BarcodeCountSession._(trackedCodes, additionalBarcodes, frameSequenceId);
  }

  Future<void> reset() {
    return _controller.reset(_frameSequenceId);
  }
}

class _BarcodeCountSessionController {
  late final MethodChannel _methodChannel = _getChannel();

  Future<void> reset(int frameSequenceId) {
    return _methodChannel.invokeMethod(BarcodeCountFunctionNames.resetBarcodeCountSession, frameSequenceId);
  }

  MethodChannel _getChannel() {
    return MethodChannel('com.scandit.datacapture.barcode.count.method/barcode_count_listener');
  }
}
