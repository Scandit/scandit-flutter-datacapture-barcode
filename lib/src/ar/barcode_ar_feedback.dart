/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'barcode_ar_defaults.dart';

class BarcodeArFeedback extends ChangeNotifier implements Serializable {
  BarcodeArFeedback();

  Feedback _scanned = BarcodeArDefaults.feedbackDefaults.scanned;

  Feedback get scanned => _scanned;

  set scanned(Feedback newValue) {
    _scanned = newValue;
    _update();
  }

  Feedback _tapped = BarcodeArDefaults.feedbackDefaults.tapped;

  Feedback get tapped => _tapped;

  set tapped(Feedback newValue) {
    _tapped = newValue;
    _update();
  }

  static BarcodeArFeedback get defaultFeedback => BarcodeArFeedback();

  void _update() {
    notifyListeners();
  }

  @override
  Map<String, dynamic> toMap() {
    return {'scanned': scanned.toMap(), 'tapped': tapped.toMap()};
  }
}
