/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/batch/barcode_batch_advanced_overlay_widget.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_batch.dart';
import 'tracked_barcode.dart';
import 'barcode_batch_function_names.dart';

abstract class BarcodeBatchAdvancedOverlayListener {
  static const String _widgetForTrackedBarcodeEventName = 'BarcodeBatchAdvancedOverlayListener.viewForTrackedBarcode';
  static const String _anchorForTrackedBarcodeEventName = 'BarcodeBatchAdvancedOverlayListener.anchorForTrackedBarcode';
  static const String _offsetForTrackedBarcodeEventName = 'BarcodeBatchAdvancedOverlayListener.offsetForTrackedBarcode';
  static const String _didTapViewForTrackedBarcodeEventName =
      'BarcodeBatchAdvancedOverlayListener.didTapViewForTrackedBarcode';

  BarcodeBatchAdvancedOverlayWidget? widgetForTrackedBarcode(
      BarcodeBatchAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
  Anchor anchorForTrackedBarcode(BarcodeBatchAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
  PointWithUnit offsetForTrackedBarcode(BarcodeBatchAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
  void didTapViewForTrackedBarcode(BarcodeBatchAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
}

class BarcodeBatchAdvancedOverlay extends DataCaptureOverlay {
  // ignore: unused_field
  final BarcodeBatch _barcodeBatch;
  late _BarcodeBatchAdvancedOverlayController _controller;
  DataCaptureView? _view;

  @override
  DataCaptureView? get view => _view;

  @override
  set view(DataCaptureView? newValue) {
    if (newValue != null) {
      newValue.addOverlay(this);
    }
    _view = newValue;
  }

  BarcodeBatchAdvancedOverlay._(this._barcodeBatch) : super('barcodeTrackingAdvanced') {
    _controller = _BarcodeBatchAdvancedOverlayController(this);
  }

  factory BarcodeBatchAdvancedOverlay.withBarcodeBatchForView(BarcodeBatch barcodeBatch, DataCaptureView? view) {
    var overlay = BarcodeBatchAdvancedOverlay._(barcodeBatch);
    overlay.view = view;
    return overlay;
  }

  BarcodeBatchAdvancedOverlayListener? _listener;

  BarcodeBatchAdvancedOverlayListener? get listener => _listener;

  set listener(BarcodeBatchAdvancedOverlayListener? newValue) {
    _controller.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller.subscribeListener();
    }

    _listener = newValue;
  }

  Future<void> setWidgetForTrackedBarcode(BarcodeBatchAdvancedOverlayWidget? widget, TrackedBarcode trackedBarcode) {
    return _controller.setWidgetForTrackedBarcode(widget, trackedBarcode);
  }

  Future<void> setAnchorForTrackedBarcode(Anchor anchor, TrackedBarcode trackedBarcode) {
    return _controller.setAnchorForTrackedBarcode(anchor, trackedBarcode);
  }

  Future<void> setOffsetForTrackedBarcode(PointWithUnit offset, TrackedBarcode trackedBarcode) {
    return _controller.setOffsetForTrackedBarcode(offset, trackedBarcode);
  }

  Future<void> clearTrackedBarcodeWidgets() {
    return _controller.clearTrackedBarcodeWidgets();
  }

  var _shouldShowScanAreaGuides = false;
  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller.update();
  }

  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['shouldShowScanAreaGuides'] = _shouldShowScanAreaGuides;
    return json;
  }
}

class _BarcodeBatchAdvancedOverlayController {
  final BarcodeBatchAdvancedOverlay _overlay;

  final MethodChannel _methodChannel = const MethodChannel(BarcodeBatchFunctionNames.methodsChannelName);

  StreamSubscription<dynamic>? _overlaySubscription;

  final List<int> _widgetRequestsCache = [];

  _BarcodeBatchAdvancedOverlayController(this._overlay);

  Future<void> setWidgetForTrackedBarcode(Widget? widget, TrackedBarcode trackedBarcode) async {
    var arguments = <String, dynamic>{'identifier': trackedBarcode.identifier};

    if (widget != null) {
      arguments['widget'] = await widget.toImage;
    } else {
      arguments['widget'] = null;
    }
    if (trackedBarcode.sessionFrameSequenceId != null) {
      arguments['sessionFrameSequenceID'] = trackedBarcode.sessionFrameSequenceId;
    }

    return _methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.setWidgetForTrackedBarcode, arguments)
        // once the widget is sent we do remove the request from the cache
        .then((value) => _widgetRequestsCache.remove(trackedBarcode.identifier));
  }

  Future<void> setAnchorForTrackedBarcode(Anchor anchor, TrackedBarcode trackedBarcode) {
    var arguments = {'anchor': anchor.toString(), 'identifier': trackedBarcode.identifier};
    if (trackedBarcode.sessionFrameSequenceId != null) {
      arguments['sessionFrameSequenceID'] = trackedBarcode.sessionFrameSequenceId!;
    }
    return _methodChannel.invokeMethod(BarcodeBatchFunctionNames.setAnchorForTrackedBarcode, arguments);
  }

  Future<void> setOffsetForTrackedBarcode(PointWithUnit offset, TrackedBarcode trackedBarcode) {
    var arguments = {'offset': jsonEncode(offset.toMap()), 'identifier': trackedBarcode.identifier};
    if (trackedBarcode.sessionFrameSequenceId != null) {
      arguments['sessionFrameSequenceID'] = trackedBarcode.sessionFrameSequenceId!;
    }
    return _methodChannel.invokeMethod(BarcodeBatchFunctionNames.setOffsetForTrackedBarcode, arguments);
  }

  Future<void> clearTrackedBarcodeWidgets() {
    return _methodChannel.invokeMethod(BarcodeBatchFunctionNames.clearTrackedBarcodeWidgets);
  }

  Future<void> update() {
    return _methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.updateBarcodeBatchAdvancedOverlay, jsonEncode(_overlay.toMap()))
        .then((value) => null, onError: _onError);
  }

  void subscribeListener() {
    _methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.addBarcodeBatchAdvancedOverlayDelegate)
        .then((value) => _listenToEvents(), onError: _onError);
  }

  void _listenToEvents() {
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
    _methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.removeBarcodeBatchAdvancedOverlayDelegate)
        .then((value) => null, onError: _onError);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }
}
