/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

abstract class SparkScanViewFeedback extends Serializable {}

class SparkScanViewErrorFeedback implements SparkScanViewFeedback {
  final Color? _visualFeedbackColor;
  final String _message;
  final Duration _resumeCapturingDelay;

  SparkScanViewErrorFeedback._(this._message, this._resumeCapturingDelay, this._visualFeedbackColor);

  SparkScanViewErrorFeedback(String message, Duration resumeCapturingDelay, Color? visualFeedbackColor)
      : this._(message, resumeCapturingDelay, visualFeedbackColor);

  Color? get visualFeedbackColor {
    return _visualFeedbackColor;
  }

  String get message {
    return _message;
  }

  Duration get resumeCapturingDelay {
    return _resumeCapturingDelay;
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'error',
      'message': _message,
      'resumeCapturingDelay': _resumeCapturingDelay.inMilliseconds
    };
    if (_visualFeedbackColor != null) {
      json['visualFeedbackColor'] = _visualFeedbackColor;
    }
    return json;
  }
}

class SparkScanViewSuccessFeedback extends SparkScanViewFeedback {
  final Color? _visualFeedbackColor;

  SparkScanViewSuccessFeedback._(this._visualFeedbackColor);

  SparkScanViewSuccessFeedback(Color? visualFeedbackColor) : this._(visualFeedbackColor);

  Color? get visualFeedbackColor {
    return _visualFeedbackColor;
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'success',
    };
    if (_visualFeedbackColor != null) {
      json['visualFeedbackColor'] = _visualFeedbackColor;
    }
    return json;
  }
}
