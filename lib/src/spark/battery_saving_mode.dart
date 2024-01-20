/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

enum BatterySavingMode {
  on('on'),
  off('off'),
  auto('auto');

  const BatterySavingMode(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BatterySavingModeDeserializer on BatterySavingMode {
  static BatterySavingMode fromJSON(String jsonValue) {
    return BatterySavingMode.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
