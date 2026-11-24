/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/logging/logging_method_channel.dart';

import '../../scandit_flutter_datacapture_barcode.dart';

/// Holds the ongoing state of a running [BarcodeSelection]. An instance of this class is passed to BarcodeSelectionListener.didUpdateSelection() when new barcodes are selected or currently selected barcodes are unselected.
///
/// The barcode selection session should only be accessed from within didUpdateSelection() to which it is provided as an argument. It is not safe to be accessed from anywhere else since it may be concurrently modified.Specifically no reference to [BarcodeSelectionSession.selectedBarcodes] should be kept and traversed outside of didUpdateSelection(). Instead a copy of the list should be made to avoid concurrent modification. The individual barcodes can be referenced without copying as they are not further modified.
///
/// Added in version 6.10.0
class BarcodeSelectionSession with _PrivateBarcodeSelectionSession {
  final List<Barcode> _selectedBarcodes;
  final List<Barcode> _newlySelectedBarcodes;
  final List<Barcode> _newlyUnselectedBarcodes;
  final _BarcodeSelectionSessionController _controller = _BarcodeSelectionSessionController();

  /// List of codes that were newly selected in the last processed frame.
  ///
  /// Added in version 6.10.0
  List<Barcode> get newlySelectedBarcodes => _newlySelectedBarcodes;

  /// List of currently selected codes.
  ///
  /// Added in version 6.10.0
  List<Barcode> get selectedBarcodes => _selectedBarcodes;

  /// List of codes that were unselected in the last processed frame.
  ///
  /// Added in version 6.10.0
  List<Barcode> get newlyUnselectedBarcodes => _newlyUnselectedBarcodes;

  final int _frameSequenceId;
  /// The identifier of the current frame sequence.
  ///
  /// As long as there is no interruptions of frames coming from the camera, the [BarcodeSelectionSession.frameSequenceId] will stay the same.
  ///
  /// Added in version 6.10.0
  int get frameSequenceId => _frameSequenceId;

  final int _modeId;

  BarcodeSelectionSession._(this._newlySelectedBarcodes, this._newlyUnselectedBarcodes, this._selectedBarcodes,
      this._frameSequenceId, String? frameId, this._modeId) {
    _frameId = frameId;
  }

  /// Resets the barcode selection session, effectively clearing the history of selected codes. This function should only be called inside the listeners’ callback. To call it from another thread, use [BarcodeSelection.reset].
  ///
  /// Added in version 6.10.0
  Future<void> reset() {
    return _controller.reset(_modeId, _frameSequenceId);
  }

  /// Returns how many times the given [Barcode] was selected.
  ///
  /// Added in version 6.10.0
  Future<int> getCount(Barcode barcode) {
    return _controller.getCount(_modeId, barcode);
  }

  /// Select all the unselected barcodes that are currently being tracked in this barcode selection session.
  ///
  /// Added in version 8.5.0
  Future<void> selectUnselectedBarcodes() {
    return _controller.selectUnselectedBarcodes(_modeId);
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

  Future<void> selectUnselectedBarcodes(int modeId) {
    return barcodeMethodHandler.selectUnselectedBarcodesInBarcodeSelectionSession(modeId: modeId).then((value) => null);
  }

  BarcodeMethodHandler _getMethodHandler() {
    final channel = const LoggingMethodChannel(BarcodeFunctionNames.methodsChannelName);
    return BarcodeMethodHandler(channel);
  }
}
