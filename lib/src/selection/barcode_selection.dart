import 'dart:async';
import 'dart:convert';

import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'package:flutter/services.dart';
import 'barcode_selection_defaults.dart';
import 'barcode_selection_feedback.dart';
import 'barcode_selection_settings.dart';
import 'barcode_selection_function_names.dart';
import 'barcode_selection_session.dart';

class BarcodeSelection extends DataCaptureMode {
  final List<BarcodeSelectionListener> _listeners = [];
  final List<BarcodeSelectionAdvancedListener> _advancedListeners = [];
  late _BarcodeSelectionListenerController _controller;
  BarcodeSelectionSettings _settings;
  BarcodeSelectionFeedback _feedback = BarcodeSelectionFeedback.defaultFeedback;
  PointWithUnit? _pointOfInterest;

  BarcodeSelection._(DataCaptureContext? context, this._settings) {
    _controller = _BarcodeSelectionListenerController.forBarcodeSelection(this);
    context?.addMode(this);
  }

  BarcodeSelection.forContext(DataCaptureContext context, BarcodeSelectionSettings settings)
      : this._(context, settings);

  @override
  DataCaptureContext? get context => super.context;

  bool _enabled = true;

  @override
  bool get isEnabled => _enabled;

  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    _controller.setModeEnabledState(newValue);
  }

  static CameraSettings get recommendedCameraSettings => _recommendedCameraSettings();

  static CameraSettings _recommendedCameraSettings() {
    var defaults = BarcodeSelectionDefaults.cameraSettingsDefaults;
    return CameraSettings(defaults.preferredResolution, defaults.zoomFactor, defaults.focusRange,
        defaults.focusGestureStrategy, defaults.zoomGestureZoomFactor,
        properties: defaults.properties, shouldPreferSmoothAutoFocus: defaults.shouldPreferSmoothAutoFocus);
  }

  BarcodeSelectionFeedback get feedback => _feedback;

  set feedback(BarcodeSelectionFeedback newValue) {
    _feedback = newValue;
    _controller.updateMode();
  }

  PointWithUnit? get pointOfInterest {
    return _pointOfInterest;
  }

  set pointOfInterest(PointWithUnit? newValue) {
    _pointOfInterest = newValue;
    _controller.updateMode();
  }

  void addListener(BarcodeSelectionListener listener) {
    if (_listeners.isEmpty) {
      _controller.subscribeListeners();
    }
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void addAdvancedListener(BarcodeSelectionAdvancedListener listener) {
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

  void removeListener(BarcodeSelectionListener listener) {
    _listeners.remove(listener);
    _checkAndUnsubscribeListeners();
  }

  void removeAdvancedListener(BarcodeSelectionAdvancedListener listener) {
    _advancedListeners.remove(listener);
    _checkAndUnsubscribeListeners();
  }

  void _checkAndUnsubscribeListeners() {
    if (_listeners.isEmpty && _advancedListeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  Future<void> applySettings(BarcodeSelectionSettings settings) {
    _settings = settings;
    return _controller.applyNewSettings(settings);
  }

  Future<void> unfreezeCamera() {
    return _controller.unfreezeCamera();
  }

  Future<void> reset() {
    return _controller.reset();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'barcodeSelection',
      'feedback': _feedback.toMap(),
      'settings': _settings.toMap()
    };
    if (_pointOfInterest != null) {
      json['pointOfInterest'] = _pointOfInterest?.toMap();
    }
    return json;
  }
}

abstract class BarcodeSelectionListener {
  static const String _didUpdateSelectionEventName = 'BarcodeSelectionListener.didUpdateSelection';
  static const String _didUpdateSessionEventName = 'BarcodeSelectionListener.didUpdateSession';

  void didUpdateSelection(BarcodeSelection barcodeSelection, BarcodeSelectionSession session);
  void didUpdateSession(BarcodeSelection barcodeSelection, BarcodeSelectionSession session);
}

abstract class BarcodeSelectionAdvancedListener {
  void didUpdateSelection(
      BarcodeSelection barcodeSelection, BarcodeSelectionSession session, Future<FrameData> getFrameData());
  void didUpdateSession(
      BarcodeSelection barcodeSelection, BarcodeSelectionSession session, Future<FrameData> getFrameData());
}

class _BarcodeSelectionListenerController {
  final MethodChannel _methodChannel = MethodChannel(BarcodeSelectionFunctionNames.methodsChannelName);
  final BarcodeSelection _barcodeSelection;
  StreamSubscription<dynamic>? _barcodeSelectionSubscription;

  _BarcodeSelectionListenerController.forBarcodeSelection(this._barcodeSelection);

  void subscribeListeners() {
    _methodChannel
        .invokeMethod(BarcodeSelectionFunctionNames.addListener)
        .then((value) => _setupBarcodeSelectionSubscription(), onError: _onError);
  }

  void unsubscribeListeners() {
    _barcodeSelectionSubscription?.cancel();
    _methodChannel.invokeMethod(BarcodeSelectionFunctionNames.removeListener).then((value) => null, onError: _onError);
  }

  void _setupBarcodeSelectionSubscription() {
    _barcodeSelectionSubscription = BarcodePluginEvents.barcodeSelectionEventStream.listen((event) {
      if (_barcodeSelection._listeners.isEmpty && _barcodeSelection._advancedListeners.isEmpty) return;

      var eventJSON = jsonDecode(event);
      var session = BarcodeSelectionSession.fromJSON(jsonDecode(eventJSON['session']));
      var eventName = eventJSON['event'] as String;
      if (eventName == BarcodeSelectionListener._didUpdateSelectionEventName) {
        _notifyListenersOfDidUpdateSelection(session);
        _methodChannel
            .invokeMethod(
                BarcodeSelectionFunctionNames.barcodeSelectionFinishDidUpdateSelection, _barcodeSelection.isEnabled)
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: (error) => print(error));
      } else if (eventName == BarcodeSelectionListener._didUpdateSessionEventName) {
        _notifyListenersOfDidUpateSession(session);
        _methodChannel
            .invokeMethod(
                BarcodeSelectionFunctionNames.barcodeSelectionFinishDidUpdateSession, _barcodeSelection.isEnabled)
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: (error) => print(error));
      }
    });
  }

  Future<void> unfreezeCamera() {
    return _methodChannel
        .invokeMethod(BarcodeSelectionFunctionNames.unfreezeCamera)
        .then((value) => null, onError: _onError);
  }

  Future<void> reset() {
    return _methodChannel.invokeMethod(BarcodeSelectionFunctionNames.resetMode);
  }

  Future<void> updateMode() {
    return _methodChannel.invokeMethod(
        BarcodeSelectionFunctionNames.updateBarcodeSelectionMode, jsonEncode(_barcodeSelection.toMap()));
  }

  Future<void> applyNewSettings(BarcodeSelectionSettings settings) {
    return _methodChannel
        .invokeMethod(BarcodeSelectionFunctionNames.applyBarcodeSelectionModeSettings, jsonEncode(settings.toMap()))
        .then((value) => null, onError: _onError);
  }

  void _notifyListenersOfDidUpateSession(BarcodeSelectionSession session) {
    for (var listener in _barcodeSelection._listeners) {
      listener.didUpdateSession(_barcodeSelection, session);
    }
    for (var listener in _barcodeSelection._advancedListeners) {
      listener.didUpdateSession(_barcodeSelection, session, _getLastFrameData);
    }
  }

  void _notifyListenersOfDidUpdateSelection(BarcodeSelectionSession session) {
    for (var listener in _barcodeSelection._listeners) {
      listener.didUpdateSelection(_barcodeSelection, session);
    }
    for (var listener in _barcodeSelection._advancedListeners) {
      listener.didUpdateSelection(_barcodeSelection, session, _getLastFrameData);
    }
  }

  Future<FrameData> _getLastFrameData() {
    return _methodChannel
        .invokeMethod(BarcodeSelectionFunctionNames.getLastFrameData)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: _onError);
  }

  void setModeEnabledState(bool newValue) {
    _methodChannel
        .invokeMethod(BarcodeSelectionFunctionNames.setModeEnabledState, newValue)
        .then((value) => null, onError: _onError);
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
