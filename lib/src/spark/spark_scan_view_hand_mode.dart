/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

enum SparkScanViewHandMode { right, left }

extension SparkScanViewHandModeSerializer on SparkScanViewHandMode {
  static SparkScanViewHandMode fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'right':
        return SparkScanViewHandMode.right;
      case 'left':
        return SparkScanViewHandMode.left;
      default:
        throw Exception("Missing SparkScanViewHandMode for name '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case SparkScanViewHandMode.right:
        return 'right';
      case SparkScanViewHandMode.left:
        return 'left';
      default:
        throw Exception("Missing name for enum '$this'");
    }
  }
}
