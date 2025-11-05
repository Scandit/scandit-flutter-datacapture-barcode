/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode_plugin_events.dart';
import 'spark_scan_function_names.dart';
import 'spark_scan_session.dart';
import 'spark_scan_settings.dart';

class SparkScan extends DataCaptureMode {
  bool _enabled = true;
  bool _isInCallback = false;
  late _SparkScanController _controller;
  SparkScanSettings _settings;
  final List<SparkScanListener> _listeners = [];

  SparkScan._(this._settings) {
    _controller = _SparkScanController.forSparkScan(this);
    _controller.updateSparkScanMode();
  }

  SparkScan() : this._(SparkScanSettings());

  SparkScan.withSettings(SparkScanSettings settings) : this._(settings);

  @override
  bool get isEnabled => _enabled;

  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    if (_isInCallback) {
      return;
    }
    _controller.setModeEnabledState(newValue);
  }

  Future<void> applySettings(SparkScanSettings settings) {
    _settings = settings;
    return _didChange();
  }

  void addListener(SparkScanListener listener) {
    if (_listeners.isEmpty) {
      _controller.subscribeListeners();
    }
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void removeListener(SparkScanListener listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  Future<void> _didChange() {
    return _controller.updateSparkScanMode();
  }

  @override
  Map<String, dynamic> toMap() {
    return {'type': 'sparkScan', 'enabled': _enabled, 'settings': _settings.toMap()};
  }
}

abstract class SparkScanListener {
  static const String _didUpdateSessionEventName = 'SparkScanListener.didUpdateSession';
  static const String _didScanEventName = 'SparkScanListener.didScan';

  Future<void> didUpdateSession(SparkScan sparkScan, SparkScanSession session, Future<FrameData> getFrameData());
  Future<void> didScan(SparkScan sparkScan, SparkScanSession session, Future<FrameData> getFrameData());
}

class _SparkScanController {
  final MethodChannel _methodChannel = const MethodChannel(SparkScanFunctionNames.methodsChannelName);
  final SparkScan _sparkScan;
  StreamSubscription<dynamic>? _sparkScanSubscription;

  _SparkScanController.forSparkScan(this._sparkScan);

  void subscribeListeners() {
    _methodChannel
        .invokeMethod(SparkScanFunctionNames.addSparkScanListener)
        .then((value) => _setupBarcodeCaptureSubscription(), onError: _onError);
  }

  void _setupBarcodeCaptureSubscription() {
    _sparkScanSubscription = BarcodePluginEvents.sparkScanEventStream.listen((event) async {
      if (_sparkScan._listeners.isEmpty) return;

      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;

      if (eventName == SparkScanListener._didScanEventName) {
        var session = SparkScanSession.fromJSON(eventJSON);
        await _notifyListenersOfDidScan(session);
        _methodChannel
            .invokeMethod(SparkScanFunctionNames.sparkScanFinishDidScan, _sparkScan.isEnabled)
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: (error) => log(error));
      } else if (eventName == SparkScanListener._didUpdateSessionEventName) {
        var session = SparkScanSession.fromJSON(eventJSON);
        await _notifyListenersOfDidUpateSession(session);
        _methodChannel
            .invokeMethod(SparkScanFunctionNames.sparkScanFinishDidUpdateSession, _sparkScan.isEnabled)
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: (error) => log(error));
      }
    });
  }

  void unsubscribeListeners() {
    _sparkScanSubscription?.cancel();
    _methodChannel
        .invokeMethod(SparkScanFunctionNames.removeSparkScanListener)
        .then((value) => null, onError: _onError);
  }

  Future<void> updateSparkScanMode() {
    return _methodChannel
        .invokeMethod(SparkScanFunctionNames.updateSparkScanMode, jsonEncode(_sparkScan.toMap()))
        .onError(_onError);
  }

  void setModeEnabledState(bool newValue) {
    _methodChannel
        .invokeMethod(SparkScanFunctionNames.setModeEnabledState, newValue)
        .then((value) => null, onError: _onError);
  }

  Future<void> _notifyListenersOfDidUpateSession(SparkScanSession session) async {
    _sparkScan._isInCallback = true;
    for (var listener in _sparkScan._listeners) {
      await listener.didUpdateSession(_sparkScan, session, () => _getLastFrameData(session));
    }
    _sparkScan._isInCallback = false;
  }

  Future<FrameData> _getLastFrameData(SparkScanSession session) {
    return _methodChannel
        .invokeMethod(SparkScanFunctionNames.getLastFrameData, session.frameId)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: _onError);
  }

  Future<void> _notifyListenersOfDidScan(SparkScanSession session) async {
    _sparkScan._isInCallback = true;
    for (var listener in _sparkScan._listeners) {
      await listener.didScan(_sparkScan, session, () => _getLastFrameData(session));
    }
    _sparkScan._isInCallback = false;
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }
}
