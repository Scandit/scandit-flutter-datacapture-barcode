/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_batch_defaults.dart';
import 'barcode_batch_function_names.dart';
import 'barcode_batch_session.dart';
import 'barcode_batch_settings.dart';

class BarcodeBatch extends DataCaptureMode {
  bool _enabled = true;
  BarcodeBatchSettings _settings;
  final List<BarcodeBatchListener> _listeners = [];
  late _BarcodeBatchListenerController _controller;

  @override
  // ignore: unnecessary_overrides
  DataCaptureContext? get context => super.context;

  @override
  bool get isEnabled => _enabled;

  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    _controller.setModeEnabledState(newValue);
  }

  static CameraSettings get recommendedCameraSettings => CameraSettings(
        BarcodeBatchDefaults.recommendedCameraSettings.preferredResolution,
        BarcodeBatchDefaults.recommendedCameraSettings.zoomFactor,
        BarcodeBatchDefaults.recommendedCameraSettings.focusRange,
        BarcodeBatchDefaults.recommendedCameraSettings.focusGestureStrategy,
        BarcodeBatchDefaults.recommendedCameraSettings.zoomGestureZoomFactor,
        properties: BarcodeBatchDefaults.recommendedCameraSettings.properties,
        shouldPreferSmoothAutoFocus: BarcodeBatchDefaults.recommendedCameraSettings.shouldPreferSmoothAutoFocus,
      );

  BarcodeBatch._(DataCaptureContext? context, this._settings) {
    _controller = _BarcodeBatchListenerController.forBarcodeBatch(this);
    if (context != null) {
      context.addMode(this);
    }
  }

  BarcodeBatch.forContext(DataCaptureContext context, BarcodeBatchSettings settings) : this._(context, settings);

  Future<void> applySettings(BarcodeBatchSettings settings) {
    _settings = settings;
    return _controller.applyNewSettings(settings);
  }

  void addListener(BarcodeBatchListener listener) {
    if (_listeners.isEmpty) {
      _controller.subscribeListeners();
    }

    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void removeListener(BarcodeBatchListener listener) {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {'type': 'barcodeTracking', 'settings': _settings.toMap()};
  }
}

abstract class BarcodeBatchListener {
  static const String _barcodeBatchListenerDidUpdateSession = 'BarcodeBatchListener.didUpdateSession';
  Future<void> didUpdateSession(
      BarcodeBatch barcodeBatch, BarcodeBatchSession session, Future<FrameData> getFrameData());
}

class _BarcodeBatchListenerController {
  final MethodChannel _methodChannel = const MethodChannel(BarcodeBatchFunctionNames.methodsChannelName);
  final BarcodeBatch _barcodeBatch;
  StreamSubscription<dynamic>? _barcodeBatchSubscription;

  _BarcodeBatchListenerController.forBarcodeBatch(this._barcodeBatch);

  void subscribeListeners() {
    if (_barcodeBatchSubscription != null) return;

    _methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.addBarcodeBatchListener)
        .then((value) => _listenForEvents(), onError: _onError);
  }

  StreamSubscription _listenForEvents() {
    return _barcodeBatchSubscription = BarcodePluginEvents.barcodeBatchEventStream.listen((event) async {
      var payload = jsonDecode(event as String);
      if (payload['event'] as String == BarcodeBatchListener._barcodeBatchListenerDidUpdateSession) {
        if (_barcodeBatch._listeners.isNotEmpty && payload.containsKey('session')) {
          var session = BarcodeBatchSession.fromJSON(payload);
          await _notifyDidUpdateListeners(session);
        }
        _methodChannel
            .invokeMethod(BarcodeBatchFunctionNames.barcodeBatchFinishDidUpdateSession, _barcodeBatch.isEnabled)
            .then((value) => null, onError: (error, stack) => log(error));
      }
    });
  }

  Future<void> updateMode() {
    return _methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.updateBarcodeBatchMode, jsonEncode(_barcodeBatch.toMap()))
        .then((value) => null, onError: _onError);
  }

  Future<void> applyNewSettings(BarcodeBatchSettings settings) {
    return _methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.applyBarcodeBatchModeSettings, jsonEncode(settings.toMap()))
        .then((value) => null, onError: _onError);
  }

  void unsubscribeListeners() {
    _barcodeBatchSubscription?.cancel();
    _methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.removeBarcodeBatchListener)
        .then((value) => null, onError: _onError);

    _barcodeBatchSubscription = null;
  }

  Future<void> _notifyDidUpdateListeners(BarcodeBatchSession session) async {
    for (var listener in _barcodeBatch._listeners) {
      await listener.didUpdateSession(_barcodeBatch, session, () => _getLastFrameData(session));
    }
  }

  Future<FrameData> _getLastFrameData(BarcodeBatchSession session) {
    return _methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.getLastFrameData, session.frameId)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: _onError);
  }

  void setModeEnabledState(bool newValue) {
    _methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.setModeEnabledState, newValue)
        .then((value) => null, onError: _onError);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }
}
