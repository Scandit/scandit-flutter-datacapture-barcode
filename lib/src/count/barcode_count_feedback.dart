/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_count_defaults.dart';

class BarcodeCountFeedback implements Serializable {
  Feedback success = BarcodeCountDefaults.barcodeCountFeedbackDefaults.success;
  Feedback failure = BarcodeCountDefaults.barcodeCountFeedbackDefaults.failure;

  static BarcodeCountFeedback get defaultFeedback => BarcodeCountFeedback();

  @override
  Map<String, dynamic> toMap() {
    return {'success': success.toMap(), 'failure': failure.toMap()};
  }
}
