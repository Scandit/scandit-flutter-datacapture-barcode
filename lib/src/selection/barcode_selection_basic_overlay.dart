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
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show BarcodeSelectionAimedBrushProviderBrushForBarcode, BarcodeSelectionTrackedBrushProviderBrushForBarcode;
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_core/internal.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'barcode_selection_brush_provider.dart';
import 'barcode_selection_defaults.dart';

/// The style of the [BarcodeSelectionBasicOverlay].
///
/// Added in version 6.10.0
enum BarcodeSelectionBasicOverlayStyle {
  /// Style that draws the highlights as a rectangular frame and adds an animation for when a code newly appears.
  ///
  /// Added in version 6.10.0
  frame('frame'),
  /// Style that draws the highlights as a dot and adds an animation for when a code newly appears.
  ///
  /// Added in version 6.10.0
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

/// An overlay for [DataCaptureView] that shows a simple augmentation over each selected barcode.
///
/// To display the augmentations, this overlay must be attached to a [DataCaptureView]. This can be done by passing this overlay to [DataCaptureView.addOverlay].
///
/// A user of this class may configure the appearance of the augmentations by configuring the brush properties.
///
/// Added in version 6.10.0
class BarcodeSelectionBasicOverlay extends DataCaptureOverlay {
  _BarcodeSelectionBasicOverlayController? _controller;

  /// The overlay style. Defaults to Frame.
  ///
  /// Added in version 6.10.0
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

  /// Constructs a new BarcodeSelectionBasicOverlay. For the overlay to be displayed on screen, it must be added to a [DataCaptureView].
  ///
  /// Added in version 7.6.0
  BarcodeSelectionBasicOverlay(BarcodeSelection mode, {BarcodeSelectionBasicOverlayStyle? style})
      : this._(mode, style ?? BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.defaultStyle);

  /// Returns the default tracked brush for the given style.
  ///
  /// Added in version 8.5.0
  static Brush defaultTrackedBrushForStyle(BarcodeSelectionBasicOverlayStyle style) =>
      BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.brushes[style]!.trackedBrush;

  /// Returns the default aimed brush for the given style.
  ///
  /// Added in version 8.5.0
  static Brush defaultAimedBrushForStyle(BarcodeSelectionBasicOverlayStyle style) =>
      BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.brushes[style]!.aimedBrush;

  /// Returns the default selected brush for the given style.
  ///
  /// Added in version 8.5.0
  static Brush defaultSelectedBrushForStyle(BarcodeSelectionBasicOverlayStyle style) =>
      BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.brushes[style]!.selectedBrush;

  /// Returns the default selecting brush for the given style.
  ///
  /// Added in version 8.5.0
  static Brush defaultSelectingBrushForStyle(BarcodeSelectionBasicOverlayStyle style) =>
      BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.brushes[style]!.selectingBrush;

  DataCaptureView? _view;

  /// The view this barcode selection basic overlay is attached to. When the barcode selection basic overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 6.10.0
  @override
  DataCaptureView? get view => _view;

  /// The view this barcode selection basic overlay is attached to. When the barcode selection basic overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 6.10.0
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

  /// The brush applied to recognized tracked barcodes. Setting this brush to [Brush.transparent] hides all tracked barcodes.
  ///
  /// Added in version 6.10.0
  Brush get trackedBrush => _trackedBrush;

  /// The brush applied to recognized tracked barcodes. Setting this brush to [Brush.transparent] hides all tracked barcodes.
  ///
  /// Added in version 6.10.0
  set trackedBrush(Brush newValue) {
    _trackedBrush = newValue;
    _controller?.update();
  }

  late Brush _aimedBrush;

  /// The brush applied to the barcode that is currently being aimed at.
  ///
  /// Added in version 6.10.0
  Brush get aimedBrush => _aimedBrush;

  /// The brush applied to the barcode that is currently being aimed at.
  ///
  /// Added in version 6.10.0
  set aimedBrush(Brush newValue) {
    _aimedBrush = newValue;
    _controller?.update();
  }

  late Brush _selectedBrush;

  /// The brush applied to selected barcodes. Setting this brush to [Brush.transparent] hides all selected barcodes.
  ///
  /// Added in version 6.10.0
  Brush get selectedBrush => _selectedBrush;

  /// The brush applied to selected barcodes. Setting this brush to [Brush.transparent] hides all selected barcodes.
  ///
  /// Added in version 6.10.0
  set selectedBrush(Brush newValue) {
    _selectedBrush = newValue;
    _controller?.update();
  }

  late Brush _selectingBrush;

  /// The brush applied to the barcodes for the short moment when they are being selected.
  ///
  /// Added in version 6.10.0
  Brush get selectingBrush => _selectingBrush;

  /// The brush applied to the barcodes for the short moment when they are being selected.
  ///
  /// Added in version 6.10.0
  set selectingBrush(Brush newValue) {
    _selectingBrush = newValue;
    _controller?.update();
  }

  bool _shouldShowScanAreaGuides = false;

  /// When set to *true*, this overlay will visualize the active scan area used for BarcodeSelection. This is useful to check margins ([DataCaptureView.scanAreaMargins]) defined on the [DataCaptureView] are set correctly. This property is meant for debugging during development and is not intended for use in production.
  ///
  /// By default this property is *false*.
  ///
  /// Added in version 6.10.0
  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  /// When set to *true*, this overlay will visualize the active scan area used for BarcodeSelection. This is useful to check margins ([DataCaptureView.scanAreaMargins]) defined on the [DataCaptureView] are set correctly. This property is meant for debugging during development and is not intended for use in production.
  ///
  /// By default this property is *false*.
  ///
  /// Added in version 6.10.0
  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller?.update();
  }

  bool _shouldShowHints = BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.shouldShowHints;

  /// When set to *true*, this overlay will visualize some hints explaining how to use barcode selection.
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.10.0
  bool get shouldShowHints => _shouldShowHints;

  /// When set to *true*, this overlay will visualize some hints explaining how to use barcode selection.
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.10.0
  set shouldShowHints(bool newValue) {
    _shouldShowHints = newValue;
    _controller?.update();
  }

  void _handleViewfinderChanged() {
    _controller?.update();
  }

  final Viewfinder _viewfinder = AimerViewfinder();

  /// The viewfinder of the overlay. The viewfinder is only visible when the selection type is [BarcodeSelectionAimerSelection].
  ///
  /// Added in version 6.10.0
  Viewfinder get viewfinder => _viewfinder;

  Color _frozenBackgroundColor = BarcodeSelectionDefaults.barcodeSelectionBasicOverlayDefaults.frozenBackgroundColor;

  /// The overlay’s background color when in frozen state. This color will be on top of the video preview but below the highlights. Semitransparent black by default.
  ///
  /// Added in version 6.13.0
  Color get frozenBackgroundColor => _frozenBackgroundColor;

  /// The overlay’s background color when in frozen state. This color will be on top of the video preview but below the highlights. Semitransparent black by default.
  ///
  /// Added in version 6.13.0
  set frozenBackgroundColor(Color newValue) {
    _frozenBackgroundColor = newValue;
    _controller?.update();
  }

  String? _textForSelectOrDoubleTapToFreezeHint;

  /// Sets the text of the hint which suggests to use double tap gesture to freeze capture view.
  ///
  /// On JavaScript-based frameworks and Flutter, this takes effect only if called before the overlay is added to the [DataCaptureView].
  ///
  /// Added in version 7.1.0
  Future<void> setTextForSelectOrDoubleTapToFreezeHint(String text) async {
    _textForSelectOrDoubleTapToFreezeHint = text;
    await _controller?.update();
  }

  String? _textForTapToSelectHint;

  /// Sets the text of the hint which suggests to use tap gesture to select barcodes.
  ///
  /// On JavaScript-based frameworks and Flutter, this takes effect only if called before the overlay is added to the [DataCaptureView].
  ///
  /// Added in version 7.1.0
  Future<void> setTextForTapToSelectHint(String text) async {
    _textForTapToSelectHint = text;
    await _controller?.update();
  }

  String? _textForDoubleTapToUnfreezeHint;

  /// Sets the text of the hint which suggests to use double tap gesture to unfreeze capture view.
  ///
  /// On JavaScript-based frameworks and Flutter, this takes effect only if called before the overlay is added to the [DataCaptureView].
  ///
  /// Added in version 7.1.0
  Future<void> setTextForDoubleTapToUnfreezeHint(String text) async {
    _textForDoubleTapToUnfreezeHint = text;
    await _controller?.update();
  }

  String? _textForTapAnywhereToSelectHint;

  /// Sets the text of the hint which suggests to use tap gesture anywhere on the screen to select.
  ///
  /// On JavaScript-based frameworks and Flutter, this takes effect only if called before the overlay is added to the [DataCaptureView].
  ///
  /// Added in version 7.1.0
  Future<void> setTextForTapAnywhereToSelectHint(String text) async {
    _textForTapAnywhereToSelectHint = text;
    await _controller?.update();
  }

  String? _textForAimToSelectAutoHint;

  /// Sets the text of the hint which suggests to aim at a barcode to scan it.
  ///
  /// Added in version 7.1.0
  Future<void> setTextForAimToSelectAutoHint(String text) async {
    _textForAimToSelectAutoHint = text;
    await _controller?.update();
  }

  /// Clears all currently displayed visualizations for the on screen barcodes.
  ///
  /// This only applies to the currently displayed barcodes, the visualizations for the new ones will still appear.
  ///
  /// Added in version 8.5.0
  Future<void> clearSelectedBarcodeBrushes() async {
    await _controller?.clearSelectedBarcodeBrushes();
  }

  BarcodeSelectionBrushProvider? _aimedBarcodeBrushProvider;

  /// Sets the brush provider for aimed barcode.
  ///
  /// Added in version 8.5.0
  Future<void> setAimedBarcodeBrushProvider(BarcodeSelectionBrushProvider? brushProvider) async {
    _aimedBarcodeBrushProvider = brushProvider;
    await _controller?.setAimedBarcodeBrushProvider(brushProvider);
  }

  BarcodeSelectionBrushProvider? _trackedBarcodeBrushProvider;

  /// Sets the brush provider for tracked barcode.
  ///
  /// Added in version 8.5.0
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
  final Set<String> _warnedOnceKeys = {};

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
      ListenerRegistry.instance.removeListener(_brushForAimedBarcodeEventName, ListenerTarget.global, this);
      await barcodeMethodHandler.removeAimedBarcodeBrushProvider().catchError(onError);
    } else {
      ListenerRegistry.instance.addListener(_brushForAimedBarcodeEventName, ListenerTarget.global, this);
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

  // ACK-owing: native blocks on the finish callback below, so a schema-parse failure must not
  // prevent it - parse tolerantly (fall back to reading the raw map) rather than throw, so the
  // ack still fires promptly instead of surfacing only after the native-side timeout.
  //
  // Duplicated (near-)verbatim across BarcodeSelectionListenerController.ts,
  // BarcodeSelectionOverlayController.ts and barcode_selection.dart. Lifting it into a shared
  // base is deliberately out of scope for this slice - it would touch seven other modes mid-epic.
  // Consolidation owner: SDC-32638.
  void _handleBrushForBarcodeEvent(
    Map<String, dynamic> payload,
    BarcodeSelectionBrushProvider? provider, {
    required bool aimed,
  }) {
    String? barcodeJson;
    try {
      barcodeJson = aimed
          ? BarcodeSelectionAimedBrushProviderBrushForBarcode.fromJson(payload).barcode
          : BarcodeSelectionTrackedBrushProviderBrushForBarcode.fromJson(payload).barcode;
    } catch (error) {
      final event = aimed ? _brushForAimedBarcodeEventName : _brushForTrackedBarcodeEventName;
      if (_warnedOnceKeys.add('$event:schema')) {
        developer.log('BarcodeSelectionBasicOverlay brushForBarcode payload failed schema validation: $error');
      }
      barcodeJson = payload['barcode'] as String?;
    }

    // Native blocks on the finish call below regardless of what selectionIdentifier it carries,
    // so an unparseable barcode - or the absence of a registered provider - still needs a
    // best-effort ack rather than stranding the native side until its own timeout.
    // Not keyed by selectionIdentifier: FrameworksBarcodeSelection{Aimed,Tracked}BrushProvider
    // .onFinishCallback calls submitResult() unconditionally; identifier is a cache key only.
    var selectionIdentifier = '';
    String? brushJson;
    try {
      if (provider != null) {
        final barcode = Barcode.fromJSON(jsonDecode(barcodeJson!) as Map<String, dynamic>);
        selectionIdentifier = (barcode.data ?? '') + barcode.symbology.toString();
        final brush = provider.brushForBarcode(barcode);
        brushJson = brush == null ? null : jsonEncode(brush.toMap());
      }
    } catch (error) {
      // Fires per barcode per frame, so log the first failure per event and drop the rest.
      final event = aimed ? _brushForAimedBarcodeEventName : _brushForTrackedBarcodeEventName;
      if (_warnedOnceKeys.add('$event:failed')) {
        developer.log('BarcodeSelectionBasicOverlay brushForBarcode failed: $error');
      }
    } finally {
      final finish = aimed
          ? barcodeMethodHandler.finishBrushForAimedBarcodeCallback(
              selectionIdentifier: selectionIdentifier, brushJson: brushJson)
          : barcodeMethodHandler.finishBrushForTrackedBarcodeCallback(
              selectionIdentifier: selectionIdentifier, brushJson: brushJson);
      finish.catchError((error) => developer.log(error.toString()));
    }
  }

  @override
  void dispose() {
    if (_overlay._aimedBarcodeBrushProvider != null) {
      ListenerRegistry.instance.removeListener(_brushForAimedBarcodeEventName, ListenerTarget.global, this);
    }
    _brushProviderSubscription?.cancel();
    _brushProviderSubscription = null;
    super.dispose();
  }
}
