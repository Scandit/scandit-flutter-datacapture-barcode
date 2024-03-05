/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode_plugin_events.dart';
import 'spark_scan_feedback.dart';
import 'spark_scan_function_names.dart';
import 'spark_scan_session.dart';
import 'spark_scan_settings.dart';

class SparkScan extends DataCaptureMode {
  bool _enabled = true;
  bool _isInCallback = false;
  late _SparkScanController _controller;
  SparkScanSettings _settings;
  final List<SparkScanListener> _listeners = [];
  SparkScanFeedback _feedback = SparkScanFeedback.defaultFeedback;

  SparkScan._(this._settings) {
    _controller = _SparkScanController.forSparkScan(this);
    _controller.updateSparkScanMode();
  }

  SparkScan() : this._(SparkScanSettings());

  SparkScan.withSettings(SparkScanSettings settings) : this._(settings);

  bool get isEnabled => _enabled;

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

  SparkScanFeedback get feedback => _feedback;

  set feedback(SparkScanFeedback newValue) {
    _feedback = newValue;
    _didChange();
  }

  Future<void> _didChange() {
    return _controller.updateSparkScanMode();
  }

  @override
  Map<String, dynamic> toMap() {
    return {'type': 'sparkScan', 'enabled': _enabled, 'feedback': _feedback.toMap(), 'settings': _settings.toMap()};
  }
}

abstract class SparkScanListener {
  static const String _didUpdateSessionEventName = 'SparkScanListener.didUpdateSession';
  static const String _didScanEventName = 'SparkScanListener.didScan';

  void didUpdateSession(SparkScan sparkScan, SparkScanSession session, Future<FrameData> getFrameData());
  void didScan(SparkScan sparkScan, SparkScanSession session, Future<FrameData> getFrameData());
}

class _SparkScanController {
  final MethodChannel _methodChannel = MethodChannel(SparkScanFunctionNames.methodsChannelName);
  final SparkScan _sparkScan;
  StreamSubscription<dynamic>? _sparkScanSubscription;

  _SparkScanController.forSparkScan(this._sparkScan);

  void subscribeListeners() {
    _methodChannel
        .invokeMethod(SparkScanFunctionNames.addSparkScanListener)
        .then((value) => _setupBarcodeCaptureSubscription(), onError: _onError);
  }

  void _setupBarcodeCaptureSubscription() {
    _sparkScanSubscription = BarcodePluginEvents.sparkScanEventStream.listen((event) {
      if (_sparkScan._listeners.isEmpty) return;

      var eventJSON = jsonDecode(event);
      var session = SparkScanSession.fromJSON(jsonDecode(eventJSON['session']));
      var eventName = eventJSON['event'] as String;
      if (eventName == SparkScanListener._didScanEventName) {
        _notifyListenersOfDidScan(session);
        _methodChannel
            .invokeMethod(SparkScanFunctionNames.sparkScanFinishDidScan, _sparkScan.isEnabled)
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: (error) => print(error));
      } else if (eventName == SparkScanListener._didUpdateSessionEventName) {
        _notifyListenersOfDidUpateSession(session);
        _methodChannel
            .invokeMethod(SparkScanFunctionNames.sparkScanFinishDidUpdateSession, _sparkScan.isEnabled)
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: (error) => print(error));
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

  void _notifyListenersOfDidUpateSession(SparkScanSession session) {
    _sparkScan._isInCallback = true;
    for (var listener in _sparkScan._listeners) {
      listener.didUpdateSession(_sparkScan, session, _getLastFrameData);
    }
    _sparkScan._isInCallback = false;
  }

  Future<FrameData> _getLastFrameData() {
    return _methodChannel
        .invokeMethod(SparkScanFunctionNames.getLastFrameData)
        .then((value) => getFrom(value as String), onError: _onError);
  }

  DefaultFrameData getFrom(String response) {
    final decoded = jsonDecode(response);
    return DefaultFrameData.fromJSON(decoded);
  }

  void _notifyListenersOfDidScan(SparkScanSession session) {
    _sparkScan._isInCallback = true;
    for (var listener in _sparkScan._listeners) {
      listener.didScan(_sparkScan, session, _getLastFrameData);
    }
    _sparkScan._isInCallback = false;
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    print(error);

    if (stackTrace != null) {
      print(stackTrace);
    }

    throw error;
  }
}
