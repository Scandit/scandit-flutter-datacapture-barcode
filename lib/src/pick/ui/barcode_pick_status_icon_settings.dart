/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodePickStatusIconSettings implements Serializable {
  double ratioToHighlightSize = BarcodePickDefaults.barcodePickStatusIconSettingsDefaults.ratioToHighlightSize;

  int minSize = BarcodePickDefaults.barcodePickStatusIconSettingsDefaults.minSize;

  int maxSize = BarcodePickDefaults.barcodePickStatusIconSettingsDefaults.maxSize;

  BarcodePickStatusIconSettings();

  factory BarcodePickStatusIconSettings.fromJSON(Map<String, dynamic> json) {
    return BarcodePickStatusIconSettings()
      ..ratioToHighlightSize = json['sizeToHighlightSizeRatio'] as double
      ..minSize = json['minSize'] as int
      ..maxSize = json['maxSize'] as int;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'ratioToHighlightSize': ratioToHighlightSize,
      'minSize': minSize,
      'maxSize': maxSize,
    };
  }
}
