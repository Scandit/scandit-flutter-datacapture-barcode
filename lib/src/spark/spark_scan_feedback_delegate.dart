/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_barcode_feedback.dart';
import 'package:scandit_flutter_datacapture_barcode/src/usi/scanned_item.dart';

/// Feedback delegate interface for SparkScan. This can be used to customize the emitted feedback for each detected barcode. See [SparkScanView.feedbackDelegate].
///
/// Added in version 6.23.0
abstract class SparkScanFeedbackDelegate {
  /// Invoked for each detected barcode. The implementation should return SparkScanBarcodeFeedback.Success ([Success]), SparkScanBarcodeFeedback.Error ([Error]), or *null*. If *null* is returned, the default brush is used to visualize the barcode and no other feedback (visual, sound, or haptic) is emitted. By default returns SparkScanBarcodeFeedback.Success ([Success]).
  ///
  /// Note that this method is executed on a background thread.
  ///
  /// Added in version 6.23.0
  SparkScanBarcodeFeedback? feedbackForBarcode(Barcode barcode);
}

/// Extension of [SparkScanFeedbackDelegate] that adds support for feedbackForScannedItem(). This interface was introduced to avoid breaking changes for existing implementations. Users should use either [SparkScanFeedbackDelegate] or [SparkScanFeedbackExtendedDelegate], but not both. This interface will be removed in a future release.
///
/// Feedback delegate interface for SparkScan. This can be used to customize the emitted feedback for each detected barcode. See [SparkScanView.feedbackDelegate].
///
/// Added in version 8.2.0
abstract class SparkScanFeedbackExtendedDelegate {
  /// Invoked for each detected barcode. The implementation should return SparkScanBarcodeFeedback.Success ([Success]), SparkScanBarcodeFeedback.Error ([Error]), or *null*. If *null* is returned, the default brush is used to visualize the barcode and no other feedback (visual, sound, or haptic) is emitted. By default returns SparkScanBarcodeFeedback.Success ([Success]).
  ///
  /// Note that this method is executed on a background thread.
  ///
  /// Added in version 8.2.0
  SparkScanBarcodeFeedback? feedbackForBarcode(Barcode barcode);
  /// Invoked for each detected scanned item. The implementation should return SparkScanBarcodeFeedback.Success ([Success]), SparkScanBarcodeFeedback.Error ([Error]), or *null*. If *null* is returned, the default brush is used to visualize the item and no other feedback (visual, sound, or haptic) is emitted. By default returns SparkScanBarcodeFeedback.Success ([Success]).
  ///
  /// Added in version 8.2.0
  SparkScanBarcodeFeedback? feedbackForScannedItem(ScannedItem item);
}
