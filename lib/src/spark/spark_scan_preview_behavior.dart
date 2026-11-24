/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

/// The preview behavior type of the [SparkScanView].
///
/// Added in version 6.23.0
enum SparkScanPreviewBehavior {
  /// After a scan with scanning behavior [SparkScanScanningBehavior.single], or stopping scanning with scanning behavior [SparkScanScanningBehavior.continuous], camera moves to standby state and preview is hidden for maximum efficiency.
  ///
  /// Added in version 6.23.0
  defaultBehaviour('default'),
  /// After a scan with scanning behavior [SparkScanScanningBehavior.single], or stopping scanning with scanning behavior [SparkScanScanningBehavior.continuous], camera stays active and preview is visible for maximum precision.
  ///
  /// Added in version 6.23.0
  persistent('persistent');

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
