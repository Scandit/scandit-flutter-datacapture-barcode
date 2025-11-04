/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_barcode/src/capture/barcode_capture.dart';
import 'package:scandit_flutter_datacapture_barcode/src/capture/barcode_capture_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'barcode_capture_function_names.dart';

class BarcodeCaptureOverlay extends DataCaptureOverlay {
  static final _noViewfinder = {'type': 'none'};

  _BarcodeCaptureOverlayController? _controller;

  DataCaptureView? _view;

  final BarcodeCapture _mode;

  BarcodeCaptureOverlay._(this._mode) : super('barcodeCapture');

  BarcodeCaptureOverlay(BarcodeCapture mode) : this._(mode);

  int get _dataCaptureViewId => _view?.viewId ?? -1;

  @override
  DataCaptureView? get view => _view;

  @override
  set view(DataCaptureView? newValue) {
    if (newValue == null) {
      _view = null;
      _controller = null;
      return;
    }

    _view = newValue;
    _controller ??= _BarcodeCaptureOverlayController(this);
  }

  Brush _brush = BarcodeCaptureDefaults.barcodeCaptureOverlayDefaults.defaultBrush;

  Brush get brush => _brush;

  set brush(Brush newValue) {
    _brush = newValue;
    _controller?.update();
  }

  bool _shouldShowScanAreaGuides = false;

  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller?.update();
  }

  Viewfinder? _viewfinder;

  Viewfinder? get viewfinder => _viewfinder;

  set viewfinder(Viewfinder? newValue) {
    _viewfinder?.removeListener(_handleViewfinderChanged);
    _viewfinder = newValue;
    _viewfinder?.addListener(_handleViewfinderChanged);

    _controller?.update();
  }

  void _handleViewfinderChanged() {
    _controller?.update();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'brush': _brush.toMap(),
      'shouldShowScanAreaGuides': _shouldShowScanAreaGuides,
      'viewfinder': _viewfinder == null ? _noViewfinder : _viewfinder?.toMap(),
    });
    json['modeId'] = _mode.toMap()['modeId'];
    return json;
  }
}

class _BarcodeCaptureOverlayController extends BaseController {
  final BarcodeCaptureOverlay _overlay;

  _BarcodeCaptureOverlayController(this._overlay) : super(BarcodeCaptureFunctionNames.methodsChannelName);

  Future<void> update() {
    return methodChannel.invokeMethod(BarcodeCaptureFunctionNames.updateBarcodeCaptureOverlay, {
      'viewId': _overlay._dataCaptureViewId,
      'overlayJson': jsonEncode(_overlay.toMap()),
    });
  }
}
