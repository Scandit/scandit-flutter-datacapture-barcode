/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import '../../scandit_flutter_datacapture_barcode.dart';
import 'spark_scan_function_names.dart';

@immutable
class SparkScanSession {
  final _SparkScanSessionController _controller = _SparkScanSessionController();

  final List<Barcode> _newlyRecognizedBarcodes;
  List<Barcode> get newlyRecognizedBarcodes => _newlyRecognizedBarcodes;

  final int _frameSequenceId;
  int get frameSequenceId => _frameSequenceId;

  SparkScanSession._(this._newlyRecognizedBarcodes, this._frameSequenceId);

  SparkScanSession.fromJSON(Map<String, dynamic> json)
      : this._(
            (json['newlyRecognizedBarcodes'] as List<dynamic>)
                .cast<Map<String, dynamic>>()
                .map((e) => Barcode.fromJSON(e))
                .toList()
                .cast<Barcode>(),
            (json['frameSequenceId'] as num).toInt());

  Future<void> reset() {
    return _controller.reset(_frameSequenceId);
  }
}

class _SparkScanSessionController {
  late final MethodChannel _methodChannel = _getChannel();

  Future<void> reset(int frameSequenceId) {
    return _methodChannel.invokeMethod(SparkScanFunctionNames.resetSparkScanSession, frameSequenceId);
  }

  MethodChannel _getChannel() {
    return MethodChannel(SparkScanFunctionNames.methodsChannelName);
  }
}
