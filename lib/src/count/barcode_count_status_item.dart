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
  final ScanditIcon? _icon;

  BarcodeCountStatusItem._(this._barcode, this._status) : _icon = null;

  BarcodeCountStatusItem._withIcon(this._barcode, this._icon) : _status = BarcodeCountStatus.none;

  factory BarcodeCountStatusItem.create(TrackedBarcode barcode, BarcodeCountStatus status) {
    return BarcodeCountStatusItem._(barcode, status);
  }

  factory BarcodeCountStatusItem.withIcon(TrackedBarcode barcode, ScanditIcon? icon) {
    return BarcodeCountStatusItem._withIcon(barcode, icon);
  }

  TrackedBarcode get barcode => _barcode;

  BarcodeCountStatus get status => _status;

  ScanditIcon? get icon => _icon;

  @override
  Map<String, dynamic> toMap() {
    return {
      'barcodeId': barcode.identifier,
      'status': status.toString(),
      if (_icon != null) 'icon': _icon.toMap(),
    };
  }
}
