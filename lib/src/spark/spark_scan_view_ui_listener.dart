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

abstract class ExtendedSparkScanViewUiListener extends SparkScanViewUiListener {
  void didTapLabelCaptureButton(SparkScanView view);
}
