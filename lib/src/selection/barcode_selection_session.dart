/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';

import 'barcode_selection_function_names.dart';
import '../../scandit_flutter_datacapture_barcode.dart';

class BarcodeSelectionSession with _PrivateBarcodeSelectionSession {
  final List<Barcode> _selectedBarcodes;
  final List<Barcode> _newlySelectedBarcodes;
  final List<Barcode> _newlyUnselectedBarcodes;
  final _BarcodeSelectionSessionController _controller = _BarcodeSelectionSessionController();

  List<Barcode> get newlySelectedBarcodes => _newlySelectedBarcodes;

  List<Barcode> get selectedBarcodes => _selectedBarcodes;

  List<Barcode> get newlyUnselectedBarcodes => _newlyUnselectedBarcodes;

  final int _frameSequenceId;
  int get frameSequenceId => _frameSequenceId;

  final int _modeId;

  BarcodeSelectionSession._(this._newlySelectedBarcodes, this._newlyUnselectedBarcodes, this._selectedBarcodes,
      this._frameSequenceId, String? frameId, this._modeId) {
    _frameId = frameId;
  }

  Future<void> reset() {
    return _controller.reset(_modeId, _frameSequenceId);
  }

  Future<int> getCount(Barcode barcode) {
    return _controller.getCount(_modeId, barcode);
  }

  factory BarcodeSelectionSession.fromJSON(Map<String, dynamic> event) {
    var json = jsonDecode(event['session']);

    return BarcodeSelectionSession._(
      (json['newlySelectedBarcodes'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((e) => Barcode.fromJSON(e))
          .toList()
          .cast<Barcode>(),
      (json['newlyUnselectedBarcodes'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((e) => Barcode.fromJSON(e))
          .toList()
          .cast<Barcode>(),
      (json['selectedBarcodes'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((e) => Barcode.fromJSON(e))
          .toList()
          .cast<Barcode>(),
      (json['frameSequenceId'] as num).toInt(),
      event['frameId'] as String?,
      event['modeId'] as int,
    );
  }
}

mixin _PrivateBarcodeSelectionSession {
  String? _frameId;

  String? get frameId => _frameId;
}

class _BarcodeSelectionSessionController {
  late final MethodChannel _methodChannel = _getChannel();

  Future<int> getCount(int modeId, Barcode barcode) {
    var selectionIdentifier = (barcode.data ?? '') + barcode.symbology.toString();
    return _methodChannel.invokeMethod<int>(BarcodeSelectionFunctionNames.getBarcodeSelectionSessionCount,
        {'modeId': modeId, 'selectionIdentifier': selectionIdentifier}).then((value) => value ?? 0);
  }

  Future<void> reset(int modeId, int frameSequenceId) {
    return _methodChannel.invokeMethod(BarcodeSelectionFunctionNames.resetBarcodeSelectionSession,
        {'modeId': modeId, 'frameSequenceId': frameSequenceId});
  }

  MethodChannel _getChannel() {
    return const MethodChannel(BarcodeSelectionFunctionNames.methodsChannelName);
  }
}
