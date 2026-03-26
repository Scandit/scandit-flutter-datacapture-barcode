/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';

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
  late final BarcodeMethodHandler barcodeMethodHandler = _getMethodHandler();

  Future<int> getCount(int modeId, Barcode barcode) async {
    var selectionIdentifier = (barcode.data ?? '') + barcode.symbology.toString();
    final count = await barcodeMethodHandler.getCountForBarcodeInBarcodeSelectionSession(
        modeId: modeId, selectionIdentifier: selectionIdentifier);
    return count.toInt();
  }

  Future<void> reset(int modeId, int frameSequenceId) {
    return barcodeMethodHandler.resetBarcodeSelectionSession(modeId: modeId).then((value) => null);
  }

  BarcodeMethodHandler _getMethodHandler() {
    final channel = const MethodChannel(BarcodeFunctionNames.methodsChannelName);
    return BarcodeMethodHandler(channel);
  }
}
