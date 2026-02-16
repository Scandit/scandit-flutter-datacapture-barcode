/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';

import 'barcode_batch_defaults.dart';
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

  BarcodeBatch._(this._settings) {
    _controller = _BarcodeBatchListenerController(this);
  }

  BarcodeBatch(BarcodeBatchSettings settings) : this._(settings);

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
  late final BarcodeMethodHandler barcodeMethodHandler;
  StreamSubscription<dynamic>? subscription;

  _BarcodeBatchListenerController(this.mode) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
  }

  void subscribeListeners() {
    if (subscription == null) {
      _listenForEvents();
    }

    barcodeMethodHandler.registerBarcodeBatchListenerForEvents(modeId: mode._modeId).onError(onError);
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
        barcodeMethodHandler
            .finishBarcodeBatchDidUpdateSessionCallback(modeId: mode._modeId, enabled: mode.isEnabled)
            .onError(onError);
      }
    });
  }

  Future<void> updateMode() {
    return barcodeMethodHandler.updateBarcodeBatchMode(modeJson: jsonEncode(mode.toMap())).onError(onError);
  }

  Future<void> applyNewSettings(BarcodeBatchSettings settings) {
    return barcodeMethodHandler
        .applyBarcodeBatchModeSettings(modeId: mode._modeId, modeSettingsJson: jsonEncode(settings.toMap()))
        .onError(onError);
  }

  void unsubscribeListeners() {
    barcodeMethodHandler.unregisterBarcodeBatchListenerForEvents(modeId: mode._modeId).onError(onError);
    subscription?.cancel();
    subscription = null;
  }

  Future<void> _notifyDidUpdateListeners(BarcodeBatchSession session) async {
    // Iterate backwards to avoid allocation and handle concurrent modifications safely
    // This is called frequently so we avoid creating a copy
    for (var i = mode._listeners.length - 1; i >= 0; i--) {
      if (i < mode._listeners.length) {
        await mode._listeners[i].didUpdateSession(mode, session, () => _getLastFrameData(session));
      }
    }
  }

  Future<FrameData> _getLastFrameData(BarcodeBatchSession session) {
    return getCoreMethodHandler()
        .getLastFrameOrNullAsMap(frameId: session.frameId)
        .then((value) => DefaultFrameData.fromJSON(value), onError: onError);
  }

  void setModeEnabledState(bool newValue) {
    barcodeMethodHandler.setBarcodeBatchModeEnabledState(modeId: mode._modeId, enabled: newValue).onError(onError);
  }
}
