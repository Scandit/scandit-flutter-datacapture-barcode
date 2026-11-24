/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

/// The possible states of an item.
///
/// Added in version 6.22.0
enum BarcodePickState {
  /// The item should be ignored in this session.
  ///
  /// Added in version 6.22.0
  ignore('ignore'),
  /// The item has been picked.
  ///
  /// Added in version 6.22.0
  picked('picked'),
  /// The item should be picked.
  ///
  /// Added in version 6.22.0
  toPick('toPick'),
  /// The item has not been mapped to a product.
  ///
  /// Added in version 6.22.0
  unknown('unknown');

  const BarcodePickState(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodePickStateDeserializer on BarcodePickState {
  static BarcodePickState fromJSON(String jsonValue) {
    return BarcodePickState.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
