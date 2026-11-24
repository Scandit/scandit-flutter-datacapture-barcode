/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show buildSparkScanBarcodeErrorFeedback, buildSparkScanBarcodeSuccessFeedback;
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'spark_scan_defaults.dart';

/// Used to emit feedback when capturing barcodes.
///
/// Added in version 6.23.0
abstract class SparkScanBarcodeFeedback extends Serializable {
  /// The default success feedback object.
  ///
  /// Added in version 6.23.0
  static Feedback? defaultSuccessFeedback() {
    return SparkScanDefaults.sparkScanFeedbackDefaults.success.feedbackDefault;
  }

  /// The default error feedback object.
  ///
  /// Added in version 6.23.0
  static Feedback? defaultErrorFeedback() {
    return SparkScanDefaults.sparkScanFeedbackDefaults.error.feedbackDefault;
  }
}

/// Used to display and emit an error feedback when capturing barcodes.
///
/// Added in version 6.23.0
class SparkScanBarcodeErrorFeedback implements SparkScanBarcodeFeedback {
  final Duration _resumeCapturingDelay;
  final Feedback? _feedback;
  final String _message;
  final Color _visualFeedbackColor;
  final Brush _brush;

  /// Constructs an error feedback.
  ///
  /// Added in version 6.23.0
  SparkScanBarcodeErrorFeedback(
      this._message, this._resumeCapturingDelay, this._visualFeedbackColor, this._brush, this._feedback);

  SparkScanBarcodeErrorFeedback.fromMessage(String message, Duration resumeCapturingDelay)
      : this(
            message,
            resumeCapturingDelay,
            SparkScanDefaults.sparkScanFeedbackDefaults.error.visualFeedbackColor,
            SparkScanDefaults.sparkScanFeedbackDefaults.error.brush,
            SparkScanDefaults.sparkScanFeedbackDefaults.error.feedbackDefault);

  /// The error message to display when a wrong barcode was captured.
  ///
  /// Added in version 6.23.0
  String get message => _message;

  /// The color of the visual error feedback.
  ///
  /// Added in version 6.23.0
  Color get visualFeedbackColor => _visualFeedbackColor;

  /// The brush used for the error feedback.
  ///
  /// Added in version 6.23.0
  Brush get brush => _brush;

  /// The feedback used for the error feedback.
  ///
  /// Added in version 6.23.0
  Feedback? get feedback => _feedback;

  /// The time interval after which to resume the capturing process.
  ///
  /// Added in version 6.23.0
  Duration get resumeCapturingDelay => _resumeCapturingDelay;

  @override
  Map<String, dynamic> toMap() {
    var barcodeFeedback = <String, dynamic>{
      'message': _message,
      'visualFeedbackColor': _visualFeedbackColor.jsonValue,
      'resumeCapturingDelay': _resumeCapturingDelay.inSeconds,
      'brush': _brush.toMap(),
    };
    if (_feedback != null) {
      barcodeFeedback['feedback'] = _feedback.toMap();
    }
    return buildSparkScanBarcodeErrorFeedback(type: 'error', barcodeFeedback: barcodeFeedback);
  }
}

/// Used to display and emit a success feedback when capturing barcodes.
///
/// Added in version 6.23.0
class SparkScanBarcodeSuccessFeedback implements SparkScanBarcodeFeedback {
  final Color _visualFeedbackColor;
  final Brush _brush;
  final Feedback? _feedback;

  SparkScanBarcodeSuccessFeedback._(this._visualFeedbackColor, this._brush, this._feedback);

  /// Constructs a success feedback.
  ///
  /// Added in version 6.23.0
  SparkScanBarcodeSuccessFeedback()
      : this._(
            SparkScanDefaults.sparkScanFeedbackDefaults.success.visualFeedbackColor,
            SparkScanDefaults.sparkScanFeedbackDefaults.success.brush,
            SparkScanDefaults.sparkScanFeedbackDefaults.success.feedbackDefault);

  SparkScanBarcodeSuccessFeedback.fromVisualFeedbackColor(Color visualFeedbackColor, Brush brush, Feedback? feedback)
      : this._(visualFeedbackColor, brush, feedback);

  /// The color of the visual success feedback.
  ///
  /// Added in version 6.23.0
  Color get visualFeedbackColor => _visualFeedbackColor;

  /// The brush used for the success feedback.
  ///
  /// Added in version 6.23.0
  Brush get brush => _brush;

  /// The feedback used for the success feedback.
  ///
  /// Added in version 6.23.0
  Feedback? get feedback => _feedback;

  @override
  Map<String, dynamic> toMap() {
    var barcodeFeedback = <String, dynamic>{
      'visualFeedbackColor': _visualFeedbackColor.jsonValue,
      'brush': _brush.toMap(),
    };
    if (_feedback != null) {
      barcodeFeedback['feedback'] = _feedback.toMap();
    }
    return buildSparkScanBarcodeSuccessFeedback(type: 'success', barcodeFeedback: barcodeFeedback);
  }
}
