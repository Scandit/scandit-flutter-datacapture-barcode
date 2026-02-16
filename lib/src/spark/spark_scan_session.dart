/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/src/usi/scanned_item.dart';

class SparkScanSession with _PrivateSparkScanSession {
  final _SparkScanSessionController _controller = _SparkScanSessionController();

  final Barcode? _newlyRecognizedBarcode;
  Barcode? get newlyRecognizedBarcode => _newlyRecognizedBarcode;

  final List<ScannedItem> _newlyRecognizedItems;
  List<ScannedItem> get newlyRecognizedItems => _newlyRecognizedItems;

  final List<ScannedItem> _allScannedItems;
  List<ScannedItem> get allScannedItems => _allScannedItems;

  final int _frameSequenceId;
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
  late final BarcodeMethodHandler methodHandler = _getMethodHandler();

  Future<void> reset(int frameSequenceId, int viewId) {
    return methodHandler.resetSparkScanSession(viewId: viewId);
  }

  BarcodeMethodHandler _getMethodHandler() {
    return BarcodeMethodHandler(const MethodChannel(BarcodeFunctionNames.methodsChannelName));
  }
}
