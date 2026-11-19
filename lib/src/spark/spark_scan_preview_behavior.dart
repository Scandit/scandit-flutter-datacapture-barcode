/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

enum SparkScanPreviewBehavior {
  defaultBehaviour('default'),
  persistent('accurate');

  const SparkScanPreviewBehavior(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension SparkScanPreviewBehaviorDeserializer on SparkScanPreviewBehavior {
  static SparkScanPreviewBehavior fromJSON(String jsonValue) {
    return SparkScanPreviewBehavior.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
