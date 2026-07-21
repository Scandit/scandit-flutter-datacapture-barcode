/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeCountNotInListActionSettings implements Serializable {
  bool enabled = false;
  String acceptButtonText = '';
  String acceptButtonContentDescription = '';
  String acceptButtonAccessibilityLabel = '';
  String acceptButtonAccessibilityHint = '';
  String rejectButtonText = '';
  String rejectButtonContentDescription = '';
  String rejectButtonAccessibilityLabel = '';
  String rejectButtonAccessibilityHint = '';
  String cancelButtonText = '';
  String cancelButtonContentDescription = '';
  String cancelButtonAccessibilityLabel = '';
  String cancelButtonAccessibilityHint = '';
  String barcodeAcceptedHint = '';
  String barcodeRejectedHint = '';

  BarcodeCountNotInListActionSettings();

  @override
  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'acceptButtonText': acceptButtonText,
      'acceptButtonContentDescription': acceptButtonContentDescription,
      'acceptButtonAccessibilityLabel': acceptButtonAccessibilityLabel,
      'acceptButtonAccessibilityHint': acceptButtonAccessibilityHint,
      'rejectButtonText': rejectButtonText,
      'rejectButtonContentDescription': rejectButtonContentDescription,
      'rejectButtonAccessibilityLabel': rejectButtonAccessibilityLabel,
      'rejectButtonAccessibilityHint': rejectButtonAccessibilityHint,
      'cancelButtonText': cancelButtonText,
      'cancelButtonContentDescription': cancelButtonContentDescription,
      'cancelButtonAccessibilityLabel': cancelButtonAccessibilityLabel,
      'cancelButtonAccessibilityHint': cancelButtonAccessibilityHint,
      'barcodeAcceptedHint': barcodeAcceptedHint,
      'barcodeRejectedHint': barcodeRejectedHint,
    };
  }
}
