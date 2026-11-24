/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';

import 'barcode_find_defaults.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show buildBarcodeFindFeedback;

/// Determines what feedback (vibration, sound) should be emitted when barcodes are scanned.
///
/// The feedback is specified for each BarcodeFind instance separately and can be changed through the feedback property by either modifying an existing instance of this class, or by assigning a new one.
///
/// As of now, this class allows to configure the feedback that gets emitted when barcodes are found successfully, through the [BarcodeFindFeedback.found] property.
///
/// See documentation on the [BarcodeFind.feedback] property for usage samples.
///
/// Added in version 6.22.0
class BarcodeFindFeedback extends ChangeNotifier implements Serializable {
  /// Empty constructor. Constructs a new feedback that will not emit any sound, nor vibration.
  ///
  /// Added in version 7.6.0
  BarcodeFindFeedback();

  Feedback _found = BarcodeFindDefaults.barcodeFindFeedbackDefaults.found;

  /// A [Feedback] for a barcode found event.
  ///
  /// Added in version 6.22.0
  Feedback get found => _found;

  /// A [Feedback] for a barcode found event.
  ///
  /// Added in version 6.22.0
  set found(Feedback newValue) {
    _found = newValue;
    notifyListeners();
  }

  Feedback _itemListUpdated = BarcodeFindDefaults.barcodeFindFeedbackDefaults.itemListUpdated;

  /// A [Feedback] for the item list updated event.
  ///
  /// Added in version 6.24.0
  Feedback get itemListUpdated => _itemListUpdated;

  /// A [Feedback] for the item list updated event.
  ///
  /// Added in version 6.24.0
  set itemListUpdated(Feedback newValue) {
    _itemListUpdated = newValue;
    notifyListeners();
  }

  /// Returns a barcode find feedback with default configuration:
  ///
  /// - default beep sound is loaded,
  /// - beeping for the success event is enabled,
  /// - vibration for the success event is enabled.
  ///
  /// Added in version 6.22.0
  static BarcodeFindFeedback get defaultFeedback => BarcodeFindFeedback();

  @override
  Map<String, dynamic> toMap() {
    return buildBarcodeFindFeedback(
      found: found.toMap(),
      itemListUpdated: itemListUpdated.toMap(),
    );
  }
}
