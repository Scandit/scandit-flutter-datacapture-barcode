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

/// The capture session is responsible for determining the list of *relevant* barcodes by filtering out duplicates. This filtering of duplicates is completely time-based and doesn’t use any information about the location of the barcode. By default, all the codes scanned in a frame are always reported. It is possible to filter out codes recently scanned by changing [BarcodeCaptureSettings.codeDuplicateFilter].
///
/// For location-based tracking over multiple frames, you may be better off using [BarcodeBatch].
///
/// When the barcode capture mode is disabled ([DataCaptureMode.isEnabled]), the session’s duplicate filter is reset.
///
/// The capture session should only be accessed from within didScan() or didUpdateSession() to which it is provided as an argument. It is not safe to be accessed from anywhere else since it may be concurrently modified.Specifically no reference to [BarcodeCaptureSession.newlyRecognizedBarcode] or [BarcodeCaptureSession.newlyLocalizedBarcodes] should be kept and traversed outside of didScan() or didUpdateSession(). Instead a copy of the lists should be made to avoid concurrent modification. The individual barcodes can be referenced without copying as they are not further modified.
///
/// Added in version 6.7.0
class BarcodeCaptureSession with _PrivateBarcodeCaptureSession {
  final _BarcodeCaptureSessionController _controller = _BarcodeCaptureSessionController();

  final Barcode? _newlyRecognizedBarcode;
  /// Last newly recognized barcode in the last processed frame.
  ///
  /// Added in version 6.26.0
  Barcode? get newlyRecognizedBarcode => _newlyRecognizedBarcode;

  final List<LocalizedOnlyBarcode> _newlyLocalizedBarcodes;
  /// List of codes that were newly localized (but not recognized) in the last processed frame.
  ///
  /// Added in version 6.7.0
  List<LocalizedOnlyBarcode> get newlyLocalizedBarcodes => _newlyLocalizedBarcodes;

  final int _frameSequenceId;
  /// The identifier of the current frame sequence.
  ///
  /// As long as there is no interruptions of frames coming from the camera, the [BarcodeCaptureSession.frameSequenceId] will stay the same.
  ///
  /// Added in version 6.7.0
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
      eventJson['frameId'] as String? ?? '',
    );
  }

  /// Resets the barcode capture session, effectively clearing the history of scanned codes. This affects duplicate filtering: when calling [BarcodeCaptureSession.reset] every frame has the same effect as setting the [BarcodeCaptureSettings.codeDuplicateFilter] to 0. This function should only be called inside the listeners’ callback.
  ///
  /// Added in version 6.12.0
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
