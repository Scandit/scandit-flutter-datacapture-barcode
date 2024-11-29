/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/selection/barcode_selection_function_names.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'barcode_selection_defaults.dart';
import 'barcode_selection.dart';

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
  @override
  DataCaptureView? view;

  late _BarcodeSelectionBasicOverlayController _controller;

  // ignore: unused_field
  final BarcodeSelection _barcodeSelection;

  late Brush _trackedBrush;

  Brush get trackedBrush => _trackedBrush;

  set trackedBrush(Brush newValue) {
    _trackedBrush = newValue;
    _controller.update();
  }

  late Brush _aimedBrush;

  Brush get aimedBrush => _aimedBrush;

  set aimedBrush(Brush newValue) {
    _aimedBrush = newValue;
    _controller.update();
  }

  late Brush _selectedBrush;

  Brush get selectedBrush => _selectedBrush;

  set selectedBrush(Brush newValue) {
    _selectedBrush = newValue;
    _controller.update();
  }

  late Brush _selectingBrush;

  Brush get selectingBrush => _selectingBrush;

  set selectingBrush(Brush newValue) {
    _selectingBrush = newValue;
    _controller.update();
  }

  bool _shouldShowScanAreaGuides = false;

  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller.update();
  }

  bool _shouldShowHints = BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.shouldShowHints;

  bool get shouldShowHints => _shouldShowHints;

  set shouldShowHints(bool newValue) {
    _shouldShowHints = newValue;
    _controller.update();
  }

  void _handleViewfinderChanged() {
    _controller.update();
  }

  final Viewfinder _viewfinder = AimerViewfinder();

  Viewfinder get viewfinder => _viewfinder;

  final BarcodeSelectionBasicOverlayStyle style;

  BarcodeSelectionBasicOverlay._(this._barcodeSelection, this.view, this.style) : super('barcodeSelectionBasic') {
    var brushDefaultsForCurrentStyle = BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.brushes[style]!;
    _aimedBrush = brushDefaultsForCurrentStyle.aimedBrush;
    _selectedBrush = brushDefaultsForCurrentStyle.selectedBrush;
    _selectingBrush = brushDefaultsForCurrentStyle.selectingBrush;
    _trackedBrush = brushDefaultsForCurrentStyle.trackedBrush;
    view?.addOverlay(this);
    _controller = _BarcodeSelectionBasicOverlayController(this);

    viewfinder.addListener(_handleViewfinderChanged);
  }

  Color _frozenBackgroundColor = BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.frozenBackgroundColor;

  Color get frozenBackgroundColor => _frozenBackgroundColor;

  set frozenBackgroundColor(Color newValue) {
    _frozenBackgroundColor = newValue;
    _controller.update();
  }

  BarcodeSelectionBasicOverlay.withBarcodeSelection(BarcodeSelection barcodeSelection)
      : this.withBarcodeSelectionForView(barcodeSelection, null);

  BarcodeSelectionBasicOverlay.withBarcodeSelectionForView(BarcodeSelection barcodeSelection, DataCaptureView? view)
      : this.withBarcodeSelectionForViewWithStyle(
            barcodeSelection, view, BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.defaultStyle);

  BarcodeSelectionBasicOverlay.withBarcodeSelectionForViewWithStyle(
      BarcodeSelection barcodeSelection, DataCaptureView? view, BarcodeSelectionBasicOverlayStyle style)
      : this._(barcodeSelection, view, style);

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
    return json;
  }
}

class _BarcodeSelectionBasicOverlayController {
  late final MethodChannel _methodChannel = _getChannel();

  final BarcodeSelectionBasicOverlay _overlay;

  _BarcodeSelectionBasicOverlayController(this._overlay);

  Future<void> update() {
    return _methodChannel.invokeMethod(
        BarcodeSelectionFunctionNames.updateBarcodeSelectionBasicOverlay, jsonEncode(_overlay.toMap()));
  }

  MethodChannel _getChannel() {
    return const MethodChannel(BarcodeSelectionFunctionNames.methodsChannelName);
  }
}
