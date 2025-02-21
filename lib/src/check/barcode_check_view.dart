/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode.dart';
import 'barcode_check.dart';
import 'barcode_check_annotation.dart';
import 'barcode_check_annotation_provider.dart';
import 'barcode_check_common.dart';
import 'barcode_check_defaults.dart';
import 'barcode_check_function_names.dart';
import 'barcode_check_highlight.dart';
import 'barcode_check_highlight_provider.dart';
import 'barcode_check_view_settings.dart';

abstract class BarcodeCheckViewUiListener {
  static const String _barcodeCheckViewUiListenerDidTapHighlight =
      'BarcodeCheckViewUiListener.didTapHighlightForBarcode';

  void didTapHighlightForBarcode(BarcodeCheck barcodeCheck, Barcode barcode, BarcodeCheckHighlight highlight);
}

// ignore: must_be_immutable
class BarcodeCheckView extends StatefulWidget implements Serializable {
  late _BarcodeCheckViewController _controller;
  // We require that to exist doesn't mean it must be used here.
  // ignore: unused_field
  final DataCaptureContext _dataCaptureContext;
  final BarcodeCheck _barcodeCheck;
  final BarcodeCheckViewSettings? _barcodeCheckViewSettings;
  final CameraSettings? _cameraSettings;

  bool _isInitialized = false;

  BarcodeCheckView._(this._dataCaptureContext, this._barcodeCheck, this._barcodeCheckViewSettings, this._cameraSettings)
      : super() {
    _controller = _BarcodeCheckViewController(this);
  }

  factory BarcodeCheckView.forMode(DataCaptureContext dataCaptureContext, BarcodeCheck barcodeCheck) {
    return BarcodeCheckView._(dataCaptureContext, barcodeCheck, null, null);
  }

  factory BarcodeCheckView.forModeWithViewSettings(
      DataCaptureContext dataCaptureContext, BarcodeCheck barcodeCheck, BarcodeCheckViewSettings viewSettings) {
    return BarcodeCheckView._(dataCaptureContext, barcodeCheck, viewSettings, null);
  }

  factory BarcodeCheckView.forModeWithViewSettingsAndCameraSettings(DataCaptureContext dataCaptureContext,
      BarcodeCheck barcodeCheck, BarcodeCheckViewSettings viewSettings, CameraSettings cameraSettings) {
    return BarcodeCheckView._(dataCaptureContext, barcodeCheck, viewSettings, cameraSettings);
  }

  BarcodeCheckViewUiListener? _viewUIListener;

  BarcodeCheckViewUiListener? get uiListener => _viewUIListener;

  set uiListener(BarcodeCheckViewUiListener? newValue) {
    _viewUIListener = newValue;
    _controller.setUiListener(newValue);
  }

  BarcodeCheckHighlightProvider? _highlightProvider;

  BarcodeCheckHighlightProvider? get highlightProvider => _highlightProvider;

  set highlightProvider(BarcodeCheckHighlightProvider? newValue) {
    _highlightProvider = newValue;
    _controller.setHighlightProvider(newValue);
  }

  BarcodeCheckAnnotationProvider? _annotationProvider;

  BarcodeCheckAnnotationProvider? get annotationProvider => _annotationProvider;

  set annotationProvider(BarcodeCheckAnnotationProvider? newValue) {
    _annotationProvider = newValue;
    _controller.setAnnotationProvider(newValue);
  }

  bool _shouldShowTorchControl = BarcodeCheckDefaults.view.defaultShouldShowTorchControl;

  bool get shouldShowTorchControl => _shouldShowTorchControl;

  set shouldShowTorchControl(bool newValue) {
    _shouldShowTorchControl = newValue;
    _updateNative();
  }

  Anchor _torchControlPosition = BarcodeCheckDefaults.view.defaultTorchControlPosition;

  Anchor get torchControlPosition => _torchControlPosition;

  set torchControlPosition(Anchor newValue) {
    _torchControlPosition = newValue;
    _updateNative();
  }

  bool _shouldShowZoomControl = BarcodeCheckDefaults.view.defaultShouldShowZoomControl;

  bool get shouldShowZoomControl => _shouldShowZoomControl;

  set shouldShowZoomControl(bool newValue) {
    _shouldShowZoomControl = newValue;
    _updateNative();
  }

  Anchor _zoomControlPosition = BarcodeCheckDefaults.view.defaultZoomControlPosition;

  Anchor get zoomControlPosition => _zoomControlPosition;

  set zoomControlPosition(Anchor newValue) {
    _zoomControlPosition = newValue;
    _updateNative();
  }

  bool _shouldShowCameraSwitchControl = BarcodeCheckDefaults.view.defaultShouldShowCameraSwitchControl;

  bool get shouldShowCameraSwitchControl => _shouldShowCameraSwitchControl;

  set shouldShowCameraSwitchControl(bool newValue) {
    _shouldShowCameraSwitchControl = newValue;
    _updateNative();
  }

  Anchor _cameraSwitchControlPosition = BarcodeCheckDefaults.view.defaultCameraSwitchControlPosition;

  Anchor get cameraSwitchControlPosition => _cameraSwitchControlPosition;

  set cameraSwitchControlPosition(Anchor newValue) {
    _cameraSwitchControlPosition = newValue;
    _updateNative();
  }

  bool _shouldShowMacroModeControl = BarcodeCheckDefaults.view.defaultShouldShowMacroModeControl;

  bool get shouldShowMacroModeControl => _shouldShowMacroModeControl;

  set shouldShowMacroModeControl(bool newValue) {
    _shouldShowMacroModeControl = newValue;
    _updateNative();
  }

  Anchor _macroModeControlPosition = BarcodeCheckDefaults.view.defaultMacroModeControlPosition;

  Anchor get macroModeControlPosition => _macroModeControlPosition;

  set macroModeControlPosition(Anchor newValue) {
    _macroModeControlPosition = newValue;
    _updateNative();
  }

  bool _isStarted = true;

  Future<void> start() {
    _isStarted = true;
    return _controller.start();
  }

  Future<void> stop() {
    _isStarted = false;
    return _controller.stop();
  }

  Future<void> pause() {
    _isStarted = false;
    return _controller.pause();
  }

  @override
  State<StatefulWidget> createState() {
    return _BarcodeCheckViewState();
  }

  Future<void> _updateNative() {
    if (!_isInitialized) {
      return Future.value();
    }
    return _controller.updateView();
  }

  @override
  Map<String, dynamic> toMap() {
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
        'isStarted': _isStarted,
        'hasUiListener': uiListener != null,
        'hasHighlightProvider': highlightProvider != null,
        'hasAnnotationProvider': annotationProvider != null,
        'viewSettings': _barcodeCheckViewSettings?.toMap(),
        'cameraSettings': _cameraSettings?.toMap()
      },
      'BarcodeCheck': _barcodeCheck.toMap()
    };
  }
}

class _BarcodeCheckViewController implements BarcodeCheckViewController {
  final MethodChannel _methodChannel = const MethodChannel(BarcodeCheckFunctionNames.methodsChannelName);

  final Map<String, BarcodeCheckHighlight> _highlightCache = {};

  final Map<String, BarcodeCheckAnnotation> _annotationsCache = {};

  StreamSubscription<dynamic>? _viewEventsSubscription;

  final BarcodeCheckView _view;

  _BarcodeCheckViewController(this._view) {
    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    _viewEventsSubscription = BarcodePluginEvents.barcodeCheckEventStream.listen((event) async {
      var json = jsonDecode(event);
      var eventName = json['event'] as String;
      switch (eventName) {
        case BarcodeCheckViewUiListener._barcodeCheckViewUiListenerDidTapHighlight:
          _handleDidTapHighlightForBarcode(json);
          break;

        case BarcodeCheckFunctionNames.highlightForBarcodeEvent:
          final barcodeId = json['barcodeId'] as String;
          final barcode = Barcode.fromJSON(jsonDecode(json['barcode']));
          final highlight = await _view.highlightProvider?.highlightForBarcode(barcode);

          if (highlight != null) {
            highlight.barcodeId = barcodeId;
            highlight.controller = this;
            // Store in cache
            _highlightCache[highlight.barcodeId] = highlight;
          }

          var result = {"barcodeId": barcodeId, "highlight": highlight?.toMap()};

          _methodChannel.invokeMethod(BarcodeCheckFunctionNames.finishHighlightForBarcode, jsonEncode(result));
          break;
        case BarcodeCheckFunctionNames.annotationForBarcodeEvent:
          final barcodeId = json['barcodeId'] as String;
          final barcode = Barcode.fromJSON(jsonDecode(json['barcode']));
          final annotation = await _view.annotationProvider?.annotationForBarcode(barcode);

          if (annotation != null) {
            annotation.barcodeId = barcodeId;
            annotation.controller = this;
            // Store in cache
            _annotationsCache[annotation.barcodeId] = annotation;
          }

          var result = {"barcodeId": barcodeId, "annotation": annotation?.toMap()};

          _methodChannel.invokeMethod(BarcodeCheckFunctionNames.finishAnnotationForBarcode, jsonEncode(result));
          break;

        case BarcodeCheckFunctionNames.didTapPopoverEvent:
          final barcodeId = json['barcodeId'] as String;

          final popover = _annotationsCache[barcodeId] as BarcodeCheckPopoverAnnotation?;
          if (popover == null) return;

          popover.listener?.didTapPopover(popover);
          break;
        case BarcodeCheckFunctionNames.didTapPopoverButtonEvent:
          final barcodeId = json['barcodeId'] as String;

          final popover = _annotationsCache[barcodeId] as BarcodeCheckPopoverAnnotation?;
          if (popover == null) return;
          final buttonIndex = json['buttonIndex'] as int;

          final button = popover.buttons[buttonIndex];

          popover.listener?.didTapPopoverButton(popover, button, buttonIndex);
          break;
        case BarcodeCheckFunctionNames.didTapInfoAnnotationRightIconEvent:
          final barcodeId = json['barcodeId'] as String;

          final infoAnnotation = _annotationsCache[barcodeId] as BarcodeCheckInfoAnnotation?;
          if (infoAnnotation == null) return;
          final componentIndex = json['componentIndex'] as int;

          infoAnnotation.listener?.didTapInfoAnnotationRightIcon(infoAnnotation, componentIndex);
          break;
        case BarcodeCheckFunctionNames.didTapInfoAnnotationLeftIconEvent:
          final barcodeId = json['barcodeId'] as String;

          final infoAnnotation = _annotationsCache[barcodeId] as BarcodeCheckInfoAnnotation?;
          if (infoAnnotation == null) return;
          final componentIndex = json['componentIndex'] as int;

          infoAnnotation.listener?.didTapInfoAnnotationLeftIcon(infoAnnotation, componentIndex);
          break;
        case BarcodeCheckFunctionNames.didTapInfoAnnotationEvent:
          final barcodeId = json['barcodeId'] as String;

          final infoAnnotation = _annotationsCache[barcodeId] as BarcodeCheckInfoAnnotation?;
          if (infoAnnotation == null) return;

          infoAnnotation.listener?.didTapInfoAnnotation(infoAnnotation);
          break;
        case BarcodeCheckFunctionNames.didTapInfoAnnotationHeaderEvent:
          final barcodeId = json['barcodeId'] as String;

          final infoAnnotation = _annotationsCache[barcodeId] as BarcodeCheckInfoAnnotation?;
          if (infoAnnotation == null) return;

          infoAnnotation.listener?.didTapInfoAnnotationHeader(infoAnnotation);
          break;
        case BarcodeCheckFunctionNames.didTapInfoAnnotationFooterEvent:
          final barcodeId = json['barcodeId'] as String;

          final infoAnnotation = _annotationsCache[barcodeId] as BarcodeCheckInfoAnnotation?;
          if (infoAnnotation == null) return;

          infoAnnotation.listener?.didTapInfoAnnotationFooter(infoAnnotation);
          break;
      }
    });
  }

  void _handleDidTapHighlightForBarcode(Map<String, dynamic> json) {
    final barcodeId = json['barcodeId'];
    final highlight = _highlightCache[barcodeId];
    if (highlight != null) {
      final barcode = Barcode.fromJSON(jsonDecode(json['barcode']));

      _view.uiListener?.didTapHighlightForBarcode(_view._barcodeCheck, barcode, highlight);
    }
  }

  Future<void> updateView() {
    final viewJson = jsonEncode(_view.toMap()['View']);
    return _methodChannel.invokeMethod(BarcodeCheckFunctionNames.updateView, viewJson);
  }

  void setUiListener(BarcodeCheckViewUiListener? listener) {
    var methodToInvoke = listener != null
        ? BarcodeCheckFunctionNames.registerBarcodeCheckViewUiListener
        : BarcodeCheckFunctionNames.unregisterBarcodeCheckViewUiListener;

    _methodChannel.invokeMethod(methodToInvoke).then((value) => null, onError: _onError);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }

  void setHighlightProvider(BarcodeCheckHighlightProvider? newValue) {
    var methodToInvoke = newValue != null
        ? BarcodeCheckFunctionNames.registerBarcodeCheckHighlightProvider
        : BarcodeCheckFunctionNames.unregisterBarcodeCheckHighlightProvider;

    if (newValue == null) {
      _highlightCache.clear();
    }

    _methodChannel.invokeMethod(methodToInvoke).then((value) => null, onError: _onError);
  }

  void setAnnotationProvider(BarcodeCheckAnnotationProvider? newValue) {
    var methodToInvoke = newValue != null
        ? BarcodeCheckFunctionNames.registerBarcodeCheckAnnotationProvider
        : BarcodeCheckFunctionNames.unregisterBarcodeCheckAnnotationProvider;

    if (newValue == null) {
      _annotationsCache.clear();
    }

    _methodChannel.invokeMethod(methodToInvoke).then((value) => null, onError: _onError);
  }

  Future<void> start() {
    return _methodChannel.invokeMethod(BarcodeCheckFunctionNames.viewStart);
  }

  Future<void> stop() {
    _highlightCache.clear();
    _annotationsCache.clear();
    return _methodChannel.invokeMethod(BarcodeCheckFunctionNames.viewStop);
  }

  Future<void> pause() {
    _highlightCache.clear();
    _annotationsCache.clear();
    return _methodChannel.invokeMethod(BarcodeCheckFunctionNames.viewPause);
  }

  @override
  Future<void> updateAnnotation(BarcodeCheckAnnotation annotation) {
    return _methodChannel.invokeMethod(BarcodeCheckFunctionNames.updateAnnotation, jsonEncode(annotation.toMap()));
  }

  @override
  Future<void> updateHighlight(BarcodeCheckHighlight highlight) {
    return _methodChannel.invokeMethod(BarcodeCheckFunctionNames.updateHighlight, jsonEncode(highlight.toMap()));
  }

  @override
  Future<void> updateBarcodeCheckPopoverButtonAtIndex(BarcodeCheckPopoverAnnotation annotation, int index) {
    var button = annotation.buttons[index].toMap();
    var updateQequest = {
      'button': button,
      'barcodeId': annotation.barcodeId,
    };
    return _methodChannel.invokeMethod(
        BarcodeCheckFunctionNames.updateBarcodeCheckPopoverButtonAtIndex, jsonEncode(updateQequest));
  }

  void dispose() {
    _viewEventsSubscription?.cancel();
    _viewEventsSubscription = null;
    _highlightCache.clear();
    _annotationsCache.clear();
  }
}

class _BarcodeCheckViewState extends State<BarcodeCheckView> {
  _BarcodeCheckViewState();

  @override
  Widget build(BuildContext context) {
    const viewType = 'com.scandit.BarcodeCheckView';

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
            creationParams: {'BarcodeCheckView': jsonEncode(widget.toMap())},
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
        creationParams: {'BarcodeCheckView': jsonEncode(widget.toMap())},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          widget._isInitialized = true;
        },
      );
    }
  }

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }
}
