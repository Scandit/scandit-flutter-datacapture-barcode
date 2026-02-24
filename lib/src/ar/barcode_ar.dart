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
import 'barcode_ar_defaults.dart';
import 'barcode_ar_feedback.dart';
import 'barcode_ar_function_names.dart';
import 'barcode_ar_session.dart';
import 'barcode_ar_settings.dart';

abstract class BarcodeArListener {
  static const String _barcodeArListenerDidUpdateSession = 'BarcodeArListener.didUpdateSession';

  Future<void> didUpdateSession(BarcodeAr barcodeAr, BarcodeArSession session, Future<FrameData> getFrameData());
}

class BarcodeAr extends Serializable {
  late _BarcodeArListenerController _controller;

  BarcodeArSettings _settings;

  final List<BarcodeArListener> _listeners = [];

  BarcodeAr._(DataCaptureContext? context, this._settings) {
    _controller = _BarcodeArListenerController.forBarcodeAr(this);
  }

  BarcodeAr.forContext(DataCaptureContext context, BarcodeArSettings settings) : this._(context, settings);

  static CameraSettings get recommendedCameraSettings => CameraSettings(
        BarcodeArDefaults.recommendedCameraSettings.preferredResolution,
        BarcodeArDefaults.recommendedCameraSettings.zoomFactor,
        BarcodeArDefaults.recommendedCameraSettings.focusRange,
        BarcodeArDefaults.recommendedCameraSettings.focusGestureStrategy,
        BarcodeArDefaults.recommendedCameraSettings.zoomGestureZoomFactor,
        properties: BarcodeArDefaults.recommendedCameraSettings.properties,
        shouldPreferSmoothAutoFocus: BarcodeArDefaults.recommendedCameraSettings.shouldPreferSmoothAutoFocus,
      );

  BarcodeArFeedback _feedback = BarcodeArFeedback();

  BarcodeArFeedback get feedback => _feedback;

  set feedback(BarcodeArFeedback newValue) {
    _feedback = newValue;
    _controller.updateFeedback(newValue);
  }

  Future<void> applySettings(BarcodeArSettings settings) {
    _settings = settings;
    return _controller.applyNewSettings(settings);
  }

  void addListener(BarcodeArListener listener) {
    if (_listeners.isEmpty) {
      _controller.subscribeListeners();
    }

    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void removeListener(BarcodeArListener listener) {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {'type': 'barcodeAr', 'settings': _settings.toMap(), 'feedback': _feedback.toMap()};
  }
}

class _BarcodeArListenerController {
  final MethodChannel _methodChannel = const MethodChannel(BarcodeArFunctionNames.methodsChannelName);
  final BarcodeAr _mode;
  StreamSubscription<dynamic>? _barcodeArSubscription;

  _BarcodeArListenerController.forBarcodeAr(this._mode);

  Future<void> applyNewSettings(BarcodeArSettings settings) {
    return _methodChannel
        .invokeMethod(BarcodeArFunctionNames.applyBarcodeArModeSettings, jsonEncode(settings.toMap()))
        .then((value) => null, onError: _onError);
  }

  Future<void> updateFeedback(BarcodeArFeedback newValue) {
    return _methodChannel
        .invokeMethod(BarcodeArFunctionNames.updateFeedback, jsonEncode(newValue.toMap()))
        .onError(_onError);
  }

  void subscribeListeners() {
    if (_barcodeArSubscription != null) return;

    _methodChannel
        .invokeMethod(BarcodeArFunctionNames.addBarcodeArListener)
        .then((value) => _listenForEvents(), onError: _onError);
  }

  StreamSubscription _listenForEvents() {
    return _barcodeArSubscription = BarcodePluginEvents.barcodeArEventStream.listen((event) async {
      var payload = jsonDecode(event as String);
      if (payload['event'] as String == BarcodeArListener._barcodeArListenerDidUpdateSession) {
        if (_mode._listeners.isNotEmpty && payload.containsKey('session')) {
          var session = BarcodeArSession.fromJSON(payload);
          await _notifyDidUpdateListeners(session);
        }
        _methodChannel
            .invokeMethod(BarcodeArFunctionNames.barcodeArFinishDidUpdateSession)
            .then((value) => null, onError: (error, stack) => log(error));
      }
    });
  }

  Future<void> _notifyDidUpdateListeners(BarcodeArSession session) async {
    for (var listener in _mode._listeners) {
      await listener.didUpdateSession(_mode, session, () => _getLastFrameData(session));
    }
  }

  Future<FrameData> _getLastFrameData(BarcodeArSession session) {
    return _methodChannel
        .invokeMethod(BarcodeArFunctionNames.getFrameData, session.frameId)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: _onError);
  }

  void unsubscribeListeners() {
    _barcodeArSubscription?.cancel();
    _methodChannel
        .invokeMethod(BarcodeArFunctionNames.removeBarcodeArListener)
        .then((value) => null, onError: _onError);

    _barcodeArSubscription = null;
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }
}
