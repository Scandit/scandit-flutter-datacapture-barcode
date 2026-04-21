/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/selection/barcode_selection.dart';
import 'package:scandit_flutter_datacapture_barcode/src/selection/barcode_selection_function_names.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'barcode_selection_defaults.dart';

enum BarcodeSelectionBasicOverlayStyle {
  frame('frame'),
  dot('dot');

  const BarcodeSelectionBasicOverlayStyle(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeSelectionBasicOverlayStyleSerializer on BarcodeSelectionBasicOverlayStyle {
  static BarcodeSelectionBasicOverlayStyle fromJSON(String jsonValue) {
    return BarcodeSelectionBasicOverlayStyle.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

class BarcodeSelectionBasicOverlay extends DataCaptureOverlay {
  _BarcodeSelectionBasicOverlayController? _controller;

  final BarcodeSelectionBasicOverlayStyle style;

  final BarcodeSelection _mode;

  BarcodeSelectionBasicOverlay._(this._mode, this._view, this.style) : super('barcodeSelectionBasic') {
    var brushDefaultsForCurrentStyle = BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.brushes[style]!;
    _aimedBrush = brushDefaultsForCurrentStyle.aimedBrush;
    _selectedBrush = brushDefaultsForCurrentStyle.selectedBrush;
    _selectingBrush = brushDefaultsForCurrentStyle.selectingBrush;
    _trackedBrush = brushDefaultsForCurrentStyle.trackedBrush;

    view?.addOverlay(this);
    viewfinder.addListener(_handleViewfinderChanged);
  }

  BarcodeSelectionBasicOverlay(BarcodeSelection mode, {BarcodeSelectionBasicOverlayStyle? style})
      : this._(mode, null, style ?? BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.defaultStyle);

  @Deprecated('Use BarcodeSelectionBasicOverlay({BarcodeSelectionBasicOverlayStyle? style})')
  BarcodeSelectionBasicOverlay.withBarcodeSelection(BarcodeSelection barcodeSelection)
      : this.withBarcodeSelectionForView(barcodeSelection, null);

  @Deprecated('Use BarcodeSelectionBasicOverlay({BarcodeSelectionBasicOverlayStyle? style})')
  BarcodeSelectionBasicOverlay.withBarcodeSelectionForView(BarcodeSelection barcodeSelection, DataCaptureView? view)
      : this.withBarcodeSelectionForViewWithStyle(
            barcodeSelection, view, BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.defaultStyle);

  @Deprecated('Use BarcodeSelectionBasicOverlay({BarcodeSelectionBasicOverlayStyle? style})')
  BarcodeSelectionBasicOverlay.withBarcodeSelectionForViewWithStyle(
      BarcodeSelection barcodeSelection, DataCaptureView? view, BarcodeSelectionBasicOverlayStyle style)
      : this._(barcodeSelection, view, style);

  DataCaptureView? _view;

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
    _controller ??= _BarcodeSelectionBasicOverlayController(this);
  }

  late Brush _trackedBrush;

  Brush get trackedBrush => _trackedBrush;

  set trackedBrush(Brush newValue) {
    _trackedBrush = newValue;
    _controller?.update();
  }

  late Brush _aimedBrush;

  Brush get aimedBrush => _aimedBrush;

  set aimedBrush(Brush newValue) {
    _aimedBrush = newValue;
    _controller?.update();
  }

  late Brush _selectedBrush;

  Brush get selectedBrush => _selectedBrush;

  set selectedBrush(Brush newValue) {
    _selectedBrush = newValue;
    _controller?.update();
  }

  late Brush _selectingBrush;

  Brush get selectingBrush => _selectingBrush;

  set selectingBrush(Brush newValue) {
    _selectingBrush = newValue;
    _controller?.update();
  }

  bool _shouldShowScanAreaGuides = false;

  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller?.update();
  }

  bool _shouldShowHints = BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.shouldShowHints;

  bool get shouldShowHints => _shouldShowHints;

  set shouldShowHints(bool newValue) {
    _shouldShowHints = newValue;
    _controller?.update();
  }

  void _handleViewfinderChanged() {
    _controller?.update();
  }

  final Viewfinder _viewfinder = AimerViewfinder();

  Viewfinder get viewfinder => _viewfinder;

  Color _frozenBackgroundColor = BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.frozenBackgroundColor;

  Color get frozenBackgroundColor => _frozenBackgroundColor;

  set frozenBackgroundColor(Color newValue) {
    _frozenBackgroundColor = newValue;
    _controller?.update();
  }

  String? _textForSelectOrDoubleTapToFreezeHint;

  Future<void> setTextForSelectOrDoubleTapToFreezeHint(String text) {
    _textForSelectOrDoubleTapToFreezeHint = text;
    return _controller?.update() ?? Future.value();
  }

  String? _textForTapToSelectHint;

  Future<void> setTextForTapToSelectHint(String text) {
    _textForTapToSelectHint = text;
    return _controller?.update() ?? Future.value();
  }

  String? _textForDoubleTapToUnfreezeHint;

  Future<void> setTextForDoubleTapToUnfreezeHint(String text) {
    _textForDoubleTapToUnfreezeHint = text;
    return _controller?.update() ?? Future.value();
  }

  String? _textForTapAnywhereToSelectHint;

  Future<void> setTextForTapAnywhereToSelectHint(String text) {
    _textForTapAnywhereToSelectHint = text;
    return _controller?.update() ?? Future.value();
  }

  String? _textForAimToSelectAutoHint;

  Future<void> setTextForAimToSelectAutoHint(String text) {
    _textForAimToSelectAutoHint = text;
    return _controller?.update() ?? Future.value();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'trackedBrush': _trackedBrush.toMap(),
      'aimedBrush': _aimedBrush.toMap(),
      'selectingBrush': _selectingBrush.toMap(),
      'selectedBrush': _selectedBrush.toMap(),
      'shouldShowHints': _shouldShowHints,
      'shouldShowScanAreaGuides': _shouldShowScanAreaGuides,
      'viewfinder': _viewfinder.toMap(),
      'style': style.toString(),
      'frozenBackgroundColor': _frozenBackgroundColor.jsonValue,
    });
    if (_textForSelectOrDoubleTapToFreezeHint != null) {
      json['textForSelectOrDoubleTapToFreezeHint'] = _textForSelectOrDoubleTapToFreezeHint;
    }
    if (_textForTapToSelectHint != null) {
      json['textForTapToSelectHint'] = _textForTapToSelectHint;
    }
    if (_textForDoubleTapToUnfreezeHint != null) {
      json['textForDoubleTapToUnfreezeHint'] = _textForDoubleTapToUnfreezeHint;
    }
    if (_textForTapAnywhereToSelectHint != null) {
      json['textForTapAnywhereToSelectHint'] = _textForTapAnywhereToSelectHint;
    }
    if (_textForAimToSelectAutoHint != null) {
      json['textForAimToSelectAutoHint'] = _textForAimToSelectAutoHint;
    }
    json['modeId'] = _mode.toMap()['modeId'];
    return json;
  }
}

class _BarcodeSelectionBasicOverlayController extends BaseController {
  final BarcodeSelectionBasicOverlay _overlay;

  _BarcodeSelectionBasicOverlayController(this._overlay) : super(BarcodeSelectionFunctionNames.methodsChannelName);

  Future<void> update() {
    return methodChannel.invokeMethod(
      BarcodeSelectionFunctionNames.updateBarcodeSelectionBasicOverlay,
      jsonEncode(_overlay.toMap()),
    );
  }
}
