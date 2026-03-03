/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

enum BarcodePickIconStyle {
  preset_1('preset1'),
  preset_2('preset2');

  const BarcodePickIconStyle(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodePickIconStyleDeserializer on BarcodePickIconStyle {
  static BarcodePickIconStyle fromJSON(String jsonValue) {
    return BarcodePickIconStyle.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
