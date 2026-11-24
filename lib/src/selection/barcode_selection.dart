import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show BarcodeSelectionListenerDidUpdateSelection, BarcodeSelectionListenerDidUpdateSession;
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/generated/core_method_handler.dart';

import 'barcode_selection_defaults.dart';
import 'barcode_selection_feedback.dart';
import 'barcode_selection_license_info.dart';
import 'barcode_selection_settings.dart';
import 'barcode_selection_session.dart';

/// Data capture mode that implements barcode selection.
///
/// Learn more on how to use Barcode Selection in our [Get Started](https://docs.scandit.com/sdks/flutter/barcode-selection/get-started) guide.
///
/// Added in version 6.10.0
class BarcodeSelection extends DataCaptureMode {
  final List<BarcodeSelectionListener> _listeners = [];
  late _BarcodeSelectionListenerController _controller;
  BarcodeSelectionSettings _settings;
  BarcodeSelectionFeedback _feedback = BarcodeSelectionFeedback.defaultFeedback;
  PointWithUnit? _pointOfInterest;

  final _modeId = Random().nextInt(0x7FFFFFFF);

  BarcodeSelection._(this._settings) {
    _controller = _BarcodeSelectionListenerController(this);
    _feedback.addListener(_updateFeedbackHandler);
  }

  /// Constructs a new BarcodeSelection instance with the provided settings.
  ///
  /// Added in version 7.6.0
  BarcodeSelection(BarcodeSelectionSettings settings) : this._(settings);

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.context].
  ///
  /// Added in version 6.10.0
  @override
  // ignore: unnecessary_overrides
  DataCaptureContext? get context => super.context;

  bool _enabled = true;

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.isEnabled].
  ///
  /// Added in version 6.10.0
  @override
  bool get isEnabled => _enabled;

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.isEnabled].
  ///
  /// Added in version 6.10.0
  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    _controller.setModeEnabledState(newValue);
  }

  /// Returns the recommended camera settings for use with barcode selection.
  ///
  /// Added in version 7.6.0
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
      torchLevel: defaults.torchLevel,
      macroMode: defaults.macroMode,
      adaptiveExposure: defaults.adaptiveExposure,
    );
  }

  /// Instance of [BarcodeSelectionFeedback] that is used by barcode selection to notify users about the selection of a barcode.
  ///
  /// The default instance of the Feedback will have the sound enabled but no vibration. A default click tone will be used for the sound.
  ///
  /// To change the feedback emitted, the [BarcodeSelectionFeedback] can be modified as shown below, or a new one can be assigned.
  ///
  /// ```dart
  /// var barcodeSelection = ...;
  /// barcodeSelection.feedback.selection = Feedback(null, Sound.defaultSound);
  /// ```
  ///
  /// Added in version 6.10.0
  BarcodeSelectionFeedback get feedback => _feedback;

  /// Instance of [BarcodeSelectionFeedback] that is used by barcode selection to notify users about the selection of a barcode.
  ///
  /// The default instance of the Feedback will have the sound enabled but no vibration. A default click tone will be used for the sound.
  ///
  /// To change the feedback emitted, the [BarcodeSelectionFeedback] can be modified as shown below, or a new one can be assigned.
  ///
  /// ```dart
  /// var barcodeSelection = ...;
  /// barcodeSelection.feedback.selection = Feedback(null, Sound.defaultSound);
  /// ```
  ///
  /// Added in version 6.10.0
  set feedback(BarcodeSelectionFeedback newValue) {
    _feedback.removeListener(_updateFeedbackHandler);
    _feedback = newValue;
    _feedback.addListener(_updateFeedbackHandler);
    _controller.updateFeedback();
  }

  void _updateFeedbackHandler() {
    _controller.updateFeedback();
  }

  /// The point of interest overwriting the point of interest of the data capture view ([DataCaptureView.pointOfInterest]). By default, this overwriting point of interest is not set and the one from the data capture view is used.
  ///
  /// Added in version 6.10.0
  PointWithUnit? get pointOfInterest {
    return _pointOfInterest;
  }

  /// The point of interest overwriting the point of interest of the data capture view ([DataCaptureView.pointOfInterest]). By default, this overwriting point of interest is not set and the one from the data capture view is used.
  ///
  /// Added in version 6.10.0
  set pointOfInterest(PointWithUnit? newValue) {
    _pointOfInterest = newValue;
    _controller.updateMode();
  }

  /// Adds the listener to this barcode selection instance.
  ///
  /// In case the same listener is already observing this instance, calling this method will not add the listener again.
  ///
  /// Added in version 6.10.0
  void addListener(BarcodeSelectionListener listener) {
    if (_listeners.isEmpty) {
      _controller.subscribeListeners();
    }
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  /// Removes a previously added listener from this barcode selection instance.
  ///
  /// In case the listener is not currently observing this instance, calling this method has no effect.
  ///
  /// Added in version 6.10.0
  void removeListener(BarcodeSelectionListener listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  /// Asynchronously applies the new settings to the barcode selection. If the barcode selection is currently running, the task will complete when the next frame is processed, and will use the new settings for that frame. If the barcode selection is currently *not* running, the task will complete as soon as the settings have been stored and won’t wait until the next frame is going to be processed.
  ///
  /// Added in version 6.10.0
  Future<void> applySettings(BarcodeSelectionSettings settings) async {
    _settings = settings;
    return _controller.applyNewSettings(settings);
  }

  /// Unfreeze the camera.
  ///
  /// Added in version 6.10.0
  Future<void> unfreezeCamera() {
    return _controller.unfreezeCamera();
  }

  /// Freeze the camera.
  ///
  /// Added in version 8.5.0
  Future<void> freezeCamera() {
    return _controller.freezeCamera();
  }

  /// Asynchronously resets the barcode selection session, effectively clearing the history of selected codes.
  ///
  /// Added in version 6.10.0
  Future<void> reset() {
    return _controller.reset();
  }

  /// Select the barcode being aimed at. Only use this with manual aimer selection.
  ///
  /// Added in version 8.5.0
  Future<void> selectAimedBarcode() {
    return _controller.selectAimedBarcode();
  }

  /// Select all the unselected barcodes that are being tracked in current the barcode selection session. This action is dispatched asynchronously and may happen on the next frame.
  ///
  /// Added in version 8.5.0
  Future<void> selectUnselectedBarcodes() {
    return _controller.selectUnselectedBarcodes();
  }

  /// Removes the barcodes from the list of selected barcodes.
  ///
  /// Added in version 8.5.0
  Future<void> unselectBarcodes(List<Barcode> barcodes) {
    return _controller.unselectBarcodes(barcodes);
  }

  /// Increments the count of how many times the given barcodes have been selected.
  ///
  /// Added in version 8.5.0
  Future<void> increaseCountForBarcodes(List<Barcode> barcodes) {
    return _controller.increaseCountForBarcodes(barcodes);
  }

  /// Enables or disables the selection of a barcode.
  ///
  /// Added in version 8.5.0
  Future<void> setSelectBarcodeEnabled(Barcode barcode, bool enabled) {
    return _controller.setSelectBarcodeEnabled(barcode, enabled);
  }

  /// Async getter for the barcode-selection license info. Returns *null* until the mode has been added to a [DataCaptureContext] with a license that covers barcode selection.
  ///
  /// Added in version 8.5.0
  Future<BarcodeSelectionLicenseInfo?> getBarcodeSelectionLicenseInfo() {
    return _controller.getBarcodeSelectionLicenseInfo();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'barcodeSelection',
      'feedback': _feedback.toMap(),
      'settings': _settings.toMap(),
      'modeId': _modeId,
      'enabled': _enabled,
    };
    if (_pointOfInterest != null) {
      json['pointOfInterest'] = _pointOfInterest?.toMap();
    }
    json['modeId'] = _modeId;
    return json;
  }
}

/// The BarcodeSelection listener is the main way for hooking into BarcodeSelection. It provides a callback that is invoked when the state of selected barcodes changes.
///
/// Added in version 6.10.0
abstract class BarcodeSelectionListener {
  static const String _didUpdateSelectionEventName = 'BarcodeSelectionListener.didUpdateSelection';
  static const String _didUpdateSessionEventName = 'BarcodeSelectionListener.didUpdateSession';

  /// Invoked whenever a barcode is selected or a previously selected barcode is unselected.
  ///
  /// [FrameData] is *null* if the camera is frozen and the selection is changed.
  ///
  /// Added in version 6.10.0
  Future<void> didUpdateSelection(
    BarcodeSelection barcodeSelection,
    BarcodeSelectionSession session,
    Future<FrameData?> Function() getFrameData,
  );
  /// Invoked after a frame has been processed by barcode selection and the session has been updated. In contrast to didUpdateSelection(), this method is invoked, regardless whether a code was selected or not.
  ///
  /// [FrameData] is *null* if the camera is frozen and the selection is changed.
  ///
  /// Added in version 6.10.0
  Future<void> didUpdateSession(
    BarcodeSelection barcodeSelection,
    BarcodeSelectionSession session,
    Future<FrameData?> Function() getFrameData,
  );
}

class _BarcodeSelectionListenerController extends BaseController {
  final BarcodeSelection _barcodeSelection;
  StreamSubscription<dynamic>? _barcodeSelectionSubscription;
  late final BarcodeMethodHandler methodHandler;
  late final CoreMethodHandler coreMethodHandler;
  final Set<String> _warnedSchemaValidationEvents = {};

  _BarcodeSelectionListenerController(this._barcodeSelection) : super(BarcodeFunctionNames.methodsChannelName) {
    methodHandler = BarcodeMethodHandler(methodChannel);
  }

  @override
  void dispose() {
    unsubscribeListeners();
    super.dispose();
  }

  void subscribeListeners() {
    methodHandler
        .registerBarcodeSelectionListenerForEvents(modeId: _barcodeSelection._modeId)
        .then((value) => _setupBarcodeSelectionSubscription(), onError: onError);
  }

  void unsubscribeListeners() {
    _barcodeSelectionSubscription?.cancel();
    methodHandler
        .unregisterBarcodeSelectionListenerForEvents(modeId: _barcodeSelection._modeId)
        .then((value) => null, onError: onError);
    _barcodeSelectionSubscription = null;
  }

  void _setupBarcodeSelectionSubscription() {
    if (_barcodeSelectionSubscription != null) return;

    _barcodeSelectionSubscription =
        BarcodePluginEvents.barcodeSelectionEventStream.forMode(_barcodeSelection._modeId).listen((event) async {
      // ACK-owing: native blocks on the ack call below, so a schema-parse failure - or a
      // failure downstream of it - must not prevent it: parse tolerantly, do the real work
      // inside `try`, and finish in `finally` so the ack always fires.
      if (event.isEvent(BarcodeSelectionListener._didUpdateSelectionEventName)) {
        try {
          final payload = _parsePayloadTolerantly<BarcodeSelectionListenerDidUpdateSelection>(
            event.payload,
            (raw) => BarcodeSelectionListenerDidUpdateSelection.fromJson(raw),
            (raw) {
              final map = raw as Map<String, dynamic>;
              return BarcodeSelectionListenerDidUpdateSelection(
                session: map['session'] as String,
                frameId: map['frameId'] as String?,
                modeId: map['modeId'] as int,
                event: BarcodeSelectionListener._didUpdateSelectionEventName,
              );
            },
            'didUpdateSelection',
          );
          if (_barcodeSelection._listeners.isNotEmpty) {
            var session = BarcodeSelectionSession.fromJSON(
                {'session': payload.session, 'frameId': payload.frameId, 'modeId': payload.modeId});
            await _notifyListenersOfDidUpdateSelection(session);
          }
        } catch (error) {
          developer.log('BarcodeSelection didUpdateSelection failed: $error');
        } finally {
          methodHandler
              .finishBarcodeSelectionDidSelect(modeId: _barcodeSelection._modeId, enabled: _barcodeSelection.isEnabled)
              .onError((error, _) => developer.log(error.toString()));
        }
      } else if (event.isEvent(BarcodeSelectionListener._didUpdateSessionEventName)) {
        try {
          final payload = _parsePayloadTolerantly<BarcodeSelectionListenerDidUpdateSession>(
            event.payload,
            (raw) => BarcodeSelectionListenerDidUpdateSession.fromJson(raw),
            (raw) {
              final map = raw as Map<String, dynamic>;
              return BarcodeSelectionListenerDidUpdateSession(
                session: map['session'] as String,
                frameId: map['frameId'] as String?,
                modeId: map['modeId'] as int,
                event: BarcodeSelectionListener._didUpdateSessionEventName,
              );
            },
            'didUpdateSession',
          );
          if (_barcodeSelection._listeners.isNotEmpty) {
            var session = BarcodeSelectionSession.fromJSON(
                {'session': payload.session, 'frameId': payload.frameId, 'modeId': payload.modeId});
            await _notifyListenersOfDidUpateSession(session);
          }
        } catch (error) {
          developer.log('BarcodeSelection didUpdateSession failed: $error');
        } finally {
          methodHandler
              .finishBarcodeSelectionDidUpdateSession(
                  modeId: _barcodeSelection._modeId, enabled: _barcodeSelection.isEnabled)
              .onError((error, _) => developer.log(error.toString()));
        }
      }
    });
  }

  // ACK-owing: native blocks on the ack call above, so a schema-parse failure must not prevent
  // it - parse tolerantly (fall back to reading the raw map) rather than throw, so the ack still
  // fires promptly instead of surfacing only after the native-side timeout.
  //
  // Duplicated (near-)verbatim across BarcodeSelectionListenerController.ts,
  // BarcodeSelectionOverlayController.ts and this file. Lifting it into a shared base is
  // deliberately out of scope for this slice - it would touch seven other modes mid-epic.
  // Consolidation owner: SDC-32638.
  //
  // Deliberate divergence from the TS copies (SDC-32666 review): TS falls back to
  // `raw as unknown as T`, an unchecked cast the compiler allows for a structural type. Dart's
  // generated schema types are real classes with required fields, so the same unchecked
  // reinterpret isn't expressible here - this `fallback` callback exists to hand-construct a
  // best-effort T from the raw map. Not aligned further: doing so would change behaviour.
  T _parsePayloadTolerantly<T>(
    Map<String, dynamic> raw,
    T Function(Object?) parse,
    T Function(Object?) fallback,
    String event,
  ) {
    try {
      return parse(raw);
    } catch (error) {
      if (_warnedSchemaValidationEvents.add(event)) {
        developer.log('BarcodeSelection $event payload failed schema validation: $error');
      }
      return fallback(raw);
    }
  }

  Future<void> unfreezeCamera() {
    return methodHandler
        .unfreezeCameraInBarcodeSelection(modeId: _barcodeSelection._modeId)
        .then((value) => null, onError: onError);
  }

  Future<void> freezeCamera() {
    return methodHandler
        .freezeCameraInBarcodeSelection(modeId: _barcodeSelection._modeId)
        .then((value) => null, onError: onError);
  }

  Future<void> selectAimedBarcode() {
    return methodHandler.selectAimedBarcode(modeId: _barcodeSelection._modeId).then((value) => null, onError: onError);
  }

  Future<void> selectUnselectedBarcodes() {
    return methodHandler
        .selectUnselectedBarcodes(modeId: _barcodeSelection._modeId)
        .then((value) => null, onError: onError);
  }

  Future<BarcodeSelectionLicenseInfo?> getBarcodeSelectionLicenseInfo() async {
    // executeBarcode returns Future<dynamic>; the generated wrapper would
    // declare Future<String> and crash on a null result, so call it directly.
    final result = await methodHandler.executeBarcode(
        'BarcodeSelectionModule', 'getBarcodeSelectionLicenseInfo', {'modeId': _barcodeSelection._modeId});
    if (result == null) return null;
    return BarcodeSelectionLicenseInfo.fromJSON(jsonDecode(result as String) as Map<String, dynamic>);
  }

  Future<void> unselectBarcodes(List<Barcode> barcodes) {
    return methodHandler
        .unselectBarcodes(
            modeId: _barcodeSelection._modeId, barcodesJson: jsonEncode(barcodes.map(_barcodeToJson).toList()))
        .then((value) => null, onError: onError);
  }

  Future<void> increaseCountForBarcodes(List<Barcode> barcodes) {
    return methodHandler
        .increaseCountForBarcodes(
            modeId: _barcodeSelection._modeId, barcodeJson: jsonEncode(barcodes.map(_barcodeToJson).toList()))
        .then((value) => null, onError: onError);
  }

  Future<void> setSelectBarcodeEnabled(Barcode barcode, bool enabled) {
    return methodHandler
        .setSelectBarcodeEnabled(
            modeId: _barcodeSelection._modeId, barcodeJson: jsonEncode(_barcodeToJson(barcode)), enabled: enabled)
        .then((value) => null, onError: onError);
  }

  // Projection accepted by the native bridge to identify a Barcode against the cached session.
  Map<String, dynamic> _barcodeToJson(Barcode barcode) => {
        'data': barcode.data,
        'rawData': barcode.rawData,
        'symbology': barcode.symbology.toString(),
        'symbolCount': barcode.symbolCount,
      };

  Future<void> reset() {
    return methodHandler
        .resetBarcodeSelection(modeId: _barcodeSelection._modeId)
        .then((value) => null, onError: onError);
  }

  Future<void> updateMode() {
    return methodHandler
        .updateBarcodeSelectionMode(modeId: _barcodeSelection._modeId, modeJson: jsonEncode(_barcodeSelection.toMap()))
        .then((value) => null, onError: onError);
  }

  Future<void> updateFeedback() {
    return methodHandler
        .updateBarcodeSelectionFeedback(
            modeId: _barcodeSelection._modeId, feedbackJson: jsonEncode(_barcodeSelection.feedback.toMap()))
        .then((value) => null, onError: onError);
  }

  Future<void> applyNewSettings(BarcodeSelectionSettings settings) {
    return methodHandler
        .applyBarcodeSelectionModeSettings(
            modeId: _barcodeSelection._modeId, modeSettingsJson: jsonEncode(settings.toMap()))
        .then((value) => null, onError: onError);
  }

  Future<void> _notifyListenersOfDidUpateSession(BarcodeSelectionSession session) async {
    // Iterate backwards to avoid allocation and handle concurrent modifications safely
    // This is called frequently so we avoid creating a copy
    for (var i = _barcodeSelection._listeners.length - 1; i >= 0; i--) {
      if (i < _barcodeSelection._listeners.length) {
        await _barcodeSelection._listeners[i]
            .didUpdateSession(_barcodeSelection, session, () => _getLastFrameData(session));
      }
    }
  }

  Future<void> _notifyListenersOfDidUpdateSelection(BarcodeSelectionSession session) async {
    for (var listener in _barcodeSelection._listeners.toList()) {
      await listener.didUpdateSelection(_barcodeSelection, session, () => _getLastFrameData(session));
    }
  }

  Future<FrameData?> _getLastFrameData(BarcodeSelectionSession session) {
    final frameId = session.frameId;
    if (frameId == null) return Future.value(null);

    return coreMethodHandler
        .getLastFrameOrNullAsMap(frameId: frameId)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: onError);
  }

  void setModeEnabledState(bool newValue) {
    methodHandler
        .setBarcodeSelectionModeEnabledState(modeId: _barcodeSelection._modeId, enabled: newValue)
        .then((value) => null, onError: onError);
  }
}
