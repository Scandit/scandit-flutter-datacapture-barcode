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
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show
        BarcodeBatchAdvancedOverlayListenerViewForTrackedBarcode,
        BarcodeBatchAdvancedOverlayListenerAnchorForTrackedBarcode,
        BarcodeBatchAdvancedOverlayListenerOffsetForTrackedBarcode,
        BarcodeBatchAdvancedOverlayListenerDidTapViewForTrackedBarcode;
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

import '../tracked_barcode.dart';

/// Added in version 7.0.0
abstract class BarcodeBatchAdvancedOverlayListener {
  static const String _widgetForTrackedBarcodeEventName = 'BarcodeBatchAdvancedOverlayListener.viewForTrackedBarcode';
  static const String _anchorForTrackedBarcodeEventName = 'BarcodeBatchAdvancedOverlayListener.anchorForTrackedBarcode';
  static const String _offsetForTrackedBarcodeEventName = 'BarcodeBatchAdvancedOverlayListener.offsetForTrackedBarcode';
  static const String _didTapViewForTrackedBarcodeEventName =
      'BarcodeBatchAdvancedOverlayListener.didTapViewForTrackedBarcode';

  /// View to be drawn corresponding to the given [TrackedBarcode]. This method will be called before [BarcodeBatchAdvancedOverlayListener.anchorForTrackedBarcode] and [BarcodeBatchAdvancedOverlayListener.offsetForTrackedBarcode]. Beware that this view can be overridden with BarcodeBatchAdvancedOverlay.setWidgetForTrackedBarcode() method. This method will only be called for new tracked barcodes that do not have a view yet, e.g. a view set by a call to BarcodeBatchAdvancedOverlay.setWidgetForTrackedBarcode().
  ///
  /// Called from the main thread.
  ///
  /// Added in version 7.0.0
  BarcodeBatchAdvancedOverlayWidget? widgetForTrackedBarcode(
    BarcodeBatchAdvancedOverlay overlay,
    TrackedBarcode trackedBarcode,
  );
  /// Anchor point that should be used for the view corresponding to the given [TrackedBarcode]. This method will be called after widgetForTrackedBarcode() and before [BarcodeBatchAdvancedOverlayListener.offsetForTrackedBarcode]. Beware that this anchor can be overridden with [BarcodeBatchAdvancedOverlay.setAnchorForTrackedBarcode] method. This method will only be called for new tracked barcodes that do not have an anchor yet, e.g. an anchor set by a call to [BarcodeBatchAdvancedOverlay.setAnchorForTrackedBarcode].
  ///
  /// Called from the main thread.
  ///
  /// Added in version 7.0.0
  Anchor anchorForTrackedBarcode(BarcodeBatchAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
  /// Offset to be set to the view corresponding to the given [TrackedBarcode]. The offset is relative to the anchor point of the tracked barcode. This method will be called after widgetForTrackedBarcode() and [BarcodeBatchAdvancedOverlayListener.anchorForTrackedBarcode]. Beware that this offset can be overridden with [BarcodeBatchAdvancedOverlay.setOffsetForTrackedBarcode] method. This method will only be called for new tracked barcodes that do not have an offset yet, e.g. an offset set by a call to [BarcodeBatchAdvancedOverlay.setOffsetForTrackedBarcode].
  ///
  /// Called from the main thread.
  ///
  /// Added in version 7.0.0
  PointWithUnit offsetForTrackedBarcode(BarcodeBatchAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
  /// Callback method that can be used to define an action that should be performed when a view for a tracked barcode is tapped.
  ///
  /// Added in version 7.0.0
  void didTapViewForTrackedBarcode(BarcodeBatchAdvancedOverlay overlay, TrackedBarcode trackedBarcode);
}

/// An overlay for [DataCaptureView] that allows anchoring a single user-provided View to each tracked barcode.The provided view is visible on the top of the camera preview as long as its tracked barcode is and for all this time retains its relative position to it. This is useful when an additional information should be provided to tracked barcodes in real time. For instance, a user may overlay the price of an item or its expiry date for each corresponding barcode.To display the views, this overlay must be attached to a [DataCaptureView]. This can be done by passing this overlay to [DataCaptureView.addOverlay].A user of this class may configure what view is displayed for the given barcode and the relative position between the two by implementing [BarcodeBatchAdvancedOverlayListener] or by calling setWidgetForTrackedBarcode(), [BarcodeBatchAdvancedOverlay.setAnchorForTrackedBarcode] or [BarcodeBatchAdvancedOverlay.setOffsetForTrackedBarcode].
///
/// For additional information about using this overlay, refer to [Adding AR Overlays](https://docs.scandit.com/sdks/flutter/matrixscan/advanced) .
///
/// Added in version 7.0.0
class BarcodeBatchAdvancedOverlay extends DataCaptureOverlay {
  _BarcodeBatchAdvancedOverlayController? _controller;
  DataCaptureView? _view;
  final BarcodeBatch _mode;

  int get _dataCaptureViewId => _view?.viewId ?? -1;

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 7.0.0
  @override
  DataCaptureView? get view => _view;

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 7.0.0
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
  /// Constructs a new BarcodeBatchAdvancedOverlay. For the overlay to be displayed on screen, it must be added to a [DataCaptureView].
  ///
  /// Added in version 7.6.0
  BarcodeBatchAdvancedOverlay(BarcodeBatch mode) : this._(mode);

  BarcodeBatchAdvancedOverlayListener? _listener;

  /// Added in version 7.0.0
  BarcodeBatchAdvancedOverlayListener? get listener => _listener;

  /// Added in version 7.0.0
  set listener(BarcodeBatchAdvancedOverlayListener? newValue) {
    _controller?.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller?.subscribeListener();
    }

    _listener = newValue;
  }

  /// The method can be called to change the view drawn for the given tracked barcode. Setting the view to *null* will unset the view from the tracked barcode and will effectively remove it from the overlay. This method is thread-safe, it can be called from any thread. The view set via this method will take precedence over the one set via BarcodeBatchAdvancedOverlayListener.widgetForTrackedBarcode(): in case a view is set before BarcodeBatchAdvancedOverlayListener.widgetForTrackedBarcode() got called, no call to BarcodeBatchAdvancedOverlayListener.widgetForTrackedBarcode() will happen.
  ///
  /// Added in version 7.0.0
  Future<void> setWidgetForTrackedBarcode(BarcodeBatchAdvancedOverlayWidget? widget, TrackedBarcode trackedBarcode) {
    return _controller?.setWidgetForTrackedBarcode(widget, trackedBarcode) ?? Future.value();
  }

  /// The method can be called to change the anchor point for the view associated with the given tracked barcode. This method is thread-safe, it can be called from any thread. The anchor set via this method will take precedence over the one set via [BarcodeBatchAdvancedOverlayListener.anchorForTrackedBarcode]: in case a view is set before [BarcodeBatchAdvancedOverlayListener.anchorForTrackedBarcode] got called, no call to [BarcodeBatchAdvancedOverlayListener.anchorForTrackedBarcode] will happen.
  ///
  /// Added in version 7.0.0
  Future<void> setAnchorForTrackedBarcode(Anchor anchor, TrackedBarcode trackedBarcode) {
    return _controller?.setAnchorForTrackedBarcode(anchor, trackedBarcode) ?? Future.value();
  }

  /// The method can be called to change the offset for the view associated with the given tracked barcode. This method is thread-safe, it can be called from any thread. The offset set via this method will take precedence over the one set via [BarcodeBatchAdvancedOverlayListener.offsetForTrackedBarcode]: in case a view is set before [BarcodeBatchAdvancedOverlayListener.offsetForTrackedBarcode] got called, no call to [BarcodeBatchAdvancedOverlayListener.offsetForTrackedBarcode] will happen. If the [MeasureUnit] of the offset is [MeasureUnit.fraction], the offset is calculated relative to view’s dimensions.
  ///
  /// Added in version 7.0.0
  Future<void> setOffsetForTrackedBarcode(PointWithUnit offset, TrackedBarcode trackedBarcode) {
    return _controller?.setOffsetForTrackedBarcode(offset, trackedBarcode) ?? Future.value();
  }

  /// Clears all the views for the currently tracked barcodes from this overlay. This method is thread-safe, it can be called from any thread.
  ///
  /// Added in version 7.0.0
  Future<void> clearTrackedBarcodeWidgets() {
    return _controller?.clearTrackedBarcodeWidgets() ?? Future.value();
  }

  var _shouldShowScanAreaGuides = false;
  /// Whether to show scan area guides on top of the preview. This property is useful during development to visualize the current scan areas on screen. It is not meant to be used for production. By default this property is *false*.
  ///
  /// Added in version 7.0.0
  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller?.update();
  }

  /// Whether to show scan area guides on top of the preview. This property is useful during development to visualize the current scan areas on screen. It is not meant to be used for production. By default this property is *false*.
  ///
  /// Added in version 7.0.0
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
  // Takes the three payload fields rather than a generated type, because the four
  // advanced-overlay events each have their own generated class (identical apart from the
  // `event` const) and Dart has no structural typing to unify them.
  TrackedBarcode? _resolveTrackedBarcode(String? rawTrackedBarcode, int? identifier, String? rawLocation) {
    if (rawTrackedBarcode != null) {
      var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(rawTrackedBarcode));
      _rememberTrackedBarcode(trackedBarcode);
      return trackedBarcode;
    }

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
        // Fire-and-forget event, no ack to protect: validate against the generated schema and
        // let a mismatch throw, then narrow the parsed payload to its full/repeat variant below.
        final payload = BarcodeBatchAdvancedOverlayListenerViewForTrackedBarcode.fromJson(event.payload);
        var trackedBarcode = _resolveTrackedBarcode(payload.trackedBarcode, payload.identifier, payload.location);
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
        // Fire-and-forget event, no ack to protect: validate against the generated schema and
        // let a mismatch throw, then narrow the parsed payload to its full/repeat variant below.
        final payload = BarcodeBatchAdvancedOverlayListenerAnchorForTrackedBarcode.fromJson(event.payload);
        var trackedBarcode = _resolveTrackedBarcode(payload.trackedBarcode, payload.identifier, payload.location);
        if (trackedBarcode == null) return;
        var anchor = _overlay._listener?.anchorForTrackedBarcode(_overlay, trackedBarcode);
        if (anchor != null) {
          // ignore: unnecessary_lambdas
          setAnchorForTrackedBarcode(anchor, trackedBarcode).catchError((error) => log(error));
        }
      } else if (event.isEvent(BarcodeBatchAdvancedOverlayListener._offsetForTrackedBarcodeEventName)) {
        // Fire-and-forget event, no ack to protect: validate against the generated schema and
        // let a mismatch throw, then narrow the parsed payload to its full/repeat variant below.
        final payload = BarcodeBatchAdvancedOverlayListenerOffsetForTrackedBarcode.fromJson(event.payload);
        var trackedBarcode = _resolveTrackedBarcode(payload.trackedBarcode, payload.identifier, payload.location);
        if (trackedBarcode == null) return;
        var offset = _overlay._listener?.offsetForTrackedBarcode(_overlay, trackedBarcode);
        if (offset != null) {
          // ignore: unnecessary_lambdas
          setOffsetForTrackedBarcode(offset, trackedBarcode).catchError((error) => log(error));
        }
      } else if (event.isEvent(BarcodeBatchAdvancedOverlayListener._didTapViewForTrackedBarcodeEventName)) {
        // Fire-and-forget event, no ack to protect: validate against the generated schema and
        // let a mismatch throw, then narrow the parsed payload to its full/repeat variant below.
        final payload = BarcodeBatchAdvancedOverlayListenerDidTapViewForTrackedBarcode.fromJson(event.payload);
        var trackedBarcode = _resolveTrackedBarcode(payload.trackedBarcode, payload.identifier, payload.location);
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
