/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'spark_scan_defaults.dart';

class SparkScanFeedback implements Serializable {
  Feedback success = SparkScanDefaults.sparkScanFeedbackDefaults.success;

  Feedback error = SparkScanDefaults.sparkScanFeedbackDefaults.error;

  static SparkScanFeedback get defaultFeedback {
    return SparkScanFeedback();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'success': success.toMap(),
      'error': error.toMap(),
    };
  }
}
