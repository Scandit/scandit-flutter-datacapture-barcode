/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

@Deprecated('This class is not used anymore. Use SparkScanBarcodeFeedback and FeedbackDelegate instead.')
class SparkScanFeedback implements Serializable {
  Feedback success = Feedback.defaultFeedback;

  Feedback error = Feedback.defaultFeedback;

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
