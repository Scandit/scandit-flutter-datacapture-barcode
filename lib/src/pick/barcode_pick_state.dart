/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

enum BarcodePickState {
  ignore('ignore'),
  picked('picked'),
  toPick('toPick'),
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
