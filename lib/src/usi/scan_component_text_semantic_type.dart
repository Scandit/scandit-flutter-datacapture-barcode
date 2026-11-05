/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

/// A semantic type to be applied to a [TextDefinition].
///
/// Added in version 8.1.0
enum ScanComponentTextSemanticType {
  /// Added in version 8.1.0
  custom('custom'),
  /// Added in version 8.1.0
  expiryDate('expiryDate'),
  /// Added in version 8.1.0
  packingDate('packingDate'),
  /// Added in version 8.1.0
  totalPrice('totalPrice'),
  /// Added in version 8.1.0
  unitPrice('unitPrice'),
  /// Added in version 8.1.0
  weight('weight');

  const ScanComponentTextSemanticType(this._name);

  @override
  String toString() => _name;

  final String _name;

  static ScanComponentTextSemanticType fromJSON(String jsonValue) {
    return ScanComponentTextSemanticType.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
