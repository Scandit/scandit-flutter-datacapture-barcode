/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

/// The available anchor options for a status icon annotation.
///
/// Added in version 8.6.0
enum BarcodeArStatusIconAnnotationAnchor {
  /// The annotation is anchored at its top-center point.
  ///
  /// Added in version 8.6.0
  top('top'),
  /// The annotation is anchored at its bottom-center point.
  ///
  /// Added in version 8.6.0
  bottom('bottom'),
  /// The annotation is anchored at its left edge.
  ///
  /// Added in version 8.6.0
  left('left'),
  /// The annotation is anchored at its right edge.
  ///
  /// Added in version 8.6.0
  right('right');

  const BarcodeArStatusIconAnnotationAnchor(this._name);

  @override
  String toString() => _name;

  final String _name;

  static BarcodeArStatusIconAnnotationAnchor fromJSON(String jsonValue) {
    return BarcodeArStatusIconAnnotationAnchor.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
