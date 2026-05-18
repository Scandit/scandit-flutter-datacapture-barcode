/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';

import 'barcode_find_defaults.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeFindFeedback extends ChangeNotifier implements Serializable {
  BarcodeFindFeedback();

  Feedback _found = BarcodeFindDefaults.barcodeFindFeedbackDefaults.found;

  Feedback get found => _found;

  set found(Feedback newValue) {
    _found = newValue;
    notifyListeners();
  }

  Feedback _itemListUpdated = BarcodeFindDefaults.barcodeFindFeedbackDefaults.itemListUpdated;

  Feedback get itemListUpdated => _itemListUpdated;

  set itemListUpdated(Feedback newValue) {
    _itemListUpdated = newValue;
    notifyListeners();
  }

  static BarcodeFindFeedback get defaultFeedback => BarcodeFindFeedback();

  @override
  Map<String, dynamic> toMap() {
    return {
      'found': found.toMap(),
      'itemListUpdated': itemListUpdated.toMap(),
    };
  }
}
