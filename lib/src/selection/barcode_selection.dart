import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

import 'barcode_selection_defaults.dart';
import 'barcode_selection_feedback.dart';
import 'barcode_selection_settings.dart';
import 'barcode_selection_function_names.dart';
import 'barcode_selection_session.dart';

class BarcodeSelection extends DataCaptureMode {
  final List<BarcodeSelectionListener> _listeners = [];
  late _BarcodeSelectionListenerController _controller;
  BarcodeSelectionSettings _settings;
  BarcodeSelectionFeedback _feedback = BarcodeSelectionFeedback.defaultFeedback;
  PointWithUnit? _pointOfInterest;
  final _modeId = Random().nextInt(0x7FFFFFFF);

  BarcodeSelection._(DataCaptureContext? context, this._settings) {
    _controller = _BarcodeSelectionListenerController(this);
    context?.setMode(this);
  }

  BarcodeSelection(BarcodeSelectionSettings settings) : this._(null, settings);

  @Deprecated('Use constructor BarcodeSelection(BarcodeSelectionSettings settings) instead.')
  BarcodeSelection.forContext(DataCaptureContext context, BarcodeSelectionSettings settings)
      : this._(context, settings);

  @override
  // ignore: unnecessary_overrides
  DataCaptureContext? get context => super.context;

  bool _enabled = true;

  @override
  bool get isEnabled => _enabled;

  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    _controller.setModeEnabledState(newValue);
  }

  static CameraSettings createRecommendedCameraSettings() {
    var defaults = BarcodeSelectionDefaults.cameraSettingsDefaults;
    return CameraSettings(
      defaults.preferredResolution,
      defaults.zoomFactor,
      defaults.focusRange,
      defaults.focusGestureStrategy,
      defaults.zoomGestureZoomFactor,
      properties: defaults.properties,
      shouldPreferSmoothAutoFocus: defaults.shouldPreferSmoothAutoFocus,
    );
  }

  @Deprecated('Use createRecommendedCameraSettings() instead.')
  static CameraSettings get recommendedCameraSettings => createRecommendedCameraSettings();

  BarcodeSelectionFeedback get feedback => _feedback;

  set feedback(BarcodeSelectionFeedback newValue) {
    _feedback = newValue;
    _controller.updateFeedback();
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

  void removeListener(BarcodeSelectionListener listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
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
      'settings': _settings.toMap(),
    };
    if (_pointOfInterest != null) {
      json['pointOfInterest'] = _pointOfInterest?.toMap();
    }
    json['modeId'] = _modeId;
    return json;
  }
}

abstract class BarcodeSelectionListener {
  static const String _didUpdateSelectionEventName = 'BarcodeSelectionListener.didUpdateSelection';
  static const String _didUpdateSessionEventName = 'BarcodeSelectionListener.didUpdateSession';

  Future<void> didUpdateSelection(
    BarcodeSelection barcodeSelection,
    BarcodeSelectionSession session,
    Future<FrameData?> getFrameData(),
  );
  Future<void> didUpdateSession(
    BarcodeSelection barcodeSelection,
    BarcodeSelectionSession session,
    Future<FrameData?> getFrameData(),
  );
}

class _BarcodeSelectionListenerController extends BaseController {
  final BarcodeSelection _barcodeSelection;
  StreamSubscription<dynamic>? _barcodeSelectionSubscription;

  _BarcodeSelectionListenerController(this._barcodeSelection) : super(BarcodeSelectionFunctionNames.methodsChannelName);

  void subscribeListeners() {
    methodChannel
        .invokeMethod(BarcodeSelectionFunctionNames.addListener)
        .then((value) => _setupBarcodeSelectionSubscription(), onError: onError);
  }

  void unsubscribeListeners() {
    _barcodeSelectionSubscription?.cancel();
    methodChannel.invokeMethod(BarcodeSelectionFunctionNames.removeListener).then((value) => null, onError: onError);
  }

  void _setupBarcodeSelectionSubscription() {
    _barcodeSelectionSubscription = BarcodePluginEvents.barcodeSelectionEventStream.listen((event) {
      if (_barcodeSelection._listeners.isEmpty) return;

      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;
      if (eventName == BarcodeSelectionListener._didUpdateSelectionEventName) {
        var session = BarcodeSelectionSession.fromJSON(eventJSON);
        _notifyListenersOfDidUpdateSelection(session).then((value) {
          methodChannel
              .invokeMethod(
                BarcodeSelectionFunctionNames.barcodeSelectionFinishDidUpdateSelection,
                _barcodeSelection.isEnabled,
              )
              // ignore: unnecessary_lambdas
              .then((value) => null, onError: (error) => developer.log(error));
        });
      } else if (eventName == BarcodeSelectionListener._didUpdateSessionEventName) {
        var session = BarcodeSelectionSession.fromJSON(eventJSON);
        _notifyListenersOfDidUpateSession(session).then((value) {
          methodChannel
              .invokeMethod(
                BarcodeSelectionFunctionNames.barcodeSelectionFinishDidUpdateSession,
                _barcodeSelection.isEnabled,
              )
              // ignore: unnecessary_lambdas
              .then((value) => null, onError: (error) => developer.log(error));
        });
      }
    });
  }

  Future<void> unfreezeCamera() {
    return methodChannel
        .invokeMethod(BarcodeSelectionFunctionNames.unfreezeCamera)
        .then((value) => null, onError: onError);
  }

  Future<void> reset() {
    return methodChannel.invokeMethod(BarcodeSelectionFunctionNames.resetMode);
  }

  Future<void> updateMode() {
    return methodChannel.invokeMethod(
      BarcodeSelectionFunctionNames.updateBarcodeSelectionMode,
      jsonEncode(_barcodeSelection.toMap()),
    );
  }

  Future<void> updateFeedback() {
    return methodChannel.invokeMethod(
      BarcodeSelectionFunctionNames.updateFeedback,
      jsonEncode(_barcodeSelection.feedback.toMap()),
    );
  }

  Future<void> applyNewSettings(BarcodeSelectionSettings settings) {
    return methodChannel
        .invokeMethod(BarcodeSelectionFunctionNames.applyBarcodeSelectionModeSettings, jsonEncode(settings.toMap()))
        .then((value) => null, onError: onError);
  }

  Future<void> _notifyListenersOfDidUpateSession(BarcodeSelectionSession session) async {
    for (var listener in _barcodeSelection._listeners) {
      await listener.didUpdateSession(_barcodeSelection, session, () => _getLastFrameData(session));
    }
  }

  Future<void> _notifyListenersOfDidUpdateSelection(BarcodeSelectionSession session) async {
    for (var listener in _barcodeSelection._listeners) {
      await listener.didUpdateSelection(_barcodeSelection, session, () => _getLastFrameData(session));
    }
  }

  Future<FrameData?> _getLastFrameData(BarcodeSelectionSession session) {
    if (session.frameId == null) return Future.value(null);

    return methodChannel
        .invokeMethod(BarcodeSelectionFunctionNames.getLastFrameData, session.frameId)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: onError);
  }

  void setModeEnabledState(bool newValue) {
    methodChannel
        .invokeMethod(BarcodeSelectionFunctionNames.setModeEnabledState, newValue)
        .then((value) => null, onError: onError);
  }
}
