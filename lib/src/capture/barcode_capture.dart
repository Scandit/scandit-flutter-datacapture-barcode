/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_capture_defaults.dart';
import 'barcode_capture_feedback.dart';
import 'barcode_capture_settings.dart';
import 'barcode_capture_function_names.dart';
import 'barcode_capture_session.dart';

class BarcodeCapture extends DataCaptureMode {
  BarcodeCaptureFeedback _feedback = BarcodeCaptureFeedback.defaultFeedback;
  bool _enabled = true;
  BarcodeCaptureSettings _settings;
  final List<BarcodeCaptureListener> _listeners = [];
  final List<BarcodeCaptureAdvancedListener> _advancedListeners = [];
  late _BarcodeCaptureListenerController _controller;
  bool _isInCallback = false;

  @override
  DataCaptureContext? get context => super.context;

  @override
  bool get isEnabled => _enabled;

  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    if (_isInCallback) {
      return;
    }
    didChange();
  }

  BarcodeCaptureFeedback get feedback => _feedback;

  set feedback(BarcodeCaptureFeedback newValue) {
    _feedback = newValue;
    didChange();
  }

  static CameraSettings get recommendedCameraSettings => _recommendedCameraSettings();

  static CameraSettings _recommendedCameraSettings() {
    var defaults = BarcodeCaptureDefaults.cameraSettingsDefaults;
    return CameraSettings(defaults.preferredResolution, defaults.zoomFactor, defaults.focusRange,
        defaults.focusGestureStrategy, defaults.zoomGestureZoomFactor,
        shouldPreferSmoothAutoFocus: defaults.shouldPreferSmoothAutoFocus);
  }

  BarcodeCapture._(DataCaptureContext? context, this._settings) {
    _controller = _BarcodeCaptureListenerController.forBarcodeCapture(this);

    context?.addMode(this);
  }

  BarcodeCapture.forContext(DataCaptureContext context, BarcodeCaptureSettings settings) : this._(context, settings);

  Future<void> applySettings(BarcodeCaptureSettings settings) {
    _settings = settings;
    return didChange();
  }

  void addListener(BarcodeCaptureListener listener) {
    _checkAndSubscribeListeners();
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void addAdvancedListener(BarcodeCaptureAdvancedListener listener) {
    _checkAndSubscribeListeners();
    if (_advancedListeners.contains(listener)) {
      return;
    }
    _advancedListeners.add(listener);
  }

  void _checkAndSubscribeListeners() {
    if (_listeners.isEmpty && _advancedListeners.isEmpty) {
      _controller.subscribeListeners();
    }
  }

  void removeListener(BarcodeCaptureListener listener) {
    _listeners.remove(listener);
    _checkAndUnsubscribeListeners();
  }

  void removeAdvancedListener(BarcodeCaptureAdvancedListener listener) {
    _advancedListeners.remove(listener);
    _checkAndUnsubscribeListeners();
  }

  void _checkAndUnsubscribeListeners() {
    if (_listeners.isEmpty && _advancedListeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  Future<void> didChange() {
    if (context != null) {
      return context!.update();
    }
    return Future.value();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'barcodeCapture',
      'enabled': _enabled,
      'feedback': _feedback.toMap(),
      'settings': _settings.toMap()
    };
  }
}

abstract class BarcodeCaptureListener {
  static const String _didUpdateSessionEventName = 'barcodeCaptureListener-didUpdateSession';
  static const String _didScanEventName = 'barcodeCaptureListener-didScan';

  void didUpdateSession(BarcodeCapture barcodeCapture, BarcodeCaptureSession session);
  void didScan(BarcodeCapture barcodeCapture, BarcodeCaptureSession session);
}

abstract class BarcodeCaptureAdvancedListener {
  void didUpdateSession(BarcodeCapture barcodeCapture, BarcodeCaptureSession session, Future<FrameData> getFrameData());
  void didScan(BarcodeCapture barcodeCapture, BarcodeCaptureSession session, Future<FrameData> getFrameData());
}

class _BarcodeCaptureListenerController {
  final EventChannel _eventChannel =
      const EventChannel('com.scandit.datacapture.barcode.capture.event/barcode_capture_listener');
  final MethodChannel _methodChannel =
      MethodChannel('com.scandit.datacapture.barcode.capture.method/barcode_capture_listener');
  final BarcodeCapture _barcodeCapture;
  StreamSubscription<dynamic>? _barcodeCaptureSubscription;

  _BarcodeCaptureListenerController.forBarcodeCapture(this._barcodeCapture);

  void subscribeListeners() {
    _methodChannel
        .invokeMethod(BarcodeCaptureFunctionNames.addBarcodeCaptureListener)
        .then((value) => _setupBarcodeCaptureSubscription(), onError: _onError);
  }

  void _setupBarcodeCaptureSubscription() {
    _barcodeCaptureSubscription = _eventChannel.receiveBroadcastStream().listen((event) {
      if (_barcodeCapture._listeners.isEmpty && _barcodeCapture._advancedListeners.isEmpty) return;

      var eventJSON = jsonDecode(event);
      var session = BarcodeCaptureSession.fromJSON(jsonDecode(eventJSON['session']));
      var eventName = eventJSON['event'] as String;
      if (eventName == BarcodeCaptureListener._didScanEventName) {
        _notifyListenersOfDidScan(session);
        _methodChannel
            .invokeMethod(BarcodeCaptureFunctionNames.barcodeCaptureFinishDidScan, _barcodeCapture.isEnabled)
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: (error) => print(error));
      } else if (eventName == BarcodeCaptureListener._didUpdateSessionEventName) {
        _notifyListenersOfDidUpateSession(session);
        _methodChannel
            .invokeMethod(BarcodeCaptureFunctionNames.barcodeCaptureFinishDidUpdateSession, _barcodeCapture.isEnabled)
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: (error) => print(error));
      }
    });
  }

  void unsubscribeListeners() {
    _barcodeCaptureSubscription?.cancel();
    _methodChannel
        .invokeMethod(BarcodeCaptureFunctionNames.removeBarcodeCaptureListener)
        .then((value) => null, onError: _onError);
  }

  void _notifyListenersOfDidUpateSession(BarcodeCaptureSession session) {
    _barcodeCapture._isInCallback = true;
    for (var listener in _barcodeCapture._listeners) {
      listener.didUpdateSession(_barcodeCapture, session);
    }
    for (var listener in _barcodeCapture._advancedListeners) {
      listener.didUpdateSession(_barcodeCapture, session, _getLastFrameData);
    }
    _barcodeCapture._isInCallback = false;
  }

  Future<FrameData> _getLastFrameData() {
    return _methodChannel
        .invokeMethod(BarcodeCaptureFunctionNames.getLastFrameData)
        .then((value) => getFrom(value as String), onError: _onError);
  }

  DefaultFrameData getFrom(String response) {
    final decoded = jsonDecode(response);
    return DefaultFrameData.fromJSON(decoded);
  }

  void _notifyListenersOfDidScan(BarcodeCaptureSession session) {
    _barcodeCapture._isInCallback = true;
    for (var listener in _barcodeCapture._listeners) {
      listener.didScan(_barcodeCapture, session);
    }
    for (var listener in _barcodeCapture._advancedListeners) {
      listener.didScan(_barcodeCapture, session, _getLastFrameData);
    }
    _barcodeCapture._isInCallback = false;
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
