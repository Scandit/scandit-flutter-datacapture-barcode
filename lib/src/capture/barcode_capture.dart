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

import 'barcode_capture_defaults.dart';
import 'barcode_capture_settings.dart';
import 'barcode_capture_function_names.dart';
import 'barcode_capture_session.dart';

class BarcodeCapture extends DataCaptureMode {
  BarcodeCaptureFeedback _feedback = BarcodeCaptureFeedback.defaultFeedback;
  bool _enabled = true;
  BarcodeCaptureSettings _settings;
  final List<BarcodeCaptureListener> _listeners = [];
  final _modeId = Random().nextInt(0x7FFFFFFF);

  late _BarcodeCaptureListenerController _controller;

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

  BarcodeCaptureFeedback get feedback => _feedback;

  set feedback(BarcodeCaptureFeedback newValue) {
    _feedback = newValue;
    // Set the modeId on the feedback object so it can update independently
    _feedback._setModeId(_modeId);
    _controller.updateFeedback();
  }

  static CameraSettings createRecommendedCameraSettings() {
    var defaults = BarcodeCaptureDefaults.cameraSettingsDefaults;
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

  BarcodeCapture._(this._settings) {
    _controller = _BarcodeCaptureListenerController(this);
    // Set the modeId on the initial feedback object
    _feedback._setModeId(_modeId);
  }

  BarcodeCapture(BarcodeCaptureSettings settings) : this._(settings);

  Future<void> applySettings(BarcodeCaptureSettings settings) {
    _settings = settings;
    return _controller.applyNewSettings(settings);
  }

  void addListener(BarcodeCaptureListener listener) {
    if (_listeners.isEmpty) {
      _controller.subscribeListeners();
    }
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void removeListener(BarcodeCaptureListener listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'barcodeCapture',
      'feedback': _feedback.toMap(),
      'settings': _settings.toMap(),
      'modeId': _modeId,
      'hasListeners': _listeners.isNotEmpty,
      'enabled': _enabled,
    };
  }
}

abstract class BarcodeCaptureListener {
  static const String _didUpdateSessionEventName = 'BarcodeCaptureListener.didUpdateSession';
  static const String _didScanEventName = 'BarcodeCaptureListener.didScan';

  Future<void> didUpdateSession(
    BarcodeCapture barcodeCapture,
    BarcodeCaptureSession session,
    Future<FrameData> getFrameData(),
  );
  Future<void> didScan(BarcodeCapture barcodeCapture, BarcodeCaptureSession session, Future<FrameData> getFrameData());
}

class _BarcodeCaptureListenerController extends BaseController {
  final BarcodeCapture _barcodeCapture;
  StreamSubscription<dynamic>? _barcodeCaptureSubscription;

  _BarcodeCaptureListenerController(this._barcodeCapture) : super(BarcodeCaptureFunctionNames.methodsChannelName);

  void subscribeListeners() {
    methodChannel.invokeMethod(BarcodeCaptureFunctionNames.addBarcodeCaptureListener,
        {'modeId': _barcodeCapture._modeId}).then((value) => _setupBarcodeCaptureSubscription(), onError: onError);
  }

  void _setupBarcodeCaptureSubscription() {
    _barcodeCaptureSubscription = BarcodePluginEvents.barcodeCaptureEventStream.listen((event) {
      if (_barcodeCapture._listeners.isEmpty) return;

      var eventJson = jsonDecode(event);
      var payload = eventJson as Map<String, dynamic>;

      // Check if this event is for our mode
      if (payload['modeId'] != _barcodeCapture._modeId) {
        return;
      }

      var session = BarcodeCaptureSession.fromJSON(eventJson);
      var eventName = eventJson['event'] as String;
      if (eventName == BarcodeCaptureListener._didScanEventName) {
        _notifyListenersOfDidScan(session).then((value) {
          methodChannel.invokeMethod(BarcodeCaptureFunctionNames.barcodeCaptureFinishDidScan, {
            'modeId': _barcodeCapture._modeId,
            'enabled': _barcodeCapture.isEnabled,
          })
              // ignore: unnecessary_lambdas
              .then((value) => null, onError: (error) => developer.log(error.toString()));
        });
      } else if (eventName == BarcodeCaptureListener._didUpdateSessionEventName) {
        _notifyListenersOfDidUpateSession(session).then((value) {
          methodChannel.invokeMethod(BarcodeCaptureFunctionNames.barcodeCaptureFinishDidUpdateSession, {
            'modeId': _barcodeCapture._modeId,
            'enabled': _barcodeCapture.isEnabled,
          })
              // ignore: unnecessary_lambdas
              .then((value) => null, onError: (error) => developer.log(error.toString()));
        });
      }
    });
  }

  void setModeEnabledState(bool newValue) {
    methodChannel.invokeMethod(BarcodeCaptureFunctionNames.setModeEnabledState, {
      'modeId': _barcodeCapture._modeId,
      'enabled': newValue,
    }).then((value) => null, onError: onError);
  }

  Future<void> updateMode() {
    return methodChannel
        .invokeMethod(BarcodeCaptureFunctionNames.updateBarcodeCaptureMode, jsonEncode(_barcodeCapture.toMap()))
        .then((value) => null, onError: onError);
  }

  Future<void> applyNewSettings(BarcodeCaptureSettings settings) {
    final arguments = {'modeId': _barcodeCapture._modeId, 'modeSettingsJson': jsonEncode(settings.toMap())};
    return methodChannel
        .invokeMethod(BarcodeCaptureFunctionNames.applyBarcodeCaptureModeSettings, arguments)
        .then((value) => null, onError: onError);
  }

  Future<void> updateFeedback() {
    return methodChannel.invokeMethod(BarcodeCaptureFunctionNames.updateFeedback, {
      'modeId': _barcodeCapture._modeId,
      'feedbackJson': jsonEncode(_barcodeCapture.feedback.toMap()),
    });
  }

  void unsubscribeListeners() {
    _barcodeCaptureSubscription?.cancel();
    methodChannel.invokeMethod(BarcodeCaptureFunctionNames.removeBarcodeCaptureListener,
        {'modeId': _barcodeCapture._modeId}).then((value) => null, onError: onError);
    _barcodeCaptureSubscription = null;
  }

  Future<void> _notifyListenersOfDidUpateSession(BarcodeCaptureSession session) async {
    for (var listener in _barcodeCapture._listeners) {
      await listener.didUpdateSession(_barcodeCapture, session, () => _getLastFrameData(session));
    }
  }

  Future<FrameData> _getLastFrameData(BarcodeCaptureSession session) {
    return methodChannel
        .invokeMethod(BarcodeCaptureFunctionNames.getLastFrameData, session.frameId)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: onError);
  }

  Future<void> _notifyListenersOfDidScan(BarcodeCaptureSession session) async {
    for (var listener in _barcodeCapture._listeners) {
      await listener.didScan(_barcodeCapture, session, () => _getLastFrameData(session));
    }
  }
}

class BarcodeCaptureFeedback implements Serializable {
  late _BarcodeCaptureFeedbackController _controller;
  int? _modeId;

  BarcodeCaptureFeedback() {
    _controller = _BarcodeCaptureFeedbackController(this);
  }

  Feedback _success = Feedback.defaultFeedback;

  Feedback get success => _success;

  set success(Feedback newValue) {
    _success = newValue;
    _controller.updateFeedback();
  }

  static BarcodeCaptureFeedback get defaultFeedback => BarcodeCaptureFeedback();

  // Internal method to set the mode ID
  void _setModeId(int modeId) {
    _modeId = modeId;
  }

  @override
  Map<String, dynamic> toMap() {
    return {'success': success.toMap()};
  }
}

class _BarcodeCaptureFeedbackController extends BaseController {
  final BarcodeCaptureFeedback _feedback;

  _BarcodeCaptureFeedbackController(this._feedback) : super(BarcodeCaptureFunctionNames.methodsChannelName);

  Future<void> updateFeedback() {
    if (_feedback._modeId == null) {
      // If no modeId is set, don't update (this feedback is not associated with a mode yet)
      return Future.value();
    }

    return methodChannel.invokeMethod(BarcodeCaptureFunctionNames.updateFeedback, {
      'modeId': _feedback._modeId,
      'feedbackJson': jsonEncode(_feedback.toMap()),
    });
  }
}
