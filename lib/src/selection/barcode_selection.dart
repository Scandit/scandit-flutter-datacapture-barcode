import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
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

  BarcodeSelection(BarcodeSelectionSettings settings) : this._(settings);

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
      torchLevel: defaults.torchLevel,
      macroMode: defaults.macroMode,
      adaptiveExposure: defaults.adaptiveExposure,
    );
  }

  BarcodeSelectionFeedback get feedback => _feedback;

  set feedback(BarcodeSelectionFeedback newValue) {
    _feedback.removeListener(_updateFeedbackHandler);
    _feedback = newValue;
    _feedback.addListener(_updateFeedbackHandler);
    _controller.updateFeedback();
  }

  void _updateFeedbackHandler() {
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

  Future<void> applySettings(BarcodeSelectionSettings settings) async {
    _settings = settings;
    return _controller.applyNewSettings(settings);
  }

  Future<void> unfreezeCamera() {
    return _controller.unfreezeCamera();
  }

  Future<void> freezeCamera() {
    return _controller.freezeCamera();
  }

  Future<void> reset() {
    return _controller.reset();
  }

  Future<void> selectAimedBarcode() {
    return _controller.selectAimedBarcode();
  }

  Future<void> selectUnselectedBarcodes() {
    return _controller.selectUnselectedBarcodes();
  }

  Future<void> unselectBarcodes(List<Barcode> barcodes) {
    return _controller.unselectBarcodes(barcodes);
  }

  Future<void> increaseCountForBarcodes(List<Barcode> barcodes) {
    return _controller.increaseCountForBarcodes(barcodes);
  }

  Future<void> setSelectBarcodeEnabled(Barcode barcode, bool enabled) {
    return _controller.setSelectBarcodeEnabled(barcode, enabled);
  }

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
      'hasListeners': _listeners.isNotEmpty,
      'enabled': _enabled,
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
    Future<FrameData?> Function() getFrameData,
  );
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

    _barcodeSelectionSubscription = BarcodePluginEvents.barcodeSelectionEventStream.asFlutterEvents().listen((event) {
      if (_barcodeSelection._listeners.isEmpty) return;

      if (event.isEvent(BarcodeSelectionListener._didUpdateSelectionEventName)) {
        var session = BarcodeSelectionSession.fromJSON(event.payload);
        _notifyListenersOfDidUpdateSelection(session).then((value) {
          methodHandler
              .finishBarcodeSelectionDidSelect(modeId: _barcodeSelection._modeId, enabled: _barcodeSelection.isEnabled)
              .then((value) => null, onError: (error) => developer.log(error));
        });
      } else if (event.isEvent(BarcodeSelectionListener._didUpdateSessionEventName)) {
        var session = BarcodeSelectionSession.fromJSON(event.payload);
        _notifyListenersOfDidUpateSession(session).then((value) {
          methodHandler
              .finishBarcodeSelectionDidUpdateSession(
                  modeId: _barcodeSelection._modeId, enabled: _barcodeSelection.isEnabled)
              .then((value) => null, onError: (error) => developer.log(error));
        });
      }
    });
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
