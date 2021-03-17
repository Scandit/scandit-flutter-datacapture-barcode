/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:meta/meta.dart';
import '../../scandit_flutter_datacapture_barcode.dart';

@immutable
class BarcodeCaptureSession {
  final List<Barcode> _newlyRecognizedBarcodes;
  List<Barcode> get newlyRecognizedBarcodes => _newlyRecognizedBarcodes;

  final List<LocalizedOnlyBarcode> _newlyLocalizedBarcodes;
  List<LocalizedOnlyBarcode> get newlyLocalizedBarcodes => _newlyLocalizedBarcodes;

  final int _frameSequenceId;
  int get frameSequenceId => _frameSequenceId;

  BarcodeCaptureSession._(this._newlyRecognizedBarcodes, this._newlyLocalizedBarcodes, this._frameSequenceId);

  BarcodeCaptureSession.fromJSON(Map<String, dynamic> json)
      : this._(
            (json['newlyRecognizedBarcodes'] as List<dynamic>)
                .cast<Map<String, dynamic>>()
                .map((e) => Barcode.fromJSON(e))
                .toList()
                .cast<Barcode>(),
            (json['newlyLocalizedBarcodes'] as List<dynamic>)
                .cast<Map<String, dynamic>>()
                .map((e) => LocalizedOnlyBarcode.fromJSON(e))
                .toList()
                .cast<LocalizedOnlyBarcode>(),
            (json['frameSequenceId'] as num).toInt());
}
