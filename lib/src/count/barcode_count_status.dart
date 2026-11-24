/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

/// A status for a [Barcode]
///
/// Added in version 7.0.0
enum BarcodeCountStatus {
  /// No status.
  ///
  /// Added in version 7.0.0
  none('none'),
  /// Status that indicates an error retrieving the status.
  ///
  /// Added in version 7.0.0
  notAvailable('notAvailable'),
  /// Status that indicates an expired item.
  ///
  /// Added in version 7.0.0
  expired('expired'),
  /// Status that indicates a fragile item.
  ///
  /// Added in version 7.0.0
  fragile('fragile'),
  /// Status that indicates a quality check is needed.
  ///
  /// Added in version 7.0.0
  qualityCheck('qualityCheck'),
  /// Status that indicates low stock of an item.
  ///
  /// Added in version 7.0.0
  lowStock('lowStock'),
  /// Status that indicates a wrong item.
  ///
  /// Added in version 7.0.0
  wrong('wrong'),
  /// Status that indicates an item that will expire soon.
  ///
  /// Added in version 7.0.0
  expiringSoon('expiringSoon');

  const BarcodeCountStatus(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeCountStatusSerializer on BarcodeCountStatus {
  static BarcodeCountStatus fromJSON(String jsonValue) {
    return BarcodeCountStatus.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
