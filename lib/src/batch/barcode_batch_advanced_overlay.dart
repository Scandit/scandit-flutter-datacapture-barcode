/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/batch/barcode_batch.dart';
import 'package:scandit_flutter_datacapture_barcode/src/batch/barcode_batch_advanced_overlay_widget.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

import '../tracked_barcode.dart';
import 'barcode_batch_function_names.dart';

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

  StreamSubscription<dynamic>? _overlaySubscription;

  final List<int> _widgetRequestsCache = [];

  _BarcodeBatchAdvancedOverlayController(this._overlay) : super(BarcodeBatchFunctionNames.methodsChannelName) {
    initialize();
  }

  void initialize() {
    if (_overlay._listener != null) {
      subscribeListener();
    }
  }

  Future<void> setWidgetForTrackedBarcode(Widget? widget, TrackedBarcode trackedBarcode) async {
    var arguments = <String, dynamic>{
      'trackedBarcodeIdentifier': trackedBarcode.identifier,
      'dataCaptureViewId': _overlay._dataCaptureViewId,
    };

    if (widget != null) {
      arguments['widget'] = await widget.toImage;
    } else {
      arguments['widget'] = null;
    }
    if (trackedBarcode.sessionFrameSequenceId != null) {
      arguments['sessionFrameSequenceID'] = trackedBarcode.sessionFrameSequenceId;
    }

    return methodChannel
        .invokeMethod(BarcodeBatchFunctionNames.setWidgetForTrackedBarcode, arguments)
        // once the widget is sent we do remove the request from the cache
        .then((value) => _widgetRequestsCache.remove(trackedBarcode.identifier));
  }

  Future<void> setAnchorForTrackedBarcode(Anchor anchor, TrackedBarcode trackedBarcode) {
    var arguments = {
      'anchor': anchor.toString(),
      'trackedBarcodeIdentifier': trackedBarcode.identifier,
      'dataCaptureViewId': _overlay._dataCaptureViewId,
    };
    if (trackedBarcode.sessionFrameSequenceId != null) {
      arguments['sessionFrameSequenceID'] = trackedBarcode.sessionFrameSequenceId!;
    }
    return methodChannel.invokeMethod(BarcodeBatchFunctionNames.setAnchorForTrackedBarcode, arguments);
  }

  Future<void> setOffsetForTrackedBarcode(PointWithUnit offset, TrackedBarcode trackedBarcode) {
    var arguments = {
      'offsetJson': jsonEncode(offset.toMap()),
      'trackedBarcodeIdentifier': trackedBarcode.identifier,
      'dataCaptureViewId': _overlay._dataCaptureViewId,
    };
    if (trackedBarcode.sessionFrameSequenceId != null) {
      arguments['sessionFrameSequenceID'] = trackedBarcode.sessionFrameSequenceId!;
    }
    return methodChannel.invokeMethod(BarcodeBatchFunctionNames.setOffsetForTrackedBarcode, arguments);
  }

  Future<void> clearTrackedBarcodeWidgets() {
    return methodChannel.invokeMethod(BarcodeBatchFunctionNames.clearTrackedBarcodeWidgets, {
      'dataCaptureViewId': _overlay._dataCaptureViewId,
    });
  }

  Future<void> update() {
    return methodChannel.invokeMethod(BarcodeBatchFunctionNames.updateBarcodeBatchAdvancedOverlay, {
      'dataCaptureViewId': _overlay._dataCaptureViewId,
      'overlayJson': jsonEncode(_overlay.toMap()),
    }).then((value) => null, onError: _onError);
  }

  void subscribeListener() {
    methodChannel.invokeMethod(BarcodeBatchFunctionNames.addBarcodeBatchAdvancedOverlayDelegate, {
      'dataCaptureViewId': _overlay._dataCaptureViewId,
    }).then((value) => _listenToEvents(), onError: _onError);
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
    methodChannel.invokeMethod(BarcodeBatchFunctionNames.removeBarcodeBatchAdvancedOverlayDelegate, {
      'dataCaptureViewId': _overlay._dataCaptureViewId,
    }).then((value) => null, onError: _onError);
    _overlaySubscription = null;
  }

  @override
  void dispose() {
    unsubscribeListener();
    super.dispose();
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }
}
