/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';

import '../../scandit_flutter_datacapture_barcode.dart';

class BarcodeCountSession with _PrivateBarcodeCountSession {
  final _BarcodeCountSessionController _controller = _BarcodeCountSessionController();

  final List<Barcode> _recognizedBarcodes;

  List<Barcode> get recognizedBarcodes => _recognizedBarcodes;

  final int _frameSequenceId;

  int get frameSequenceId => _frameSequenceId;

  final List<Barcode> _additionalBarcodes;

  List<Barcode> get additionalBarcodes => _additionalBarcodes;

  final int _viewId;

  BarcodeCountSession._(
      this._recognizedBarcodes, this._additionalBarcodes, this._frameSequenceId, String frameId, this._viewId) {
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
    final viewId = event['viewId'] as int;

    return BarcodeCountSession._(trackedCodes, additionalBarcodes, frameSequenceId, frameId, viewId);
  }

  Future<void> reset() {
    return _controller.reset(_viewId, _frameSequenceId);
  }
}

mixin _PrivateBarcodeCountSession {
  String _frameId = "";

  String get frameId => _frameId;
}

class _BarcodeCountSessionController {
  late final BarcodeMethodHandler _methodHandler = _getMethodHandler();

  Future<void> reset(int viewId, int frameSequenceId) {
    return _methodHandler.resetBarcodeCountSession(viewId: viewId);
  }

  BarcodeMethodHandler _getMethodHandler() {
    return BarcodeMethodHandler(const MethodChannel(BarcodeFunctionNames.methodsChannelName));
  }
}
