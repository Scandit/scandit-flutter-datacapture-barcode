/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_barcode_feedback.dart';
import 'package:scandit_flutter_datacapture_barcode/src/usi/scanned_item.dart';

abstract class SparkScanFeedbackDelegate {
  SparkScanBarcodeFeedback? feedbackForBarcode(Barcode barcode);
}

abstract class SparkScanFeedbackExtendedDelegate {
  SparkScanBarcodeFeedback? feedbackForBarcode(Barcode barcode);
  SparkScanBarcodeFeedback? feedbackForScannedItem(ScannedItem item);
}
