/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/batch/barcode_batch.dart';
import 'package:scandit_flutter_datacapture_barcode/src/batch/barcode_batch_advanced_overlay_widget.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

import '../tracked_barcode.dart';

abstract class BarcodeBatchAdvancedOverlayListener {
  static const String _widgetForTrackedBarcodeEventName = 'BarcodeBatchAdvancedOverlayListener.viewForTrackedBarcode';
  static const String _anchorForTrackedBarcodeEventName = 'BarcodeBatchAdvancedOverlayListener.anchorForTrackedBarcode';
  static const String _offsetForTrackedBarcodeEventName = 'BarcodeBatchAdvancedOverlayListener.offsetForTrackedBarcode';
  static const String _didTapViewForTrackedBarcodeEventName =
      'BarcodeBatchAdvancedOverlayListener.didTapViewForTrackedBarcode';

  BarcodeBatchAdvancedOverlayWidget? widgetForTrackedBarcode(
    BarcodeBatchAdvancedOverlay overlay,
    TrackedBarcode trackedBarcode,
  );
  Anchor anchorForTrackedBarcode(BarcodeBatchAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
  PointWithUnit offsetForTrackedBarcode(BarcodeBatchAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
  void didTapViewForTrackedBarcode(BarcodeBatchAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
}

class BarcodeBatchAdvancedOverlay extends DataCaptureOverlay {
  _BarcodeBatchAdvancedOverlayController? _controller;
  DataCaptureView? _view;
  final BarcodeBatch _mode;

  int get _dataCaptureViewId => _view?.viewId ?? -1;

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
    _controller ??= _BarcodeBatchAdvancedOverlayController(this);
  }

  BarcodeBatchAdvancedOverlay._(this._mode) : super('barcodeTrackingAdvanced');
  BarcodeBatchAdvancedOverlay(BarcodeBatch mode) : this._(mode);

  BarcodeBatchAdvancedOverlayListener? _listener;

  BarcodeBatchAdvancedOverlayListener? get listener => _listener;

  set listener(BarcodeBatchAdvancedOverlayListener? newValue) {
    _controller?.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller?.subscribeListener();
    }

    _listener = newValue;
  }

  Future<void> setWidgetForTrackedBarcode(BarcodeBatchAdvancedOverlayWidget? widget, TrackedBarcode trackedBarcode) {
    return _controller?.setWidgetForTrackedBarcode(widget, trackedBarcode) ?? Future.value();
  }

  Future<void> setAnchorForTrackedBarcode(Anchor anchor, TrackedBarcode trackedBarcode) {
    return _controller?.setAnchorForTrackedBarcode(anchor, trackedBarcode) ?? Future.value();
  }

  Future<void> setOffsetForTrackedBarcode(PointWithUnit offset, TrackedBarcode trackedBarcode) {
    return _controller?.setOffsetForTrackedBarcode(offset, trackedBarcode) ?? Future.value();
  }

  Future<void> clearTrackedBarcodeWidgets() {
    return _controller?.clearTrackedBarcodeWidgets() ?? Future.value();
  }

  var _shouldShowScanAreaGuides = false;
  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller?.update();
  }

  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['shouldShowScanAreaGuides'] = _shouldShowScanAreaGuides;
    json['hasListener'] = _listener != null;
    json['modeId'] = _mode.toMap()['modeId'];
    return json;
  }
}

class _BarcodeBatchAdvancedOverlayController extends BaseController {
  final BarcodeBatchAdvancedOverlay _overlay;
  late final BarcodeMethodHandler barcodeMethodHandler;
  StreamSubscription<dynamic>? _overlaySubscription;

  final List<int> _widgetRequestsCache = [];

  _BarcodeBatchAdvancedOverlayController(this._overlay) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
    initialize();
  }

  void initialize() {
    if (_overlay._listener != null) {
      subscribeListener();
    }
  }

  Future<void> setWidgetForTrackedBarcode(Widget? widget, TrackedBarcode trackedBarcode) async {
    final viewBytes = await widget?.toImage;
    return barcodeMethodHandler
        .setViewForTrackedBarcodeFromBytes(
            dataCaptureViewId: _overlay._dataCaptureViewId,
            trackedBarcodeIdentifier: trackedBarcode.identifier,
            viewBytes: viewBytes)
        .onError(onError);
  }

  Future<void> setAnchorForTrackedBarcode(Anchor anchor, TrackedBarcode trackedBarcode) {
    return barcodeMethodHandler
        .setAnchorForTrackedBarcode(
            dataCaptureViewId: _overlay._dataCaptureViewId,
            anchorJson: anchor.toString(),
            trackedBarcodeIdentifier: trackedBarcode.identifier)
        .onError(onError);
  }

  Future<void> setOffsetForTrackedBarcode(PointWithUnit offset, TrackedBarcode trackedBarcode) {
    return barcodeMethodHandler
        .setOffsetForTrackedBarcode(
            dataCaptureViewId: _overlay._dataCaptureViewId,
            offsetJson: jsonEncode(offset.toMap()),
            trackedBarcodeIdentifier: trackedBarcode.identifier)
        .onError(onError);
  }

  Future<void> clearTrackedBarcodeWidgets() {
    return barcodeMethodHandler
        .clearTrackedBarcodeViews(dataCaptureViewId: _overlay._dataCaptureViewId)
        .onError(onError);
  }

  Future<void> update() {
    return barcodeMethodHandler
        .updateBarcodeBatchAdvancedOverlay(
            dataCaptureViewId: _overlay._dataCaptureViewId, overlayJson: jsonEncode(_overlay.toMap()))
        .onError(onError);
  }

  void subscribeListener() {
    barcodeMethodHandler
        .registerListenerForAdvancedOverlayEvents(dataCaptureViewId: _overlay._dataCaptureViewId)
        .then((value) => _listenToEvents(), onError: onError);
  }

  void _listenToEvents() {
    if (_overlaySubscription != null) return;

    _overlaySubscription = BarcodePluginEvents.barcodeBatchEventStream.listen((event) async {
      if (_overlay._listener == null) return;

      var json = jsonDecode(event as String);
      switch (json['event'] as String) {
        case BarcodeBatchAdvancedOverlayListener._widgetForTrackedBarcodeEventName:
          var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode']));
          // this is to avoid processing multiple requests for the same
          // barcode at the same time.
          if (_widgetRequestsCache.contains(trackedBarcode.identifier)) return;
          _widgetRequestsCache.add(trackedBarcode.identifier);

          var widget = _overlay._listener?.widgetForTrackedBarcode(_overlay, trackedBarcode);
          if (widget == null) return;
          // ignore: unnecessary_lambdas
          setWidgetForTrackedBarcode(widget, trackedBarcode).catchError((error) => log(error));
          break;
        case BarcodeBatchAdvancedOverlayListener._anchorForTrackedBarcodeEventName:
          var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode']));
          var anchor = _overlay._listener?.anchorForTrackedBarcode(_overlay, trackedBarcode);
          if (anchor == null) {
            break;
          }
          // ignore: unnecessary_lambdas
          setAnchorForTrackedBarcode(anchor, trackedBarcode).catchError((error) => log(error));
          break;
        case BarcodeBatchAdvancedOverlayListener._offsetForTrackedBarcodeEventName:
          var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode']));
          var offset = _overlay._listener?.offsetForTrackedBarcode(_overlay, trackedBarcode);
          if (offset == null) {
            break;
          }
          // ignore: unnecessary_lambdas
          setOffsetForTrackedBarcode(offset, trackedBarcode).catchError((error) => log(error));
          break;
        case BarcodeBatchAdvancedOverlayListener._didTapViewForTrackedBarcodeEventName:
          var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode']));
          _overlay._listener?.didTapViewForTrackedBarcode(_overlay, trackedBarcode);
          break;
      }
    });
  }

  void unsubscribeListener() {
    _overlaySubscription?.cancel();
    barcodeMethodHandler
        .unregisterListenerForAdvancedOverlayEvents(dataCaptureViewId: _overlay._dataCaptureViewId)
        .onError(onError);
    _overlaySubscription = null;
  }

  @override
  void dispose() {
    unsubscribeListener();
    super.dispose();
  }
}
