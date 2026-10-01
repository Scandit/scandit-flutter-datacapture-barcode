/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

enum BarcodePickAction {
  none('none'),
  pick('pick'),
  unpick('unpick');

  const BarcodePickAction(this._name);

  @override
  String toString() => _name;

  final String _name;

  static BarcodePickAction fromJSON(String jsonValue) {
    return BarcodePickAction.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
