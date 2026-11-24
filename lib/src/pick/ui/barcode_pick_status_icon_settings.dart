/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show buildBarcodePickStatusIconSettings;

/// Use this class to customize the status icons in styles that support it.
///
/// Added in version 7.3.0
class BarcodePickStatusIconSettings implements Serializable {
  /// The ratio between the shortest highlight dimension and the base size for the status icon. This base size will then be clamped between [BarcodePickStatusIconSettings.minSize] and [BarcodePickStatusIconSettings.maxSize]. For example, for a highlight with a size of 90x60 dp, a ratio of 0.6 means the base size for the status icon will be calculated as 60 (shortest dimension) * 0.6 = 36 dp, before being clamped between the minimum and maximum allowed sizes.
  ///
  /// Default is 0.5.
  ///
  /// Added in version 7.3.0
  double ratioToHighlightSize = BarcodePickDefaults.barcodePickStatusIconSettingsDefaults.ratioToHighlightSize;

  /// The minimum size allowed for status icons.
  ///
  /// Default is 20 dp.
  ///
  /// Added in version 7.3.0
  int minSize = BarcodePickDefaults.barcodePickStatusIconSettingsDefaults.minSize;

  /// The maximum size allowed for status icons.
  ///
  /// Default is no maximum, INT_MAX.
  ///
  /// Added in version 7.3.0
  int maxSize = BarcodePickDefaults.barcodePickStatusIconSettingsDefaults.maxSize;

  /// Creates a new BarcodePickStatusIconSettings instance with default values.
  ///
  /// Added in version 7.3.0
  BarcodePickStatusIconSettings();

  factory BarcodePickStatusIconSettings.fromJSON(Map<String, dynamic> json) {
    return BarcodePickStatusIconSettings()
      ..ratioToHighlightSize = json['sizeToHighlightSizeRatio'] as double
      ..minSize = json['minSize'] as int
      ..maxSize = json['maxSize'] as int;
  }

  @override
  Map<String, dynamic> toMap() {
    return buildBarcodePickStatusIconSettings(
      // Wire key differs from the property name: native reads `sizeToHighlightSizeRatio`.
      sizeToHighlightSizeRatio: ratioToHighlightSize,
      minSize: minSize,
      maxSize: maxSize,
    );
  }
}
