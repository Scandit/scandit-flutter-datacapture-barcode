/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/batch/barcode_batch.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show BarcodeBatchBasicOverlayListenerBrushForTrackedBarcode, BarcodeBatchBasicOverlayListenerDidTapTrackedBarcode;
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_core/internal.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

import 'barcode_batch_defaults.dart';
import '../tracked_barcode.dart';

const List<String> _barcodeBatchBasicOverlayListenerEvents = [
  'BarcodeBatchBasicOverlayListener.brushForTrackedBarcode',
  'BarcodeBatchBasicOverlayListener.didTapTrackedBarcode'
];

/// The style of the [BarcodeBatchBasicOverlay]
///
/// Added in version 7.0.0
enum BarcodeBatchBasicOverlayStyle {
  /// Style that draws the highlights as a rectangular frame and adds an animation for when a code newly appears.
  ///
  /// Added in version 7.0.0
  frame('frame'),
  /// Style that draws the highlights as a dot and adds an animation for when a code newly appears.
  ///
  /// Added in version 7.0.0
  dot('dot');

  const BarcodeBatchBasicOverlayStyle(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeBatchBasicOverlayStyleSerializer on BarcodeBatchBasicOverlayStyle {
  static BarcodeBatchBasicOverlayStyle fromJSON(String jsonValue) {
    return BarcodeBatchBasicOverlayStyle.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

/// An overlay for SDCDataCaptureView that shows a simple augmentation over each tracked barcode.
///
/// To display the augmentations, this overlay must be attached to a [DataCaptureView]. This can be done by passing this overlay to [DataCaptureView.addOverlay].
///
/// A user of this class may configure the appearance of the augmentations by implementing [BarcodeBatchBasicOverlayListener] or by calling [BarcodeBatchBasicOverlay.setBrushForTrackedBarcode].
///
/// For additional information about using this overlay, refer to [MatrixScan Get Started](https://docs.scandit.com/sdks/flutter/matrixscan/get-started) guide.
///
/// Added in version 7.0.0
class BarcodeBatchBasicOverlay extends DataCaptureOverlay {
  DataCaptureView? _view;

  int get _dataCaptureViewId => _view?.viewId ?? -1;

  final BarcodeBatch _mode;

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
    _controller ??= _BarcodeBatchBasicOverlayController(this);
  }

  _BarcodeBatchBasicOverlayController? _controller;

  BarcodeBatchBasicOverlay._(this._mode, this.style) : super('barcodeTrackingBasic') {
    _brush = BarcodeBatchDefaults.barcodeBatchBasicOverlayDefaults.brushes[style]!;
    _controller = _BarcodeBatchBasicOverlayController(this);
  }

  /// Constructs a new BarcodeBatchBasicOverlay. For the overlay to be displayed on screen, it must be added to a [DataCaptureView].
  ///
  /// Added in version 7.6.0
  BarcodeBatchBasicOverlay(BarcodeBatch mode, {BarcodeBatchBasicOverlayStyle? style})
      : this._(mode, style ?? BarcodeBatchDefaults.barcodeBatchBasicOverlayDefaults.defaultStyle);

  late Brush _brush;

  /// The brush applied to recognized tracked barcodes if [BarcodeBatchBasicOverlayListener] is not implemented.
  ///
  /// Setting this brush to *null* hides all tracked barcodes, unless [BarcodeBatchBasicOverlay.setBrushForTrackedBarcode] is called.
  ///
  /// Added in version 7.0.0
  Brush get brush => _brush;

  /// The brush applied to recognized tracked barcodes if [BarcodeBatchBasicOverlayListener] is not implemented.
  ///
  /// Setting this brush to *null* hides all tracked barcodes, unless [BarcodeBatchBasicOverlay.setBrushForTrackedBarcode] is called.
  ///
  /// Added in version 7.0.0
  set brush(Brush newValue) {
    _brush = newValue;
    _controller?.update();
  }

  /// The overlay style. Defaults to Frame.
  ///
  /// Added in version 7.0.0
  final BarcodeBatchBasicOverlayStyle style;

  /// The method can be called to change the visualization style of a tracked barcode. This method is thread-safe, it can be called from any thread. If the brush is *null*, then no visualization will be drawn for the tracked barcode. Additionally, tapping on the barcode will have no effect - the action defined by BarcodeBatchBasicOverlayListener.didTapTrackedBarcode() callback will not be performed.
  ///
  /// Setting a brush for a tracked barcode that is not part of the currently active session will be ignored.
  ///
  /// Using this function requires the MatrixScan AR add-on.
  ///
  /// Added in version 7.0.0
  Future<void> setBrushForTrackedBarcode(Brush? brush, TrackedBarcode trackedBarcode) {
    return _controller?.setBrushForTrackedBarcode(brush, trackedBarcode) ?? Future.value();
  }

  /// Clears all currently displayed visualizations for the tracked barcodes.
  ///
  /// This only applies to the currently tracked barcodes, the visualizations for the new ones will still appear.
  ///
  /// Added in version 7.0.0
  Future<void> clearTrackedBarcodeBrushes() {
    return _controller?.clearTrackedBarcodeBrushes() ?? Future.value();
  }

  BarcodeBatchBasicOverlayListener? _listener;

  /// The listener which is called whenever a new TrackedBarcode is newly tracked or newly recognized.
  ///
  /// Using this listener requires the MatrixScan AR add-on.
  ///
  /// Added in version 7.0.0
  BarcodeBatchBasicOverlayListener? get listener => _listener;

  /// The listener which is called whenever a new TrackedBarcode is newly tracked or newly recognized.
  ///
  /// Using this listener requires the MatrixScan AR add-on.
  ///
  /// Added in version 7.0.0
  set listener(BarcodeBatchBasicOverlayListener? newValue) {
    _controller?.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller?.subscribeListener();
    }

    _listener = newValue;
  }

  var _shouldShowScanAreaGuides = false;
  /// When set to *true*, this overlay will visualize the active scan area used for BarcodeBatch. This is useful to check margins ([DataCaptureView.scanAreaMargins]) defined on the [DataCaptureView] are set correctly. This property is meant for debugging during development and is not intended for use in production.
  ///
  /// By default this property is *false*.
  ///
  /// Added in version 7.0.0
  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller?.update();
  }

  /// When set to *true*, this overlay will visualize the active scan area used for BarcodeBatch. This is useful to check margins ([DataCaptureView.scanAreaMargins]) defined on the [DataCaptureView] are set correctly. This property is meant for debugging during development and is not intended for use in production.
  ///
  /// By default this property is *false*.
  ///
  /// Added in version 7.0.0
  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'defaultBrush': _brush.toMap(),
      'shouldShowScanAreaGuides': _shouldShowScanAreaGuides,
      'style': style.toString(),
      'hasListener': _listener != null,
      'modeId': _mode.toMap()['modeId'],
    });
    return json;
  }
}

/// Added in version 7.0.0
abstract class BarcodeBatchBasicOverlayListener {
  static const String _brushForTrackedBarcodeEventName = 'BarcodeBatchBasicOverlayListener.brushForTrackedBarcode';
  static const String _didTapTrackedBarcodeEventName = 'BarcodeBatchBasicOverlayListener.didTapTrackedBarcode';

  /// Callback method that can be used to set a [Brush] for a tracked barcode. It is called when a new tracked barcode appears. Called from the rendering thread. If the callback returns *null*, then no visualization will be drawn for the tracked barcode. Additionally, tapping on the barcode will have no effect - the action defined by didTapTrackedBarcode() callback will not be performed.
  ///
  /// Added in version 7.0.0
  Brush? brushForTrackedBarcode(BarcodeBatchBasicOverlay overlay, TrackedBarcode trackedBarcode);
  /// Callback method that can be used to define an action that should be performed once a tracked barcode is tapped. Called from the main thread.
  ///
  /// Added in version 7.0.0
  void didTapTrackedBarcode(BarcodeBatchBasicOverlay overlay, TrackedBarcode trackedBarcode);
}

class _BarcodeBatchBasicOverlayController extends BaseController {
  final BarcodeBatchBasicOverlay _overlay;
  late final BarcodeMethodHandler barcodeMethodHandler;
  StreamSubscription<dynamic>? _overlaySubscription;

  _BarcodeBatchBasicOverlayController(this._overlay) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
    initialize();
  }

  void initialize() {
    if (_overlay._listener != null) {
      subscribeListener();
    }
  }

  Future<void> setBrushForTrackedBarcode(Brush? brush, TrackedBarcode trackedBarcode) {
    return barcodeMethodHandler
        .setBrushForTrackedBarcode(
            dataCaptureViewId: _overlay._dataCaptureViewId,
            trackedBarcodeIdentifier: trackedBarcode.identifier,
            brushJson: brush != null ? jsonEncode(brush.toMap()) : null)
        .onError(onError);
  }

  Future<void> clearTrackedBarcodeBrushes() {
    return barcodeMethodHandler
        .clearTrackedBarcodeBrushes(dataCaptureViewId: _overlay._dataCaptureViewId)
        .onError(onError);
  }

  Future<void> update() {
    return barcodeMethodHandler
        .updateBarcodeBatchBasicOverlay(
            dataCaptureViewId: _overlay._dataCaptureViewId, overlayJson: jsonEncode(_overlay.toMap()))
        .onError(onError);
  }

  void unsubscribeListener() {
    _overlaySubscription?.cancel();
    ListenerRegistry.instance.removeListeners(
        _barcodeBatchBasicOverlayListenerEvents, ListenerTarget.view(_overlay._dataCaptureViewId), this);
    _overlaySubscription = null;
  }

  void subscribeListener() {
    ListenerRegistry.instance
        .addListeners(_barcodeBatchBasicOverlayListenerEvents, ListenerTarget.view(_overlay._dataCaptureViewId), this);
    _registerEventChannelStreamListener();
  }

  void _registerEventChannelStreamListener() {
    if (_overlaySubscription != null) return;

    _overlaySubscription = BarcodePluginEvents.barcodeBatchEventStream.asFlutterEvents().listen((event) async {
      if (_overlay._listener == null) return;

      if (event.isEvent(BarcodeBatchBasicOverlayListener._brushForTrackedBarcodeEventName)) {
        // Fire-and-forget event, no ack to protect: parse strictly and let a schema mismatch
        // throw.
        final payload = BarcodeBatchBasicOverlayListenerBrushForTrackedBarcode.fromJson(event.payload);
        var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(payload.trackedBarcode));
        var brush = _overlay._listener?.brushForTrackedBarcode(_overlay, trackedBarcode);
        if (brush != null) {
          await barcodeMethodHandler.setBrushForTrackedBarcode(
              dataCaptureViewId: _overlay._dataCaptureViewId,
              trackedBarcodeIdentifier: trackedBarcode.identifier,
              brushJson: jsonEncode(brush.toMap()));
        }
      } else if (event.isEvent(BarcodeBatchBasicOverlayListener._didTapTrackedBarcodeEventName)) {
        // Fire-and-forget event, no ack to protect: parse strictly and let a schema mismatch
        // throw.
        final payload = BarcodeBatchBasicOverlayListenerDidTapTrackedBarcode.fromJson(event.payload);
        _overlay._listener?.didTapTrackedBarcode(
          _overlay,
          TrackedBarcode.fromJSON(jsonDecode(payload.trackedBarcode)),
        );
      }
    });
  }

  @override
  void dispose() {
    unsubscribeListener();
    super.dispose();
  }
}
