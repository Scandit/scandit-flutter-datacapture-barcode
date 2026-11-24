/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show buildBarcodeCountNotInListActionSettings;

/// Added in version 8.3.0
class BarcodeCountNotInListActionSettings implements Serializable {
  /// Use this property to enable the not in list actions. Defaults to *false*.
  ///
  /// Added in version 8.3.0
  bool enabled = false;
  /// The text for the label associated with the accept button.
  ///
  /// Default value is “Accept”.
  ///
  /// Added in version 8.3.0
  String acceptButtonText = '';
  /// The accept button content description.
  ///
  /// Default value is “Accept barcode button”.
  ///
  /// This feature is only available on Android devices.
  ///
  /// Added in version 8.3.0
  String acceptButtonContentDescription = '';
  /// The accept button accessibility label.
  ///
  /// Default value is “Accept barcode button”.
  ///
  /// Added in version 8.3.0
  String acceptButtonAccessibilityLabel = '';
  /// The accept button accessibility hint.
  ///
  /// Default value is “Accept barcode button”.
  ///
  /// Added in version 8.3.0
  String acceptButtonAccessibilityHint = '';
  /// The text for the label associated with the reject button.
  ///
  /// Default value is “Reject”.
  ///
  /// Added in version 8.3.0
  String rejectButtonText = '';
  /// The reject button content description.
  ///
  /// Default value is “Reject barcode button”.
  ///
  /// This feature is only available on Android devices.
  ///
  /// Added in version 8.3.0
  String rejectButtonContentDescription = '';
  /// The reject button accessibility label.
  ///
  /// Default value is “Reject barcode button”.
  ///
  /// Added in version 8.3.0
  String rejectButtonAccessibilityLabel = '';
  /// The reject button accessibility hint.
  ///
  /// Default value is “Reject barcode button”.
  ///
  /// Added in version 8.3.0
  String rejectButtonAccessibilityHint = '';
  /// The text for the label associated with the cancel button.
  ///
  /// Default value is “Cancel”.
  ///
  /// Added in version 8.3.0
  String cancelButtonText = '';
  /// The cancel button content description.
  ///
  /// Default value is “Cancel popover button”.
  ///
  /// This feature is only available on Android devices.
  ///
  /// Added in version 8.3.0
  String cancelButtonContentDescription = '';
  /// The cancel button accessibility label.
  ///
  /// Default value is “Cancel popover button”.
  ///
  /// Added in version 8.3.0
  String cancelButtonAccessibilityLabel = '';
  /// The cancel button accessibility hint.
  ///
  /// Default value is “Cancel popover button”.
  ///
  /// Added in version 8.3.0
  String cancelButtonAccessibilityHint = '';
  /// The text for the hint that will be shown when a barcode is accepted.
  ///
  /// Default value is “Item accepted”.
  ///
  /// Added in version 8.3.0
  String barcodeAcceptedHint = '';
  /// The text for the hint that will be shown when a barcode is rejected.
  ///
  /// Default value is “Item rejected”.
  ///
  /// Added in version 8.3.0
  String barcodeRejectedHint = '';

  /// Build a new instance of this class, with default values.
  ///
  /// Added in version 8.3.0
  BarcodeCountNotInListActionSettings();

  @override
  Map<String, dynamic> toMap() {
    return buildBarcodeCountNotInListActionSettings(
      enabled: enabled,
      acceptButtonText: acceptButtonText,
      acceptButtonContentDescription: acceptButtonContentDescription,
      acceptButtonAccessibilityLabel: acceptButtonAccessibilityLabel,
      acceptButtonAccessibilityHint: acceptButtonAccessibilityHint,
      rejectButtonText: rejectButtonText,
      rejectButtonContentDescription: rejectButtonContentDescription,
      rejectButtonAccessibilityLabel: rejectButtonAccessibilityLabel,
      rejectButtonAccessibilityHint: rejectButtonAccessibilityHint,
      cancelButtonText: cancelButtonText,
      cancelButtonContentDescription: cancelButtonContentDescription,
      cancelButtonAccessibilityLabel: cancelButtonAccessibilityLabel,
      cancelButtonAccessibilityHint: cancelButtonAccessibilityHint,
      barcodeAcceptedHint: barcodeAcceptedHint,
      barcodeRejectedHint: barcodeRejectedHint,
    );
  }
}
