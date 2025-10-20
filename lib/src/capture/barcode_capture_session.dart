/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'barcode_capture_function_names.dart';
import '../../scandit_flutter_datacapture_barcode.dart';

class BarcodeCaptureSession with _PrivateBarcodeCaptureSession {
  final _BarcodeCaptureSessionController _controller = _BarcodeCaptureSessionController();

  final Barcode? _newlyRecognizedBarcode;
  Barcode? get newlyRecognizedBarcode => _newlyRecognizedBarcode;

  final List<LocalizedOnlyBarcode> _newlyLocalizedBarcodes;
  List<LocalizedOnlyBarcode> get newlyLocalizedBarcodes => _newlyLocalizedBarcodes;

  final int _frameSequenceId;
  int get frameSequenceId => _frameSequenceId;

  BarcodeCaptureSession._(
      this._newlyRecognizedBarcode, this._newlyLocalizedBarcodes, this._frameSequenceId, String frameId) {
    _frameId = frameId;
  }

  factory BarcodeCaptureSession.fromJSON(Map<String, dynamic> eventJson) {
    var json = jsonDecode(eventJson['session']);

    return BarcodeCaptureSession._(
      json['newlyRecognizedBarcode'] != null ? Barcode.fromJSON(json['newlyRecognizedBarcode']) : null,
      (json['newlyLocalizedBarcodes'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((e) => LocalizedOnlyBarcode.fromJSON(e))
          .toList()
          .cast<LocalizedOnlyBarcode>(),
      (json['frameSequenceId'] as num).toInt(),
      eventJson['frameId'],
    );
  }

  Future<void> reset() {
    return _controller.reset();
  }
}

mixin _PrivateBarcodeCaptureSession {
  String _frameId = "";

  String get frameId => _frameId;
}

class _BarcodeCaptureSessionController {
  late final MethodChannel _methodChannel = _getChannel();

  Future<void> reset() {
    return _methodChannel.invokeMethod(BarcodeCaptureFunctionNames.resetBarcodeCaptureSession);
  }

  MethodChannel _getChannel() {
    return const MethodChannel(BarcodeCaptureFunctionNames.methodsChannelName);
  }
}
