/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum SparkScanMiniPreviewSize {
  regular('regular'),
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
