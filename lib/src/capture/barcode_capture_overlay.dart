/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../capture/barcode_capture_defaults.dart';
import '../capture/barcode_capture.dart';

enum BarcodeCaptureOverlayStyle { legacy, frame }

extension BarcodeCaptureOverlayStyleSerializer on BarcodeCaptureOverlayStyle {
  static BarcodeCaptureOverlayStyle fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'legacy':
        return BarcodeCaptureOverlayStyle.legacy;
      case 'frame':
        return BarcodeCaptureOverlayStyle.frame;
      default:
        throw Exception('Missing BarcodeCaptureOverlayStyle for name "$jsonValue"');
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case BarcodeCaptureOverlayStyle.legacy:
        return 'legacy';
      case BarcodeCaptureOverlayStyle.frame:
        return 'frame';
    }
  }
}

class BarcodeCaptureOverlay extends DataCaptureOverlay {
  static final _noViewfinder = {'type': 'none'};

  @override
  DataCaptureView? view;

  BarcodeCapture _barcodeCapture;

  late Brush _brush;

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

  final BarcodeCaptureOverlayStyle style;

  BarcodeCaptureOverlay._(this._barcodeCapture, this.view, this.style) : super('barcodeCapture') {
    _brush = BarcodeCaptureDefaults.barcodeCaptureOverlayDefaults.brushes[style]!;
    view?.addOverlay(this);
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
      'style': style.jsonValue
    });
    return json;
  }
}
