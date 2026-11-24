/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/capture/barcode_capture.dart';
import 'package:scandit_flutter_datacapture_barcode/src/capture/barcode_capture_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

/// Overlay for the [BarcodeCapture] capture mode that displays recognized barcodes on top of a data capture view ([DataCaptureView]).
///
/// The appearance of the visualized barcodes can be configured or turned off completely through the [BarcodeCaptureOverlay.brush] property.
///
/// Added in version 6.7.0
class BarcodeCaptureOverlay extends DataCaptureOverlay {
  static final _noViewfinder = {'type': 'none'};

  _BarcodeCaptureOverlayController? _controller;

  DataCaptureView? _view;

  final BarcodeCapture _mode;

  BarcodeCaptureOverlay._(this._mode) : super('barcodeCapture');

  /// Constructs a new BarcodeCaptureOverlay. For the overlay to be displayed on screen, it must be added to a [DataCaptureView].
  ///
  /// Added in version 7.6.0
  BarcodeCaptureOverlay(BarcodeCapture mode) : this._(mode);

  int get _dataCaptureViewId => _view?.viewId ?? -1;

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 6.7.0
  @override
  DataCaptureView? get view => _view;

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 6.7.0
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

  /// The brush used for visualizing a recognized barcode in the UI. To turn off drawing of locations, set the brush to use both a transparent fill and stroke color. By default, the brush has a transparent fill color, a “Scandit”-blue stroke color, and a stroke width of 1.
  ///
  /// Added in version 6.7.0
  Brush get brush => _brush;

  /// The brush used for visualizing a recognized barcode in the UI. To turn off drawing of locations, set the brush to use both a transparent fill and stroke color. By default, the brush has a transparent fill color, a “Scandit”-blue stroke color, and a stroke width of 1.
  ///
  /// Added in version 6.7.0
  set brush(Brush newValue) {
    _brush = newValue;
    _controller?.update();
  }

  bool _shouldShowScanAreaGuides = false;

  /// Whether to show scan area guides on top of the preview. This property is useful during development to visualize the current scan areas on screen. It is not meant to be used for production. By default this property is *false*.
  ///
  /// Added in version 6.7.0
  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  /// Whether to show scan area guides on top of the preview. This property is useful during development to visualize the current scan areas on screen. It is not meant to be used for production. By default this property is *false*.
  ///
  /// Added in version 6.7.0
  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller?.update();
  }

  Viewfinder? _viewfinder;

  /// Sets the viewfinder. By default, the viewfinder is *null*. Set this to an instance of [Viewfinder] if you want to draw a viewfinder.
  ///
  /// Added in version 6.7.0
  Viewfinder? get viewfinder => _viewfinder;

  /// Sets the viewfinder. By default, the viewfinder is *null*. Set this to an instance of [Viewfinder] if you want to draw a viewfinder.
  ///
  /// Added in version 6.7.0
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
  late final BarcodeMethodHandler barcodeMethodHandler;
  _BarcodeCaptureOverlayController(this._overlay) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
  }

  Future<void> update() {
    return barcodeMethodHandler
        .updateBarcodeCaptureOverlay(viewId: _overlay._dataCaptureViewId, overlayJson: jsonEncode(_overlay.toMap()))
        .onError(onError);
  }
}
