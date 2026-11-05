/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_view.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_view_capture_mode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_view_state.dart';

/// Added in version 6.20.0
abstract class SparkScanViewUiListener {
  /// Callback method that can be used to define an action that should be performed when barcode find button is tapped from the toolbar. Called from the main thread.
  ///
  /// Added in version 7.0.0
  void didTapBarcodeFindButton(SparkScanView view);

  /// Callback method that can be used to define an action that should be performed when barcode count button is tapped from the toolbar. Called from the main thread.
  ///
  /// Added in version 6.20.0
  void didTapBarcodeCountButton(SparkScanView view);

  /// Callback method that will be called when [SparkScanViewState] changes. Called from the main thread.
  ///
  /// Added in version 7.0.0
  void didChangeViewState(SparkScanViewState newState);

  /// Callback method that can be used to define an action that should be performed when label capture button is tapped from the toolbar. Called from the main thread.
  ///
  /// Added in version 8.0.0
  void didTapLabelCaptureButton(SparkScanView view);
}

/// Extended version of [SparkScanViewUiListener] that adds support for scanning mode change events. This interface was introduced to avoid breaking changes for existing implementations. It inherits all methods from [SparkScanViewUiListener] and adds the following:
///
/// This listener will be removed in a future release. The didChangeScanningMode() method will be added directly to [SparkScanViewUiListener].
///
/// Added in version 8.3.0
abstract class SparkScanViewUiExtendedListener extends SparkScanViewUiListener {
  /// Callback method that will be called when the currently used SparkScanScanningMode changes. Called from the main thread.
  ///
  /// Added in version 8.3.0
  void didChangeScanningMode(SparkScanScanningMode newScanningMode);
}
