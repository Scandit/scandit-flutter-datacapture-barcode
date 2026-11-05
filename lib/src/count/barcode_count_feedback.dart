/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_count_defaults.dart';

/// Determines what feedback (vibration, sound) should be emitted when barcodes are scanned.
///
/// The feedback is specified for each BarcodeCount instance separately and can be changed through the feedback property by either modifying an existing instance of this class, or by assigning a new one.
///
/// As of now, this class allows to configure the feedback that gets emitted when barcodes are read successfully, through the [BarcodeCountFeedback.success] property, and a feedback that gets emitted when barcodes are not read successfully, through the [BarcodeCountFeedback.failure] property.
///
/// See documentation on the [BarcodeCount.feedback] property for usage samples.
///
/// Added in version 6.17.0
class BarcodeCountFeedback extends ChangeNotifier implements Serializable {
  /// Empty constructor. Constructs a new feedback that will not emit any sound, nor vibration.
  ///
  /// Added in version 6.17.0
  BarcodeCountFeedback() : super();

  Feedback _success = BarcodeCountDefaults.barcodeCountFeedbackDefaults.success;

  /// A [Feedback] for a success event.
  ///
  /// Added in version 6.17.0
  Feedback get success => _success;

  /// A [Feedback] for a success event.
  ///
  /// Added in version 6.17.0
  set success(Feedback newValue) {
    _success = newValue;
    _update();
  }

  Feedback _failure = BarcodeCountDefaults.barcodeCountFeedbackDefaults.failure;

  /// A [Feedback] for a failure event.
  ///
  /// Added in version 6.17.0
  Feedback get failure => _failure;

  /// A [Feedback] for a failure event.
  ///
  /// Added in version 6.17.0
  set failure(Feedback newValue) {
    _failure = newValue;
    _update();
  }

  /// Returns a barcode count feedback with default configuration:
  ///
  /// - default beep sound is loaded,
  /// - beeping for the success event is enabled,
  /// - vibration for the success event is enabled,
  /// - beeping for the failure event is enabled,
  /// - vibration for the failure event is enabled.
  ///
  /// Added in version 6.17.0
  static BarcodeCountFeedback get defaultFeedback => BarcodeCountFeedback();

  void _update() {
    notifyListeners();
  }

  @override
  Map<String, dynamic> toMap() {
    return {'success': success.toMap(), 'failure': failure.toMap()};
  }
}
