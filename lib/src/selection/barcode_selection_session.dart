/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'package:flutter/services.dart';

import 'barcode_selection_function_names.dart';
import '../../scandit_flutter_datacapture_barcode.dart';

class BarcodeSelectionSession {
  final List<Barcode> _selectedBarcodes;
  final List<Barcode> _newlySelectedBarcodes;
  final List<Barcode> _newlyUnselectedBarcodes;
  final _BarcodeSelectionSessionController _controller = _BarcodeSelectionSessionController();

  List<Barcode> get newlySelectedBarcodes => _newlySelectedBarcodes;

  List<Barcode> get selectedBarcodes => _selectedBarcodes;

  List<Barcode> get newlyUnselectedBarcodes => _newlyUnselectedBarcodes;

  final int _frameSequenceId;
  int get frameSequenceId => _frameSequenceId;

  BarcodeSelectionSession._(
      this._newlySelectedBarcodes, this._newlyUnselectedBarcodes, this._selectedBarcodes, this._frameSequenceId);

  Future<void> reset() {
    return _controller.reset(_frameSequenceId);
  }

  Future<int> getCount(Barcode barcode) {
    return _controller.getCount(_frameSequenceId, barcode);
  }

  BarcodeSelectionSession.fromJSON(Map<String, dynamic> json)
      : this._(
            (json['newlySelectedBarcodes'] as List<dynamic>)
                .cast<Map<String, dynamic>>()
                .map((e) => Barcode.fromJSON(e))
                .toList()
                .cast<Barcode>(),
            (json['newlyUnselectedBarcodes'] as List<dynamic>)
                .cast<Map<String, dynamic>>()
                .map((e) => LocalizedOnlyBarcode.fromJSON(e))
                .toList()
                .cast<Barcode>(),
            (json['selectedBarcodes'] as List<dynamic>)
                .cast<Map<String, dynamic>>()
                .map((e) => LocalizedOnlyBarcode.fromJSON(e))
                .toList()
                .cast<Barcode>(),
            (json['frameSequenceId'] as num).toInt());
}

class _BarcodeSelectionSessionController {
  late final MethodChannel _methodChannel = _getChannel();

  Future<int> getCount(int frameSequenceId, Barcode barcode) {
    var arguments = {
      'frameSequenceId': frameSequenceId,
      'symbology': barcode.symbology.jsonValue,
      'data': barcode.data
    };
    return _methodChannel
        .invokeMethod<int>(BarcodeSelectionFunctionNames.getBarcodeSelectionSessionCount, jsonEncode(arguments))
        .then((value) => value ?? 0);
  }

  Future<void> reset(int frameSequenceId) {
    return _methodChannel.invokeMethod(BarcodeSelectionFunctionNames.resetBarcodeSelectionSession, frameSequenceId);
  }

  MethodChannel _getChannel() {
    return MethodChannel('com.scandit.datacapture.barcode.selection.method/barcode_selection_session');
  }
}
