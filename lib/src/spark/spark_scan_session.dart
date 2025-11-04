/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import '../../scandit_flutter_datacapture_barcode.dart';
import 'spark_scan_function_names.dart';

class SparkScanSession with _PrivateSparkScanSession {
  final _SparkScanSessionController _controller = _SparkScanSessionController();

  final Barcode? _newlyRecognizedBarcode;
  Barcode? get newlyRecognizedBarcode => _newlyRecognizedBarcode;

  final int _frameSequenceId;
  int get frameSequenceId => _frameSequenceId;

  final int _viewId;

  SparkScanSession._(this._newlyRecognizedBarcode, this._frameSequenceId, String frameId, this._viewId) {
    _frameId = frameId;
  }

  factory SparkScanSession.fromJSON(Map<String, dynamic> event, int viewId) {
    var json = jsonDecode(event['session']);
    return SparkScanSession._(
      json['newlyRecognizedBarcode'] != null ? Barcode.fromJSON(json['newlyRecognizedBarcode']) : null,
      (json['frameSequenceId'] as num).toInt(),
      event['frameId'],
      viewId,
    );
  }

  Future<void> reset() {
    return _controller.reset(_frameSequenceId, _viewId);
  }
}

mixin _PrivateSparkScanSession {
  String _frameId = "";

  String get frameId => _frameId;
}

class _SparkScanSessionController {
  late final MethodChannel _methodChannel = _getChannel();

  Future<void> reset(int frameSequenceId, int viewId) {
    return _methodChannel.invokeMethod(
        SparkScanFunctionNames.resetSparkScanSession, {'viewId': viewId, 'frameSequenceId': frameSequenceId});
  }

  MethodChannel _getChannel() {
    return const MethodChannel(SparkScanFunctionNames.methodsChannelName);
  }
}
