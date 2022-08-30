import 'dart:async';
import 'dart:convert';

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
  bool _isInCallback = false;

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
    if (_isInCallback) {
      return;
    }
    didChange();
  }

  static CameraSettings get recommendedCameraSettings => _recommendedCameraSettings();

  static CameraSettings _recommendedCameraSettings() {
    var defaults = BarcodeSelectionDefaults.cameraSettingsDefaults;
    return CameraSettings(defaults.preferredResolution, defaults.zoomFactor, defaults.focusRange,
        defaults.focusGestureStrategy, defaults.zoomGestureZoomFactor,
        shouldPreferSmoothAutoFocus: defaults.shouldPreferSmoothAutoFocus);
  }

  BarcodeSelectionFeedback get feedback => _feedback;

  set feedback(BarcodeSelectionFeedback newValue) {
    _feedback = newValue;
    didChange();
  }

  PointWithUnit? get pointOfInterest {
    return _pointOfInterest;
  }

  set pointOfInterest(PointWithUnit? newValue) {
    _pointOfInterest = newValue;
    didChange();
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
    return didChange();
  }

  Future<void> unfreezeCamera() {
    return _controller.unfreezeCamera();
  }

  Future<void> reset() {
    return _controller.reset();
  }

  Future<void> didChange() {
    if (context != null) {
      return context!.update();
    }
    return Future.value();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'barcodeSelection',
      'enabled': _enabled,
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
  static const String _didUpdateSelectionEventName = 'barcodeSelectionListener-didUpdateSelection';
  static const String _didUpdateSessionEventName = 'barcodeSelectionListener-didUpdateSession';

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
  final EventChannel _eventChannel =
      const EventChannel('com.scandit.datacapture.barcode.selection.event/barcode_selection_listener');
  final MethodChannel _methodChannel =
      MethodChannel('com.scandit.datacapture.barcode.selection.method/barcode_selection_listener');
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
    _barcodeSelectionSubscription = _eventChannel.receiveBroadcastStream().listen((event) {
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

  void _notifyListenersOfDidUpateSession(BarcodeSelectionSession session) {
    _barcodeSelection._isInCallback = true;
    for (var listener in _barcodeSelection._listeners) {
      listener.didUpdateSession(_barcodeSelection, session);
    }
    for (var listener in _barcodeSelection._advancedListeners) {
      listener.didUpdateSession(_barcodeSelection, session, _getLastFrameData);
    }
    _barcodeSelection._isInCallback = false;
  }

  void _notifyListenersOfDidUpdateSelection(BarcodeSelectionSession session) {
    _barcodeSelection._isInCallback = true;
    for (var listener in _barcodeSelection._listeners) {
      listener.didUpdateSelection(_barcodeSelection, session);
    }
    for (var listener in _barcodeSelection._advancedListeners) {
      listener.didUpdateSelection(_barcodeSelection, session, _getLastFrameData);
    }
    _barcodeSelection._isInCallback = false;
  }

  Future<FrameData> _getLastFrameData() {
    return _methodChannel
        .invokeMethod(BarcodeSelectionFunctionNames.getLastFrameData)
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
