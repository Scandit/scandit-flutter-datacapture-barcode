/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

// ignore_for_file: must_be_immutable - packaging injects doc comments above the
// class, which detaches a line-level ignore from the class it applies to.

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/ar/barcode_ar_feedback.dart';
import 'package:scandit_flutter_datacapture_barcode/src/ar/barcode_ar_session.dart';
import 'package:scandit_flutter_datacapture_barcode/src/ar/barcode_ar_settings.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show
        BarcodeArAnnotationProviderAnnotationForBarcode,
        BarcodeArAugmentationsEvicted,
        BarcodeArFilterFilterBarcodes,
        BarcodeArHighlightProviderHighlightForBarcode,
        BarcodeArInfoAnnotationListenerDidTapInfoAnnotation,
        BarcodeArInfoAnnotationListenerDidTapInfoAnnotationFooter,
        BarcodeArInfoAnnotationListenerDidTapInfoAnnotationHeader,
        BarcodeArInfoAnnotationListenerDidTapInfoAnnotationLeftIcon,
        BarcodeArInfoAnnotationListenerDidTapInfoAnnotationRightIcon,
        BarcodeArListenerDidUpdateSession,
        BarcodeArPopoverAnnotationListenerDidTapPopover,
        BarcodeArPopoverAnnotationListenerDidTapPopoverButton,
        BarcodeArViewUiListenerDidTapHighlightForBarcode;
import 'package:scandit_flutter_datacapture_core/experimental.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';

import '../barcode.dart';
import 'barcode_ar_annotation.dart';
import 'barcode_ar_annotation_provider.dart';
import 'barcode_ar_common.dart';
import 'barcode_ar_defaults.dart';
import 'barcode_ar_filter.dart';
import 'barcode_ar_function_names.dart';
import 'barcode_ar_highlight.dart';
import 'barcode_ar_highlight_provider.dart';
import 'barcode_ar_view_settings.dart';

/// Listener interface for BarcodeAr.
///
/// Added in version 7.1.0
abstract class BarcodeArListener {
  static const String _barcodeArListenerDidUpdateSession = 'BarcodeArListener.didUpdateSession';

  /// Invoked whenever the session has been updated.
  ///
  /// Added in version 7.1.0
  Future<void> didUpdateSession(
      BarcodeAr barcodeAr, BarcodeArSession session, Future<FrameData> Function() getFrameData);
}

/// Added in version 7.1.0
abstract class BarcodeArViewUiListener {
  static const String _barcodeArViewUiListenerDidTapHighlight = 'BarcodeArViewUiListener.didTapHighlightForBarcode';

  /// Callback method that is called when a barcode highlight is tapped in the view.
  ///
  /// Added in version 7.1.0
  void didTapHighlightForBarcode(BarcodeAr barcodeAr, Barcode barcode, BarcodeArHighlight highlight);
}

/// Capture mode that implements Barcode AR.
///
/// Added in version 7.1.0
class BarcodeAr extends Serializable {
  _BarcodeArViewController? _controller;

  BarcodeArSettings _settings;

  final List<BarcodeArListener> _listeners = [];

  BarcodeArFeedback _feedback = BarcodeArFeedback();
  VoidCallback? _feedbackListener;

  BarcodeAr._(this._settings) {
    _addFeedbackListener();
  }

  /// Constructs a new BarcodeAr instance with the provided settings.
  ///
  /// Added in version 7.6.0
  BarcodeAr(BarcodeArSettings settings) : this._(settings);

  /// Returns the recommended camera settings for use with Barcode AR.
  ///
  /// Added in version 7.6.0
  static CameraSettings createRecommendedCameraSettings() {
    return CameraSettings(
      BarcodeArDefaults.recommendedCameraSettings.preferredResolution,
      BarcodeArDefaults.recommendedCameraSettings.zoomFactor,
      BarcodeArDefaults.recommendedCameraSettings.focusRange,
      BarcodeArDefaults.recommendedCameraSettings.focusGestureStrategy,
      BarcodeArDefaults.recommendedCameraSettings.zoomGestureZoomFactor,
      properties: BarcodeArDefaults.recommendedCameraSettings.properties,
      shouldPreferSmoothAutoFocus: BarcodeArDefaults.recommendedCameraSettings.shouldPreferSmoothAutoFocus,
      torchLevel: BarcodeArDefaults.recommendedCameraSettings.torchLevel,
      macroMode: BarcodeArDefaults.recommendedCameraSettings.macroMode,
      adaptiveExposure: BarcodeArDefaults.recommendedCameraSettings.adaptiveExposure,
    );
  }

  /// Instance of [BarcodeArFeedback] that is used by the barcode scanner to notify users about Ar events.
  ///
  /// The default instance of the Feedback will have both sound and vibration enabled. A default beep sound will be used for the sound.
  ///
  /// Added in version 7.1.0
  BarcodeArFeedback get feedback => _feedback;

  /// Instance of [BarcodeArFeedback] that is used by the barcode scanner to notify users about Ar events.
  ///
  /// The default instance of the Feedback will have both sound and vibration enabled. A default beep sound will be used for the sound.
  ///
  /// Added in version 7.1.0
  set feedback(BarcodeArFeedback newValue) {
    if (_feedback == newValue) {
      return;
    }
    _removeFeedbackListener();
    _feedback = newValue;
    _addFeedbackListener();
    _controller?.updateFeedback();
  }

  void _addFeedbackListener() {
    _feedbackListener = () {
      _controller?.updateFeedback();
    };
    _feedback.addListener(_feedbackListener!);
  }

  void _removeFeedbackListener() {
    if (_feedbackListener != null) {
      _feedback.removeListener(_feedbackListener!);
      _feedbackListener = null;
    }
  }

  /// Asynchronously applies the new settings to the barcode scanner. If the scanner is currently running, the task will complete when the next frame is processed, and will use the new settings for that frame. If the scanner is currently *not* running, the task will complete as soon as the settings have been stored and won’t wait until the next frame is going to be processed.
  ///
  /// Added in version 7.1.0
  Future<void> applySettings(BarcodeArSettings settings) {
    _settings = settings;
    return _controller?.applyNewSettings(settings) ?? Future.value();
  }

  /// Adds a listener to receive Barcode AR events.
  ///
  /// In case the same listener is already observing this instance, calling this method will not add the listener again.
  ///
  /// Added in version 7.1.0
  void addListener(BarcodeArListener listener) {
    if (_listeners.isEmpty) {
      _controller?.subscribeModeListeners();
    }

    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  /// Removes a previously added listener from this BarcodeAr instance.
  ///
  /// In case the listener is not currently observing this instance, calling this method has no effect.
  ///
  /// Added in version 7.1.0
  void removeListener(BarcodeArListener listener) {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      _controller?.unsubscribeModeListeners();
    }
  }

  BarcodeArFilter? _barcodeFilter;

  /// Sets a filter that determines which barcodes should be visible in the [BarcodeArSession].
  ///
  /// Pass *null* to remove the filter and show all barcodes.
  ///
  /// See [BarcodeArFilter] for details on implementing a custom filter.
  ///
  /// Added in version 8.5.0
  Future<void> setBarcodeFilter(BarcodeArFilter? filter) async {
    _barcodeFilter = filter;
    await _controller?.setBarcodeFilter(filter);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'barcodeAr',
      'settings': _settings.toMap(),
      'feedback': _feedback.toMap(),
      'hasBarcodeFilter': _barcodeFilter != null,
    };
  }
}

/// Barcode AR comes with a ready-to-use UI that allows highlighting barcodes and displaying additional information over them. The BarcodeArView integrates with any app in just a few lines of code.
///
/// Added in version 7.1.0
class BarcodeArView extends StatefulWidget implements Serializable {
  _BarcodeArViewController? _controller;
  // We require that to exist doesn't mean it must be used here.
  // ignore: unused_field
  final DataCaptureContext _dataCaptureContext;
  final BarcodeAr _barcodeAr;
  final BarcodeArViewSettings? _barcodeArViewSettings;
  final CameraSettings? _cameraSettings;

  bool _isInitialized = false;
  int _viewId = 0;

  BarcodeArView._(this._dataCaptureContext, this._barcodeAr, this._barcodeArViewSettings, this._cameraSettings)
      : super();

  factory BarcodeArView.forMode(DataCaptureContext dataCaptureContext, BarcodeAr barcodeAr) {
    return BarcodeArView._(dataCaptureContext, barcodeAr, null, null);
  }

  /// Creates a new BarcodeArView with the provided mode, viewSettings and default camera settings from [BarcodeAr.createRecommendedCameraSettings]. This is equivalent of calling forMode() ([BarcodeArView.BarcodeArView]) with *null* cameraSettings.
  ///
  /// Added in version 7.1.0
  factory BarcodeArView.forModeWithViewSettings(
    DataCaptureContext dataCaptureContext,
    BarcodeAr barcodeAr,
    BarcodeArViewSettings viewSettings,
  ) {
    return BarcodeArView._(dataCaptureContext, barcodeAr, viewSettings, null);
  }

  factory BarcodeArView.forModeWithViewSettingsAndCameraSettings(
    DataCaptureContext dataCaptureContext,
    BarcodeAr barcodeAr,
    BarcodeArViewSettings viewSettings,
    CameraSettings cameraSettings,
  ) {
    return BarcodeArView._(dataCaptureContext, barcodeAr, viewSettings, cameraSettings);
  }

  BarcodeArViewUiListener? _viewUIListener;

  /// Sets the listener which is called whenever a barcode highlight is tapped in the view.
  ///
  /// Added in version 7.1.0
  BarcodeArViewUiListener? get uiListener => _viewUIListener;

  /// Sets the listener which is called whenever a barcode highlight is tapped in the view.
  ///
  /// Added in version 7.1.0
  set uiListener(BarcodeArViewUiListener? newValue) {
    _viewUIListener = newValue;
    _controller?.setUiListener(newValue);
  }

  BarcodeArHighlightProvider? _highlightProvider;

  /// Sets the provider which supplies highlight information for barcodes in the view. If *null*, a default provider is used, which returns a predefined highlight for each barcode.
  ///
  /// Added in version 7.1.0
  BarcodeArHighlightProvider? get highlightProvider => _highlightProvider;

  /// Sets the provider which supplies highlight information for barcodes in the view. If *null*, a default provider is used, which returns a predefined highlight for each barcode.
  ///
  /// Added in version 7.1.0
  set highlightProvider(BarcodeArHighlightProvider? newValue) {
    _highlightProvider = newValue;
    _controller?.setHighlightProvider(newValue);
  }

  BarcodeArAnnotationProvider? _annotationProvider;

  /// Sets the provider which supplies annotation information for barcodes in the view. If *null*, no annotation will be displayed for any barcode.
  ///
  /// Added in version 7.1.0
  BarcodeArAnnotationProvider? get annotationProvider => _annotationProvider;

  /// Sets the provider which supplies annotation information for barcodes in the view. If *null*, no annotation will be displayed for any barcode.
  ///
  /// Added in version 7.1.0
  set annotationProvider(BarcodeArAnnotationProvider? newValue) {
    _annotationProvider = newValue;
    _controller?.setAnnotationProvider(newValue);
  }

  bool _shouldShowTorchControl = BarcodeArDefaults.view.defaultShouldShowTorchControl;

  /// Indicates whether the torch control button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 7.1.0
  bool get shouldShowTorchControl => _shouldShowTorchControl;

  /// Indicates whether the torch control button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 7.1.0
  set shouldShowTorchControl(bool newValue) {
    _shouldShowTorchControl = newValue;
    _updateNative();
  }

  Anchor _torchControlPosition = BarcodeArDefaults.view.defaultTorchControlPosition;

  /// Updates the position of the torch control button.
  ///
  /// Default is [Anchor.topLeft].
  ///
  /// Added in version 7.1.0
  Anchor get torchControlPosition => _torchControlPosition;

  /// Updates the position of the torch control button.
  ///
  /// Default is [Anchor.topLeft].
  ///
  /// Added in version 7.1.0
  set torchControlPosition(Anchor newValue) {
    _torchControlPosition = newValue;
    _updateNative();
  }

  bool _shouldShowZoomControl = BarcodeArDefaults.view.defaultShouldShowZoomControl;

  /// Indicates whether the zoom control button should be shown to the user.
  ///
  /// Added in version 7.1.0
  bool get shouldShowZoomControl => _shouldShowZoomControl;

  /// Indicates whether the zoom control button should be shown to the user.
  ///
  /// Added in version 7.1.0
  set shouldShowZoomControl(bool newValue) {
    _shouldShowZoomControl = newValue;
    _updateNative();
  }

  Anchor _zoomControlPosition = BarcodeArDefaults.view.defaultZoomControlPosition;

  /// Updates the position of the zoom control button.
  ///
  /// Default is [Anchor.bottomRight].
  ///
  /// Added in version 7.1.0
  Anchor get zoomControlPosition => _zoomControlPosition;

  /// Updates the position of the zoom control button.
  ///
  /// Default is [Anchor.bottomRight].
  ///
  /// Added in version 7.1.0
  set zoomControlPosition(Anchor newValue) {
    _zoomControlPosition = newValue;
    _updateNative();
  }

  bool _shouldShowCameraSwitchControl = BarcodeArDefaults.view.defaultShouldShowCameraSwitchControl;

  /// Indicates whether the camera switch control button should be shown to the user.
  ///
  /// Added in version 7.1.0
  bool get shouldShowCameraSwitchControl => _shouldShowCameraSwitchControl;

  /// Indicates whether the camera switch control button should be shown to the user.
  ///
  /// Added in version 7.1.0
  set shouldShowCameraSwitchControl(bool newValue) {
    _shouldShowCameraSwitchControl = newValue;
    _updateNative();
  }

  Anchor _cameraSwitchControlPosition = BarcodeArDefaults.view.defaultCameraSwitchControlPosition;

  /// Updates the position of the camera switch control button.
  ///
  /// Default is [Anchor.topRight].
  ///
  /// Added in version 7.1.0
  Anchor get cameraSwitchControlPosition => _cameraSwitchControlPosition;

  /// Updates the position of the camera switch control button.
  ///
  /// Default is [Anchor.topRight].
  ///
  /// Added in version 7.1.0
  set cameraSwitchControlPosition(Anchor newValue) {
    _cameraSwitchControlPosition = newValue;
    _updateNative();
  }

  bool _shouldShowMacroModeControl = BarcodeArDefaults.view.defaultShouldShowMacroModeControl;

  /// Indicates whether the macro mode control button should be shown to the user.
  ///
  /// This property is only supported on iOS devices.
  ///
  /// Added in version 7.1.0
  bool get shouldShowMacroModeControl => _shouldShowMacroModeControl;

  /// Indicates whether the macro mode control button should be shown to the user.
  ///
  /// This property is only supported on iOS devices.
  ///
  /// Added in version 7.1.0
  set shouldShowMacroModeControl(bool newValue) {
    _shouldShowMacroModeControl = newValue;
    _updateNative();
  }

  Anchor _macroModeControlPosition = BarcodeArDefaults.view.defaultMacroModeControlPosition;

  /// Updates the position of the macro mode control button.
  ///
  /// Default is [Anchor.topRight].
  ///
  /// This property is only supported on iOS devices.
  ///
  /// Added in version 7.1.0
  Anchor get macroModeControlPosition => _macroModeControlPosition;

  /// Updates the position of the macro mode control button.
  ///
  /// Default is [Anchor.topRight].
  ///
  /// This property is only supported on iOS devices.
  ///
  /// Added in version 7.1.0
  set macroModeControlPosition(Anchor newValue) {
    _macroModeControlPosition = newValue;
    _updateNative();
  }

  PointWithUnit? _torchControlOffset;

  /// Sets the visual offset of the torch control button.
  ///
  /// Assign null to reset the offset to its default position.
  ///
  /// Added in version 8.6.0
  PointWithUnit? get torchControlOffset => _torchControlOffset;

  /// Sets the visual offset of the torch control button.
  ///
  /// Assign null to reset the offset to its default position.
  ///
  /// Added in version 8.6.0
  set torchControlOffset(PointWithUnit? newValue) {
    _torchControlOffset = newValue;
    _updateNative();
  }

  PointWithUnit? _zoomControlOffset;

  /// Sets the visual offset of the zoom control button.
  ///
  /// Assign null to reset the offset to its default position.
  ///
  /// Added in version 8.6.0
  PointWithUnit? get zoomControlOffset => _zoomControlOffset;

  /// Sets the visual offset of the zoom control button.
  ///
  /// Assign null to reset the offset to its default position.
  ///
  /// Added in version 8.6.0
  set zoomControlOffset(PointWithUnit? newValue) {
    _zoomControlOffset = newValue;
    _updateNative();
  }

  PointWithUnit? _cameraSwitchControlOffset;

  /// Sets the visual offset of the camera switch control button.
  ///
  /// Assign null to reset the offset to its default position.
  ///
  /// Added in version 8.6.0
  PointWithUnit? get cameraSwitchControlOffset => _cameraSwitchControlOffset;

  /// Sets the visual offset of the camera switch control button.
  ///
  /// Assign null to reset the offset to its default position.
  ///
  /// Added in version 8.6.0
  set cameraSwitchControlOffset(PointWithUnit? newValue) {
    _cameraSwitchControlOffset = newValue;
    _updateNative();
  }

  PointWithUnit? _macroModeControlOffset;

  /// Sets the visual offset of the macro mode control button.
  ///
  /// Assign null to reset the offset to its default position.
  ///
  /// Added in version 8.6.0
  PointWithUnit? get macroModeControlOffset => _macroModeControlOffset;

  /// Sets the visual offset of the macro mode control button.
  ///
  /// Assign null to reset the offset to its default position.
  ///
  /// Added in version 8.6.0
  set macroModeControlOffset(PointWithUnit? newValue) {
    _macroModeControlOffset = newValue;
    _updateNative();
  }

  LogoStyle _logoStyle = BarcodeArDefaults.view.defaultLogoStyle;

  /// The style of the logo, either the extended “Scanning By Scandit” or the minimal “Scandit”.
  ///
  /// Default is [LogoStyle.extended].
  ///
  /// Added in version 8.6.0
  LogoStyle get logoStyle => _logoStyle;

  /// The style of the logo, either the extended “Scanning By Scandit” or the minimal “Scandit”.
  ///
  /// Default is [LogoStyle.extended].
  ///
  /// Added in version 8.6.0
  set logoStyle(LogoStyle newValue) {
    _logoStyle = newValue;
    _updateNative();
  }

  Anchor _logoAnchor = BarcodeArDefaults.view.defaultLogoAnchor;

  /// The anchor point used to position the Scandit logo. To shift the logo relative to the anchor, use [BarcodeArView.logoOffset].
  ///
  /// Default is [Anchor.bottomRight].
  ///
  /// Added in version 8.6.0
  Anchor get logoAnchor => _logoAnchor;

  /// The anchor point used to position the Scandit logo. To shift the logo relative to the anchor, use [BarcodeArView.logoOffset].
  ///
  /// Default is [Anchor.bottomRight].
  ///
  /// Added in version 8.6.0
  set logoAnchor(Anchor newValue) {
    _logoAnchor = newValue;
    _updateNative();
  }

  PointWithUnit _logoOffset = BarcodeArDefaults.view.defaultLogoOffset;

  /// The offset applied to the Scandit logo relative to the logo anchor ([BarcodeArView.logoAnchor]). When specified in pixels ([MeasureUnit.pixel]) the offset is used as-is. When specified as a fraction ([MeasureUnit.fraction]) the offset is computed relative to the view size minus the scan area margins.
  ///
  /// Default is a zero offset.
  ///
  /// Added in version 8.6.0
  PointWithUnit get logoOffset => _logoOffset;

  /// The offset applied to the Scandit logo relative to the logo anchor ([BarcodeArView.logoAnchor]). When specified in pixels ([MeasureUnit.pixel]) the offset is used as-is. When specified as a fraction ([MeasureUnit.fraction]) the offset is computed relative to the view size minus the scan area margins.
  ///
  /// Default is a zero offset.
  ///
  /// Added in version 8.6.0
  set logoOffset(PointWithUnit newValue) {
    _logoOffset = newValue;
    _updateNative();
  }

  bool _isStarted = true;

  /// Starts the scanning process.
  ///
  /// Added in version 7.1.0
  Future<void> start() {
    _isStarted = true;
    return _controller?.start() ?? Future.value();
  }

  /// Stops the scanning process.
  ///
  /// On Android the highlights and annotations that are already shown are kept, and they are still there when scanning starts again. On iOS they are removed, and they are supplied again by the providers after the next start. Resetting or disposing the view removes them.
  ///
  /// Added in version 7.1.0
  Future<void> stop() {
    _isStarted = false;
    return _controller?.stop() ?? Future.value();
  }

  /// Pauses the scanning process.
  ///
  /// The highlights and annotations that are already shown are kept, so they stay tappable while the view is paused and when scanning starts again. Resetting or disposing the view removes them.
  ///
  /// Added in version 7.1.0
  Future<void> pause() {
    _isStarted = false;
    return _controller?.pause() ?? Future.value();
  }

  /// Clears all highlights and annotations currently visible and calls [BarcodeArView.highlightProvider] and [BarcodeArView.annotationProvider] to supply new highlights and annotations.
  ///
  /// Added in version 7.2.0
  Future<void> reset() {
    return _controller?.reset() ?? Future.value();
  }

  /// Implemented from [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html). Called by the Flutter framework.
  ///
  /// Added in version 7.1.0
  @override
  State<StatefulWidget> createState() {
    return _BarcodeArViewState();
  }

  Future<void> _updateNative() {
    if (!_isInitialized) {
      return Future.value();
    }
    return _controller?.updateView() ?? Future.value();
  }

  @override
  Map<String, dynamic> toMap() {
    final torchControlOffset = _torchControlOffset;
    final zoomControlOffset = _zoomControlOffset;
    final cameraSwitchControlOffset = _cameraSwitchControlOffset;
    final macroModeControlOffset = _macroModeControlOffset;
    return <String, dynamic>{
      'View': {
        'shouldShowTorchControl': shouldShowTorchControl,
        'torchControlPosition': torchControlPosition.toString(),
        'shouldShowZoomControl': shouldShowZoomControl,
        'zoomControlPosition': zoomControlPosition.toString(),
        'shouldShowCameraSwitchControl': shouldShowCameraSwitchControl,
        'cameraSwitchControlPosition': cameraSwitchControlPosition.toString(),
        'shouldShowMacroModeControl': shouldShowMacroModeControl,
        'macroModeControlPosition': macroModeControlPosition.toString(),
        'torchControlOffset': torchControlOffset?.toMap(),
        'zoomControlOffset': zoomControlOffset?.toMap(),
        'cameraSwitchControlOffset': cameraSwitchControlOffset?.toMap(),
        'macroModeControlOffset': macroModeControlOffset?.toMap(),
        'logoStyle': logoStyle.toString(),
        'logoAnchor': logoAnchor.toString(),
        'logoOffset': logoOffset.toMap(),
        'hasModeListener': _barcodeAr._listeners.isNotEmpty,
        'hasUiListener': _viewUIListener != null,
        'hasHighlightProvider': _highlightProvider != null,
        'hasAnnotationProvider': _annotationProvider != null,
        'isStarted': _isStarted,
        'viewId': _viewId,
        'viewSettings': _barcodeArViewSettings?.toMap(),
        'cameraSettings': _cameraSettings?.toMap(),
      },
      'BarcodeAr': _barcodeAr.toMap(),
    };
  }
}

enum _CustomWidgetType {
  highlight,
  annotation,
}

class _CustomWidgetOverlay {
  final Widget widget;
  final Offset position;
  final Anchor anchor;
  final String barcodeId;
  final _CustomWidgetType type;
  final double? threshold;
  final bool visible;

  _CustomWidgetOverlay({
    required this.widget,
    required this.position,
    required this.anchor,
    required this.barcodeId,
    required this.type,
    this.threshold,
    this.visible = true,
  });

  // One overlay per responsive slot: every slot of a barcode shares its barcodeId.
  String get cacheKey => _customOverlayKey(barcodeId, threshold);

  bool get requiresClickHandling => type == _CustomWidgetType.highlight;

  _CustomWidgetOverlay copyWith({
    Widget? widget,
    Offset? position,
    Anchor? anchor,
    String? barcodeId,
    _CustomWidgetType? type,
    bool? visible,
  }) {
    return _CustomWidgetOverlay(
      widget: widget ?? this.widget,
      position: position ?? this.position,
      anchor: anchor ?? this.anchor,
      barcodeId: barcodeId ?? this.barcodeId,
      type: type ?? this.type,
      threshold: threshold,
      visible: visible ?? this.visible,
    );
  }
}

String _customOverlayKey(String barcodeId, double? threshold) =>
    threshold == null ? barcodeId : '$barcodeId|$threshold';

double? _thresholdOf(Map<String, dynamic> json) => (json['responsiveAnnotationThreshold'] as num?)?.toDouble();

class _BarcodeArViewController extends BaseController implements BarcodeArViewController {
  final Map<String, BarcodeArHighlight> _highlightCache = {};

  final Map<String, BarcodeArAnnotation> _annotationsCache = {};

  final Map<String, _CustomWidgetOverlay> _customHighlightCache = {};

  final Map<String, _CustomWidgetOverlay> _customAnnotationCache = {};

  StreamSubscription<dynamic>? _viewEventsSubscription;

  final StreamController<List<_CustomWidgetOverlay>> _customWidgetsController =
      StreamController<List<_CustomWidgetOverlay>>.broadcast();

  Stream<List<_CustomWidgetOverlay>> get customWidgetsStream => _customWidgetsController.stream;

  final BarcodeArView _view;

  late final BarcodeMethodHandler barcodeMethodHandler;

  _BarcodeArViewController(this._view) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
    _subscribeToEvents();
    if (_view._barcodeAr._listeners.isNotEmpty) {
      subscribeModeListeners();
    }
  }

  void _notifyCustomWidgetsChanged() {
    final allCustomWidgets = <_CustomWidgetOverlay>[];
    allCustomWidgets.addAll(_customHighlightCache.values);
    allCustomWidgets.addAll(_customAnnotationCache.values.where((overlay) => overlay.visible));
    _customWidgetsController.add(allCustomWidgets);
  }

  void _subscribeToEvents() {
    if (_viewEventsSubscription != null) return;

    _viewEventsSubscription = BarcodePluginEvents.barcodeArEventStream.forView(_view._viewId).listen((event) async {
      final json = event.payload;
      if (event.isEvent(BarcodeArViewUiListener._barcodeArViewUiListenerDidTapHighlight)) {
        final payload = BarcodeArViewUiListenerDidTapHighlightForBarcode.fromJson(json);
        _handleDidTapHighlightForBarcode(payload);
      } else if (event.isEvent(BarcodeArFunctionNames.highlightForBarcodeEvent)) {
        // Async provider callback that owns native cache eviction: parse strictly, but the
        // finish call must still fire exactly once for the recovered barcodeId -- including
        // when the parse itself throws -- so the native callback entry never leaks until
        // clearCache(). barcodeId is therefore recovered defensively from the raw payload
        // BEFORE validating, since the native side keys its pending callback by it.
        final rawBarcodeId = json['barcodeId'] is String ? json['barcodeId'] as String : null;
        BarcodeArHighlight? highlight;
        try {
          final payload = BarcodeArHighlightProviderHighlightForBarcode.fromJson(json);
          final barcodeId = payload.barcodeId;
          final barcode = Barcode.fromJSON(jsonDecode(payload.barcode));
          highlight = await _view.highlightProvider?.highlightForBarcode(barcode);

          if (highlight != null) {
            highlight.barcodeId = barcodeId;
            highlight.controller = this;
            _highlightCache[highlight.barcodeId] = highlight;
          }
        } finally {
          // Without a recovered barcodeId the native side has no callback to resolve (it keys
          // its pending callback by barcodeId and throws parsing the ack if the key is
          // missing/null), so there is nothing useful to ack.
          if (rawBarcodeId == null) {
            dev.log('BarcodeArView highlightForBarcode: no barcodeId recovered, skipping ack');
          } else {
            var result = _providerResult("highlight", rawBarcodeId, highlight?.toMap());
            barcodeMethodHandler
                .finishBarcodeArHighlightForBarcode(viewId: _view._viewId, highlightJson: jsonEncode(result))
                .onError(onError);
          }
        }
      } else if (event.isEvent(BarcodeArFunctionNames.filterBarcodesEvent)) {
        // Blocks a native thread for 2000 ms on failure to reply: parse tolerantly, and finish
        // in a `finally` so the ack always fires.
        var ids = <String>[];
        List<String>? filteredIds;
        try {
          // The happy path validates strictly (`fromJson`) and then reads `barcodeId`/`barcode`
          // off the TYPED item -- no flattening back to a raw map. The whole point of the
          // fallback arm is tolerance, so ONLY it stays raw-map-based (read `e['barcodeId']`/
          // `e['barcode']` off `Map<String, dynamic>`, tolerating a missing/non-String field)
          // rather than re-running the strict `fromJson` on each item, which would throw on
          // item-level schema drift before `ids` is populated below -- the `finally` fail-open
          // then acks `{'barcodes': []}` and drops every highlight for the frame instead of
          // keeping the ones it could recover. Both arms converge on the same lightweight
          // `_FilterBarcodeEntry` so the code below is agnostic to which arm ran. It is a plain
          // class rather than a record: the docs `collect-signatures-dart` job pins an older
          // `analyzer` that cannot parse record syntax, so a record here fails `flutter-docs`
          // (parseString throws) while local `dart analyze` on a modern SDK stays clean.
          final entries = _parsePayloadTolerantly<List<_FilterBarcodeEntry>>(
            json,
            (raw) => BarcodeArFilterFilterBarcodes.fromJson(raw)
                .barcodes
                .map((e) => _FilterBarcodeEntry(e.barcodeId, e.barcode))
                .toList(),
            (raw) => ((raw as Map<String, dynamic>)['barcodes'] as List<Object?>)
                .cast<Map<String, dynamic>>()
                .map((e) => _FilterBarcodeEntry(
                      e['barcodeId'] is String ? e['barcodeId'] as String : null,
                      e['barcode'] is String ? e['barcode'] as String : null,
                    ))
                .toList(),
            'filterBarcodes',
          );
          // Recover the ids BEFORE decoding: a single undecodable `barcode` (or a non-String
          // `barcodeId`) throws out of the map below, and the `finally` fallback is only useful
          // if `ids` is already populated. `rawIds` stays index-aligned with `entries`/`barcodes`
          // for the lookup further down; `ids` is the fallback list, so it drops unusable ids.
          final rawIds = entries.map((e) => e.barcodeId).toList();
          ids = rawIds.whereType<String>().toList();
          final barcodes = entries.map((e) => Barcode.fromJSON(jsonDecode(e.barcode as String))).toList();
          final filter = _view._barcodeAr._barcodeFilter;
          final filtered = filter != null ? await filter.filterBarcodes(barcodes) : barcodes;
          filteredIds = filtered
              .map((fb) {
                final idx = barcodes.indexWhere((b) => identical(b, fb));
                final id = idx >= 0 ? rawIds[idx] : null;
                return id is String ? id : null;
              })
              .whereType<String>()
              .toList();
        } catch (error) {
          dev.log('BarcodeArView filterBarcodes failed: $error');
        } finally {
          // Fail open, as the native 2000 ms timeout does: fall back to all known ids so a
          // throwing filter (or a per-entry parse failure) never drops every highlight/
          // annotation for the frame. Only an unparseable payload (no ids recovered) still
          // acks [].
          barcodeMethodHandler
              .finishBarcodeArFilterBarcodes(
                  viewId: _view._viewId, filteredBarcodesJson: jsonEncode({'barcodes': filteredIds ?? ids}))
              .onError(onError);
        }
      } else if (event.isEvent(BarcodeArFunctionNames.annotationForBarcodeEvent)) {
        // Async provider callback that owns native cache eviction: parse strictly, but always
        // run the finish call (in a `finally`) so the native callback entry doesn't leak until
        // clearCache(). barcodeId is recovered defensively from the raw payload BEFORE
        // validating, since the native side keys its pending callback by it and a parse
        // failure must still ack for that id.
        final rawBarcodeId = json['barcodeId'] is String ? json['barcodeId'] as String : null;
        BarcodeArAnnotation? annotation;
        try {
          final payload = BarcodeArAnnotationProviderAnnotationForBarcode.fromJson(json);
          final barcodeId = payload.barcodeId;
          final barcode = Barcode.fromJSON(jsonDecode(payload.barcode));
          annotation = await _view.annotationProvider?.annotationForBarcode(barcode);

          if (annotation != null) {
            annotation.barcodeId = barcodeId;
            annotation.controller = this;
            // Store in cache
            _annotationsCache[annotation.barcodeId] = annotation;
          }
        } finally {
          // Without a recovered barcodeId the native side has no callback to resolve (it keys
          // its pending callback by barcodeId and throws parsing the ack if the key is
          // missing/null), so there is nothing useful to ack.
          if (rawBarcodeId == null) {
            dev.log('BarcodeArView annotationForBarcode: no barcodeId recovered, skipping ack');
          } else {
            var result = _providerResult("annotation", rawBarcodeId, annotation?.toMap());
            barcodeMethodHandler
                .finishBarcodeArAnnotationForBarcode(viewId: _view._viewId, annotationJson: jsonEncode(result))
                .onError(onError);
          }
        }
      } else if (event.isEvent(BarcodeArFunctionNames.didTapPopoverEvent)) {
        final payload = BarcodeArPopoverAnnotationListenerDidTapPopover.fromJson(json);

        final popover = _getAnnotationFromPayload<BarcodeArPopoverAnnotation>(
            payload.barcodeId, payload.responsiveAnnotationThreshold, payload.responsiveAnnotationType);
        if (popover == null) return;

        popover.listener?.didTapPopover(popover);
      } else if (event.isEvent(BarcodeArFunctionNames.didTapPopoverButtonEvent)) {
        final payload = BarcodeArPopoverAnnotationListenerDidTapPopoverButton.fromJson(json);

        final popover = _getAnnotationFromPayload<BarcodeArPopoverAnnotation>(
            payload.barcodeId, payload.responsiveAnnotationThreshold, payload.responsiveAnnotationType);
        if (popover == null) return;

        final button = popover.buttons[payload.buttonIndex];

        popover.listener?.didTapPopoverButton(popover, button, payload.buttonIndex);
      } else if (event.isEvent(BarcodeArFunctionNames.didTapInfoAnnotationRightIconEvent)) {
        final payload = BarcodeArInfoAnnotationListenerDidTapInfoAnnotationRightIcon.fromJson(json);
        final infoAnnotation = _getAnnotationFromPayload<BarcodeArInfoAnnotation>(
            payload.barcodeId, payload.responsiveAnnotationThreshold, payload.responsiveAnnotationType);
        if (infoAnnotation == null) return;

        infoAnnotation.listener?.didTapInfoAnnotationRightIcon(infoAnnotation, payload.componentIndex);
      } else if (event.isEvent(BarcodeArFunctionNames.didTapInfoAnnotationLeftIconEvent)) {
        final payload = BarcodeArInfoAnnotationListenerDidTapInfoAnnotationLeftIcon.fromJson(json);
        final infoAnnotation = _getAnnotationFromPayload<BarcodeArInfoAnnotation>(
            payload.barcodeId, payload.responsiveAnnotationThreshold, payload.responsiveAnnotationType);
        if (infoAnnotation == null) return;

        infoAnnotation.listener?.didTapInfoAnnotationLeftIcon(infoAnnotation, payload.componentIndex);
      } else if (event.isEvent(BarcodeArFunctionNames.didTapInfoAnnotationEvent)) {
        final payload = BarcodeArInfoAnnotationListenerDidTapInfoAnnotation.fromJson(json);
        final infoAnnotation = _getAnnotationFromPayload<BarcodeArInfoAnnotation>(
            payload.barcodeId, payload.responsiveAnnotationThreshold, payload.responsiveAnnotationType);
        if (infoAnnotation == null) return;

        infoAnnotation.listener?.didTapInfoAnnotation(infoAnnotation);
      } else if (event.isEvent(BarcodeArFunctionNames.didTapInfoAnnotationHeaderEvent)) {
        final payload = BarcodeArInfoAnnotationListenerDidTapInfoAnnotationHeader.fromJson(json);
        final infoAnnotation = _getAnnotationFromPayload<BarcodeArInfoAnnotation>(
            payload.barcodeId, payload.responsiveAnnotationThreshold, payload.responsiveAnnotationType);
        if (infoAnnotation == null) return;

        infoAnnotation.listener?.didTapInfoAnnotationHeader(infoAnnotation);
      } else if (event.isEvent(BarcodeArFunctionNames.didTapInfoAnnotationFooterEvent)) {
        final payload = BarcodeArInfoAnnotationListenerDidTapInfoAnnotationFooter.fromJson(json);
        final infoAnnotation = _getAnnotationFromPayload<BarcodeArInfoAnnotation>(
            payload.barcodeId, payload.responsiveAnnotationThreshold, payload.responsiveAnnotationType);
        if (infoAnnotation == null) return;

        infoAnnotation.listener?.didTapInfoAnnotationFooter(infoAnnotation);
      } else if (event.isEvent(BarcodeArFunctionNames.didCreateBarcodeArCustomHighlight) ||
          event.isEvent(BarcodeArFunctionNames.showBarcodeArCustomHighlight)) {
        _handleCreateOrShowCustomHighlight(json);
      } else if (event.isEvent(BarcodeArFunctionNames.didUpdateBarcodeArCustomHighlight)) {
        _handleUpdateCustomWidget(json, cache: _customHighlightCache);
      } else if (event.isEvent(BarcodeArFunctionNames.didDisposeBarcodeArCustomHighlight) ||
          event.isEvent(BarcodeArFunctionNames.hideBarcodeArCustomHighlight)) {
        _handleDisposeOrHideCustomWidget(json, cache: _customHighlightCache);
      } else if (event.isEvent(BarcodeArFunctionNames.didCreateBarcodeArCustomAnnotation) ||
          event.isEvent(BarcodeArFunctionNames.showBarcodeArCustomAnnotation)) {
        _handleCreateOrShowCustomAnnotation(
          json,
          isShow: event.isEvent(BarcodeArFunctionNames.showBarcodeArCustomAnnotation),
        );
      } else if (event.isEvent(BarcodeArFunctionNames.barcodeArAugmentationsEvicted)) {
        _handleAugmentationsEvicted(json);
      } else if (event.isEvent(BarcodeArFunctionNames.didUpdateBarcodeArCustomAnnotation)) {
        _handleUpdateCustomWidget(json, cache: _customAnnotationCache);
      } else if (event.isEvent(BarcodeArFunctionNames.didDisposeBarcodeArCustomAnnotation) ||
          event.isEvent(BarcodeArFunctionNames.hideBarcodeArCustomAnnotation)) {
        _handleDisposeOrHideCustomAnnotation(
          json,
          isHide: event.isEvent(BarcodeArFunctionNames.hideBarcodeArCustomAnnotation),
        );
      }
    });
  }

  // Builds the response for a highlight/annotation provider request. The native side treats the
  // ABSENCE of the augmentation key as "the provider supplied nothing" and drops the augmentation;
  // a key present with a null value takes the parse path instead and leaves the previously supplied
  // augmentation in place. Omit the key so an augmentation the provider no longer returns is
  // actually cleared.
  Map<String, dynamic> _providerResult(String key, String? barcodeId, Map<String, dynamic>? augmentation) {
    return {
      "barcodeId": barcodeId,
      if (augmentation != null) key: augmentation,
    };
  }

  // An event can come from a top-level annotation or from one nested inside a responsive
  // annotation. `is` checks keep a mismatched cache entry from throwing.
  T? _getAnnotationFromPayload<T extends BarcodeArAnnotation>(
      String barcodeId, double? responsiveAnnotationThreshold, String? responsiveAnnotationType) {
    final cached = _annotationsCache[barcodeId];

    if (responsiveAnnotationThreshold != null) {
      final nested =
          cached is BarcodeArResponsiveAnnotation ? cached.annotationsByThreshold[responsiveAnnotationThreshold] : null;
      return nested is T ? nested : null;
    }

    // Legacy fallback for native builds that only emit responsiveAnnotationType.
    if (responsiveAnnotationType == 'closeUp' || responsiveAnnotationType == 'farAway') {
      if (cached is! BarcodeArResponsiveAnnotation) return null;
      final BarcodeArAnnotation? nested =
          responsiveAnnotationType == 'closeUp' ? cached.closeUpAnnotation : cached.farAwayAnnotation;
      return nested is T ? nested : null;
    }

    return cached is T ? cached : null;
  }

  // Tolerant parsing is limited to the two events that block a native thread for 2000 ms
  // awaiting a reply (didUpdateSession, filterBarcodes): a payload that fails schema
  // validation is logged and passed through unvalidated (the caller re-derives what it needs
  // straight from the raw map) rather than thrown, so the ack still fires promptly instead of
  // surfacing only after the native-side timeout.
  T _parsePayloadTolerantly<T>(
    Map<String, dynamic> raw,
    T Function(Object?) parse,
    T Function(Object?) fallback,
    String event,
  ) {
    try {
      return parse(raw);
    } catch (error) {
      dev.log('BarcodeArView $event payload failed schema validation: $error');
      return fallback(raw);
    }
  }

  void _handleCreateOrShowCustomHighlight(Map<String, dynamic> json) {
    final barcodeId = json['barcodeId'] as String;
    final item = _highlightCache[barcodeId];
    if (item is! BarcodeArCustomHighlight) return;

    _customHighlightCache[barcodeId] = _CustomWidgetOverlay(
      widget: item.child,
      position: Offset.zero,
      anchor: Anchor.center,
      barcodeId: barcodeId,
      type: _CustomWidgetType.highlight,
    );
    _notifyCustomWidgetsChanged();
  }

  // Top-level annotations keep the create/show and dispose/hide pairing; a nested slot is
  // registered hidden on create and only rendered between show and hide.
  void _handleCreateOrShowCustomAnnotation(Map<String, dynamic> json, {required bool isShow}) {
    final barcodeId = json['barcodeId'] as String;
    final threshold = _thresholdOf(json);
    final item = _getAnnotationFromPayload<BarcodeArCustomAnnotation>(barcodeId, threshold, null);
    if (item == null) return;

    final key = _customOverlayKey(barcodeId, threshold);
    final existing = _customAnnotationCache[key];
    if (threshold != null && existing != null) {
      if (!isShow || existing.visible) return;
      _customAnnotationCache[key] = existing.copyWith(visible: true);
    } else {
      final visible = threshold == null || isShow;
      _customAnnotationCache[key] = _CustomWidgetOverlay(
        widget: item.child,
        position: Offset.zero,
        anchor: item.anchor,
        barcodeId: barcodeId,
        type: _CustomWidgetType.annotation,
        threshold: threshold,
        visible: visible,
      );
      if (!visible) return;
    }
    _notifyCustomWidgetsChanged();
  }

  void _handleDisposeOrHideCustomAnnotation(Map<String, dynamic> json, {required bool isHide}) {
    final threshold = _thresholdOf(json);
    final key = _customOverlayKey(json['barcodeId'] as String, threshold);
    if (isHide && threshold != null) {
      final overlay = _customAnnotationCache[key];
      if (overlay == null || !overlay.visible) return;
      _customAnnotationCache[key] = overlay.copyWith(visible: false);
    } else if (_customAnnotationCache.remove(key) == null) {
      return;
    }
    _notifyCustomWidgetsChanged();
  }

  void _handleUpdateCustomWidget(
    Map<String, dynamic> json, {
    required Map<String, _CustomWidgetOverlay> cache,
  }) {
    final updates = json['updates'] as List?;
    if (updates != null) {
      for (var update in updates) {
        _updateSingleWidget(update, cache: cache);
      }
    } else {
      _updateSingleWidget(json, cache: cache);
    }
    _notifyCustomWidgetsChanged();
  }

  void _updateSingleWidget(
    Map<String, dynamic> json, {
    required Map<String, _CustomWidgetOverlay> cache,
  }) {
    final barcodeId = json['barcodeId'] as String;
    final centerPositionJson = json['centerPosition'] as String;
    final centerPosition = Point.fromJSON(jsonDecode(centerPositionJson));
    final key = _customOverlayKey(barcodeId, _thresholdOf(json));
    final overlay = cache[key];
    if (overlay != null) {
      cache[key] = overlay.copyWith(
        position: Offset(centerPosition.x, centerPosition.y),
      );
    }
  }

  // Native evicts a barcode's augmentations once it has really gone (after its own
  // delay-and-cancel grace period) and tells us here, so these caches stay bounded without
  // the script layer re-implementing that policy.
  void _handleAugmentationsEvicted(Map<String, dynamic> json) {
    final barcodeId = BarcodeArAugmentationsEvicted.fromJson(json).barcodeId;

    _highlightCache.remove(barcodeId);
    _annotationsCache.remove(barcodeId);
    // Both removals must run: a barcode can hold a custom highlight and a custom annotation
    // at once, and `||` would short-circuit past the annotation.
    final removedHighlight = _customHighlightCache.remove(barcodeId) != null;
    final removedAnnotation = _customAnnotationCache.values.any((overlay) => overlay.barcodeId == barcodeId);
    _customAnnotationCache.removeWhere((_, overlay) => overlay.barcodeId == barcodeId);
    final hadCustomWidget = removedHighlight || removedAnnotation;
    if (hadCustomWidget) {
      _notifyCustomWidgetsChanged();
    }
  }

  void _handleDisposeOrHideCustomWidget(
    Map<String, dynamic> json, {
    required Map<String, _CustomWidgetOverlay> cache,
  }) {
    final barcodeId = json['barcodeId'] as String;
    cache.remove(barcodeId);
    _notifyCustomWidgetsChanged();
  }

  void _handleDidTapHighlightForBarcode(BarcodeArViewUiListenerDidTapHighlightForBarcode payload) {
    final highlight = _highlightCache[payload.barcodeId];
    if (highlight != null) {
      final barcode = Barcode.fromJSON(jsonDecode(payload.barcode));

      _view.uiListener?.didTapHighlightForBarcode(_view._barcodeAr, barcode, highlight);
    }
  }

  void _handleHighlightTap(String barcodeId) {
    final highlight = _highlightCache[barcodeId];
    if (highlight != null && highlight is BarcodeArCustomHighlight) {
      barcodeMethodHandler.onCustomHighlightClicked(viewId: _view._viewId, barcodeId: barcodeId).onError(onError);
    }
  }

  Future<void> updateView() {
    final viewJson = jsonEncode(_view.toMap()['View']);
    return barcodeMethodHandler.updateBarcodeArView(viewId: _view._viewId, viewJson: viewJson);
  }

  void setUiListener(BarcodeArViewUiListener? listener) {
    if (listener != null) {
      barcodeMethodHandler.registerBarcodeArViewUiListener(viewId: _view._viewId).onError(onError);
    } else {
      barcodeMethodHandler.unregisterBarcodeArViewUiListener(viewId: _view._viewId).onError(onError);
    }
  }

  void setHighlightProvider(BarcodeArHighlightProvider? newValue) {
    if (newValue != null) {
      barcodeMethodHandler.registerBarcodeArHighlightProvider(viewId: _view._viewId).onError(onError);
    } else {
      barcodeMethodHandler.unregisterBarcodeArHighlightProvider(viewId: _view._viewId).onError(onError);
    }
    if (newValue == null) {
      _highlightCache.clear();
      _customHighlightCache.clear();
      _notifyCustomWidgetsChanged();
    }
  }

  void setAnnotationProvider(BarcodeArAnnotationProvider? newValue) {
    if (newValue != null) {
      barcodeMethodHandler.registerBarcodeArAnnotationProvider(viewId: _view._viewId).onError(onError);
    } else {
      barcodeMethodHandler.unregisterBarcodeArAnnotationProvider(viewId: _view._viewId).onError(onError);
    }

    if (newValue == null) {
      _annotationsCache.clear();
      _customAnnotationCache.clear();
      _notifyCustomWidgetsChanged();
    }
  }

  Future<void> setBarcodeFilter(BarcodeArFilter? filter) {
    if (filter != null) {
      return barcodeMethodHandler.registerBarcodeArFilter(viewId: _view._viewId).onError(onError);
    } else {
      return barcodeMethodHandler.unregisterBarcodeArFilter(viewId: _view._viewId).onError(onError);
    }
  }

  // SDC-34107: only reset() and dispose() clear. Native retains its augmentations across
  // stop()/pause() and re-requests providers only for newly tracked barcodes
  // (AugmentationTrackHandler.onSession), so clearing here would leave a highlight on screen
  // with no cache entry and a dead tap. The custom-widget maps alone shrink on dispose/hide.
  void _clearAugmentationCaches() {
    _highlightCache.clear();
    _annotationsCache.clear();
    _customHighlightCache.clear();
    _customAnnotationCache.clear();
    // Without this the overlay keeps rendering widgets that no longer have a cache entry.
    _notifyCustomWidgetsChanged();
  }

  Future<void> start() {
    return barcodeMethodHandler.barcodeArViewStart(viewId: _view._viewId);
  }

  Future<void> stop() {
    return barcodeMethodHandler.barcodeArViewStop(viewId: _view._viewId);
  }

  Future<void> pause() {
    return barcodeMethodHandler.barcodeArViewPause(viewId: _view._viewId);
  }

  Future<void> reset() {
    _clearAugmentationCaches();
    return barcodeMethodHandler.barcodeArViewReset(viewId: _view._viewId);
  }

  @override
  Future<void> updateAnnotation(BarcodeArAnnotation annotation) {
    var updatedAnnotation = annotation;
    final annotationInCache = _annotationsCache[annotation.barcodeId];
    if (annotationInCache is BarcodeArResponsiveAnnotation) {
      updatedAnnotation = annotationInCache;
    }

    return barcodeMethodHandler.updateBarcodeArAnnotation(
        viewId: _view._viewId, annotationJson: jsonEncode(updatedAnnotation.toMap()));
  }

  @override
  Future<void> updateHighlight(BarcodeArHighlight highlight) {
    return barcodeMethodHandler.updateBarcodeArHighlight(
        viewId: _view._viewId, highlightJson: jsonEncode(highlight.toMap()));
  }

  double? _responsiveThresholdOf(BarcodeArAnnotation annotation) {
    final cached = _annotationsCache[annotation.barcodeId];
    if (cached is! BarcodeArResponsiveAnnotation) return null;

    for (final entry in cached.annotationsByThreshold.entries) {
      if (identical(entry.value, annotation)) return entry.key;
    }
    return null;
  }

  @override
  Future<void> updateBarcodeArPopoverButtonAtIndex(BarcodeArPopoverAnnotation annotation, int index) {
    var button = annotation.buttons[index].toMap();
    var updateRequest = {
      'button': button,
      'barcodeId': annotation.barcodeId,
      if (_responsiveThresholdOf(annotation) case final threshold?) 'responsiveAnnotationThreshold': threshold,
    };
    return barcodeMethodHandler.updateBarcodeArPopoverButtonAtIndex(
        viewId: _view._viewId, updateJson: jsonEncode(updateRequest));
  }

  // Mode

  StreamSubscription<dynamic>? _barcodeArSubscription;

  Future<void> applyNewSettings(BarcodeArSettings settings) {
    return barcodeMethodHandler.applyBarcodeArSettings(viewId: _view._viewId, settings: jsonEncode(settings.toMap()));
  }

  Future<void> updateFeedback() {
    return barcodeMethodHandler.updateBarcodeArFeedback(
        viewId: _view._viewId, feedbackJson: jsonEncode(_view._barcodeAr.feedback.toMap()));
  }

  void subscribeModeListeners() {
    if (_barcodeArSubscription != null) return;

    barcodeMethodHandler.registerBarcodeArListener(viewId: _view._viewId).then((value) => _listenForModeEvents());
  }

  StreamSubscription _listenForModeEvents() {
    return _barcodeArSubscription =
        BarcodePluginEvents.barcodeArEventStream.forView(_view._viewId).listen((event) async {
      if (event.isEvent(BarcodeArListener._barcodeArListenerDidUpdateSession)) {
        // Blocks a native thread for 2000 ms on failure to reply: parse tolerantly, and finish
        // in a `finally` so the ack always fires.
        final payload = event.payload;
        try {
          final parsed = _parsePayloadTolerantly<BarcodeArListenerDidUpdateSession?>(
            payload,
            (raw) => BarcodeArListenerDidUpdateSession.fromJson(raw),
            (raw) {
              final map = raw as Map<String, dynamic>;
              if (!map.containsKey('session')) return null;
              return BarcodeArListenerDidUpdateSession(
                session: map['session'] as String,
                frameId: map['frameId'] as String?,
                viewId: map['viewId'] as int,
              );
            },
            'didUpdateSession',
          );
          if (_view._barcodeAr._listeners.isNotEmpty && parsed != null) {
            var session = BarcodeArSession.fromJSON(
                {'session': parsed.session, 'frameId': parsed.frameId, 'viewId': parsed.viewId});
            await _notifyDidUpdateListeners(session);
          }
        } catch (error) {
          dev.log('BarcodeArView didUpdateSession failed: $error');
        } finally {
          barcodeMethodHandler.finishBarcodeArOnDidUpdateSession(viewId: _view._viewId).onError(onError);
        }
      }
    });
  }

  Future<void> _notifyDidUpdateListeners(BarcodeArSession session) async {
    // Iterate backwards to avoid allocation and handle concurrent modifications safely
    // This is called frequently so we avoid creating a copy
    for (var i = _view._barcodeAr._listeners.length - 1; i >= 0; i--) {
      if (i < _view._barcodeAr._listeners.length) {
        await _view._barcodeAr._listeners[i]
            .didUpdateSession(_view._barcodeAr, session, () => _getLastFrameData(session));
      }
    }
  }

  Future<FrameData> _getLastFrameData(BarcodeArSession session) {
    // `frameId` is required-but-nullable on the wire (SDC-33544): the public
    // `BarcodeArListener.didUpdateSession` callback signature stays
    // `Future<FrameData> Function()`, so a missing frame id fails the
    // returned Future explicitly instead of the previous `as String` cast's
    // opaque `TypeError` on a null value.
    final frameId = session.frameId;
    if (frameId == null) {
      return Future.error(
          StateError('BarcodeArSession.frameId is null; no frame data is available for this session update.'));
    }
    return getCoreMethodHandler()
        .getLastFrameOrNullAsMap(frameId: frameId)
        .then((value) => DefaultFrameData.fromJSON(value), onError: onError);
  }

  void unsubscribeModeListeners() {
    _barcodeArSubscription?.cancel();
    barcodeMethodHandler.unregisterBarcodeArListener(viewId: _view._viewId).onError(onError);

    _barcodeArSubscription = null;
  }

  @override
  void dispose() {
    unsubscribeModeListeners();

    _viewEventsSubscription?.cancel();
    _viewEventsSubscription = null;
    _highlightCache.clear();
    _annotationsCache.clear();
    _customHighlightCache.clear();
    _customAnnotationCache.clear();
    _customWidgetsController.close();
    super.dispose();
  }
}

// ignore: experimental_member_use
class _BarcodeArViewState extends State<BarcodeArView> implements CameraOwner {
  final int _viewId = Random().nextInt(0x7FFFFFFF);

  bool _isRouteActive = true;

  @override
  String get id => 'barcode-ar-view-$_viewId';

  _BarcodeArViewState();

  @override
  void initState() {
    super.initState();
    widget._viewId = _viewId;
    widget._controller = _BarcodeArViewController(widget);
    widget._barcodeAr._controller = widget._controller;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkRouteStatus();
  }

  void _checkRouteStatus() {
    final route = ModalRoute.of(context);
    final wasActive = _isRouteActive;
    _isRouteActive = route?.isCurrent == true;

    if (wasActive != _isRouteActive) {
      if (_isRouteActive) {
        // ignore: experimental_member_use
        CameraOwnershipHelper.requestOwnership(CameraPosition.worldFacing, this);
      } else {
        // ignore: experimental_member_use
        CameraOwnershipHelper.releaseOwnership(CameraPosition.worldFacing, this);
      }
    }
  }

  Widget _buildPlatformView() {
    const viewType = 'com.scandit.BarcodeArView';

    if (Platform.isAndroid) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          var view = PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: {'BarcodeArView': jsonEncode(widget.toMap())},
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
          widget._isInitialized = true;
          return view;
        },
      );
    } else {
      return UiKitView(
        viewType: viewType,
        creationParams: {'BarcodeArView': jsonEncode(widget.toMap())},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          widget._isInitialized = true;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final platformView = _buildPlatformView();

    return Stack(
      children: [
        platformView,
        StreamBuilder<List<_CustomWidgetOverlay>>(
          stream: widget._controller?.customWidgetsStream,
          initialData: const [],
          builder: (context, snapshot) {
            final customWidgets = snapshot.data ?? [];
            if (customWidgets.isEmpty) {
              return const SizedBox.shrink();
            }

            return Stack(
              children: customWidgets.map((overlay) {
                final child = FractionalTranslation(
                  translation: _getTranslationFromAnchor(overlay.anchor),
                  child: overlay.widget,
                );

                final key = ValueKey('${overlay.type.name}_${overlay.cacheKey}');

                return Positioned(
                  key: key,
                  left: overlay.position.dx,
                  top: overlay.position.dy,
                  child: overlay.requiresClickHandling
                      ? GestureDetector(
                          onTap: () => widget._controller?._handleHighlightTap(overlay.barcodeId),
                          child: child,
                        )
                      : child,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Offset _getTranslationFromAnchor(Anchor anchor) {
    // The position from native is the CENTER of the barcode.
    // The anchor describes where the widget appears RELATIVE TO the barcode.
    // For topLeft: widget appears above and to the left (bottom-right corner of widget touches top-left of barcode center)
    // FractionalTranslation: positive offset moves RIGHT/DOWN, negative moves LEFT/UP.
    // Additional offset of 0.1 (10% of widget size) for spacing on edges.
    const edgeOffset = 0.1;

    switch (anchor) {
      case Anchor.topLeft:
        // Widget bottom-right at barcode center (widget is top-left of barcode)
        return const Offset(-1 - edgeOffset, -1 - edgeOffset);
      case Anchor.topCenter:
        // Widget bottom-center at barcode center (widget is above barcode)
        return const Offset(-0.5, -1 - edgeOffset);
      case Anchor.topRight:
        // Widget bottom-left at barcode center (widget is top-right of barcode)
        return const Offset(edgeOffset, -1 - edgeOffset);
      case Anchor.centerLeft:
        // Widget center-right at barcode center (widget is to the left of barcode)
        return const Offset(-1 - edgeOffset, -0.5);
      case Anchor.center:
        // Widget center at barcode center (widget is centered on barcode)
        return const Offset(-0.5, -0.5);
      case Anchor.centerRight:
        // Widget center-left at barcode center (widget is to the right of barcode)
        return const Offset(edgeOffset, -0.5);
      case Anchor.bottomLeft:
        // Widget top-right at barcode center (widget is bottom-left of barcode)
        return const Offset(-1 - edgeOffset, edgeOffset);
      case Anchor.bottomCenter:
        // Widget top-center at barcode center (widget is below barcode)
        return const Offset(-0.5, edgeOffset);
      case Anchor.bottomRight:
        // Widget top-left at barcode center (widget is bottom-right of barcode)
        return const Offset(edgeOffset, edgeOffset);
    }
  }

  @override
  void dispose() {
    widget._controller?.dispose();
    super.dispose();
  }
}

/// One entry of a `BarcodeArFilter.filterBarcodes` payload, as recovered by either arm of the
/// tolerant parse: the strict arm fills it from the generated item type, the fallback arm from a
/// raw map. Both fields are nullable because the fallback tolerates a missing or non-String value.
class _FilterBarcodeEntry {
  const _FilterBarcodeEntry(this.barcodeId, this.barcode);

  final String? barcodeId;
  final String? barcode;
}
