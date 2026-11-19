/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_count_defaults.dart';

class BarcodeCountFeedback extends ChangeNotifier implements Serializable {
  BarcodeCountFeedback() : super();

  Feedback _success = BarcodeCountDefaults.barcodeCountFeedbackDefaults.success;

  Feedback get success => _success;

  set success(Feedback newValue) {
    _success = newValue;
    _update();
  }

  Feedback _failure = BarcodeCountDefaults.barcodeCountFeedbackDefaults.failure;

  Feedback get failure => _failure;

  set failure(Feedback newValue) {
    _failure = newValue;
    _update();
  }

  static BarcodeCountFeedback get defaultFeedback => BarcodeCountFeedback();

  void _update() {
    notifyListeners();
  }

  @override
  Map<String, dynamic> toMap() {
    return {'success': success.toMap(), 'failure': failure.toMap()};
  }
}
