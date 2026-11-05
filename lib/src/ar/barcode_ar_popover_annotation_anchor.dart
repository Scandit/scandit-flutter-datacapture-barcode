/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

/// The available anchor options for a popover annotation.
///
/// Added in version 8.5.0
enum BarcodeArPopoverAnnotationAnchor {
  /// The annotation is anchored at its top-center point.
  ///
  /// Added in version 8.5.0
  top('top'),
  /// The annotation is anchored at its bottom-center point.
  ///
  /// Added in version 8.5.0
  bottom('bottom'),
  /// The annotation is anchored at its left edge.
  ///
  /// Added in version 8.5.0
  left('left'),
  /// The annotation is anchored at its right edge.
  ///
  /// Added in version 8.5.0
  right('right');

  const BarcodeArPopoverAnnotationAnchor(this._name);

  @override
  String toString() => _name;

  final String _name;

  static BarcodeArPopoverAnnotationAnchor fromJSON(String jsonValue) {
    return BarcodeArPopoverAnnotationAnchor.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
