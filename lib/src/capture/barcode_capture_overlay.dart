/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../capture/barcode_capture_defaults.dart';
import '../capture/barcode_capture.dart';
import 'barcode_capture_function_names.dart';

enum BarcodeCaptureOverlayStyle {
  @Deprecated('The legacy style is deprecated.')
  legacy('legacy'),
  frame('frame');

  const BarcodeCaptureOverlayStyle(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeCaptureOverlayStyleSerializer on BarcodeCaptureOverlayStyle {
  static BarcodeCaptureOverlayStyle fromJSON(String jsonValue) {
    return BarcodeCaptureOverlayStyle.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

class BarcodeCaptureOverlay extends DataCaptureOverlay {
  static final _noViewfinder = {'type': 'none'};

  late _BarcodeCaptureOverlayController _controller;

  @override
  DataCaptureView? view;

  // ignore: unused_field
  BarcodeCapture _barcodeCapture;

  late Brush _brush;

  Brush get brush => _brush;

  set brush(Brush newValue) {
    _brush = newValue;
    _controller.update();
  }

  bool _shouldShowScanAreaGuides = false;

  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller.update();
  }

  Viewfinder? _viewfinder;

  Viewfinder? get viewfinder => _viewfinder;

  set viewfinder(Viewfinder? newValue) {
    _viewfinder = newValue;
    _controller.update();
  }

  final BarcodeCaptureOverlayStyle style;

  BarcodeCaptureOverlay._(this._barcodeCapture, this.view, this.style) : super('barcodeCapture') {
    _brush = BarcodeCaptureDefaults.barcodeCaptureOverlayDefaults.brushes[style]!;
    view?.addOverlay(this);
    _controller = _BarcodeCaptureOverlayController(this);
  }

  BarcodeCaptureOverlay.withBarcodeCapture(BarcodeCapture barcodeCapture)
      : this.withBarcodeCaptureForView(barcodeCapture, null);

  BarcodeCaptureOverlay.withBarcodeCaptureForView(BarcodeCapture barcodeCapture, DataCaptureView? view)
      : this.withBarcodeCaptureForViewWithStyle(
            barcodeCapture, view, BarcodeCaptureDefaults.barcodeCaptureOverlayDefaults.defaultStyle);

  BarcodeCaptureOverlay.withBarcodeCaptureForViewWithStyle(
      BarcodeCapture barcodeCapture, DataCaptureView? view, BarcodeCaptureOverlayStyle style)
      : this._(barcodeCapture, view, style);

  @Deprecated('Use the brush instance property instead.')
  static Brush get defaultBrush {
    return BarcodeCaptureDefaults
        .barcodeCaptureOverlayDefaults.brushes[BarcodeCaptureDefaults.barcodeCaptureOverlayDefaults.defaultStyle]!;
  }

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'brush': _brush.toMap(),
      'shouldShowScanAreaGuides': _shouldShowScanAreaGuides,
      'viewfinder': _viewfinder == null ? _noViewfinder : _viewfinder?.toMap(),
      'style': style.toString()
    });
    return json;
  }
}

class _BarcodeCaptureOverlayController {
  late final MethodChannel _methodChannel = _getChannel();

  BarcodeCaptureOverlay _overlay;

  _BarcodeCaptureOverlayController(this._overlay);

  Future<void> update() {
    return _methodChannel.invokeMethod(
        BarcodeCaptureFunctionNames.updateBarcodeCaptureOverlay, jsonEncode(_overlay.toMap()));
  }

  MethodChannel _getChannel() {
    return MethodChannel(BarcodeCaptureFunctionNames.methodsChannelName);
  }
}
