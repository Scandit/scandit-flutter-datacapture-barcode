/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';

import 'barcode_selection_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_selection_function_names.dart';

class BarcodeSelectionFeedback implements Serializable {
  late _BarcodeSelectionFeedbackController _controller;

  BarcodeSelectionFeedback() {
    _controller = _BarcodeSelectionFeedbackController(this);
  }

  Feedback _selection = BarcodeSelectionDefaults.barcodeSelectionFeedbackDefaults.selection;

  Feedback get selection => _selection;

  set selection(Feedback newValue) {
    _selection = newValue;
    _controller.updateFeedback();
  }

  static BarcodeSelectionFeedback get defaultFeedback => BarcodeSelectionFeedback();

  @override
  Map<String, dynamic> toMap() {
    return {'selection': selection.toMap()};
  }
}

class _BarcodeSelectionFeedbackController {
  final MethodChannel _methodChannel = const MethodChannel(BarcodeSelectionFunctionNames.methodsChannelName);
  final BarcodeSelectionFeedback _feedback;

  _BarcodeSelectionFeedbackController(this._feedback);

  Future<void> updateFeedback() {
    return _methodChannel.invokeMethod(BarcodeSelectionFunctionNames.updateFeedback, jsonEncode(_feedback.toMap()));
  }
}
