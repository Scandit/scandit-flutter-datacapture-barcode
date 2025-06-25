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
import 'barcode_ar.dart';
import 'barcode_ar_annotation.dart';
import 'barcode_ar_annotation_provider.dart';
import 'barcode_ar_common.dart';
import 'barcode_ar_defaults.dart';
import 'barcode_ar_function_names.dart';
import 'barcode_ar_highlight.dart';
import 'barcode_ar_highlight_provider.dart';
import 'barcode_ar_view_settings.dart';

abstract class BarcodeArViewUiListener {
  static const String _barcodeArViewUiListenerDidTapHighlight = 'BarcodeArViewUiListener.didTapHighlightForBarcode';

  void didTapHighlightForBarcode(BarcodeAr barcodeAr, Barcode barcode, BarcodeArHighlight highlight);
}

// ignore: must_be_immutable
class BarcodeArView extends StatefulWidget implements Serializable {
  late _BarcodeArViewController _controller;
  // We require that to exist doesn't mean it must be used here.
  // ignore: unused_field
  final DataCaptureContext _dataCaptureContext;
  final BarcodeAr _barcodeAr;
  final BarcodeArViewSettings? _barcodeArViewSettings;
  final CameraSettings? _cameraSettings;

  bool _isInitialized = false;

  BarcodeArView._(this._dataCaptureContext, this._barcodeAr, this._barcodeArViewSettings, this._cameraSettings)
      : super() {
    _controller = _BarcodeArViewController(this);
  }

  factory BarcodeArView.forMode(DataCaptureContext dataCaptureContext, BarcodeAr barcodeAr) {
    return BarcodeArView._(dataCaptureContext, barcodeAr, null, null);
  }

  factory BarcodeArView.forModeWithViewSettings(
      DataCaptureContext dataCaptureContext, BarcodeAr barcodeAr, BarcodeArViewSettings viewSettings) {
    return BarcodeArView._(dataCaptureContext, barcodeAr, viewSettings, null);
  }

  factory BarcodeArView.forModeWithViewSettingsAndCameraSettings(DataCaptureContext dataCaptureContext,
      BarcodeAr barcodeAr, BarcodeArViewSettings viewSettings, CameraSettings cameraSettings) {
    return BarcodeArView._(dataCaptureContext, barcodeAr, viewSettings, cameraSettings);
  }

  BarcodeArViewUiListener? _viewUIListener;

  BarcodeArViewUiListener? get uiListener => _viewUIListener;

  set uiListener(BarcodeArViewUiListener? newValue) {
    _viewUIListener = newValue;
    _controller.setUiListener(newValue);
  }

  BarcodeArHighlightProvider? _highlightProvider;

  BarcodeArHighlightProvider? get highlightProvider => _highlightProvider;

  set highlightProvider(BarcodeArHighlightProvider? newValue) {
    _highlightProvider = newValue;
    _controller.setHighlightProvider(newValue);
  }

  BarcodeArAnnotationProvider? _annotationProvider;

  BarcodeArAnnotationProvider? get annotationProvider => _annotationProvider;

  set annotationProvider(BarcodeArAnnotationProvider? newValue) {
    _annotationProvider = newValue;
    _controller.setAnnotationProvider(newValue);
  }

  bool _shouldShowTorchControl = BarcodeArDefaults.view.defaultShouldShowTorchControl;

  bool get shouldShowTorchControl => _shouldShowTorchControl;

  set shouldShowTorchControl(bool newValue) {
    _shouldShowTorchControl = newValue;
    _updateNative();
  }

  Anchor _torchControlPosition = BarcodeArDefaults.view.defaultTorchControlPosition;

  Anchor get torchControlPosition => _torchControlPosition;

  set torchControlPosition(Anchor newValue) {
    _torchControlPosition = newValue;
    _updateNative();
  }

  bool _shouldShowZoomControl = BarcodeArDefaults.view.defaultShouldShowZoomControl;

  bool get shouldShowZoomControl => _shouldShowZoomControl;

  set shouldShowZoomControl(bool newValue) {
    _shouldShowZoomControl = newValue;
    _updateNative();
  }

  Anchor _zoomControlPosition = BarcodeArDefaults.view.defaultZoomControlPosition;

  Anchor get zoomControlPosition => _zoomControlPosition;

  set zoomControlPosition(Anchor newValue) {
    _zoomControlPosition = newValue;
    _updateNative();
  }

  bool _shouldShowCameraSwitchControl = BarcodeArDefaults.view.defaultShouldShowCameraSwitchControl;

  bool get shouldShowCameraSwitchControl => _shouldShowCameraSwitchControl;

  set shouldShowCameraSwitchControl(bool newValue) {
    _shouldShowCameraSwitchControl = newValue;
    _updateNative();
  }

  Anchor _cameraSwitchControlPosition = BarcodeArDefaults.view.defaultCameraSwitchControlPosition;

  Anchor get cameraSwitchControlPosition => _cameraSwitchControlPosition;

  set cameraSwitchControlPosition(Anchor newValue) {
    _cameraSwitchControlPosition = newValue;
    _updateNative();
  }

  bool _shouldShowMacroModeControl = BarcodeArDefaults.view.defaultShouldShowMacroModeControl;

  bool get shouldShowMacroModeControl => _shouldShowMacroModeControl;

  set shouldShowMacroModeControl(bool newValue) {
    _shouldShowMacroModeControl = newValue;
    _updateNative();
  }

  Anchor _macroModeControlPosition = BarcodeArDefaults.view.defaultMacroModeControlPosition;

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

  Future<void> reset() {
    return _controller.reset();
  }

  @override
  State<StatefulWidget> createState() {
    return _BarcodeArViewState();
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
        'viewSettings': _barcodeArViewSettings?.toMap(),
        'cameraSettings': _cameraSettings?.toMap()
      },
      'BarcodeAr': _barcodeAr.toMap()
    };
  }
}

class _BarcodeArViewController implements BarcodeArViewController {
  final MethodChannel _methodChannel = const MethodChannel(BarcodeArFunctionNames.methodsChannelName);

  final Map<String, BarcodeArHighlight> _highlightCache = {};

  final Map<String, BarcodeArAnnotation> _annotationsCache = {};

  StreamSubscription<dynamic>? _viewEventsSubscription;

  final BarcodeArView _view;

  _BarcodeArViewController(this._view) {
    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    _viewEventsSubscription = BarcodePluginEvents.barcodeArEventStream.listen((event) async {
      var json = jsonDecode(event);
      var eventName = json['event'] as String;
      switch (eventName) {
        case BarcodeArViewUiListener._barcodeArViewUiListenerDidTapHighlight:
          _handleDidTapHighlightForBarcode(json);
          break;

        case BarcodeArFunctionNames.highlightForBarcodeEvent:
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

          _methodChannel.invokeMethod(BarcodeArFunctionNames.finishHighlightForBarcode, jsonEncode(result));
          break;
        case BarcodeArFunctionNames.annotationForBarcodeEvent:
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

          _methodChannel.invokeMethod(BarcodeArFunctionNames.finishAnnotationForBarcode, jsonEncode(result));
          break;

        case BarcodeArFunctionNames.didTapPopoverEvent:
          final barcodeId = json['barcodeId'] as String;

          final popover = _annotationsCache[barcodeId] as BarcodeArPopoverAnnotation?;
          if (popover == null) return;

          popover.listener?.didTapPopover(popover);
          break;
        case BarcodeArFunctionNames.didTapPopoverButtonEvent:
          final barcodeId = json['barcodeId'] as String;

          final popover = _annotationsCache[barcodeId] as BarcodeArPopoverAnnotation?;
          if (popover == null) return;
          final buttonIndex = json['buttonIndex'] as int;

          final button = popover.buttons[buttonIndex];

          popover.listener?.didTapPopoverButton(popover, button, buttonIndex);
          break;
        case BarcodeArFunctionNames.didTapInfoAnnotationRightIconEvent:
          final barcodeId = json['barcodeId'] as String;

          final infoAnnotation = _annotationsCache[barcodeId] as BarcodeArInfoAnnotation?;
          if (infoAnnotation == null) return;
          final componentIndex = json['componentIndex'] as int;

          infoAnnotation.listener?.didTapInfoAnnotationRightIcon(infoAnnotation, componentIndex);
          break;
        case BarcodeArFunctionNames.didTapInfoAnnotationLeftIconEvent:
          final barcodeId = json['barcodeId'] as String;

          final infoAnnotation = _annotationsCache[barcodeId] as BarcodeArInfoAnnotation?;
          if (infoAnnotation == null) return;
          final componentIndex = json['componentIndex'] as int;

          infoAnnotation.listener?.didTapInfoAnnotationLeftIcon(infoAnnotation, componentIndex);
          break;
        case BarcodeArFunctionNames.didTapInfoAnnotationEvent:
          final barcodeId = json['barcodeId'] as String;

          final infoAnnotation = _annotationsCache[barcodeId] as BarcodeArInfoAnnotation?;
          if (infoAnnotation == null) return;

          infoAnnotation.listener?.didTapInfoAnnotation(infoAnnotation);
          break;
        case BarcodeArFunctionNames.didTapInfoAnnotationHeaderEvent:
          final barcodeId = json['barcodeId'] as String;

          final infoAnnotation = _annotationsCache[barcodeId] as BarcodeArInfoAnnotation?;
          if (infoAnnotation == null) return;

          infoAnnotation.listener?.didTapInfoAnnotationHeader(infoAnnotation);
          break;
        case BarcodeArFunctionNames.didTapInfoAnnotationFooterEvent:
          final barcodeId = json['barcodeId'] as String;

          final infoAnnotation = _annotationsCache[barcodeId] as BarcodeArInfoAnnotation?;
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

      _view.uiListener?.didTapHighlightForBarcode(_view._barcodeAr, barcode, highlight);
    }
  }

  Future<void> updateView() {
    final viewJson = jsonEncode(_view.toMap()['View']);
    return _methodChannel.invokeMethod(BarcodeArFunctionNames.updateView, viewJson);
  }

  void setUiListener(BarcodeArViewUiListener? listener) {
    var methodToInvoke = listener != null
        ? BarcodeArFunctionNames.registerBarcodeArViewUiListener
        : BarcodeArFunctionNames.unregisterBarcodeArViewUiListener;

    _methodChannel.invokeMethod(methodToInvoke).then((value) => null, onError: _onError);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }

  void setHighlightProvider(BarcodeArHighlightProvider? newValue) {
    var methodToInvoke = newValue != null
        ? BarcodeArFunctionNames.registerBarcodeArHighlightProvider
        : BarcodeArFunctionNames.unregisterBarcodeArHighlightProvider;

    if (newValue == null) {
      _highlightCache.clear();
    }

    _methodChannel.invokeMethod(methodToInvoke).then((value) => null, onError: _onError);
  }

  void setAnnotationProvider(BarcodeArAnnotationProvider? newValue) {
    var methodToInvoke = newValue != null
        ? BarcodeArFunctionNames.registerBarcodeArAnnotationProvider
        : BarcodeArFunctionNames.unregisterBarcodeArAnnotationProvider;

    if (newValue == null) {
      _annotationsCache.clear();
    }

    _methodChannel.invokeMethod(methodToInvoke).then((value) => null, onError: _onError);
  }

  Future<void> start() {
    return _methodChannel.invokeMethod(BarcodeArFunctionNames.viewStart);
  }

  Future<void> stop() {
    _highlightCache.clear();
    _annotationsCache.clear();
    return _methodChannel.invokeMethod(BarcodeArFunctionNames.viewStop);
  }

  Future<void> pause() {
    _highlightCache.clear();
    _annotationsCache.clear();
    return _methodChannel.invokeMethod(BarcodeArFunctionNames.viewPause);
  }

  Future<void> reset() {
    _highlightCache.clear();
    _annotationsCache.clear();
    return _methodChannel.invokeMethod(BarcodeArFunctionNames.viewReset);
  }

  @override
  Future<void> updateAnnotation(BarcodeArAnnotation annotation) {
    return _methodChannel.invokeMethod(BarcodeArFunctionNames.updateAnnotation, jsonEncode(annotation.toMap()));
  }

  @override
  Future<void> updateHighlight(BarcodeArHighlight highlight) {
    return _methodChannel.invokeMethod(BarcodeArFunctionNames.updateHighlight, jsonEncode(highlight.toMap()));
  }

  @override
  Future<void> updateBarcodeArPopoverButtonAtIndex(BarcodeArPopoverAnnotation annotation, int index) {
    var button = annotation.buttons[index].toMap();
    var updateQequest = {
      'button': button,
      'barcodeId': annotation.barcodeId,
    };
    return _methodChannel.invokeMethod(
        BarcodeArFunctionNames.updateBarcodeArPopoverButtonAtIndex, jsonEncode(updateQequest));
  }

  void dispose() {
    _viewEventsSubscription?.cancel();
    _viewEventsSubscription = null;
    _highlightCache.clear();
    _annotationsCache.clear();
  }
}

class _BarcodeArViewState extends State<BarcodeArView> {
  _BarcodeArViewState();

  @override
  Widget build(BuildContext context) {
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
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }
}
