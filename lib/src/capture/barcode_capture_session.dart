/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';

// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

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

class _BarcodeCaptureSessionController extends BaseController {
  late final BarcodeMethodHandler barcodeMethodHandler;

  _BarcodeCaptureSessionController() : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
  }

  Future<void> reset() {
    return barcodeMethodHandler.resetBarcodeCaptureSession().onError(onError);
  }
}
