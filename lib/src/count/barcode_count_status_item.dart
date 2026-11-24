/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_batch.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_count_status.dart';

/// A class that stores a [TrackedBarcode] alongside its associated status.
///
/// Added in version 7.0.0
class BarcodeCountStatusItem implements Serializable {
  final TrackedBarcode _barcode;
  final BarcodeCountStatus _status;
  final ScanditIcon? _icon;

  BarcodeCountStatusItem._(this._barcode, this._status) : _icon = null;

  BarcodeCountStatusItem._withIcon(this._barcode, this._icon) : _status = BarcodeCountStatus.none;

  factory BarcodeCountStatusItem.create(TrackedBarcode barcode, BarcodeCountStatus status) {
    return BarcodeCountStatusItem._(barcode, status);
  }

  /// Constructs a new barcode count status item with an icon. Pass *null* for the icon to indicate that the barcode should not show any icon.
  ///
  /// Added in version 8.5.0
  factory BarcodeCountStatusItem.withIcon(TrackedBarcode barcode, ScanditIcon? icon) {
    return BarcodeCountStatusItem._withIcon(barcode, icon);
  }

  /// The tracked barcode.
  ///
  /// Added in version 7.0.0
  TrackedBarcode get barcode => _barcode;

  /// The status associated to the barcode. Items constructed with an icon instead of a status report [BarcodeCountStatus].None.
  ///
  /// Added in version 7.0.0
  BarcodeCountStatus get status => _status;

  /// The icon associated to the barcode.
  ///
  /// Added in version 8.5.0
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
