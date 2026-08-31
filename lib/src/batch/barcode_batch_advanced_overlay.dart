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

  final Set<int> _widgetRequestsCache = {};

  // Per-identifier cache of the last full TrackedBarcode received, so repeat payloads (which
  // only carry {identifier, location}) can patch the cached instance's location in place
  // instead of the native side re-sending the full ~1.1 KB JSON on every ask. Bounded with a
  // simple insertion-order eviction, since tracked identifiers accumulate over a scanning
  // session and would otherwise grow unbounded.
  final Map<int, TrackedBarcode> _trackedBarcodeCache = {};

  static const int _maxCacheSize = 256;

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

  // Resolves the TrackedBarcode for an advanced-overlay event payload, transparently handling
  // both shapes: a full payload (has a `trackedBarcode` key) is parsed and cached by
  // identifier; a repeat payload (has `identifier`/`location` keys instead) looks up the
  // cached instance and patches its location in place, so callers always get an up-to-date
  // TrackedBarcode without native re-sending the full JSON. A repeat payload with no matching
  // cache entry logs and returns null - no listener invocation, no throw.
  TrackedBarcode? _resolveTrackedBarcode(Map<dynamic, dynamic> payload) {
    final rawTrackedBarcode = payload['trackedBarcode'];
    if (rawTrackedBarcode != null) {
      var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(rawTrackedBarcode));
      _rememberTrackedBarcode(trackedBarcode);
      return trackedBarcode;
    }

    final identifier = payload['identifier'] as int?;
    final rawLocation = payload['location'] as String?;
    if (identifier == null || rawLocation == null) {
      log('BarcodeBatchAdvancedOverlayController: malformed repeat event payload, skipping.');
      return null;
    }

    var cached = _trackedBarcodeCache[identifier];
    if (cached == null) {
      log('BarcodeBatchAdvancedOverlayController: no cached TrackedBarcode for identifier '
          '$identifier, skipping repeat event.');
      return null;
    }
    // Bump recency on repeat hits too: the native gate is access-ordered (a repeat ask keeps
    // its identifier hot and never re-sends full), so this cache must age entries the same
    // way or an actively-asked identifier could be evicted here while still gated natively,
    // permanently stranding its repeats.
    _trackedBarcodeCache.remove(identifier);
    _trackedBarcodeCache[identifier] = cached;
    cached.updateLocationFromJSON(jsonDecode(rawLocation));
    return cached;
  }

  void _rememberTrackedBarcode(TrackedBarcode trackedBarcode) {
    // Re-inserting moves the key to the end of Dart's Map insertion order, giving simple
    // least-recently-inserted eviction below.
    _trackedBarcodeCache.remove(trackedBarcode.identifier);
    _trackedBarcodeCache[trackedBarcode.identifier] = trackedBarcode;
    if (_trackedBarcodeCache.length > _maxCacheSize) {
      _trackedBarcodeCache.remove(_trackedBarcodeCache.keys.first);
    }
  }

  void _rememberWidgetRequested(int identifier) {
    // A Dart Set is insertion-ordered, so removing the first element gives the same
    // oldest-first eviction the sibling caches use, with O(1) contains/add.
    _widgetRequestsCache.add(identifier);
    if (_widgetRequestsCache.length > _maxCacheSize) {
      _widgetRequestsCache.remove(_widgetRequestsCache.first);
    }
  }

  void _listenToEvents() {
    if (_overlaySubscription != null) return;

    _overlaySubscription = BarcodePluginEvents.barcodeBatchEventStream.asFlutterEvents().listen((event) async {
      if (_overlay._listener == null) return;

      if (event.isEvent(BarcodeBatchAdvancedOverlayListener._widgetForTrackedBarcodeEventName)) {
        var trackedBarcode = _resolveTrackedBarcode(event.payload);
        if (trackedBarcode == null) return;
        // this is to avoid processing multiple requests for the same
        // barcode at the same time.
        if (_widgetRequestsCache.contains(trackedBarcode.identifier)) return;
        _rememberWidgetRequested(trackedBarcode.identifier);

        var widget = _overlay._listener?.widgetForTrackedBarcode(_overlay, trackedBarcode);
        if (widget == null) return;
        // ignore: unnecessary_lambdas
        setWidgetForTrackedBarcode(widget, trackedBarcode).catchError((error) => log(error));
      } else if (event.isEvent(BarcodeBatchAdvancedOverlayListener._anchorForTrackedBarcodeEventName)) {
        var trackedBarcode = _resolveTrackedBarcode(event.payload);
        if (trackedBarcode == null) return;
        var anchor = _overlay._listener?.anchorForTrackedBarcode(_overlay, trackedBarcode);
        if (anchor != null) {
          // ignore: unnecessary_lambdas
          setAnchorForTrackedBarcode(anchor, trackedBarcode).catchError((error) => log(error));
        }
      } else if (event.isEvent(BarcodeBatchAdvancedOverlayListener._offsetForTrackedBarcodeEventName)) {
        var trackedBarcode = _resolveTrackedBarcode(event.payload);
        if (trackedBarcode == null) return;
        var offset = _overlay._listener?.offsetForTrackedBarcode(_overlay, trackedBarcode);
        if (offset != null) {
          // ignore: unnecessary_lambdas
          setOffsetForTrackedBarcode(offset, trackedBarcode).catchError((error) => log(error));
        }
      } else if (event.isEvent(BarcodeBatchAdvancedOverlayListener._didTapViewForTrackedBarcodeEventName)) {
        var trackedBarcode = _resolveTrackedBarcode(event.payload);
        if (trackedBarcode == null) return;
        _overlay._listener?.didTapViewForTrackedBarcode(_overlay, trackedBarcode);
      }
    });
  }

  void unsubscribeListener() {
    _overlaySubscription?.cancel();
    barcodeMethodHandler
        .unregisterListenerForAdvancedOverlayEvents(dataCaptureViewId: _overlay._dataCaptureViewId)
        .onError(onError);
    _overlaySubscription = null;
    _trackedBarcodeCache.clear();
    _widgetRequestsCache.clear();
  }

  @override
  void dispose() {
    unsubscribeListener();
    super.dispose();
  }
}
