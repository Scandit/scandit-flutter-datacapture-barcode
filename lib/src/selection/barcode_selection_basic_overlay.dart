/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'barcode_selection_defaults.dart';
import 'barcode_selection.dart';

enum BarcodeSelectionBasicOverlayStyle { frame, dot }

extension BarcodeSelectionBasicOverlayStyleSerializer on BarcodeSelectionBasicOverlayStyle {
  static BarcodeSelectionBasicOverlayStyle fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'frame':
        return BarcodeSelectionBasicOverlayStyle.frame;
      case 'dot':
        return BarcodeSelectionBasicOverlayStyle.dot;
      default:
        throw Exception('Missing BarcodeSelectionBasicOverlayStyle for name "$jsonValue"');
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case BarcodeSelectionBasicOverlayStyle.frame:
        return 'frame';
      case BarcodeSelectionBasicOverlayStyle.dot:
        return 'dot';
    }
  }
}

class BarcodeSelectionBasicOverlay extends DataCaptureOverlay {
  @override
  DataCaptureView? view;

  final BarcodeSelection _barcodeSelection;

  late Brush _trackedBrush;

  Brush get trackedBrush => _trackedBrush;

  set trackedBrush(Brush newValue) {
    _trackedBrush = newValue;
    _barcodeSelection.didChange();
  }

  late Brush _aimedBrush;

  Brush get aimedBrush => _aimedBrush;

  set aimedBrush(Brush newValue) {
    _aimedBrush = newValue;
    _barcodeSelection.didChange();
  }

  late Brush _selectedBrush;

  Brush get selectedBrush => _selectedBrush;

  set selectedBrush(Brush newValue) {
    _selectedBrush = newValue;
    _barcodeSelection.didChange();
  }

  late Brush _selectingBrush;

  Brush get selectingBrush => _selectingBrush;

  set selectingBrush(Brush newValue) {
    _selectingBrush = newValue;
    _barcodeSelection.didChange();
  }

  bool _shouldShowScanAreaGuides = false;

  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _barcodeSelection.didChange();
  }

  bool _shouldShowHints = BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.shouldShowHints;

  bool get shouldShowHints => _shouldShowHints;

  set shouldShowHints(bool newValue) {
    _shouldShowHints = newValue;
    _barcodeSelection.didChange();
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
  }

  Color _frozenBackgroundColor = BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.frozenBackgroundColor;

  Color get frozenBackgroundColor => _frozenBackgroundColor;

  set frozenBackgroundColor(Color newValue) {
    _frozenBackgroundColor = newValue;
    _barcodeSelection.didChange();
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
      'style': style.jsonValue,
      'frozenBackgroundColor': _frozenBackgroundColor.jsonValue,
    });
    return json;
  }
}
