/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/capture/barcode_capture_function_names.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeCaptureFeedback implements Serializable {
  late _BarcodeCaptureFeedbackController _controller;

  BarcodeCaptureFeedback() {
    _controller = _BarcodeCaptureFeedbackController(this);
  }
  Feedback _success = Feedback.defaultFeedback;

  Feedback get success => _success;

  set success(Feedback newValue) {
    _success = newValue;
    _controller.updateFeedback();
  }

  static BarcodeCaptureFeedback get defaultFeedback => BarcodeCaptureFeedback();

  @override
  Map<String, dynamic> toMap() {
    return {'success': success.toMap()};
  }
}

class _BarcodeCaptureFeedbackController {
  final MethodChannel _methodChannel = MethodChannel(BarcodeCaptureFunctionNames.methodsChannelName);
  final BarcodeCaptureFeedback _feedback;

  _BarcodeCaptureFeedbackController(this._feedback);

  Future<void> updateFeedback() {
    return _methodChannel.invokeMethod(BarcodeCaptureFunctionNames.updateFeedback, jsonEncode(_feedback.toMap()));
  }
}
