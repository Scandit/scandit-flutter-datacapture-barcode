/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/target_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/tracked_barcode.dart';

/// The capture list session contains all the barcodes recognised so far, and how they match against the target list.
///
/// Added in version 6.17.0
@immutable
class BarcodeCountCaptureListSession {
  final List<TrackedBarcode> _correctBarcodes;

  /// A list of tracked barcodes that have been correctly matched to the target data provided in the list.
  ///
  /// Added in version 6.17.0
  List<TrackedBarcode> get correctBarcodes => _correctBarcodes;

  final List<TrackedBarcode> _wrongBarcodes;

  /// A list of tracked barcodes that have been correctly scanned, but that don’t match any of the ones provided in the list.
  ///
  /// Added in version 6.17.0
  List<TrackedBarcode> get wrongBarcodes => _wrongBarcodes;

  final List<TargetBarcode> _missingBarcodes;

  /// A list of the barcodes in the target list that have not yet been correctly scanned. If no list was provided to [BarcodeCountCaptureList], this list will be empty.
  ///
  /// Added in version 6.17.0
  List<TargetBarcode> get missingBarcodes => _missingBarcodes;

  final List<Barcode> _additionalBarcodes;

  /// The array of additional barcodes injected with [BarcodeCount.setAdditionalBarcodes].
  ///
  /// Added in version 6.17.0
  List<Barcode> get additionalBarcodes => _additionalBarcodes;

  final List<TrackedBarcode> _acceptedBarcodes;

  /// A list of tracked barcodes that have been marked as accepted.
  ///
  /// Added in version 8.3.0
  List<TrackedBarcode> get acceptedBarcodes => _acceptedBarcodes;

  final List<TrackedBarcode> _rejectedBarcodes;

  /// A list of tracked barcodes that have been marked as rejected.
  ///
  /// Added in version 8.3.0
  List<TrackedBarcode> get rejectedBarcodes => _rejectedBarcodes;

  const BarcodeCountCaptureListSession._(this._correctBarcodes, this._wrongBarcodes, this._missingBarcodes,
      this._additionalBarcodes, this._acceptedBarcodes, this._rejectedBarcodes);

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

    var acceptedBarcodes = (json['acceptedBarcodes'] as List?)
            ?.map((acceptedBarcodesJSON) => TrackedBarcode.fromJSON(acceptedBarcodesJSON, sessionFrameSequenceId: 0))
            .toList() ??
        [];

    var rejectedBarcodes = (json['rejectedBarcodes'] as List?)
            ?.map((rejectedBarcodesJSON) => TrackedBarcode.fromJSON(rejectedBarcodesJSON, sessionFrameSequenceId: 0))
            .toList() ??
        [];

    return BarcodeCountCaptureListSession._(
        correctBarcodes, wrongBarcodes, missingBarcodes, additionalBarcodes, acceptedBarcodes, rejectedBarcodes);
  }
}
