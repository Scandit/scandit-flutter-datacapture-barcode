/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';

import 'barcode_selection_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeSelectionFeedback extends ChangeNotifier implements Serializable {
  BarcodeSelectionFeedback();

  Feedback _selection = BarcodeSelectionDefaults.barcodeSelectionFeedbackDefaults.selection;

  Feedback get selection => _selection;

  set selection(Feedback newValue) {
    _selection = newValue;
    notifyListeners();
  }

  static BarcodeSelectionFeedback get defaultFeedback => BarcodeSelectionFeedback();

  @override
  Map<String, dynamic> toMap() {
    return {'selection': selection.toMap()};
  }
}
