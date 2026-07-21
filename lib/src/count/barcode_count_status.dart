/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum BarcodeCountStatus {
  none('none'),
  notAvailable('notAvailable'),
  expired('expired'),
  fragile('fragile'),
  qualityCheck('qualityCheck'),
  lowStock('lowStock'),
  wrong('wrong'),
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
