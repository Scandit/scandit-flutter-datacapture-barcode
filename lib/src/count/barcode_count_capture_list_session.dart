/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:meta/meta.dart';
import '../../scandit_flutter_datacapture_barcode.dart';
import 'target_barcode.dart';
import '../../scandit_flutter_datacapture_barcode_tracking.dart';

@immutable
class BarcodeCountCaptureListSession {
  final List<TrackedBarcode> _correctBarcodes;

  List<TrackedBarcode> get correctBarcodes => _correctBarcodes;

  final List<TrackedBarcode> _wrongBarcodes;

  List<TrackedBarcode> get wrongBarcodes => _wrongBarcodes;

  final List<TargetBarcode> _missingBarcodes;

  List<TargetBarcode> get missingBarcodes => _missingBarcodes;

  final List<Barcode> _additionalBarcodes;

  List<Barcode> get additionalBarcodes => _additionalBarcodes;

  BarcodeCountCaptureListSession._(
      this._correctBarcodes, this._wrongBarcodes, this._missingBarcodes, this._additionalBarcodes);

  factory BarcodeCountCaptureListSession.fromJSON(Map<String, dynamic> json) {
    var correctBarcodes = (json['correctBarcodes'] as List)
        .map((correctBarcodesJSON) => TrackedBarcode.fromJSON(correctBarcodesJSON, sessionFrameSequenceId: 0))
        .toList();

    var wrongBarcodes = (json['wrongBarcodes'] as List)
        .map((wrongBarcodesJSON) => TrackedBarcode.fromJSON(wrongBarcodesJSON, sessionFrameSequenceId: 0))
        .toList();

    var missingBarcodes = (json['missingBarcodes'] as List)
        .map((missingBarcodesJSON) => TargetBarcode.fromJSON(missingBarcodesJSON))
        .toList();

    var additionalBarcodes = (json['additionalBarcodes'] as List)
        .map((additionalBarcodesJSON) => Barcode.fromJSON(additionalBarcodesJSON))
        .toList();

    return BarcodeCountCaptureListSession._(correctBarcodes, wrongBarcodes, missingBarcodes, additionalBarcodes);
  }
}
