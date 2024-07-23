/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'barcode_find_defaults.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeFindFeedback implements Serializable {
  Feedback found = BarcodeFindDefaults.barcodeFindFeedbackDefaults.found;

  static BarcodeFindFeedback get defaultFeedback => BarcodeFindFeedback();

  @override
  Map<String, dynamic> toMap() {
    return {'found': found.toMap()};
  }
}
