/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/selection/barcode_selection.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'barcode_selection_brush_provider.dart';
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

  BarcodeSelectionBasicOverlay._(this._mode, this.style) : super('barcodeSelectionBasic') {
    var brushDefaultsForCurrentStyle = BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.brushes[style]!;
    _aimedBrush = brushDefaultsForCurrentStyle.aimedBrush;
    _selectedBrush = brushDefaultsForCurrentStyle.selectedBrush;
    _selectingBrush = brushDefaultsForCurrentStyle.selectingBrush;
    _trackedBrush = brushDefaultsForCurrentStyle.trackedBrush;
    viewfinder.addListener(_handleViewfinderChanged);
  }

  BarcodeSelectionBasicOverlay(BarcodeSelection mode, {BarcodeSelectionBasicOverlayStyle? style})
      : this._(mode, style ?? BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.defaultStyle);

  static Brush defaultTrackedBrushForStyle(BarcodeSelectionBasicOverlayStyle style) =>
      BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.brushes[style]!.trackedBrush;

  static Brush defaultAimedBrushForStyle(BarcodeSelectionBasicOverlayStyle style) =>
      BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.brushes[style]!.aimedBrush;

  static Brush defaultSelectedBrushForStyle(BarcodeSelectionBasicOverlayStyle style) =>
      BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.brushes[style]!.selectedBrush;

  static Brush defaultSelectingBrushForStyle(BarcodeSelectionBasicOverlayStyle style) =>
      BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.brushes[style]!.selectingBrush;

  DataCaptureView? _view;

  @override
  DataCaptureView? get view => _view;

  @override
  set view(DataCaptureView? newValue) {
    if (newValue == null) {
      _view = null;
      _controller?.dispose();
      _controller = null;
      return;
    }

    _view = newValue;
    if (_controller == null) {
      final controller = _BarcodeSelectionBasicOverlayController(this);
      _controller = controller;
      if (_aimedBarcodeBrushProvider != null) {
        controller.setAimedBarcodeBrushProvider(_aimedBarcodeBrushProvider);
      }
      if (_trackedBarcodeBrushProvider != null) {
        controller.setTrackedBarcodeBrushProvider(_trackedBarcodeBrushProvider);
      }
    }
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

  Future<void> setTextForSelectOrDoubleTapToFreezeHint(String text) async {
    _textForSelectOrDoubleTapToFreezeHint = text;
    await _controller?.update();
  }

  String? _textForTapToSelectHint;

  Future<void> setTextForTapToSelectHint(String text) async {
    _textForTapToSelectHint = text;
    await _controller?.update();
  }

  String? _textForDoubleTapToUnfreezeHint;

  Future<void> setTextForDoubleTapToUnfreezeHint(String text) async {
    _textForDoubleTapToUnfreezeHint = text;
    await _controller?.update();
  }

  String? _textForTapAnywhereToSelectHint;

  Future<void> setTextForTapAnywhereToSelectHint(String text) async {
    _textForTapAnywhereToSelectHint = text;
    await _controller?.update();
  }

  String? _textForAimToSelectAutoHint;

  Future<void> setTextForAimToSelectAutoHint(String text) async {
    _textForAimToSelectAutoHint = text;
    await _controller?.update();
  }

  Future<void> clearSelectedBarcodeBrushes() async {
    await _controller?.clearSelectedBarcodeBrushes();
  }

  BarcodeSelectionBrushProvider? _aimedBarcodeBrushProvider;

  Future<void> setAimedBarcodeBrushProvider(BarcodeSelectionBrushProvider? brushProvider) async {
    _aimedBarcodeBrushProvider = brushProvider;
    await _controller?.setAimedBarcodeBrushProvider(brushProvider);
  }

  BarcodeSelectionBrushProvider? _trackedBarcodeBrushProvider;

  Future<void> setTrackedBarcodeBrushProvider(BarcodeSelectionBrushProvider? brushProvider) async {
    _trackedBarcodeBrushProvider = brushProvider;
    await _controller?.setTrackedBarcodeBrushProvider(brushProvider);
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
      'hasAimedBrushProvider': _aimedBarcodeBrushProvider != null,
      'hasTrackedBrushProvider': _trackedBarcodeBrushProvider != null,
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
  static const String _brushForAimedBarcodeEventName = 'BarcodeSelectionAimedBrushProvider.brushForBarcode';
  static const String _brushForTrackedBarcodeEventName = 'BarcodeSelectionTrackedBrushProvider.brushForBarcode';

  final BarcodeSelectionBasicOverlay _overlay;
  late final BarcodeMethodHandler barcodeMethodHandler;

  StreamSubscription<dynamic>? _brushProviderSubscription;

  _BarcodeSelectionBasicOverlayController(this._overlay) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
  }

  Future<void> update() {
    return barcodeMethodHandler
        .updateBarcodeSelectionBasicOverlay(overlayJson: jsonEncode(_overlay.toMap()))
        .then((value) => null, onError: onError);
  }

  Future<void> clearSelectedBarcodeBrushes() {
    return barcodeMethodHandler.clearSelectedBarcodeBrushes().then((value) => null, onError: onError);
  }

  Future<void> setAimedBarcodeBrushProvider(BarcodeSelectionBrushProvider? provider) async {
    if (provider == null) {
      await barcodeMethodHandler.removeAimedBarcodeBrushProvider().catchError(onError);
    } else {
      _ensureBrushProviderSubscription();
      await barcodeMethodHandler.setAimedBarcodeBrushProvider().catchError(onError);
    }
    _maybeCancelBrushProviderSubscription();
  }

  Future<void> setTrackedBarcodeBrushProvider(BarcodeSelectionBrushProvider? provider) async {
    if (provider == null) {
      await barcodeMethodHandler.removeTrackedBarcodeBrushProvider().catchError(onError);
    } else {
      _ensureBrushProviderSubscription();
      await barcodeMethodHandler.setTrackedBarcodeBrushProvider().catchError(onError);
    }
    _maybeCancelBrushProviderSubscription();
  }

  void _ensureBrushProviderSubscription() {
    if (_brushProviderSubscription != null) return;
    _brushProviderSubscription = BarcodePluginEvents.barcodeSelectionEventStream.asFlutterEvents().listen((event) {
      if (event.isEvent(_brushForAimedBarcodeEventName)) {
        _handleBrushForBarcodeEvent(event.payload, _overlay._aimedBarcodeBrushProvider, aimed: true);
      } else if (event.isEvent(_brushForTrackedBarcodeEventName)) {
        _handleBrushForBarcodeEvent(event.payload, _overlay._trackedBarcodeBrushProvider, aimed: false);
      }
    });
  }

  void _maybeCancelBrushProviderSubscription() {
    if (_overlay._aimedBarcodeBrushProvider != null || _overlay._trackedBarcodeBrushProvider != null) return;
    _brushProviderSubscription?.cancel();
    _brushProviderSubscription = null;
  }

  void _handleBrushForBarcodeEvent(
    Map<String, dynamic> payload,
    BarcodeSelectionBrushProvider? provider, {
    required bool aimed,
  }) {
    if (provider == null) return;
    final barcodeJson = payload['barcode'] as String?;
    if (barcodeJson == null) return;
    final barcode = Barcode.fromJSON(jsonDecode(barcodeJson) as Map<String, dynamic>);
    final selectionIdentifier = (barcode.data ?? '') + barcode.symbology.toString();
    final brush = provider.brushForBarcode(barcode);
    final brushJson = brush == null ? null : jsonEncode(brush.toMap());
    final finish = aimed
        ? barcodeMethodHandler.finishBrushForAimedBarcodeCallback(
            selectionIdentifier: selectionIdentifier, brushJson: brushJson)
        : barcodeMethodHandler.finishBrushForTrackedBarcodeCallback(
            selectionIdentifier: selectionIdentifier, brushJson: brushJson);
    finish.catchError((error) => developer.log(error.toString()));
  }

  @override
  void dispose() {
    _brushProviderSubscription?.cancel();
    _brushProviderSubscription = null;
    super.dispose();
  }
}
