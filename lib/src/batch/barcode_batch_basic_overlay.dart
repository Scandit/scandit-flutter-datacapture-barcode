/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/batch/barcode_batch.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

import 'barcode_batch_defaults.dart';
import '../tracked_barcode.dart';

enum BarcodeBatchBasicOverlayStyle {
  frame('frame'),
  dot('dot');

  const BarcodeBatchBasicOverlayStyle(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeBatchBasicOverlayStyleSerializer on BarcodeBatchBasicOverlayStyle {
  static BarcodeBatchBasicOverlayStyle fromJSON(String jsonValue) {
    return BarcodeBatchBasicOverlayStyle.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

class BarcodeBatchBasicOverlay extends DataCaptureOverlay {
  DataCaptureView? _view;

  int get _dataCaptureViewId => _view?.viewId ?? -1;

  final BarcodeBatch _mode;

  @override
  DataCaptureView? get view => _view;

  @override
  set view(DataCaptureView? newValue) {
    if (newValue == null) {
      _view = null;
      _controller?.dispose();
      _controller = null;
      return;
    }

    _view = newValue;
    _controller ??= _BarcodeBatchBasicOverlayController(this);
  }

  _BarcodeBatchBasicOverlayController? _controller;

  BarcodeBatchBasicOverlay._(this._mode, this.style) : super('barcodeTrackingBasic') {
    _brush = BarcodeBatchDefaults.barcodeBatchBasicOverlayDefaults.brushes[style]!;
    _controller = _BarcodeBatchBasicOverlayController(this);
  }

  BarcodeBatchBasicOverlay(BarcodeBatch mode, {BarcodeBatchBasicOverlayStyle? style})
      : this._(mode, style ?? BarcodeBatchDefaults.barcodeBatchBasicOverlayDefaults.defaultStyle);

  late Brush _brush;

  Brush get brush => _brush;

  set brush(Brush newValue) {
    _brush = newValue;
    _controller?.update();
  }

  final BarcodeBatchBasicOverlayStyle style;

  Future<void> setBrushForTrackedBarcode(Brush? brush, TrackedBarcode trackedBarcode) {
    return _controller?.setBrushForTrackedBarcode(brush, trackedBarcode) ?? Future.value();
  }

  Future<void> clearTrackedBarcodeBrushes() {
    return _controller?.clearTrackedBarcodeBrushes() ?? Future.value();
  }

  BarcodeBatchBasicOverlayListener? _listener;

  BarcodeBatchBasicOverlayListener? get listener => _listener;

  set listener(BarcodeBatchBasicOverlayListener? newValue) {
    _controller?.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller?.subscribeListener();
    }

    _listener = newValue;
  }

  var _shouldShowScanAreaGuides = false;
  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller?.update();
  }

  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'defaultBrush': _brush.toMap(),
      'shouldShowScanAreaGuides': _shouldShowScanAreaGuides,
      'style': style.toString(),
      'hasListener': _listener != null,
      'modeId': _mode.toMap()['modeId'],
    });
    return json;
  }
}

abstract class BarcodeBatchBasicOverlayListener {
  static const String _brushForTrackedBarcodeEventName = 'BarcodeBatchBasicOverlayListener.brushForTrackedBarcode';
  static const String _didTapTrackedBarcodeEventName = 'BarcodeBatchBasicOverlayListener.didTapTrackedBarcode';

  Brush? brushForTrackedBarcode(BarcodeBatchBasicOverlay overlay, TrackedBarcode trackedBarcode);
  void didTapTrackedBarcode(BarcodeBatchBasicOverlay overlay, TrackedBarcode trackedBarcode);
}

class _BarcodeBatchBasicOverlayController extends BaseController {
  final BarcodeBatchBasicOverlay _overlay;
  late final BarcodeMethodHandler barcodeMethodHandler;
  StreamSubscription<dynamic>? _overlaySubscription;

  _BarcodeBatchBasicOverlayController(this._overlay) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
    initialize();
  }

  void initialize() {
    if (_overlay._listener != null) {
      subscribeListener();
    }
  }

  Future<void> setBrushForTrackedBarcode(Brush? brush, TrackedBarcode trackedBarcode) {
    return barcodeMethodHandler
        .setBrushForTrackedBarcode(
            dataCaptureViewId: _overlay._dataCaptureViewId,
            trackedBarcodeIdentifier: trackedBarcode.identifier,
            brushJson: brush != null ? jsonEncode(brush.toMap()) : null)
        .onError(onError);
  }

  Future<void> clearTrackedBarcodeBrushes() {
    return barcodeMethodHandler
        .clearTrackedBarcodeBrushes(dataCaptureViewId: _overlay._dataCaptureViewId)
        .onError(onError);
  }

  Future<void> update() {
    return barcodeMethodHandler
        .updateBarcodeBatchBasicOverlay(
            dataCaptureViewId: _overlay._dataCaptureViewId, overlayJson: jsonEncode(_overlay.toMap()))
        .onError(onError);
  }

  void unsubscribeListener() {
    _overlaySubscription?.cancel();
    barcodeMethodHandler
        .unregisterListenerForBasicOverlayEvents(dataCaptureViewId: _overlay._dataCaptureViewId)
        .onError(onError);
    _overlaySubscription = null;
  }

  void subscribeListener() {
    barcodeMethodHandler
        .registerListenerForBasicOverlayEvents(dataCaptureViewId: _overlay._dataCaptureViewId)
        .then((value) => _registerEventChannelStreamListener(), onError: onError);
  }

  void _registerEventChannelStreamListener() {
    if (_overlaySubscription != null) return;

    _overlaySubscription = BarcodePluginEvents.barcodeBatchEventStream.listen((event) async {
      if (_overlay._listener == null) return;

      var json = jsonDecode(event as String);
      switch (json['event'] as String) {
        case BarcodeBatchBasicOverlayListener._brushForTrackedBarcodeEventName:
          var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode']));
          var brush = _overlay._listener?.brushForTrackedBarcode(_overlay, trackedBarcode);
          if (brush == null) {
            break;
          }
          await barcodeMethodHandler.setBrushForTrackedBarcode(
              dataCaptureViewId: _overlay._dataCaptureViewId,
              trackedBarcodeIdentifier: trackedBarcode.identifier,
              brushJson: jsonEncode(brush.toMap()));
          break;
        case BarcodeBatchBasicOverlayListener._didTapTrackedBarcodeEventName:
          _overlay._listener?.didTapTrackedBarcode(
            _overlay,
            TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode'])),
          );
          break;
      }
    });
  }

  @override
  void dispose() {
    unsubscribeListener();
    super.dispose();
  }
}
