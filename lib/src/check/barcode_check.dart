/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode_plugin_events.dart';
import 'barcode_check_defaults.dart';
import 'barcode_check_feedback.dart';
import 'barcode_check_function_names.dart';
import 'barcode_check_session.dart';
import 'barcode_check_settings.dart';

abstract class BarcodeCheckListener {
  static const String _barcodeCheckListenerDidUpdateSession = 'BarcodeCheckListener.didUpdateSession';

  Future<void> didUpdateSession(
      BarcodeCheck barcodeCheck, BarcodeCheckSession session, Future<FrameData> getFrameData());
}

class BarcodeCheck extends Serializable {
  late _BarcodeCheckListenerController _controller;

  BarcodeCheckSettings _settings;

  final List<BarcodeCheckListener> _listeners = [];

  BarcodeCheck._(DataCaptureContext? context, this._settings) {
    _controller = _BarcodeCheckListenerController.forBarcodeCheck(this);
  }

  BarcodeCheck.forContext(DataCaptureContext context, BarcodeCheckSettings settings) : this._(context, settings);

  static CameraSettings get recommendedCameraSettings => CameraSettings(
        BarcodeCheckDefaults.recommendedCameraSettings.preferredResolution,
        BarcodeCheckDefaults.recommendedCameraSettings.zoomFactor,
        BarcodeCheckDefaults.recommendedCameraSettings.focusRange,
        BarcodeCheckDefaults.recommendedCameraSettings.focusGestureStrategy,
        BarcodeCheckDefaults.recommendedCameraSettings.zoomGestureZoomFactor,
        properties: BarcodeCheckDefaults.recommendedCameraSettings.properties,
        shouldPreferSmoothAutoFocus: BarcodeCheckDefaults.recommendedCameraSettings.shouldPreferSmoothAutoFocus,
      );

  BarcodeCheckFeedback _feedback = BarcodeCheckFeedback();

  BarcodeCheckFeedback get feedback => _feedback;

  set feedback(BarcodeCheckFeedback newValue) {
    _feedback = newValue;
    _controller.updateFeedback(newValue);
  }

  Future<void> applySettings(BarcodeCheckSettings settings) {
    _settings = settings;
    return _controller.applyNewSettings(settings);
  }

  void addListener(BarcodeCheckListener listener) {
    if (_listeners.isEmpty) {
      _controller.subscribeListeners();
    }

    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void removeListener(BarcodeCheckListener listener) {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {'type': 'barcodeCheck', 'settings': _settings.toMap(), 'feedback': _feedback.toMap()};
  }
}

class _BarcodeCheckListenerController {
  final MethodChannel _methodChannel = const MethodChannel(BarcodeCheckFunctionNames.methodsChannelName);
  final BarcodeCheck _mode;
  StreamSubscription<dynamic>? _barcodeCheckSubscription;

  _BarcodeCheckListenerController.forBarcodeCheck(this._mode);

  Future<void> applyNewSettings(BarcodeCheckSettings settings) {
    return _methodChannel
        .invokeMethod(BarcodeCheckFunctionNames.applyBarcodeCheckModeSettings, jsonEncode(settings.toMap()))
        .then((value) => null, onError: _onError);
  }

  Future<void> updateFeedback(BarcodeCheckFeedback newValue) {
    return _methodChannel
        .invokeMethod(BarcodeCheckFunctionNames.updateFeedback, jsonEncode(newValue.toMap()))
        .onError(_onError);
  }

  void subscribeListeners() {
    if (_barcodeCheckSubscription != null) return;

    _methodChannel
        .invokeMethod(BarcodeCheckFunctionNames.addBarcodeCheckListener)
        .then((value) => _listenForEvents(), onError: _onError);
  }

  StreamSubscription _listenForEvents() {
    return _barcodeCheckSubscription = BarcodePluginEvents.barcodeCheckEventStream.listen((event) async {
      var payload = jsonDecode(event as String);
      if (payload['event'] as String == BarcodeCheckListener._barcodeCheckListenerDidUpdateSession) {
        if (_mode._listeners.isNotEmpty && payload.containsKey('session')) {
          var session = BarcodeCheckSession.fromJSON(payload);
          await _notifyDidUpdateListeners(session);
        }
        _methodChannel
            .invokeMethod(BarcodeCheckFunctionNames.barcodeCheckFinishDidUpdateSession)
            .then((value) => null, onError: (error, stack) => log(error));
      }
    });
  }

  Future<void> _notifyDidUpdateListeners(BarcodeCheckSession session) async {
    for (var listener in _mode._listeners) {
      await listener.didUpdateSession(_mode, session, () => _getLastFrameData(session));
    }
  }

  Future<FrameData> _getLastFrameData(BarcodeCheckSession session) {
    return _methodChannel
        .invokeMethod(BarcodeCheckFunctionNames.getFrameData, session.frameId)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: _onError);
  }

  void unsubscribeListeners() {
    _barcodeCheckSubscription?.cancel();
    _methodChannel
        .invokeMethod(BarcodeCheckFunctionNames.removeBarcodeCheckListener)
        .then((value) => null, onError: _onError);

    _barcodeCheckSubscription = null;
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }
}
