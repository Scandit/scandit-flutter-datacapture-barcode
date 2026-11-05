/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';

import 'barcode_selection_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

/// Determines what feedback (vibration, sound) should be emitted when reading barcodes. The feedback is specified for each [BarcodeSelection] instance separately and can be changed through the [BarcodeSelection.feedback] property by either modifying an existing instance of this class, or by assigning a new one.As of now, this class only allows to configure the feedback that gets emitted when a barcode is selected, through the [BarcodeSelectionFeedback.selection] property.See documentation on the [BarcodeSelection.feedback] property for usage samples.
///
/// Added in version 6.10.0
class BarcodeSelectionFeedback extends ChangeNotifier implements Serializable {
  /// Creates new default barcode selection feedback instance.
  ///
  /// This differs from the native platforms on purpose: on Android, iOS and KMP the empty constructor is silent, while here it returns the default feedback. The framework constructor has always behaved this way, and aligning it would silently drop the selection click for existing callers, so it is kept as is. For a silent feedback on these platforms, assign an empty [Feedback] to [BarcodeSelectionFeedback.selection].
  ///
  /// Added in version 6.10.0
  BarcodeSelectionFeedback();

  Feedback _selection = BarcodeSelectionDefaults.barcodeSelectionFeedbackDefaults.selection;

  /// A [Feedback] for a selection event.
  ///
  /// Added in version 6.10.0
  Feedback get selection => _selection;

  /// A [Feedback] for a selection event.
  ///
  /// Added in version 6.10.0
  set selection(Feedback newValue) {
    _selection = newValue;
    notifyListeners();
  }

  /// Returns a barcode selection feedback with default configuration:
  ///
  /// - default click sound
  /// - no vibration
  ///
  /// Added in version 6.10.0
  static BarcodeSelectionFeedback get defaultFeedback => BarcodeSelectionFeedback();

  @override
  Map<String, dynamic> toMap() {
    return {'selection': selection.toMap()};
  }
}
