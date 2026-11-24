/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

/// An enumeration of possible actions.
///
/// Added in version 8.5.0
enum BarcodePickAction {
  /// No action.
  ///
  /// Added in version 8.5.0
  none('none'),
  /// Pick action.
  ///
  /// Added in version 8.5.0
  pick('pick'),
  /// Unpick action.
  ///
  /// Added in version 8.5.0
  unpick('unpick');

  const BarcodePickAction(this._name);

  @override
  String toString() => _name;

  final String _name;

  static BarcodePickAction fromJSON(String jsonValue) {
    return BarcodePickAction.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
