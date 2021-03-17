/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeCaptureFeedback implements Serializable {
  Feedback success = Feedback.defaultFeedback;

  static BarcodeCaptureFeedback get defaultFeedback => BarcodeCaptureFeedback();

  @override
  Map<String, dynamic> toMap() {
    return {'success': success.toMap()};
  }
}
