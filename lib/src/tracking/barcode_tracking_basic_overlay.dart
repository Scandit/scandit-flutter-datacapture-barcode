/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_tracking.dart';
import 'barcode_tracking_defaults.dart';
import 'barcode_tracking_function_names.dart';
import 'tracked_barcode.dart';

enum BarcodeTrackingBasicOverlayStyle { legacy, frame, dot }

extension BarcodeTrackingBasicOverlayStyleSerializer on BarcodeTrackingBasicOverlayStyle {
  static BarcodeTrackingBasicOverlayStyle fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'legacy':
        return BarcodeTrackingBasicOverlayStyle.legacy;
      case 'frame':
        return BarcodeTrackingBasicOverlayStyle.frame;
      case 'dot':
        return BarcodeTrackingBasicOverlayStyle.dot;
      default:
        throw Exception('Missing BarcodeTrackingBasicOverlayStyle for name "$jsonValue"');
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case BarcodeTrackingBasicOverlayStyle.legacy:
        return 'legacy';
      case BarcodeTrackingBasicOverlayStyle.frame:
        return 'frame';
      case BarcodeTrackingBasicOverlayStyle.dot:
        return 'dot';
    }
  }
}

class BarcodeTrackingBasicOverlay extends DataCaptureOverlay {
  DataCaptureView? _view;

  @override
  DataCaptureView? get view => _view;

  @override
  set view(DataCaptureView? newValue) {
    if (newValue != null) {
      newValue.addOverlay(this);
    }
    _view = newValue;
  }

  final BarcodeTracking _barcodeTracking;

  late _BarcodeTrackingBasicOverlayController _controller;

  BarcodeTrackingBasicOverlay._(this._barcodeTracking, this.style) : super('barcodeTrackingBasic') {
    _brush = BarcodeTrackingDefaults.barcodeTrackingBasicOverlayDefaults.brushes[style]!;
    _controller = _BarcodeTrackingBasicOverlayController(this);
  }

  BarcodeTrackingBasicOverlay.withBarcodeTracking(BarcodeTracking barcodeTracking)
      : this._(barcodeTracking, BarcodeTrackingDefaults.barcodeTrackingBasicOverlayDefaults.defaultStyle);

  factory BarcodeTrackingBasicOverlay.withBarcodeTrackingForView(
      BarcodeTracking barcodeTracking, DataCaptureView? view) {
    return BarcodeTrackingBasicOverlay.withBarcodeTrackingForViewWithStyle(
        barcodeTracking, view, BarcodeTrackingDefaults.barcodeTrackingBasicOverlayDefaults.defaultStyle);
  }

  factory BarcodeTrackingBasicOverlay.withBarcodeTrackingForViewWithStyle(
      BarcodeTracking barcodeTracking, DataCaptureView? view, BarcodeTrackingBasicOverlayStyle style) {
    var overlay = BarcodeTrackingBasicOverlay._(barcodeTracking, style);
    overlay.view = view;
    return overlay;
  }

  @Deprecated('Use the brush instance property instead.')
  static Brush get defaultBrush {
    return BarcodeTrackingDefaults.barcodeTrackingBasicOverlayDefaults
        .brushes[BarcodeTrackingDefaults.barcodeTrackingBasicOverlayDefaults.defaultStyle]!;
  }

  late Brush _brush;

  Brush get brush => _brush;

  set brush(Brush newValue) {
    _brush = newValue;
    _barcodeTracking.didChange();
  }

  final BarcodeTrackingBasicOverlayStyle style;

  Future<void> setBrushForTrackedBarcode(Brush brush, TrackedBarcode trackedBarcode) {
    return _controller.setBrushForTrackedBarcode(brush, trackedBarcode);
  }

  Future<void> clearTrackedBarcodeBrushes() {
    return _controller.clearTrackedBarcodeBrushes();
  }

  BarcodeTrackingBasicOverlayListener? _listener;

  BarcodeTrackingBasicOverlayListener? get listener => _listener;

  set listener(BarcodeTrackingBasicOverlayListener? newValue) {
    _controller.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller.subscribeListener();
    }

    _listener = newValue;
  }

  var _shouldShowScanAreaGuides = false;
  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _barcodeTracking.didChange();
  }

  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'defaultBrush': _brush.toMap(),
      'shouldShowScanAreaGuides': _shouldShowScanAreaGuides,
      'style': style.jsonValue
    });
    return json;
  }
}

abstract class BarcodeTrackingBasicOverlayListener {
  static const String _brushForTrackedBarcodeEventName = 'barcodeTrackingBasicOverlayListener-brushForTrackedBarcode';
  static const String _didTapTrackedBarcodeEventName = 'barcodeTrackingBasicOverlayListener-didTapTrackedBarcode';

  Brush brushForTrackedBarcode(BarcodeTrackingBasicOverlay overlay, TrackedBarcode trackedBarcode);
  void didTapTrackedBarcode(BarcodeTrackingBasicOverlay overlay, TrackedBarcode trackedBarcode);
}

class _BarcodeTrackingBasicOverlayController {
  final BarcodeTrackingBasicOverlay _overlay;
  final EventChannel _eventChannel =
      EventChannel('com.scandit.datacapture.barcode.tracking.event/barcode_tracking_basic_overlay');
  final MethodChannel _methodChannel =
      MethodChannel("com.scandit.datacapture.barcode.tracking.method/barcode_tracking_basic_overlay");
  StreamSubscription<dynamic>? _overlaySubscription;

  _BarcodeTrackingBasicOverlayController(this._overlay);

  Future<void> setBrushForTrackedBarcode(Brush brush, TrackedBarcode trackedBarcode) {
    var arguments = {
      'brush': brush.toMap(),
      'sessionFrameSequenceID': trackedBarcode.sessionFrameSequenceId,
      'trackedBarcodeID': trackedBarcode.identifier
    };
    return _methodChannel.invokeMethod(BarcodeTrackingFunctionNames.setBrushForTrackedBarcode, jsonEncode(arguments));
  }

  Future<void> clearTrackedBarcodeBrushes() {
    return _methodChannel.invokeMethod(BarcodeTrackingFunctionNames.clearTrackedBarcodeBrushes);
  }

  void unsubscribeListener() {
    _overlaySubscription?.cancel();
    _methodChannel
        .invokeMethod(BarcodeTrackingFunctionNames.unsubscribeBTBasicOverlayListener)
        .then((value) => null, onError: (error, stacktrace) => null);
  }

  void subscribeListener() {
    _methodChannel
        .invokeMethod(BarcodeTrackingFunctionNames.subscribeBTBasicOverlayListener)
        .then((value) => _registerEventChannelStreamListener(), onError: (error, stacktrace) => print(error));
  }

  void _registerEventChannelStreamListener() {
    _overlaySubscription = _eventChannel.receiveBroadcastStream().listen((event) async {
      if (_overlay._listener == null) return;

      var json = jsonDecode(event as String);
      switch (json['event'] as String) {
        case BarcodeTrackingBasicOverlayListener._brushForTrackedBarcodeEventName:
          var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode']));
          var brush = _overlay._listener?.brushForTrackedBarcode(_overlay, trackedBarcode);
          if (brush == null) {
            break;
          }
          await _methodChannel.invokeMethod(
              BarcodeTrackingFunctionNames.finishBrushForTrackedBarcodeCallback, jsonEncode(brush.toMap()));
          break;
        case BarcodeTrackingBasicOverlayListener._didTapTrackedBarcodeEventName:
          _overlay._listener
              ?.didTapTrackedBarcode(_overlay, TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode'])));
          break;
      }
    });
  }
}
