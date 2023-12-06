/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_tracking.dart';
import 'tracked_barcode.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/widget_to_base64_converter.dart';
import 'barcode_tracking_function_names.dart';

abstract class BarcodeTrackingAdvancedOverlayListener {
  static const String _widgetForTrackedBarcodeEventName =
      'barcodeTrackingAdvancedOverlayListener-widgetForTrackedBarcode';
  static const String _anchorForTrackedBarcodeEventName =
      'barcodeTrackingAdvancedOverlayListener-anchorForTrackedBarcode';
  static const String _offsetForTrackedBarcodeEventName =
      'barcodeTrackingAdvancedOverlayListener-offsetForTrackedBarcode';
  static const String _didTapViewForTrackedBarcodeEventName =
      'barcodeTrackingAdvancedOverlayListener-didTapViewForTrackedBarcode';

  Widget? widgetForTrackedBarcode(BarcodeTrackingAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
  Anchor anchorForTrackedBarcode(BarcodeTrackingAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
  PointWithUnit offsetForTrackedBarcode(BarcodeTrackingAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
  void didTapViewForTrackedBarcode(BarcodeTrackingAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
}

class BarcodeTrackingAdvancedOverlay extends DataCaptureOverlay {
  // ignore: unused_field
  final BarcodeTracking _barcodeTracking;
  late _BarcodeTrackingAdvancedOverlayController _controller;
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

  BarcodeTrackingAdvancedOverlay._(this._barcodeTracking) : super('barcodeTrackingAdvanced') {
    _controller = _BarcodeTrackingAdvancedOverlayController(this);
  }

  factory BarcodeTrackingAdvancedOverlay.withBarcodeTrackingForView(
      BarcodeTracking barcodeTracking, DataCaptureView? view) {
    var overlay = BarcodeTrackingAdvancedOverlay._(barcodeTracking);
    overlay.view = view;
    return overlay;
  }

  BarcodeTrackingAdvancedOverlayListener? _listener;

  BarcodeTrackingAdvancedOverlayListener? get listener => _listener;

  set listener(BarcodeTrackingAdvancedOverlayListener? newValue) {
    _controller.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller.subscribeListener();
    }

    _listener = newValue;
  }

  Future<void> setWidgetForTrackedBarcode(Widget? widget, TrackedBarcode trackedBarcode) {
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
    _barcodeTracking.didChange();
  }

  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['shouldShowScanAreaGuides'] = _shouldShowScanAreaGuides;
    return json;
  }
}

class _BarcodeTrackingAdvancedOverlayController {
  final BarcodeTrackingAdvancedOverlay _overlay;

  final EventChannel _eventChannel =
      EventChannel('com.scandit.datacapture.barcode.tracking.event/barcode_tracking_advanced_overlay');

  final MethodChannel _methodChannel =
      MethodChannel('com.scandit.datacapture.barcode.tracking.method/barcode_tracking_advanced_overlay');

  StreamSubscription<dynamic>? _overlaySubscription;

  final List<int> _widgetRequestsCache = [];

  _BarcodeTrackingAdvancedOverlayController(this._overlay);

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
        .invokeMethod(BarcodeTrackingFunctionNames.setWidgetForTrackedBarcode, arguments)
        // once the widget is sent we do remove the request from the cache
        .then((value) => _widgetRequestsCache.remove(trackedBarcode.identifier));
  }

  Future<void> setAnchorForTrackedBarcode(Anchor anchor, TrackedBarcode trackedBarcode) {
    var arguments = {'anchor': anchor.jsonValue, 'identifier': trackedBarcode.identifier};
    if (trackedBarcode.sessionFrameSequenceId != null) {
      arguments['sessionFrameSequenceID'] = trackedBarcode.sessionFrameSequenceId!;
    }
    return _methodChannel.invokeMethod(BarcodeTrackingFunctionNames.setAnchorForTrackedBarcode, arguments);
  }

  Future<void> setOffsetForTrackedBarcode(PointWithUnit offset, TrackedBarcode trackedBarcode) {
    var arguments = {'offset': jsonEncode(offset.toMap()), 'identifier': trackedBarcode.identifier};
    if (trackedBarcode.sessionFrameSequenceId != null) {
      arguments['sessionFrameSequenceID'] = trackedBarcode.sessionFrameSequenceId!;
    }
    return _methodChannel.invokeMethod(BarcodeTrackingFunctionNames.setOffsetForTrackedBarcode, arguments);
  }

  Future<void> clearTrackedBarcodeWidgets() {
    return _methodChannel.invokeMethod(BarcodeTrackingFunctionNames.clearTrackedBarcodeWidgets);
  }

  void subscribeListener() {
    _methodChannel
        .invokeMethod(BarcodeTrackingFunctionNames.addBarcodeTrackingAdvancedOverlayDelegate)
        .then((value) => _listenToEvents(), onError: _onError);
  }

  void _listenToEvents() {
    _overlaySubscription = _eventChannel.receiveBroadcastStream().listen((event) async {
      if (_overlay._listener == null) return;

      var json = jsonDecode(event as String);
      switch (json['event'] as String) {
        case BarcodeTrackingAdvancedOverlayListener._widgetForTrackedBarcodeEventName:
          var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode']));
          // this is to avoid processing multiple requests for the same
          // barcode at the same time.
          if (_widgetRequestsCache.contains(trackedBarcode.identifier)) return;
          _widgetRequestsCache.add(trackedBarcode.identifier);

          var widget = _overlay._listener?.widgetForTrackedBarcode(_overlay, trackedBarcode);
          if (widget == null) return;
          // ignore: unnecessary_lambdas
          setWidgetForTrackedBarcode(widget, trackedBarcode).catchError((error) => print(error));
          break;
        case BarcodeTrackingAdvancedOverlayListener._anchorForTrackedBarcodeEventName:
          var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode']));
          var anchor = _overlay._listener?.anchorForTrackedBarcode(_overlay, trackedBarcode);
          if (anchor == null) {
            break;
          }
          // ignore: unnecessary_lambdas
          setAnchorForTrackedBarcode(anchor, trackedBarcode).catchError((error) => print(error));
          break;
        case BarcodeTrackingAdvancedOverlayListener._offsetForTrackedBarcodeEventName:
          var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode']));
          var offset = _overlay._listener?.offsetForTrackedBarcode(_overlay, trackedBarcode);
          if (offset == null) {
            break;
          }
          // ignore: unnecessary_lambdas
          setOffsetForTrackedBarcode(offset, trackedBarcode).catchError((error) => print(error));
          break;
        case BarcodeTrackingAdvancedOverlayListener._didTapViewForTrackedBarcodeEventName:
          var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode']));
          _overlay._listener?.didTapViewForTrackedBarcode(_overlay, trackedBarcode);
          break;
      }
    });
  }

  void unsubscribeListener() {
    _overlaySubscription?.cancel();
    _methodChannel
        .invokeMethod(BarcodeTrackingFunctionNames.removeBarcodeTrackingAdvancedOverlayDelegate)
        .then((value) => null, onError: _onError);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    print(error);

    if (stackTrace != null) {
      print(stackTrace);
    }

    throw error;
  }
}
