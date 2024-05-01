/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'spark_scan_defaults.dart';

abstract class SparkScanBarcodeFeedback extends Serializable {
  static Feedback? defaultSuccessFeedback() {
    return SparkScanDefaults.sparkScanFeedbackDefaults.success.feedbackDefault;
  }

  static Feedback? defaultErrorFeedback() {
    return SparkScanDefaults.sparkScanFeedbackDefaults.error.feedbackDefault;
  }
}

class SparkScanBarcodeErrorFeedback implements SparkScanBarcodeFeedback {
  final Duration _resumeCapturingDelay;
  final Feedback? _feedback;
  final String _message;
  final Color _visualFeedbackColor;
  final Brush _brush;

  SparkScanBarcodeErrorFeedback(
      this._message, this._resumeCapturingDelay, this._visualFeedbackColor, this._brush, this._feedback);

  SparkScanBarcodeErrorFeedback.fromMessage(String message, Duration resumeCapturingDelay)
      : this(
            message,
            resumeCapturingDelay,
            SparkScanDefaults.sparkScanFeedbackDefaults.error.visualFeedbackColor,
            SparkScanDefaults.sparkScanFeedbackDefaults.error.brush,
            SparkScanDefaults.sparkScanFeedbackDefaults.error.feedbackDefault);

  String get message => _message;

  Color get visualFeedbackColor => _visualFeedbackColor;

  Brush get brush => _brush;

  Feedback? get feedback => _feedback;

  Duration get resumeCapturingDelay => _resumeCapturingDelay;

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'error',
      'barcodeFeedback': {
        'message': _message,
        'visualFeedbackColor': _visualFeedbackColor.jsonValue,
        'resumeCapturingDelay': _resumeCapturingDelay.inSeconds,
        'brush': _brush.toMap(),
      }
    };
    if (_feedback != null) {
      json['barcodeFeedback']['feedback'] = _feedback?.toMap();
    }
    return json;
  }
}

class SparkScanBarcodeSuccessFeedback implements SparkScanBarcodeFeedback {
  final Color _visualFeedbackColor;
  final Brush _brush;
  final Feedback? _feedback;

  SparkScanBarcodeSuccessFeedback._(this._visualFeedbackColor, this._brush, this._feedback);

  SparkScanBarcodeSuccessFeedback()
      : this._(
            SparkScanDefaults.sparkScanFeedbackDefaults.success.visualFeedbackColor,
            SparkScanDefaults.sparkScanFeedbackDefaults.success.brush,
            SparkScanDefaults.sparkScanFeedbackDefaults.success.feedbackDefault);

  SparkScanBarcodeSuccessFeedback.fromVisualFeedbackColor(Color visualFeedbackColor, Brush brush, Feedback? feedback)
      : this._(visualFeedbackColor, brush, feedback);

  Color get visualFeedbackColor => _visualFeedbackColor;

  Brush get brush => _brush;

  Feedback? get feedback => _feedback;

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'success',
      'barcodeFeedback': {
        'visualFeedbackColor': _visualFeedbackColor.jsonValue,
        'brush': _brush.toMap(),
      },
    };
    if (_feedback != null) {
      json['barcodeFeedback']['feedback'] = _feedback?.toMap();
    }
    return json;
  }
}
