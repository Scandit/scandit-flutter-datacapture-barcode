/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'barcode_ar_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show buildBarcodeArFeedback;

/// Determines what feedback (vibration, sound) should be emitted when barcodes are checked.
///
/// The feedback is specified for each BarcodeAr instance separately and can be changed through the feedback property by either modifying an existing instance of this class, or by assigning a new one.
///
/// See documentation on the [BarcodeAr.feedback] property for usage samples.
///
/// Added in version 7.1.0
class BarcodeArFeedback extends ChangeNotifier implements Serializable {
  /// Empty constructor. Constructs a new feedback that will not emit any sound, nor vibration.
  ///
  /// Added in version 7.1.0
  BarcodeArFeedback();

  Feedback _scanned = BarcodeArDefaults.feedbackDefaults.scanned;

  /// A [Feedback] for a barcode scanned event.
  ///
  /// Added in version 7.1.0
  Feedback get scanned => _scanned;

  /// A [Feedback] for a barcode scanned event.
  ///
  /// Added in version 7.1.0
  set scanned(Feedback newValue) {
    _scanned = newValue;
    _update();
  }

  Feedback _tapped = BarcodeArDefaults.feedbackDefaults.tapped;

  /// A [Feedback] for an element tapped event.
  ///
  /// Added in version 7.1.0
  Feedback get tapped => _tapped;

  /// A [Feedback] for an element tapped event.
  ///
  /// Added in version 7.1.0
  set tapped(Feedback newValue) {
    _tapped = newValue;
    _update();
  }

  /// Returns a Barcode AR feedback with default configuration:
  ///
  /// - default beep sound is loaded,
  /// - beeping for the success event is enabled,
  /// - vibration for the success event is enabled.
  ///
  /// Added in version 7.1.0
  static BarcodeArFeedback get defaultFeedback => BarcodeArFeedback();

  void _update() {
    notifyListeners();
  }

  @override
  Map<String, dynamic> toMap() {
    return buildBarcodeArFeedback(
      scanned: scanned.toMap(),
      tapped: tapped.toMap(),
    );
  }
}
