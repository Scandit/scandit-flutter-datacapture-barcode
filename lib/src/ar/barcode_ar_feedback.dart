/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'dart:convert';

import 'barcode_ar_defaults.dart';
import 'barcode_ar_function_names.dart';

class BarcodeArFeedback implements Serializable {
  late _BarcodeArFeedbackController _controller;

  BarcodeArFeedback() {
    _controller = _BarcodeArFeedbackController(this);
  }

  Feedback _scanned = BarcodeArDefaults.feedbackDefaults.scanned;

  Feedback get scanned => _scanned;

  set scanned(Feedback newValue) {
    _scanned = newValue;
    _update();
  }

  Feedback _tapped = BarcodeArDefaults.feedbackDefaults.tapped;

  Feedback get tapped => _tapped;

  set tapped(Feedback newValue) {
    _tapped = newValue;
    _update();
  }

  static BarcodeArFeedback get defaultFeedback => BarcodeArFeedback();

  void _update() {
    _controller.updateFeedback();
  }

  @override
  Map<String, dynamic> toMap() {
    return {'scanned': scanned.toMap(), 'tapped': tapped.toMap()};
  }
}

class _BarcodeArFeedbackController {
  final MethodChannel _methodChannel = const MethodChannel(BarcodeArFunctionNames.methodsChannelName);
  final BarcodeArFeedback _feedback;

  _BarcodeArFeedbackController(this._feedback);

  Future<void> updateFeedback() {
    return _methodChannel.invokeMethod(BarcodeArFunctionNames.updateFeedback, jsonEncode(_feedback.toMap()));
  }
}
