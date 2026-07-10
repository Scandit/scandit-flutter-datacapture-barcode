/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class TargetBarcode implements Serializable {
  final String _data;
  final int _quantity;

  TargetBarcode._(this._data, this._quantity);

  String get data => _data;

  int get quantity => quantity;

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
