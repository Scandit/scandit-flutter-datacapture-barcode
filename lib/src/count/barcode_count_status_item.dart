/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_batch.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_count_status.dart';

class BarcodeCountStatusItem implements Serializable {
  final TrackedBarcode _barcode;
  final BarcodeCountStatus _status;

  BarcodeCountStatusItem._(this._barcode, this._status);

  factory BarcodeCountStatusItem.create(TrackedBarcode barcode, BarcodeCountStatus status) {
    return BarcodeCountStatusItem._(barcode, status);
  }

  TrackedBarcode get barcode => _barcode;

  BarcodeCountStatus get status => _status;

  @override
  Map<String, dynamic> toMap() {
    return {
      'barcodeId': barcode.identifier,
      'status': status.toString(),
    };
  }
}
