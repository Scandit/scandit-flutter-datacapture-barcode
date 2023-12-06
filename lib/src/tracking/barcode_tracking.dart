/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_tracking_defaults.dart';
import 'barcode_tracking_function_names.dart';
import 'barcode_tracking_session.dart';
import 'barcode_tracking_settings.dart';

class BarcodeTracking extends DataCaptureMode {
  bool _enabled = true;
  BarcodeTrackingSettings _settings;
  final List<BarcodeTrackingListener> _listeners = [];
  final List<BarcodeTrackingAdvancedListener> _advancedListeners = [];
  late _BarcodeTrackingListenerController _controller;
  bool _isInCallback = false;

  @override
  DataCaptureContext? get context => super.context;

  bool get isEnabled => _enabled;

  set isEnabled(bool newValue) {
    _enabled = newValue;
    if (_isInCallback) {
      return;
    }
    didChange();
  }

  static CameraSettings get recommendedCameraSettings => CameraSettings(
        BarcodeTrackingDefaults.recommendedCameraSettings.preferredResolution,
        BarcodeTrackingDefaults.recommendedCameraSettings.zoomFactor,
        BarcodeTrackingDefaults.recommendedCameraSettings.focusRange,
        BarcodeTrackingDefaults.recommendedCameraSettings.focusGestureStrategy,
        BarcodeTrackingDefaults.recommendedCameraSettings.zoomGestureZoomFactor,
        shouldPreferSmoothAutoFocus: BarcodeTrackingDefaults.recommendedCameraSettings.shouldPreferSmoothAutoFocus,
      );

  BarcodeTracking._(DataCaptureContext? context, this._settings) {
    _controller = _BarcodeTrackingListenerController.forBarcodeTracking(this);
    if (context != null) {
      context.addMode(this);
    }
  }

  BarcodeTracking.forContext(DataCaptureContext context, BarcodeTrackingSettings settings) : this._(context, settings);

  Future<void> applySettings(BarcodeTrackingSettings settings) {
    _settings = settings;
    return didChange();
  }

  void addListener(BarcodeTrackingListener listener) {
    _checkAndSubscribeListeners();

    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void addAdvancedListener(BarcodeTrackingAdvancedListener listener) {
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

  void removeListener(BarcodeTrackingListener listener) {
    _listeners.remove(listener);

    _checkAndUnsubscribeListeners();
  }

  void removeAdvancedListener(BarcodeTrackingAdvancedListener listener) {
    _advancedListeners.remove(listener);

    _checkAndUnsubscribeListeners();
  }

  void _checkAndUnsubscribeListeners() {
    if (_listeners.isEmpty && _advancedListeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {'type': 'barcodeTracking', 'settings': _settings.toMap(), 'enabled': isEnabled};
  }

  Future<void> didChange() {
    return context?.update() ?? Future.value();
  }
}

abstract class BarcodeTrackingListener {
  static const String _barcodeTrackingListenerDidUpdateSession = 'barcodeTrackingListener-didUpdateSession';
  void didUpdateSession(BarcodeTracking barcodeTracking, BarcodeTrackingSession session);
}

abstract class BarcodeTrackingAdvancedListener {
  void didUpdateSession(
      BarcodeTracking barcodeTracking, BarcodeTrackingSession session, Future<FrameData> getFrameData());
}

class _BarcodeTrackingListenerController {
  final EventChannel _eventChannel =
      const EventChannel('com.scandit.datacapture.barcode.tracking.event/barcode_tracking_listener');
  final MethodChannel _methodChannel =
      MethodChannel('com.scandit.datacapture.barcode.tracking.method/barcode_tracking_listener');
  final BarcodeTracking _barcodeTracking;
  StreamSubscription<dynamic>? _barcodeTrackingSubscription;

  _BarcodeTrackingListenerController.forBarcodeTracking(this._barcodeTracking);

  void subscribeListeners() {
    if (_barcodeTrackingSubscription != null) return;

    _methodChannel
        .invokeMethod(BarcodeTrackingFunctionNames.addBarcodeTrackingListener)
        .then((value) => _listenForEvents(), onError: _onError);
  }

  StreamSubscription _listenForEvents() {
    return _barcodeTrackingSubscription = _eventChannel.receiveBroadcastStream().listen((event) {
      if (_barcodeTracking._listeners.isEmpty && _barcodeTracking._advancedListeners.isEmpty) return;

      var payload = jsonDecode(event as String);
      if (payload['event'] as String == BarcodeTrackingListener._barcodeTrackingListenerDidUpdateSession) {
        if (payload.containsKey('session')) {
          var session = BarcodeTrackingSession.fromJSON(jsonDecode(payload['session']));
          _notifyDidUpdateListeners(session);
        }
        _methodChannel
            .invokeMethod(
                BarcodeTrackingFunctionNames.barcodeTrackingFinishDidUpdateSession, _barcodeTracking.isEnabled)
            .then((value) => null, onError: (error, stack) => print(error));
      }
    });
  }

  void unsubscribeListeners() {
    _barcodeTrackingSubscription?.cancel();
    _methodChannel
        .invokeMethod(BarcodeTrackingFunctionNames.removeBarcodeTrackingListener)
        .then((value) => null, onError: _onError);

    _barcodeTrackingSubscription = null;
  }

  void _notifyDidUpdateListeners(BarcodeTrackingSession session) {
    _barcodeTracking._isInCallback = true;
    for (var listener in _barcodeTracking._listeners) {
      listener.didUpdateSession(_barcodeTracking, session);
    }
    for (var listener in _barcodeTracking._advancedListeners) {
      listener.didUpdateSession(_barcodeTracking, session, _getLastFrameData);
    }
    _barcodeTracking._isInCallback = false;
  }

  Future<FrameData> _getLastFrameData() {
    return _methodChannel
        .invokeMethod(BarcodeTrackingFunctionNames.getLastFrameData)
        .then((value) => getFrom(value as String), onError: _onError);
  }

  DefaultFrameData getFrom(String response) {
    final decoded = jsonDecode(response);
    return DefaultFrameData.fromJSON(decoded);
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
