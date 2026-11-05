/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

/// The available width options for an info annotation.
///
/// Added in version 7.1.0
enum BarcodeArInfoAnnotationWidthPreset {
  /// Small width. Recommended for annotations that contain only text or icon, and do not include a header or footer.
  ///
  /// Added in version 7.1.0
  small('small'),
  /// Medium width.
  ///
  /// Added in version 7.1.0
  medium('medium'),
  /// Large width.
  ///
  /// Added in version 7.1.0
  large('large');

  const BarcodeArInfoAnnotationWidthPreset(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeArInfoAnnotationWidthPresetSerializer on BarcodeArInfoAnnotationWidthPreset {
  static BarcodeArInfoAnnotationWidthPreset fromJSON(String jsonValue) {
    return BarcodeArInfoAnnotationWidthPreset.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
