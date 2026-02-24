/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';

import '../../scandit_flutter_datacapture_barcode.dart';
import 'barcode_count_function_names.dart';

class BarcodeCountSession with _PrivateBarcodeCountSession {
  final _BarcodeCountSessionController _controller = _BarcodeCountSessionController();

  final List<Barcode> _recognizedBarcodes;

  List<Barcode> get recognizedBarcodes => _recognizedBarcodes;

  final int _frameSequenceId;

  int get frameSequenceId => _frameSequenceId;

  final List<Barcode> _additionalBarcodes;

  List<Barcode> get additionalBarcodes => _additionalBarcodes;

  BarcodeCountSession._(this._recognizedBarcodes, this._additionalBarcodes, this._frameSequenceId, String frameId) {
    _frameId = frameId;
  }

  factory BarcodeCountSession.fromJSON(Map<String, dynamic> event) {
    final json = jsonDecode(event['session']);
    final frameSequenceId = json['frameSequenceId'] as int;
    final trackedCodes = (json['recognizedBarcodes'] as List).map((e) => Barcode.fromJSON(e)).toList();
    final additionalBarcodes = (json['additionalBarcodes'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((e) => Barcode.fromJSON(e))
        .toList()
        .cast<Barcode>();
    final frameId = event['frameId'] as String;

    return BarcodeCountSession._(trackedCodes, additionalBarcodes, frameSequenceId, frameId);
  }

  Future<void> reset() {
    return _controller.reset(_frameSequenceId);
  }
}

mixin _PrivateBarcodeCountSession {
  String _frameId = "";

  String get frameId => _frameId;
}

class _BarcodeCountSessionController {
  late final MethodChannel _methodChannel = _getChannel();

  Future<void> reset(int frameSequenceId) {
    return _methodChannel.invokeMethod(BarcodeCountFunctionNames.resetBarcodeCountSession, frameSequenceId);
  }

  MethodChannel _getChannel() {
    return const MethodChannel(BarcodeCountFunctionNames.methodsChannelName);
  }
}
