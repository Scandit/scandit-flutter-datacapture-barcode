/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:math' hide log;

import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show BarcodeCaptureListenerDidScan, BarcodeCaptureListenerDidUpdateSession;
// Aliased: this library's `AdaptiveRecognitionFrameMetadata` is the raw wire payload type, which
// would otherwise collide with the public domain type of the same name from '../adaptive_recognition.dart'.
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart' as are_schema
    show
        BarcodeCaptureAdaptiveRecognitionListenerDispatchStarted,
        BarcodeCaptureAdaptiveRecognitionListenerResponse,
        BarcodeCaptureAdaptiveRecognitionListenerError;
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_core/internal.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';

import '../adaptive_recognition.dart';
import 'barcode_capture_defaults.dart';
import 'barcode_capture_license_info.dart';
import 'barcode_capture_settings.dart';
import 'barcode_capture_session.dart';

/// Capture mode for single barcode scanning. This capture mode uses the *barcode scanning* capability.
///
/// Learn more on how to use barcode capture in our [Get Started](https://docs.scandit.com/sdks/flutter/barcode-capture/get-started) guide.
///
/// For MatrixScan-based barcode capture, use [BarcodeBatch] instead.
///
/// It cannot be used together with other capture modes that require the same capabilities, e.g. [BarcodeBatch].
///
/// Added in version 6.7.0
class BarcodeCapture extends DataCaptureMode {
  BarcodeCaptureFeedback _feedback = BarcodeCaptureFeedback.defaultFeedback;
  bool _enabled = true;
  BarcodeCaptureSettings _settings;
  final _modeId = Random().nextInt(0x7FFFFFFF);

  late _BarcodeCaptureListenerController _controller;

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.context].
  ///
  /// Added in version 6.7.0
  @override
  // ignore: unnecessary_overrides
  DataCaptureContext? get context => super.context;

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.isEnabled].
  ///
  /// Added in version 6.7.0
  @override
  bool get isEnabled => _enabled;

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.isEnabled].
  ///
  /// Added in version 6.7.0
  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    _controller.setModeEnabledState(newValue);
  }

  /// Instance of [BarcodeCaptureFeedback] that is used by the barcode scanner to notify users about Success and Failure events.
  ///
  /// The default instance of the Feedback will have both sound and vibration enabled. A default beep sound will be used for the sound.
  ///
  /// To change the feedback emitted, the [BarcodeCaptureFeedback] can be modified as shown below, or a new one can be assigned.
  ///
  /// ```dart
  /// var barcodeCapture = ...;
  /// barcodeCapture.feedback.success = Feedback(null, Sound.defaultSound);
  /// ```
  ///
  /// Added in version 6.7.0
  BarcodeCaptureFeedback get feedback => _feedback;

  /// Instance of [BarcodeCaptureFeedback] that is used by the barcode scanner to notify users about Success and Failure events.
  ///
  /// The default instance of the Feedback will have both sound and vibration enabled. A default beep sound will be used for the sound.
  ///
  /// To change the feedback emitted, the [BarcodeCaptureFeedback] can be modified as shown below, or a new one can be assigned.
  ///
  /// ```dart
  /// var barcodeCapture = ...;
  /// barcodeCapture.feedback.success = Feedback(null, Sound.defaultSound);
  /// ```
  ///
  /// Added in version 6.7.0
  set feedback(BarcodeCaptureFeedback newValue) {
    _feedback = newValue;
    // Set the modeId on the feedback object so it can update independently
    _feedback._setModeId(_modeId);
    _controller.updateFeedback();
  }

  /// Returns the recommended camera settings for use with barcode capture.
  ///
  /// Added in version 7.6.0
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
      torchLevel: defaults.torchLevel,
      macroMode: defaults.macroMode,
      adaptiveExposure: defaults.adaptiveExposure,
    );
  }

  BarcodeCapture._(this._settings) {
    _controller = _BarcodeCaptureListenerController(this);
    // Set the modeId on the initial feedback object
    _feedback._setModeId(_modeId);
  }

  /// Constructs a new BarcodeCapture instance with the provided settings.
  ///
  /// Added in version 7.6.0
  BarcodeCapture(BarcodeCaptureSettings settings) : this._(settings);

  /// Asynchronously applies the new settings to the barcode scanner. If the scanner is currently running, the task will complete when the next frame is processed, and will use the new settings for that frame. If the scanner is currently *not* running, the task will complete as soon as the settings have been stored and won’t wait until the next frame is going to be processed.
  ///
  /// Added in version 6.7.0
  Future<void> applySettings(BarcodeCaptureSettings settings) {
    _settings = settings;
    return _controller.applyNewSettings(settings);
  }

  /// Adds the listener to this barcode capture instance.
  ///
  /// In case the same listener is already observing this instance, calling this method will not add the listener again.
  ///
  /// Added in version 6.7.0
  void addListener(BarcodeCaptureListener listener) {
    _controller.addListener(listener);
  }

  /// Removes a previously added listener from this barcode capture instance.
  ///
  /// In case the listener is not currently observing this instance, calling this method has no effect.
  ///
  /// Added in version 6.7.0
  void removeListener(BarcodeCaptureListener listener) {
    _controller.removeListener(listener);
  }

  /// Adds the listener to observe the outcome of adaptive recognition dispatches performed by this mode’s adaptive recognition service. See [AdaptiveRecognitionServiceListener].
  ///
  /// Added in version 8.7.0
  void addAdaptiveRecognitionServiceListener(AdaptiveRecognitionServiceListener listener) {
    _controller.addAdaptiveRecognitionServiceListener(listener);
  }

  /// Removes a previously added adaptive recognition service listener from this barcode capture instance.
  ///
  /// Added in version 8.7.0
  void removeAdaptiveRecognitionServiceListener(AdaptiveRecognitionServiceListener listener) {
    _controller.removeAdaptiveRecognitionServiceListener(listener);
  }

  /// Async getter for the barcode-capture license info. Returns *null* until the mode has been added to a [DataCaptureContext] with a license that covers barcode capture.
  ///
  /// Added in version 8.6.0
  Future<BarcodeCaptureLicenseInfo?> getBarcodeCaptureLicenseInfo() {
    return _controller.getBarcodeCaptureLicenseInfo();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'barcodeCapture',
      'feedback': _feedback.toMap(),
      'settings': _settings.toMap(),
      'modeId': _modeId,
      'enabled': _enabled,
    };
  }
}

/// Listener interface for traditional barcode capture.
///
/// Added in version 6.7.0
abstract class BarcodeCaptureListener {
  static const String _didUpdateSessionEventName = 'BarcodeCaptureListener.didUpdateSession';
  static const String _didScanEventName = 'BarcodeCaptureListener.didScan';

  /// Invoked after a frame has been processed by barcode capture and the session has been updated. In contrast to didScan(), this method is invoked, regardless whether a code was scanned or not. If codes were recognized in this frame, this method is invoked after didScan().
  ///
  /// This callback will be blocking the further processing of frames, so you should return from it as quickly as possible. Therefore, if you need to perform a time-consuming operation, like querying a database or opening an URL encoded in the barcode data, consider moving it out of this callback, e.g. by using a timeout to let this function return before you do any more work. It is advised to disable the capture mode while you’re doing additional work and enabling it again once that work is done.
  ///
  /// See the documentation in didScan() for information on how to properly stop recognition of barcodes.
  ///
  /// Added in version 6.7.0
  Future<void> didUpdateSession(
    BarcodeCapture barcodeCapture,
    BarcodeCaptureSession session,
    Future<FrameData> Function() getFrameData,
  );
  /// Invoked whenever a code has been scanned. The newly scanned barcode can be retrieved from [BarcodeCaptureSession.newlyRecognizedBarcode].
  ///
  /// This callback will be blocking the further processing of frames, so you should return from it as quickly as possible. Therefore, if you need to perform a time-consuming operation, like querying a database or opening an URL encoded in the barcode data, consider moving it out of this callback, e.g. by using a timeout to let this function return before you do any more work. It is advised to disable the capture mode while you’re doing additional work and enabling it again once that work is done.
  ///
  /// Sometimes, after receiving this callback, you may want to pause scanning or to stop scanning completely.
  ///
  /// - To pause scanning, but keep the camera (frame source) running, just set the barcode capture’s enabled property ([DataCaptureMode.isEnabled]) to *false*.
  ///
  /// ```dart
  /// captureMode.isEnabled = false;
  /// ```
  ///
  /// - To stop scanning, you will need to both disable the capture mode ([DataCaptureMode.isEnabled]) and stop the frame source.
  ///
  /// While it’s possible to only stop the camera and keep the capture mode enabled, this may lead to additional scan events being delivered, which is typically not desired. The following lines of code show how to disable the capture mode and stop the frame source as well:
  ///
  /// ```dart
  /// // no more didScan callbacks will be invoked after this call.
  /// captureMode.isEnabled = false;
  /// // asynchronously turn off the camera
  /// captureMode.context.frameSource.switchToDesiredState(FrameSourceState.off);
  /// ```
  ///
  /// Added in version 6.7.0
  Future<void> didScan(
      BarcodeCapture barcodeCapture, BarcodeCaptureSession session, Future<FrameData> Function() getFrameData);
}

class _BarcodeCaptureListenerController extends BaseController {
  static const String _dispatchStartedEventName = 'BarcodeCaptureAdaptiveRecognitionListener.dispatchStarted';
  static const String _responseEventName = 'BarcodeCaptureAdaptiveRecognitionListener.response';
  static const String _errorEventName = 'BarcodeCaptureAdaptiveRecognitionListener.error';

  final BarcodeCapture _barcodeCapture;
  late final BarcodeMethodHandler barcodeMethodHandler;

  _BarcodeCaptureListenerController(this._barcodeCapture) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
  }

  List<BarcodeCaptureListener> get listeners => ListenerRegistry.instance
      .listenersFor(BarcodeCaptureListener._didScanEventName, ListenerTarget.mode(_barcodeCapture._modeId))
      .cast<BarcodeCaptureListener>();

  @override
  void dispose() {
    for (final listener in listeners) {
      removeListener(listener);
    }
    super.dispose();
  }

  void addListener(BarcodeCaptureListener listener) {
    ListenerRegistry.instance.addListener(
      BarcodeCaptureListener._didUpdateSessionEventName,
      ListenerTarget.mode(_barcodeCapture._modeId),
      listener,
      handler: _handleDidUpdateSessionEvent,
      eventStream: BarcodePluginEvents.barcodeCaptureEventStream,
    );
    ListenerRegistry.instance.addListener(
      BarcodeCaptureListener._didScanEventName,
      ListenerTarget.mode(_barcodeCapture._modeId),
      listener,
      handler: _handleDidScanEvent,
      eventStream: BarcodePluginEvents.barcodeCaptureEventStream,
    );
  }

  void removeListener(BarcodeCaptureListener listener) {
    ListenerRegistry.instance.removeListener(
        BarcodeCaptureListener._didUpdateSessionEventName, ListenerTarget.mode(_barcodeCapture._modeId), listener);
    ListenerRegistry.instance.removeListener(
        BarcodeCaptureListener._didScanEventName, ListenerTarget.mode(_barcodeCapture._modeId), listener);
  }

  void addAdaptiveRecognitionServiceListener(AdaptiveRecognitionServiceListener listener) {
    ListenerRegistry.instance.addListener(
      _dispatchStartedEventName,
      ListenerTarget.mode(_barcodeCapture._modeId),
      listener,
      handler: _handleDispatchStartedEvent,
      eventStream: BarcodePluginEvents.barcodeCaptureEventStream,
    );
    ListenerRegistry.instance.addListener(
      _responseEventName,
      ListenerTarget.mode(_barcodeCapture._modeId),
      listener,
      handler: _handleResponseEvent,
      eventStream: BarcodePluginEvents.barcodeCaptureEventStream,
    );
    ListenerRegistry.instance.addListener(
      _errorEventName,
      ListenerTarget.mode(_barcodeCapture._modeId),
      listener,
      handler: _handleErrorEvent,
      eventStream: BarcodePluginEvents.barcodeCaptureEventStream,
    );
  }

  void removeAdaptiveRecognitionServiceListener(AdaptiveRecognitionServiceListener listener) {
    ListenerRegistry.instance
        .removeListener(_dispatchStartedEventName, ListenerTarget.mode(_barcodeCapture._modeId), listener);
    ListenerRegistry.instance
        .removeListener(_responseEventName, ListenerTarget.mode(_barcodeCapture._modeId), listener);
    ListenerRegistry.instance.removeListener(_errorEventName, ListenerTarget.mode(_barcodeCapture._modeId), listener);
  }

  void _handleDispatchStartedEvent(List<Object> activeListeners, FlutterEvent event) {
    if (event.modeId == null) {
      return;
    }
    unawaited(_processDispatchStarted(event, activeListeners.cast<AdaptiveRecognitionServiceListener>()));
  }

  void _handleResponseEvent(List<Object> activeListeners, FlutterEvent event) {
    if (event.modeId == null) {
      return;
    }
    unawaited(_processResponse(event, activeListeners.cast<AdaptiveRecognitionServiceListener>()));
  }

  void _handleErrorEvent(List<Object> activeListeners, FlutterEvent event) {
    if (event.modeId == null) {
      return;
    }
    unawaited(_processError(event, activeListeners.cast<AdaptiveRecognitionServiceListener>()));
  }

  // Fire-and-forget: unlike didScan/didUpdateSession above, native does not block on a reply for
  // these callbacks, so there is no finishXxx ack call here.
  Future<void> _processDispatchStarted(
      FlutterEvent event, List<AdaptiveRecognitionServiceListener> activeListeners) async {
    are_schema.BarcodeCaptureAdaptiveRecognitionListenerDispatchStarted payload;
    try {
      payload = are_schema.BarcodeCaptureAdaptiveRecognitionListenerDispatchStarted.fromJson(event.payload);
    } catch (error) {
      log('BarcodeCapture dispatchStarted payload failed schema validation: $error');
      return;
    }
    final frameMetadata = AdaptiveRecognitionFrameMetadata.fromJSON(payload.frameMetadata.toJson());
    for (final listener in activeListeners) {
      try {
        listener.onAdaptiveRecognitionServiceDispatchStarted(
          () => _getFrameData(payload.frameDataId),
          frameMetadata,
        );
      } catch (error) {
        log('BarcodeCapture dispatchStarted listener threw: $error');
      }
    }
  }

  Future<void> _processResponse(FlutterEvent event, List<AdaptiveRecognitionServiceListener> activeListeners) async {
    are_schema.BarcodeCaptureAdaptiveRecognitionListenerResponse payload;
    try {
      payload = are_schema.BarcodeCaptureAdaptiveRecognitionListenerResponse.fromJson(event.payload);
    } catch (error) {
      log('BarcodeCapture response payload failed schema validation: $error');
      return;
    }
    final frameMetadata = AdaptiveRecognitionFrameMetadata.fromJSON(payload.frameMetadata.toJson());
    for (final listener in activeListeners) {
      try {
        listener.onAdaptiveRecognitionServiceResponse(payload.response, frameMetadata);
      } catch (error) {
        log('BarcodeCapture response listener threw: $error');
      }
    }
  }

  Future<void> _processError(FlutterEvent event, List<AdaptiveRecognitionServiceListener> activeListeners) async {
    are_schema.BarcodeCaptureAdaptiveRecognitionListenerError payload;
    try {
      payload = are_schema.BarcodeCaptureAdaptiveRecognitionListenerError.fromJson(event.payload);
    } catch (error) {
      log('BarcodeCapture error payload failed schema validation: $error');
      return;
    }
    final frameMetadata = AdaptiveRecognitionFrameMetadata.fromJSON(payload.frameMetadata.toJson());
    final reason = AdaptiveRecognitionErrorReason.fromJSON(payload.reason);
    for (final listener in activeListeners) {
      try {
        listener.onAdaptiveRecognitionServiceError(reason, frameMetadata);
      } catch (error) {
        log('BarcodeCapture error listener threw: $error');
      }
    }
  }

  // Best effort: the frame may already be evicted from the native cache, in which case this
  // resolves null rather than the didScan/didUpdateSession getters' non-null placeholder.
  Future<FrameData?> _getFrameData(String frameDataId) {
    return getCoreMethodHandler()
        .getLastFrameOrNullAsMap(frameId: frameDataId)
        .then((value) => value == null ? null : DefaultFrameData.fromJSON(value), onError: onError);
  }

  void _handleDidScanEvent(List<Object> activeListeners, FlutterEvent event) {
    if (event.modeId == null) {
      return;
    }
    unawaited(_processDidScan(event, List.of(activeListeners.cast<BarcodeCaptureListener>())));
  }

  void _handleDidUpdateSessionEvent(List<Object> activeListeners, FlutterEvent event) {
    if (event.modeId == null) {
      return;
    }
    unawaited(_processDidUpdateSession(event, activeListeners.cast<BarcodeCaptureListener>()));
  }

  // ACK-owing: native blocks on the ack call below, so a schema-parse failure - or a
  // failure downstream of it - must not prevent it: parse tolerantly, do the real work
  // inside `try`, and finish in `finally` so the ack always fires.
  Future<void> _processDidScan(FlutterEvent event, List<BarcodeCaptureListener> activeListeners) async {
    try {
      final payload = _parsePayloadTolerantly<BarcodeCaptureListenerDidScan>(
        event.payload,
        (raw) => BarcodeCaptureListenerDidScan.fromJson(raw),
        (raw) {
          // The fallback can itself throw on a payload malformed enough to break these
          // casts. That is fine: the caller's `finally` still fires the ack.
          // `modeId` and `event` are supplied rather than read: the registry already routed
          // this event by mode and matched it on the event name, so both are known here. It
          // does mean the fallback path asserts the two values the schema would check.
          final map = raw as Map<String, dynamic>;
          return BarcodeCaptureListenerDidScan(
            session: map['session'] as String,
            frameId: map['frameId'] as String?,
            modeId: _barcodeCapture._modeId,
            event: BarcodeCaptureListener._didScanEventName,
          );
        },
        'didScan',
      );
      var session = BarcodeCaptureSession.fromJSON({'session': payload.session, 'frameId': payload.frameId});
      await _notifyListenersOfDidScan(session, activeListeners);
    } catch (error) {
      log('BarcodeCapture didScan failed: $error');
    } finally {
      barcodeMethodHandler
          .finishBarcodeCaptureDidScan(modeId: _barcodeCapture._modeId, enabled: _barcodeCapture.isEnabled)
          .onError(onError);
    }
  }

  Future<void> _processDidUpdateSession(FlutterEvent event, List<BarcodeCaptureListener> activeListeners) async {
    try {
      final payload = _parsePayloadTolerantly<BarcodeCaptureListenerDidUpdateSession>(
        event.payload,
        (raw) => BarcodeCaptureListenerDidUpdateSession.fromJson(raw),
        (raw) {
          // The fallback can itself throw on a payload malformed enough to break these
          // casts. That is fine: the caller's `finally` still fires the ack.
          // `modeId` and `event` are supplied rather than read: the registry already routed
          // this event by mode and matched it on the event name, so both are known here. It
          // does mean the fallback path asserts the two values the schema would check.
          final map = raw as Map<String, dynamic>;
          return BarcodeCaptureListenerDidUpdateSession(
            session: map['session'] as String,
            frameId: map['frameId'] as String?,
            modeId: _barcodeCapture._modeId,
            event: BarcodeCaptureListener._didUpdateSessionEventName,
          );
        },
        'didUpdateSession',
      );
      var session = BarcodeCaptureSession.fromJSON({'session': payload.session, 'frameId': payload.frameId});
      await _notifyListenersOfDidUpateSession(session, activeListeners);
    } catch (error) {
      log('BarcodeCapture didUpdateSession failed: $error');
    } finally {
      barcodeMethodHandler
          .finishBarcodeCaptureDidUpdateSession(modeId: _barcodeCapture._modeId, enabled: _barcodeCapture.isEnabled)
          .onError(onError);
    }
  }

  // ACK-owing: native blocks on the ack call above, so a schema-parse failure must not prevent
  // it - parse tolerantly (fall back to reading the raw map) rather than throw, so the ack still
  // fires promptly instead of surfacing only after the native-side timeout.
  T _parsePayloadTolerantly<T>(
    Map<String, dynamic> raw,
    T Function(Object?) parse,
    T Function(Object?) fallback,
    String event,
  ) {
    try {
      return parse(raw);
    } catch (error) {
      log('BarcodeCapture $event payload failed schema validation: $error');
      return fallback(raw);
    }
  }

  void setModeEnabledState(bool newValue) {
    barcodeMethodHandler
        .setBarcodeCaptureModeEnabledState(modeId: _barcodeCapture._modeId, enabled: newValue)
        .onError(onError);
  }

  Future<void> updateMode() {
    return barcodeMethodHandler
        .updateBarcodeCaptureMode(modeJson: jsonEncode(_barcodeCapture.toMap()))
        .onError(onError);
  }

  Future<void> applyNewSettings(BarcodeCaptureSettings settings) {
    return barcodeMethodHandler
        .applyBarcodeCaptureModeSettings(
            modeId: _barcodeCapture._modeId, modeSettingsJson: jsonEncode(settings.toMap()))
        .onError(onError);
  }

  Future<void> updateFeedback() {
    return barcodeMethodHandler
        .updateBarcodeCaptureFeedback(
            modeId: _barcodeCapture._modeId, feedbackJson: jsonEncode(_barcodeCapture.feedback.toMap()))
        .onError(onError);
  }

  Future<BarcodeCaptureLicenseInfo?> getBarcodeCaptureLicenseInfo() async {
    // executeBarcode returns Future<dynamic>; the generated wrapper would
    // declare Future<String> and crash on a null result, so call it directly.
    final result = await barcodeMethodHandler
        .executeBarcode('BarcodeCaptureModule', 'getBarcodeCaptureLicenseInfo', {'modeId': _barcodeCapture._modeId});
    if (result == null) return null;
    return BarcodeCaptureLicenseInfo.fromJSON(jsonDecode(result as String) as Map<String, dynamic>);
  }

  Future<void> _notifyListenersOfDidUpateSession(
      BarcodeCaptureSession session, List<BarcodeCaptureListener> activeListeners) async {
    for (var i = activeListeners.length - 1; i >= 0; i--) {
      if (i < activeListeners.length) {
        await activeListeners[i].didUpdateSession(_barcodeCapture, session, () => _getLastFrameData(session));
      }
    }
  }

  Future<FrameData> _getLastFrameData(BarcodeCaptureSession session) {
    return getCoreMethodHandler()
        .getLastFrameOrNullAsMap(frameId: session.frameId)
        .then((value) => DefaultFrameData.fromJSON(value), onError: onError);
  }

  Future<void> _notifyListenersOfDidScan(
      BarcodeCaptureSession session, List<BarcodeCaptureListener> activeListeners) async {
    for (var listener in activeListeners) {
      await listener.didScan(_barcodeCapture, session, () => _getLastFrameData(session));
    }
  }
}

/// Determines what feedback (vibration, sound) should be emitted when reading barcodes. The feedback is specified for each [BarcodeCapture] instance separately and can be changed through the [BarcodeCapture.feedback] property by either modifying an existing instance of this class, or by assigning a new one.
///
/// As of now, this class only allows to configure the feedback that gets emitted when a barcode is read successfully, through the [BarcodeCaptureFeedback.success] property.
///
/// See documentation on the [BarcodeCapture.feedback] property for usage samples.
///
/// Added in version 6.7.0
class BarcodeCaptureFeedback implements Serializable {
  late _BarcodeCaptureFeedbackController _controller;
  int? _modeId;

  /// Empty constructor. Constructs a new feedback that will not emit any sound, nor vibration.
  ///
  /// Added in version 6.7.0
  BarcodeCaptureFeedback() {
    _controller = _BarcodeCaptureFeedbackController(this);
  }

  Feedback _success = Feedback.defaultFeedback;

  /// A [Feedback] for a success event.
  ///
  /// Added in version 6.7.0
  Feedback get success => _success;

  /// A [Feedback] for a success event.
  ///
  /// Added in version 6.7.0
  set success(Feedback newValue) {
    _success = newValue;
    _controller.updateFeedback();
  }

  /// Returns a barcode capture feedback with default configuration:
  ///
  /// - default beep sound is loaded,
  /// - beeping for the success event is enabled,
  /// - vibration for the success event is enabled.
  ///
  /// Added in version 6.7.0
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
  late final BarcodeMethodHandler barcodeMethodHandler;

  _BarcodeCaptureFeedbackController(this._feedback) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
  }

  Future<void> updateFeedback() {
    var modeId = _feedback._modeId;
    if (modeId == null) {
      // If no modeId is set, don't update (this feedback is not associated with a mode yet)
      return Future.value();
    }

    return barcodeMethodHandler
        .updateBarcodeCaptureFeedback(modeId: modeId, feedbackJson: jsonEncode(_feedback.toMap()))
        .onError(onError);
  }
}
