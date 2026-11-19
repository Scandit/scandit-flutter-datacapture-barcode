/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

enum ScanComponentTextSemanticType {
  custom('custom'),
  expiryDate('expiryDate'),
  packingDate('packingDate'),
  totalPrice('totalPrice'),
  unitPrice('unitPrice'),
  weight('weight');

  const ScanComponentTextSemanticType(this._name);

  @override
  String toString() => _name;

  final String _name;

  static ScanComponentTextSemanticType fromJSON(String jsonValue) {
    return ScanComponentTextSemanticType.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
