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

@Deprecated('BarcodeCaptureOverlayStyle is deprecated and will be removed in a future release.')
enum BarcodeCaptureOverlayStyle {
  frame('frame');

  const BarcodeCaptureOverlayStyle(this._name);

  @override
  String toString() => _name;

  final String _name;
}

// ignore: deprecated_member_use_from_same_package
extension BarcodeCaptureOverlayStyleSerializer on BarcodeCaptureOverlayStyle {
  // ignore: deprecated_member_use_from_same_package
  static BarcodeCaptureOverlayStyle fromJSON(String jsonValue) {
    // ignore: deprecated_member_use_from_same_package
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
    _viewfinder?.removeListener(_handleViewfinderChanged);
    _viewfinder = newValue;
    _viewfinder?.addListener(_handleViewfinderChanged);

    _controller.update();
  }

  void _handleViewfinderChanged() {
    _controller.update();
  }

  // ignore: deprecated_member_use_from_same_package
  final BarcodeCaptureOverlayStyle _style = BarcodeCaptureOverlayStyle.frame;

  @Deprecated('The style property is deprecated and will be removed in a future release.')
  BarcodeCaptureOverlayStyle get style => _style;

  BarcodeCaptureOverlay._(this._barcodeCapture, this.view) : super('barcodeCapture') {
    // ignore: deprecated_member_use_from_same_package
    _brush = BarcodeCaptureDefaults.barcodeCaptureOverlayDefaults.brushes[style]!;
    view?.addOverlay(this);
    _controller = _BarcodeCaptureOverlayController(this);
  }

  BarcodeCaptureOverlay.withBarcodeCapture(BarcodeCapture barcodeCapture)
      : this.withBarcodeCaptureForView(barcodeCapture, null);

  BarcodeCaptureOverlay.withBarcodeCaptureForView(BarcodeCapture barcodeCapture, DataCaptureView? view)
      : this._(barcodeCapture, view);

  @Deprecated(
      'withBarcodeCaptureForViewWithStyle is deprecated and will be removed in a future release. Use the version without style parameter instead.')
  BarcodeCaptureOverlay.withBarcodeCaptureForViewWithStyle(
      BarcodeCapture barcodeCapture, DataCaptureView? view, BarcodeCaptureOverlayStyle style)
      : this.withBarcodeCaptureForView(barcodeCapture, view);

  @Deprecated('Use the brush instance property instead.')
  static Brush get defaultBrush {
    return BarcodeCaptureDefaults.barcodeCaptureOverlayDefaults.brushes[BarcodeCaptureOverlayStyle.frame]!;
  }

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'brush': _brush.toMap(),
      'shouldShowScanAreaGuides': _shouldShowScanAreaGuides,
      'viewfinder': _viewfinder == null ? _noViewfinder : _viewfinder?.toMap(),
      // ignore: deprecated_member_use_from_same_package
      'style': style.toString()
    });
    return json;
  }
}

class _BarcodeCaptureOverlayController {
  late final MethodChannel _methodChannel = _getChannel();

  final BarcodeCaptureOverlay _overlay;

  _BarcodeCaptureOverlayController(this._overlay);

  Future<void> update() {
    return _methodChannel.invokeMethod(
        BarcodeCaptureFunctionNames.updateBarcodeCaptureOverlay, jsonEncode(_overlay.toMap()));
  }

  MethodChannel _getChannel() {
    return const MethodChannel(BarcodeCaptureFunctionNames.methodsChannelName);
  }
}
