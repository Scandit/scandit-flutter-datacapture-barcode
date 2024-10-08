/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';

import 'barcode_find_defaults.dart';
import 'barcode_find_function_names.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeFindFeedback implements Serializable {
  late _BarcodeFindFeedbackController _controller;

  BarcodeFindFeedback() {
    _controller = _BarcodeFindFeedbackController(this);
  }

  Feedback _found = BarcodeFindDefaults.barcodeFindFeedbackDefaults.found;

  Feedback get found => _found;

  set found(Feedback newValue) {
    _found = newValue;
    _controller.updateFeedback();
  }

  Feedback _itemListUpdated = BarcodeFindDefaults.barcodeFindFeedbackDefaults.itemListUpdated;

  Feedback get itemListUpdated => _itemListUpdated;

  set itemListUpdated(Feedback newValue) {
    _itemListUpdated = newValue;
    _controller.updateFeedback();
  }

  static BarcodeFindFeedback get defaultFeedback => BarcodeFindFeedback();

  @override
  Map<String, dynamic> toMap() {
    return {
      'found': found.toMap(),
      'itemListUpdated': itemListUpdated.toMap(),
    };
  }
}

class _BarcodeFindFeedbackController {
  final MethodChannel _methodChannel = MethodChannel(BarcodeFindFunctionNames.methodsChannelName);
  final BarcodeFindFeedback _feedback;

  _BarcodeFindFeedbackController(this._feedback);

  Future<void> updateFeedback() {
    return _methodChannel.invokeMethod(BarcodeFindFunctionNames.updateFeedback, jsonEncode(_feedback.toMap()));
  }
}
