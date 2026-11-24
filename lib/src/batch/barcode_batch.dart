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
    show BarcodeBatchListenerDidUpdateSession;
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';

import 'barcode_batch_defaults.dart';
import 'barcode_batch_license_info.dart';
import 'barcode_batch_session.dart';
import 'barcode_batch_settings.dart';

/// Data capture mode that implements MatrixScan (Barcode Batch).
///
/// Learn more on how to use Barcode Batch in our [Get Started](https://docs.scandit.com/sdks/flutter/matrixscan/get-started) guide.
///
/// Added in version 6.7.0
class BarcodeBatch extends DataCaptureMode {
  bool _enabled = true;
  BarcodeBatchSettings _settings;
  final List<BarcodeBatchListener> _listeners = [];
  final _modeId = Random().nextInt(0x7FFFFFFF);

  late _BarcodeBatchListenerController _controller;

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.context].
  ///
  /// Added in version 7.0.0
  @override
  // ignore: unnecessary_overrides
  DataCaptureContext? get context => super.context;

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.isEnabled].
  ///
  /// Added in version 7.0.0
  @override
  bool get isEnabled => _enabled;

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.isEnabled].
  ///
  /// Added in version 7.0.0
  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    _controller.setModeEnabledState(newValue);
  }

  /// Returns the recommended camera settings for use with Barcode Batch.
  ///
  /// Added in version 7.6.0
  static CameraSettings createRecommendedCameraSettings() {
    return CameraSettings(
      BarcodeBatchDefaults.recommendedCameraSettings.preferredResolution,
      BarcodeBatchDefaults.recommendedCameraSettings.zoomFactor,
      BarcodeBatchDefaults.recommendedCameraSettings.focusRange,
      BarcodeBatchDefaults.recommendedCameraSettings.focusGestureStrategy,
      BarcodeBatchDefaults.recommendedCameraSettings.zoomGestureZoomFactor,
      properties: BarcodeBatchDefaults.recommendedCameraSettings.properties,
      shouldPreferSmoothAutoFocus: BarcodeBatchDefaults.recommendedCameraSettings.shouldPreferSmoothAutoFocus,
      torchLevel: BarcodeBatchDefaults.recommendedCameraSettings.torchLevel,
      macroMode: BarcodeBatchDefaults.recommendedCameraSettings.macroMode,
      adaptiveExposure: BarcodeBatchDefaults.recommendedCameraSettings.adaptiveExposure,
    );
  }

  BarcodeBatch._(this._settings) {
    _controller = _BarcodeBatchListenerController(this);
  }

  /// Constructs a new BarcodeBatch instance with the provided settings.
  ///
  /// Added in version 7.6.0
  BarcodeBatch(BarcodeBatchSettings settings) : this._(settings);

  /// Asynchronously applies the new settings to the barcode scanner. If the scanner is currently running, the task will complete when the next frame is processed, and will use the new settings for that frame. If the scanner is currently *not* running, the task will complete as soon as the settings have been stored and won’t wait until the next frame is going to be processed.
  ///
  /// Added in version 7.0.0
  Future<void> applySettings(BarcodeBatchSettings settings) {
    _settings = settings;
    return _controller.applyNewSettings(settings);
  }

  /// Adds the listener to observe this barcode capture instance.
  ///
  /// In case the same listener is already observing this instance, calling this method will not add the listener again.
  ///
  /// Added in version 7.0.0
  void addListener(BarcodeBatchListener listener) {
    if (_listeners.isEmpty) {
      _controller.subscribeListeners();
    }

    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  /// Removes a previously added listener from this Barcode Batch instance.
  ///
  /// In case the listener is not currently observing this instance, calling this method has no effect.
  ///
  /// Added in version 7.0.0
  void removeListener(BarcodeBatchListener listener) {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  /// Async getter for the Barcode Batch license info. Returns *null* until the mode has been added to a [DataCaptureContext] with a license that covers Barcode Batch.
  ///
  /// Added in version 8.6.0
  Future<BarcodeBatchLicenseInfo?> getBarcodeBatchLicenseInfo() {
    return _controller.getBarcodeBatchLicenseInfo();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'barcodeTracking',
      'settings': _settings.toMap(),
      'modeId': _modeId,
      'enabled': _enabled,
    };
  }
}

/// The BarcodeBatch listener is the main way for hooking into BarcodeBatch. It provides a callback that is invoked when the state of tracked barcodes changes.
///
/// Added in version 7.0.0
abstract class BarcodeBatchListener {
  static const String _barcodeBatchListenerDidUpdateSession = 'BarcodeBatchListener.didUpdateSession';
  /// Invoked after Barcode Batch has completed to process a frame.
  ///
  /// Added in version 7.0.0
  Future<void> didUpdateSession(
    BarcodeBatch barcodeBatch,
    BarcodeBatchSession session,
    Future<FrameData> Function() getFrameData,
  );
}

class _BarcodeBatchListenerController extends BaseController {
  final BarcodeBatch mode;
  late final BarcodeMethodHandler barcodeMethodHandler;
  StreamSubscription<dynamic>? subscription;

  _BarcodeBatchListenerController(this.mode) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
  }

  @override
  void dispose() {
    unsubscribeListeners();
    super.dispose();
  }

  void subscribeListeners() {
    if (subscription == null) {
      _listenForEvents();
    }

    barcodeMethodHandler.registerBarcodeBatchListenerForEvents(modeId: mode._modeId).onError(onError);
  }

  void _listenForEvents() {
    subscription =
        BarcodePluginEvents.barcodeBatchEventStream.asFlutterEvents().forMode(mode._modeId).listen((event) async {
      if (event.isEvent(BarcodeBatchListener._barcodeBatchListenerDidUpdateSession)) {
        // ACK-owing: native blocks on the ack call below, so a schema-parse failure - or a
        // failure downstream of it - must not prevent it: parse tolerantly, do the real work
        // inside `try`, and finish in `finally` so the ack always fires.
        try {
          final payload = _parsePayloadTolerantly<BarcodeBatchListenerDidUpdateSession>(
            event.payload,
            (raw) => BarcodeBatchListenerDidUpdateSession.fromJson(raw),
            (raw) {
              // The fallback can itself throw on a payload malformed enough to break these
              // casts. That is fine: the caller's `finally` still fires the ack.
              // `modeId` and `event` are supplied rather than read: this stream is already
              // `forMode`-filtered and matched on the event name, so both are known here. It
              // does mean the fallback path asserts the two values the schema would check.
              final map = raw as Map<String, dynamic>;
              return BarcodeBatchListenerDidUpdateSession(
                session: map['session'] as String,
                frameId: map['frameId'] as String?,
                modeId: mode._modeId,
                event: BarcodeBatchListener._barcodeBatchListenerDidUpdateSession,
              );
            },
            'didUpdateSession',
          );
          if (mode._listeners.isNotEmpty) {
            var session = BarcodeBatchSession.fromJSON({'session': payload.session, 'frameId': payload.frameId});
            await _notifyDidUpdateListeners(session);
          }
        } catch (error) {
          log('BarcodeBatch didUpdateSession failed: $error');
        } finally {
          barcodeMethodHandler
              .finishBarcodeBatchDidUpdateSessionCallback(modeId: mode._modeId, enabled: mode.isEnabled)
              .onError(onError);
        }
      }
    });
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
      log('BarcodeBatch $event payload failed schema validation: $error');
      return fallback(raw);
    }
  }

  Future<void> updateMode() {
    return barcodeMethodHandler.updateBarcodeBatchMode(modeJson: jsonEncode(mode.toMap())).onError(onError);
  }

  Future<BarcodeBatchLicenseInfo?> getBarcodeBatchLicenseInfo() async {
    // executeBarcode returns Future<dynamic>; the generated wrapper would
    // declare Future<String> and crash on a null result, so call it directly.
    final result = await barcodeMethodHandler
        .executeBarcode('BarcodeBatchModule', 'getBarcodeBatchLicenseInfo', {'modeId': mode._modeId});
    if (result == null) return null;
    return BarcodeBatchLicenseInfo.fromJSON(jsonDecode(result as String) as Map<String, dynamic>);
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
