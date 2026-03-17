/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_view.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_view_state.dart';

abstract class SparkScanViewUiListener {
  void didTapBarcodeFindButton(SparkScanView view);

  void didTapBarcodeCountButton(SparkScanView view);

  void didChangeViewState(SparkScanViewState newState);
}

/// @deprecated This class is deprecated.
/// Starting from version 8.0 of the plugins, the `didTapLabelCaptureButton`
/// method will be included directly in [SparkScanViewUiListener].
@Deprecated('This class is deprecated. '
    'Starting from version 8.0 of the plugins, the didTapLabelCaptureButton '
    'method will be included directly in SparkScanViewUiListener.')
abstract class ExtendedSparkScanViewUiListener extends SparkScanViewUiListener {
  /// Called when the label capture button is tapped.
  ///
  /// @deprecated This method will be moved to [SparkScanViewUiListener] in version 8.0.
  /// Continue using this method for now, but prepare to migrate to [SparkScanViewUiListener]
  /// in the next major version.
  void didTapLabelCaptureButton(SparkScanView view);
}
