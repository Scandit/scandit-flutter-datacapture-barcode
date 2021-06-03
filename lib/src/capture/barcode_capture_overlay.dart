/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../capture/barcode_capture_defaults.dart';
import '../capture/barcode_capture.dart';

class BarcodeCaptureOverlay extends DataCaptureOverlay {
  static final _noViewfinder = {'type': 'none'};

  @override
  DataCaptureView? view;

  BarcodeCapture _barcodeCapture;

  Brush _brush = defaultBrush;

  Brush get brush => _brush;

  set brush(Brush newValue) {
    _brush = newValue;
    _barcodeCapture.didChange();
  }

  bool _shouldShowScanAreaGuides = false;

  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _barcodeCapture.didChange();
  }

  Viewfinder? _viewfinder;

  Viewfinder? get viewfinder => _viewfinder;

  set viewfinder(Viewfinder? newValue) {
    _viewfinder = newValue;
    _barcodeCapture.didChange();
  }

  BarcodeCaptureOverlay._(this._barcodeCapture, this.view) : super('barcodeCapture') {
    view?.addOverlay(this);
  }

  BarcodeCaptureOverlay.withBarcodeCapture(BarcodeCapture barcodeCapture) : this._(barcodeCapture, null);

  BarcodeCaptureOverlay.withBarcodeCaptureForView(BarcodeCapture barcodeCapture, DataCaptureView? view)
      : this._(barcodeCapture, view);

  static Brush get defaultBrush => Brush(
      BarcodeCaptureDefaults.barcodeCaptureOverlayDefaults.defaultBrush.fillColor,
      BarcodeCaptureDefaults.barcodeCaptureOverlayDefaults.defaultBrush.strokeColor,
      BarcodeCaptureDefaults.barcodeCaptureOverlayDefaults.defaultBrush.strokeWidth);

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'brush': _brush.toMap(),
      'shouldShowScanAreaGuides': _shouldShowScanAreaGuides,
      'viewfinder': _viewfinder == null ? _noViewfinder : _viewfinder?.toMap()
    });
    return json;
  }
}
