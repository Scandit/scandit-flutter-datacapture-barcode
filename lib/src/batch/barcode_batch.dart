/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

import 'barcode_batch_defaults.dart';
import 'barcode_batch_function_names.dart';
import 'barcode_batch_session.dart';
import 'barcode_batch_settings.dart';

class BarcodeBatch extends DataCaptureMode {
  bool _enabled = true;
  BarcodeBatchSettings _settings;
  final List<BarcodeBatchListener> _listeners = [];
  final _modeId = Random().nextInt(0x7FFFFFFF);

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

  static CameraSettings createRecommendedCameraSettings() {
    return CameraSettings(
      BarcodeBatchDefaults.recommendedCameraSettings.preferredResolution,
      BarcodeBatchDefaults.recommendedCameraSettings.zoomFactor,
      BarcodeBatchDefaults.recommendedCameraSettings.focusRange,
      BarcodeBatchDefaults.recommendedCameraSettings.focusGestureStrategy,
      BarcodeBatchDefaults.recommendedCameraSettings.zoomGestureZoomFactor,
      properties: BarcodeBatchDefaults.recommendedCameraSettings.properties,
      shouldPreferSmoothAutoFocus: BarcodeBatchDefaults.recommendedCameraSettings.shouldPreferSmoothAutoFocus,
    );
  }

  @Deprecated('Use createRecommendedCameraSettings() instead.')
  static CameraSettings get recommendedCameraSettings => createRecommendedCameraSettings();

  BarcodeBatch._(DataCaptureContext? context, this._settings) {
    _controller = _BarcodeBatchListenerController(this);
    if (context != null) {
      context.setMode(this);
    }
  }

  BarcodeBatch(BarcodeBatchSettings settings) : this._(null, settings);

  @Deprecated('Use constructor BarcodeBatch(BarcodeBatchSettings settings) instead.')
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
    return {
      'type': 'barcodeTracking',
      'settings': _settings.toMap(),
      'modeId': _modeId,
      'hasListeners': _listeners.isNotEmpty,
      'enabled': _enabled,
    };
  }
}

abstract class BarcodeBatchListener {
  static const String _barcodeBatchListenerDidUpdateSession = 'BarcodeBatchListener.didUpdateSession';
  Future<void> didUpdateSession(
    BarcodeBatch barcodeBatch,
    BarcodeBatchSession session,
    Future<FrameData> getFrameData(),
  );
}

class _BarcodeBatchListenerController extends BaseController {
  final BarcodeBatch mode;

  StreamSubscription<dynamic>? subscription;

  _BarcodeBatchListenerController(this.mode) : super(BarcodeBatchFunctionNames.methodsChannelName);

  void subscribeListeners() {
    if (subscription == null) {
      _listenForEvents();
    }

    methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.addBarcodeBatchListener, {'modeId': mode._modeId}).onError(onError);
  }

  void _listenForEvents() {
    subscription = BarcodePluginEvents.barcodeBatchEventStream.listen((event) async {
      var payload = jsonDecode(event as String);
      if (payload['event'] as String == BarcodeBatchListener._barcodeBatchListenerDidUpdateSession) {
        if (payload['modeId'] != mode._modeId) {
          return;
        }

        if (mode._listeners.isNotEmpty && payload.containsKey('session')) {
          var session = BarcodeBatchSession.fromJSON(payload);
          await _notifyDidUpdateListeners(session);
        }
        methodChannel.invokeMethod(BarcodeBatchFunctionNames.barcodeBatchFinishDidUpdateSession, {
          'modeId': mode._modeId,
          'enabled': mode.isEnabled,
        }).then((value) => null, onError: (error, stack) => developer.log(error.toString()));
      }
    });
  }

  Future<void> updateMode() {
    return methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.updateBarcodeBatchMode, jsonEncode(mode.toMap()))
        .then((value) => null, onError: onError);
  }

  Future<void> applyNewSettings(BarcodeBatchSettings settings) {
    final arguments = {'modeId': mode._modeId, 'modeSettingsJson': jsonEncode(settings.toMap())};
    return methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.applyBarcodeBatchModeSettings, arguments)
        .then((value) => null, onError: onError);
  }

  void unsubscribeListeners() {
    methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.removeBarcodeBatchListener, {'modeId': mode._modeId}).onError(onError);
    subscription?.cancel();
    subscription = null;
  }

  Future<void> _notifyDidUpdateListeners(BarcodeBatchSession session) async {
    for (var listener in mode._listeners) {
      await listener.didUpdateSession(mode, session, () => _getLastFrameData(session));
    }
  }

  Future<FrameData> _getLastFrameData(BarcodeBatchSession session) {
    return methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.getLastFrameData, session.frameId)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: onError);
  }

  void setModeEnabledState(bool newValue) {
    methodChannel.invokeMethod(BarcodeBatchFunctionNames.setModeEnabledState, {
      'modeId': mode._modeId,
      'enabled': newValue,
    }).then((value) => null, onError: onError);
  }
}
