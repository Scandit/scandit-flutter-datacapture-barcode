/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_batch.dart';
import 'barcode_batch_defaults.dart';
import 'barcode_batch_function_names.dart';
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

  @override
  DataCaptureView? get view => _view;

  @override
  set view(DataCaptureView? newValue) {
    if (newValue != null && newValue != _view) {
      newValue.addOverlay(this);
    }
    _view = newValue;
    if (_listener != null) {
      _controller.subscribeListener();
    }
  }

  // ignore: unused_field
  final BarcodeBatch _barcodeBatch;

  late _BarcodeBatchBasicOverlayController _controller;

  BarcodeBatchBasicOverlay._(this._barcodeBatch, this.style) : super('barcodeTrackingBasic') {
    _brush = BarcodeBatchDefaults.barcodeBatchBasicOverlayDefaults.brushes[style]!;
    _controller = _BarcodeBatchBasicOverlayController(this);
  }

  BarcodeBatchBasicOverlay.withBarcodeBatch(BarcodeBatch barcodeBatch)
      : this._(barcodeBatch, BarcodeBatchDefaults.barcodeBatchBasicOverlayDefaults.defaultStyle);

  factory BarcodeBatchBasicOverlay.withBarcodeBatchForView(BarcodeBatch barcodeBatch, DataCaptureView? view) {
    return BarcodeBatchBasicOverlay.withBarcodeBatchForViewWithStyle(
        barcodeBatch, view, BarcodeBatchDefaults.barcodeBatchBasicOverlayDefaults.defaultStyle);
  }

  factory BarcodeBatchBasicOverlay.withBarcodeBatchForViewWithStyle(
      BarcodeBatch barcodeBatch, DataCaptureView? view, BarcodeBatchBasicOverlayStyle style) {
    var overlay = BarcodeBatchBasicOverlay._(barcodeBatch, style);
    overlay.view = view;
    return overlay;
  }

  @Deprecated('Use the brush instance property instead.')
  static Brush get defaultBrush {
    return BarcodeBatchDefaults
        .barcodeBatchBasicOverlayDefaults.brushes[BarcodeBatchDefaults.barcodeBatchBasicOverlayDefaults.defaultStyle]!;
  }

  late Brush _brush;

  Brush get brush => _brush;

  set brush(Brush newValue) {
    _brush = newValue;
    _controller.update();
  }

  final BarcodeBatchBasicOverlayStyle style;

  Future<void> setBrushForTrackedBarcode(Brush brush, TrackedBarcode trackedBarcode) {
    return _controller.setBrushForTrackedBarcode(brush, trackedBarcode);
  }

  Future<void> clearTrackedBarcodeBrushes() {
    return _controller.clearTrackedBarcodeBrushes();
  }

  BarcodeBatchBasicOverlayListener? _listener;

  BarcodeBatchBasicOverlayListener? get listener => _listener;

  set listener(BarcodeBatchBasicOverlayListener? newValue) {
    _controller.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller.subscribeListener();
    }

    _listener = newValue;
  }

  var _shouldShowScanAreaGuides = false;
  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller.update();
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
    });
    return json;
  }
}

abstract class BarcodeBatchBasicOverlayListener {
  static const String _brushForTrackedBarcodeEventName = 'BarcodeBatchBasicOverlayListener.brushForTrackedBarcode';
  static const String _didTapTrackedBarcodeEventName = 'BarcodeBatchBasicOverlayListener.didTapTrackedBarcode';

  Brush brushForTrackedBarcode(BarcodeBatchBasicOverlay overlay, TrackedBarcode trackedBarcode);
  void didTapTrackedBarcode(BarcodeBatchBasicOverlay overlay, TrackedBarcode trackedBarcode);
}

class _BarcodeBatchBasicOverlayController {
  final BarcodeBatchBasicOverlay _overlay;
  final MethodChannel _methodChannel = const MethodChannel(BarcodeBatchFunctionNames.methodsChannelName);
  StreamSubscription<dynamic>? _overlaySubscription;

  _BarcodeBatchBasicOverlayController(this._overlay);

  Future<void> setBrushForTrackedBarcode(Brush brush, TrackedBarcode trackedBarcode) {
    var arguments = {
      'brushJson': jsonEncode(brush.toMap()),
      'sessionFrameSequenceID': trackedBarcode.sessionFrameSequenceId,
      'trackedBarcodeIdentifier': trackedBarcode.identifier,
      'dataCaptureViewId': _overlay._dataCaptureViewId,
    };
    return _methodChannel.invokeMethod(BarcodeBatchFunctionNames.setBrushForTrackedBarcode, arguments);
  }

  Future<void> clearTrackedBarcodeBrushes() {
    return _methodChannel.invokeMethod(BarcodeBatchFunctionNames.clearTrackedBarcodeBrushes, {
      'dataCaptureViewId': _overlay._dataCaptureViewId,
    });
  }

  Future<void> update() {
    return _methodChannel.invokeMethod(BarcodeBatchFunctionNames.updateBarcodeBatchBasicOverlay, {
      'dataCaptureViewId': _overlay._dataCaptureViewId,
      'overlayJson': jsonEncode(_overlay.toMap()),
    });
  }

  void unsubscribeListener() {
    _overlaySubscription?.cancel();
    _methodChannel.invokeMethod(BarcodeBatchFunctionNames.unsubscribeBTBasicOverlayListener, {
      'dataCaptureViewId': _overlay._dataCaptureViewId,
    }).then((value) => null, onError: (error, stacktrace) => null);
  }

  void subscribeListener() {
    _methodChannel.invokeMethod(BarcodeBatchFunctionNames.subscribeBTBasicOverlayListener, {
      'dataCaptureViewId': _overlay._dataCaptureViewId,
    }).then((value) => _registerEventChannelStreamListener(), onError: (error, stacktrace) => log(error));
  }

  void _registerEventChannelStreamListener() {
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
          await _methodChannel.invokeMethod(BarcodeBatchFunctionNames.setBrushForTrackedBarcode, {
            'brushJson': jsonEncode(brush.toMap()),
            'trackedBarcodeIdentifier': trackedBarcode.identifier,
            'sessionFrameSequenceID': trackedBarcode.sessionFrameSequenceId,
            'dataCaptureViewId': _overlay._dataCaptureViewId,
          });
          break;
        case BarcodeBatchBasicOverlayListener._didTapTrackedBarcodeEventName:
          _overlay._listener
              ?.didTapTrackedBarcode(_overlay, TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode'])));
          break;
      }
    });
  }
}
