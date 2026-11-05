/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

/// The size of the mini preview in [SparkScanView].
///
/// Used in [SparkScanViewSettings.defaultMiniPreviewSize].
///
/// Added in version 7.0.0
enum SparkScanMiniPreviewSize {
  /// Regular, smaller size of the mini preview.
  ///
  /// Added in version 7.0.0
  regular('regular'),
  /// Expanded, larger size of the mini preview.
  ///
  /// Added in version 7.0.0
  expanded('expanded');

  const SparkScanMiniPreviewSize(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension SparkScanMiniPreviewSizeSerializer on SparkScanMiniPreviewSize {
  static SparkScanMiniPreviewSize fromJSON(String jsonValue) {
    return SparkScanMiniPreviewSize.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
