/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

/// A barcode that’s part of a list of targets for [BarcodeCountCaptureList].
///
/// Added in version 6.17.0
class TargetBarcode implements Serializable {
  final String _data;
  final int _quantity;

  TargetBarcode._(this._data, this._quantity);

  /// The data of the target barcode, as a sequence of characters.
  ///
  /// Added in version 6.17.0
  String get data => _data;

  /// The number of times that the target barcode is expected to be scanned.
  ///
  /// Added in version 6.17.0
  int get quantity => _quantity;

  /// Constructs a new target barcode to be added to a [BarcodeCountCaptureList].
  ///
  /// Added in version 6.17.0
  factory TargetBarcode.create(String data, int quantity) {
    return TargetBarcode._(data, quantity);
  }

  factory TargetBarcode.fromJSON(Map<String, dynamic> json) {
    var data = json['data'] as String;
    var quantity = (json['quantity'] as num).toInt();
    return TargetBarcode.create(data, quantity);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'data': _data, 'quantity': _quantity};
  }
}
