/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'dart:convert';

import 'barcode_check_defaults.dart';
import 'barcode_check_function_names.dart';

class BarcodeCheckFeedback implements Serializable {
  late _BarcodeCheckFeedbackController _controller;

  BarcodeCheckFeedback() {
    _controller = _BarcodeCheckFeedbackController(this);
  }

  Feedback _scanned = BarcodeCheckDefaults.feedbackDefaults.scanned;

  Feedback get scanned => _scanned;

  set scanned(Feedback newValue) {
    _scanned = newValue;
    _update();
  }

  Feedback _tapped = BarcodeCheckDefaults.feedbackDefaults.tapped;

  Feedback get tapped => _tapped;

  set tapped(Feedback newValue) {
    _tapped = newValue;
    _update();
  }

  static BarcodeCheckFeedback get defaultFeedback => BarcodeCheckFeedback();

  void _update() {
    _controller.updateFeedback();
  }

  @override
  Map<String, dynamic> toMap() {
    return {'scanned': scanned.toMap(), 'tapped': tapped.toMap()};
  }
}

class _BarcodeCheckFeedbackController {
  final MethodChannel _methodChannel = const MethodChannel(BarcodeCheckFunctionNames.methodsChannelName);
  final BarcodeCheckFeedback _feedback;

  _BarcodeCheckFeedbackController(this._feedback);

  Future<void> updateFeedback() {
    return _methodChannel.invokeMethod(BarcodeCheckFunctionNames.updateFeedback, jsonEncode(_feedback.toMap()));
  }
}
