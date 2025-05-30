/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:developer';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import '../../scandit_flutter_datacapture_barcode.dart';
import '../barcode_plugin_events.dart';
import 'barcode_count_capture_list_session.dart';
import 'barcode_count_defaults.dart';
import 'barcode_count_feedback.dart';
import 'barcode_count_function_names.dart';
import 'barcode_count_session.dart';
import 'barcode_count_settings.dart';
import 'target_barcode.dart';

class BarcodeCount extends DataCaptureMode {
  BarcodeCountFeedback _feedback = BarcodeCountFeedback.defaultFeedback;
  bool _enabled = true;
  BarcodeCountSettings _settings;
  final List<BarcodeCountListener> _listeners = [];
  late _BarcodeCountController _controller;

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

  BarcodeCountFeedback get feedback => _feedback;

  set feedback(BarcodeCountFeedback newValue) {
    _feedback = newValue;
    _controller.updateFeedback();
  }

  static CameraSettings get recommendedCameraSettings => _recommendedCameraSettings();

  static CameraSettings _recommendedCameraSettings() {
    var defaults = BarcodeCountDefaults.cameraSettingsDefaults;
    return CameraSettings(defaults.preferredResolution, defaults.zoomFactor, defaults.focusRange,
        defaults.focusGestureStrategy, defaults.zoomGestureZoomFactor,
        shouldPreferSmoothAutoFocus: defaults.shouldPreferSmoothAutoFocus, properties: defaults.properties);
  }

  BarcodeCount._(DataCaptureContext context, this._settings) {
    _controller = _BarcodeCountController.forBarcodeCount(this);
    // No need to add the mode to the context
  }

  BarcodeCount.forContext(DataCaptureContext context, BarcodeCountSettings settings) : this._(context, settings);

  Future<void> applySettings(BarcodeCountSettings settings) {
    _settings = settings;
    return didChange();
  }

  void addListener(BarcodeCountListener listener) {
    _checkAndSubscribeListeners();
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void _checkAndSubscribeListeners() {
    if (_listeners.isEmpty) {
      _controller.subscribeListeners();
    }
  }

  void removeListener(BarcodeCountListener listener) {
    _listeners.remove(listener);
    _checkAndUnsubscribeListeners();
  }

  void _checkAndUnsubscribeListeners() {
    if (_listeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  Future<void> didChange() {
    return _controller.updateMode();
  }

  Future<void> reset() {
    return _controller.reset();
  }

  Future<void> startScanningPhase() {
    return _controller.startScanningPhase();
  }

  Future<void> endScanningPhase() {
    return _controller.endScanningPhase();
  }

  Future<void> setBarcodeCountCaptureList(BarcodeCountCaptureList list) {
    return _controller.setBarcodeCountCaptureList(list);
  }

  List<Barcode> _additionalBarcodes = [];

  Future<void> setAdditionalBarcodes(List<Barcode> barcodes) {
    _additionalBarcodes = barcodes;
    return didChange();
  }

  Future<void> clearAdditionalBarcodes() {
    _additionalBarcodes = [];
    return didChange();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'barcodeCount',
      'feedback': _feedback.toMap(),
      'settings': _settings.toMap(),
      'additionalBarcodes': _additionalBarcodes.map((e) => e.toMap()).toList(growable: false)
    };

    return json;
  }
}

abstract class BarcodeCountListener {
  static const String _onScanEventName = 'BarcodeCountListener.onScan';

  Future<void> didScan(BarcodeCount barcodeCount, BarcodeCountSession session, Future<FrameData> getFrameData());
}

abstract class BarcodeCountCaptureListListener {
  static const String _didUpdateSessionEventName = 'BarcodeCountCaptureListListener.didUpdateSession';

  void didUpdateSession(BarcodeCountCaptureList barcodeCountCaptureList, BarcodeCountCaptureListSession session);
}

class BarcodeCountCaptureList {
  final BarcodeCountCaptureListListener _listener;
  final List<TargetBarcode> _targetBarcodes;

  BarcodeCountCaptureList._(this._listener, this._targetBarcodes);

  factory BarcodeCountCaptureList.create(BarcodeCountCaptureListListener listener, List<TargetBarcode> targetBarcodes) {
    return BarcodeCountCaptureList._(listener, targetBarcodes);
  }
}

class _BarcodeCountController {
  final MethodChannel _methodChannel = const MethodChannel(BarcodeCountFunctionNames.methodsChannelName);
  final BarcodeCount _barcodeCount;
  StreamSubscription<dynamic>? _streamSubscription;
  BarcodeCountCaptureList? _barcodeCountCaptureList;

  _BarcodeCountController.forBarcodeCount(this._barcodeCount);

  void subscribeListeners() {
    _methodChannel
        .invokeMethod(BarcodeCountFunctionNames.addBarcodeCountListener)
        .then((value) => _setupBarcodeCountSubscription())
        .onError(_onError);
  }

  void _setupBarcodeCountSubscription() {
    _streamSubscription = BarcodePluginEvents.barcodeCountEventStream.listen((event) async {
      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;
      if (eventName == BarcodeCountListener._onScanEventName) {
        var session = BarcodeCountSession.fromJSON(eventJSON);
        await _notifyListenersOfOnScan(session);
        _methodChannel
            .invokeMethod(BarcodeCountFunctionNames.barcodeCountFinishOnScan, _barcodeCount.isEnabled)
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: (error) => log(error));
      } else if (eventName == BarcodeCountCaptureListListener._didUpdateSessionEventName) {
        var session = BarcodeCountCaptureListSession.fromJSON(jsonDecode(eventJSON['session']));
        _notifyBarcodeCountCaptureList(session);
      }
    });
  }

  void unsubscribeListeners() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _methodChannel
        .invokeMethod(BarcodeCountFunctionNames.removeBarcodeCountListener)
        .then((value) => null, onError: _onError);
  }

  Future<void> reset() {
    return _methodChannel.invokeMethod(BarcodeCountFunctionNames.resetMode);
  }

  Future<void> startScanningPhase() {
    return _methodChannel.invokeMethod(BarcodeCountFunctionNames.startScanningPhase);
  }

  Future<void> endScanningPhase() {
    return _methodChannel.invokeMethod(BarcodeCountFunctionNames.endScanningPhase);
  }

  Future<void> setBarcodeCountCaptureList(BarcodeCountCaptureList list) {
    _barcodeCountCaptureList = list;
    return _methodChannel.invokeMethod(BarcodeCountFunctionNames.setBarcodeCountCaptureList,
        jsonEncode(list._targetBarcodes.map((e) => e.toMap()).toList()));
  }

  Future<FrameData> _getLastFrameData(BarcodeCountSession session) {
    return _methodChannel
        .invokeMethod(BarcodeCountFunctionNames.getBarcodeCountLastFrameData, session.frameId)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: _onError);
  }

  Future<void> updateMode() {
    return _methodChannel.invokeMethod(
        BarcodeCountFunctionNames.updateBarcodeCountMode, jsonEncode(_barcodeCount.toMap()));
  }

  Future<void> updateFeedback() {
    return _methodChannel.invokeMethod(
        BarcodeCountFunctionNames.updateFeedback, jsonEncode(_barcodeCount.feedback.toMap()));
  }

  void setModeEnabledState(bool newValue) {
    _methodChannel
        .invokeMethod(BarcodeCountFunctionNames.setModeEnabledState, newValue)
        .then((value) => null, onError: _onError);
  }

  Future<void> _notifyListenersOfOnScan(BarcodeCountSession session) async {
    for (var listener in _barcodeCount._listeners) {
      await listener.didScan(_barcodeCount, session, () => _getLastFrameData(session));
    }
  }

  void _notifyBarcodeCountCaptureList(BarcodeCountCaptureListSession session) {
    var barcodeCountCaptureList = _barcodeCountCaptureList;
    if (barcodeCountCaptureList != null) {
      _barcodeCountCaptureList?._listener.didUpdateSession(barcodeCountCaptureList, session);
    }
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }
}
