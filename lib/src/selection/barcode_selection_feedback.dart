/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'barcode_selection_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeSelectionFeedback implements Serializable {
  Feedback selection = BarcodeSelectionDefaults.barcodeSelectionFeedbackDefaults.selection;

  static BarcodeSelectionFeedback get defaultFeedback => BarcodeSelectionFeedback();

  @override
  Map<String, dynamic> toMap() {
    return {'selection': selection.toMap()};
  }
}
