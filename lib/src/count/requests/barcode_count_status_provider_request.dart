/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_batch.dart';

class BarcodeCountStatusProviderRequest {
  final String _requestId;
  final List<TrackedBarcode> _trackedBarcodes;

  BarcodeCountStatusProviderRequest._(this._requestId, this._trackedBarcodes);

  String get id => _requestId;

  List<TrackedBarcode> get barcodes => _trackedBarcodes;

  factory BarcodeCountStatusProviderRequest.fromJSON(Map<String, dynamic> json) {
    var trackedBarcodes = (json['barcodes'] as List)
        .map((barcodeJson) => TrackedBarcode.fromJSON(jsonDecode(barcodeJson), sessionFrameSequenceId: 0))
        .toList();

    return BarcodeCountStatusProviderRequest._(json['requestId'], trackedBarcodes);
  }
}
