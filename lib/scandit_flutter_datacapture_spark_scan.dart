/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

library scandit_flutter_datacapture_spark_scan;

export 'src/spark/spark_scan_session.dart' show SparkScanSession;
export 'src/spark/spark_scan.dart' show SparkScan, SparkScanListener;
// ignore: deprecated_member_use_from_same_package
export 'src/spark/spark_scan_feedback.dart' show SparkScanFeedback;
export 'src/spark/spark_scan_settings.dart' show SparkScanSettings;

export 'src/spark/spark_scan_view.dart'
    show
        SparkScanView,
        SparkScanViewUiListener,
        // ignore: deprecated_member_use_from_same_package
        SparkScanScanningPrecision,
        SparkScanPreviewBehavior,
        SparkScanFeedbackDelegate;
export 'src/spark/spark_scan_view_settings.dart' show SparkScanViewSettings;
export 'src/spark/spark_scan_view_capture_mode.dart'
    show SparkScanScanningBehavior, SparkScanScanningMode, SparkScanScanningModeTarget, SparkScanScanningModeDefault;
export 'src/spark/spark_scan_view_hand_mode.dart' show SparkScanViewHandMode;
export 'src/spark/spark_scan_view_feedback.dart'
    show
        // ignore: deprecated_member_use_from_same_package
        SparkScanViewErrorFeedback,
        // ignore: deprecated_member_use_from_same_package
        SparkScanViewFeedback,
        // ignore: deprecated_member_use_from_same_package
        SparkScanViewSuccessFeedback;
export 'src/spark/spark_scan_toast_settings.dart' show SparkScanToastSettings;
export 'src/spark/spark_scan_barcode_feedback.dart'
    show SparkScanBarcodeFeedback, SparkScanBarcodeErrorFeedback, SparkScanBarcodeSuccessFeedback;
