/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_count_defaults.dart';
import 'barcode_count_function_names.dart';

class BarcodeCountFeedback implements Serializable {
  late _BarcodeCountFeedbackController _controller;

  BarcodeCountFeedback() {
    _controller = _BarcodeCountFeedbackController(this);
  }

  Feedback _success = BarcodeCountDefaults.barcodeCountFeedbackDefaults.success;

  Feedback get success => _success;

  set success(Feedback newValue) {
    _success = newValue;
    _update();
  }

  Feedback _failure = BarcodeCountDefaults.barcodeCountFeedbackDefaults.failure;

  Feedback get failure => _failure;

  set failure(Feedback newValue) {
    _failure = newValue;
    _update();
  }

  static BarcodeCountFeedback get defaultFeedback => BarcodeCountFeedback();

  void _update() {
    _controller.updateFeedback();
  }

  @override
  Map<String, dynamic> toMap() {
    return {'success': success.toMap(), 'failure': failure.toMap()};
  }
}

class _BarcodeCountFeedbackController {
  final MethodChannel _methodChannel = MethodChannel(BarcodeCountFunctionNames.methodsChannelName);
  final BarcodeCountFeedback _feedback;

  _BarcodeCountFeedbackController(this._feedback);

  Future<void> updateFeedback() {
    return _methodChannel.invokeMethod(BarcodeCountFunctionNames.updateFeedback, jsonEncode(_feedback.toMap()));
  }
}
