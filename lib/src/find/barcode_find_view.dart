/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_function_names.dart';

import '../barcode_plugin_events.dart';
import 'barcode_find.dart';
import 'barcode_find_item.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_find_view_settings.dart';

abstract class BarcodeFindViewUiListener {
  static const String _onFinishButtonTappedEventName = 'BarcodeFindViewUiListener.onFinishButtonTapped';

  void didTapFinishButton(Set<BarcodeFindItem> foundItems);
}

// ignore: must_be_immutable
class BarcodeFindView extends StatefulWidget implements Serializable {
  // We require that to exist doesn't mean it must be used here.
  // ignore: unused_field
  final DataCaptureContext _dataCaptureContext;
  final BarcodeFind _barcodeFind;
  final BarcodeFindViewSettings? _barcodeFindViewSettings;
  final CameraSettings? _cameraSettings;
  var _startSearching = false;

  late _BarcodeFindViewController _controller;

  bool _isInitialized = false;

  BarcodeFindView._(this._dataCaptureContext, this._barcodeFind, this._barcodeFindViewSettings, this._cameraSettings)
      : super() {
    _controller = _BarcodeFindViewController(this);
  }

  factory BarcodeFindView.forMode(DataCaptureContext dataCaptureContext, BarcodeFind barcodeFind) {
    return BarcodeFindView._(dataCaptureContext, barcodeFind, null, null);
  }

  factory BarcodeFindView.forModeWithViewSettings(
      DataCaptureContext dataCaptureContext, BarcodeFind barcodeFind, BarcodeFindViewSettings viewSettings) {
    return BarcodeFindView._(dataCaptureContext, barcodeFind, viewSettings, null);
  }

  factory BarcodeFindView.forModeWithViewSettingsAndCameraSettings(DataCaptureContext dataCaptureContext,
      BarcodeFind barcodeFind, BarcodeFindViewSettings viewSettings, CameraSettings cameraSettings) {
    return BarcodeFindView._(dataCaptureContext, barcodeFind, viewSettings, cameraSettings);
  }

  @override
  State<StatefulWidget> createState() => _BarcodeFindViewState();

  Future<void> widgetPaused() {
    return _controller.widgetPaused();
  }

  Future<void> widgetResumed() {
    return _controller.widgetResumed();
  }

  Future<void> stopSearching() {
    _startSearching = false;
    return _controller.stopSearching();
  }

  Future<void> startSearching() {
    _startSearching = true;
    return _controller.startSearching();
  }

  Future<void> pauseSearching() {
    _startSearching = false;
    return _controller.pauseSearching();
  }

  BarcodeFindViewUiListener? _barcodeFindViewUiListener;

  BarcodeFindViewUiListener? get uiListener => _barcodeFindViewUiListener;

  set uiListener(BarcodeFindViewUiListener? newValue) {
    _barcodeFindViewUiListener = newValue;
    _controller.setUiListener(newValue);
  }

  bool _shouldShowUserGuidanceView = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowUserGuidanceView;

  bool get shouldShowUserGuidanceView => _shouldShowUserGuidanceView;

  set shouldShowUserGuidanceView(bool newValue) {
    _shouldShowUserGuidanceView = newValue;
    _updateNative();
  }

  bool _shouldShowHints = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowHints;

  bool get shouldShowHints => _shouldShowHints;

  set shouldShowHints(bool newValue) {
    _shouldShowHints = newValue;
    _updateNative();
  }

  bool _shouldShowCarousel = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowCarousel;

  bool get shouldShowCarousel => _shouldShowCarousel;

  set shouldShowCarousel(bool newValue) {
    _shouldShowCarousel = newValue;
    _updateNative();
  }

  bool _shouldShowPauseButton = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowPauseButton;

  bool get shouldShowPauseButton => _shouldShowPauseButton;

  set shouldShowPauseButton(bool newValue) {
    _shouldShowPauseButton = newValue;
    _updateNative();
  }

  bool _shouldShowFinishButton = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowFinishButton;

  bool get shouldShowFinishButton => _shouldShowFinishButton;

  set shouldShowFinishButton(bool newValue) {
    _shouldShowFinishButton = newValue;
    _updateNative();
  }

  bool _shouldShowProgressBar = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowProgressBar;

  bool get shouldShowProgressBar => _shouldShowProgressBar;

  set shouldShowProgressBar(bool newValue) {
    _shouldShowProgressBar = newValue;
    _updateNative();
  }

  bool _shouldShowTorchControl = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowTorchControl;

  bool get shouldShowTorchControl => _shouldShowTorchControl;

  set shouldShowTorchControl(bool newValue) {
    _shouldShowTorchControl = newValue;
    _updateNative();
  }

  Anchor _torchControlPosition = BarcodeFindDefaults.barcodeFindViewDefaults.torchControlPosition;

  Anchor get torchControlPosition => _torchControlPosition;

  set torchControlPosition(Anchor newValue) {
    _torchControlPosition = newValue;
    _updateNative();
  }

  String? _textForCollapseCardsButton = BarcodeFindDefaults.barcodeFindViewDefaults.textForCollapseCardsButton;

  String? get textForCollapseCardsButton => _textForCollapseCardsButton;

  set textForCollapseCardsButton(String? newValue) {
    _textForCollapseCardsButton = newValue;
    _updateNative();
  }

  String? _textForAllItemsFoundSuccessfullyHint =
      BarcodeFindDefaults.barcodeFindViewDefaults.textForAllItemsFoundSuccessfullyHint;

  String? get textForAllItemsFoundSuccessfullyHint => _textForAllItemsFoundSuccessfullyHint;

  set textForAllItemsFoundSuccessfullyHint(String? newValue) {
    _textForAllItemsFoundSuccessfullyHint = newValue;
    _updateNative();
  }

  String? _textForPointAtBarcodesToSearchHint =
      BarcodeFindDefaults.barcodeFindViewDefaults.textForPointAtBarcodesToSearchHint;

  String? get textForPointAtBarcodesToSearchHint => _textForPointAtBarcodesToSearchHint;

  set textForPointAtBarcodesToSearchHint(String? newValue) {
    _textForPointAtBarcodesToSearchHint = newValue;
    _updateNative();
  }

  String? _textForMoveCloserToBarcodesHint =
      BarcodeFindDefaults.barcodeFindViewDefaults.textForMoveCloserToBarcodesHint;

  String? get textForMoveCloserToBarcodesHint => _textForMoveCloserToBarcodesHint;

  set textForMoveCloserToBarcodesHint(String? newValue) {
    _textForMoveCloserToBarcodesHint = newValue;
    _updateNative();
  }

  String? _textForTapShutterToPauseScreenHint =
      BarcodeFindDefaults.barcodeFindViewDefaults.textForTapShutterToPauseScreenHint;

  String? get textForTapShutterToPauseScreenHint => _textForTapShutterToPauseScreenHint;

  set textForTapShutterToPauseScreenHint(String? newValue) {
    _textForTapShutterToPauseScreenHint = newValue;
    _updateNative();
  }

  String? _textForTapShutterToResumeSearchHint =
      BarcodeFindDefaults.barcodeFindViewDefaults.textForTapShutterToResumeSearchHint;

  String? get textForTapShutterToResumeSearchHint => _textForTapShutterToResumeSearchHint;

  set textForTapShutterToResumeSearchHint(String? newValue) {
    _textForTapShutterToResumeSearchHint = newValue;
    _updateNative();
  }

  String? _textForItemListUpdatedHint = BarcodeFindDefaults.barcodeFindViewDefaults.textForItemListUpdatedHint;

  String? get textForItemListUpdatedHint => _textForItemListUpdatedHint;

  set textForItemListUpdatedHint(String? newValue) {
    _textForItemListUpdatedHint = newValue;
    _updateNative();
  }

  String? _textForItemListUpdatedWhenPausedHint =
      BarcodeFindDefaults.barcodeFindViewDefaults.textForItemListUpdatedWhenPausedHint;

  String? get textForItemListUpdatedWhenPausedHint => _textForItemListUpdatedWhenPausedHint;

  set textForItemListUpdatedWhenPausedHint(String? newValue) {
    _textForItemListUpdatedWhenPausedHint = newValue;
    _updateNative();
  }

  Future<void> _updateNative() {
    if (!_isInitialized) {
      return Future.value();
    }
    return _controller.updateView();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'View': {
        'shouldShowUserGuidanceView': shouldShowUserGuidanceView,
        'shouldShowHints': shouldShowHints,
        'shouldShowCarousel': shouldShowCarousel,
        'shouldShowPauseButton': shouldShowPauseButton,
        'shouldShowFinishButton': shouldShowFinishButton,
        'shouldShowProgressBar': shouldShowProgressBar,
        'shouldShowTorchControl': shouldShowTorchControl,
        'torchControlPosition': torchControlPosition.toString(),
        'textForCollapseCardsButton': textForCollapseCardsButton,
        'textForAllItemsFoundSuccessfullyHint': textForAllItemsFoundSuccessfullyHint,
        'textForPointAtBarcodesToSearchHint': textForPointAtBarcodesToSearchHint,
        'textForMoveCloserToBarcodesHint': textForMoveCloserToBarcodesHint,
        'textForTapShutterToPauseScreenHint': textForTapShutterToPauseScreenHint,
        'textForTapShutterToResumeSearchHint': textForTapShutterToResumeSearchHint,
        'startSearching': _startSearching,
        'textForItemListUpdatedHint': textForItemListUpdatedHint,
        'textForItemListUpdatedWhenPausedHint': textForItemListUpdatedWhenPausedHint,
      },
      'BarcodeFind': _barcodeFind.toMap()
    };

    if (_barcodeFindViewSettings != null) {
      json['View']['viewSettings'] = _barcodeFindViewSettings.toMap();
    }

    if (_cameraSettings != null) {
      json['View']['cameraSettings'] = _cameraSettings.toMap();
    }

    return json;
  }
}

class _BarcodeFindViewController {
  final MethodChannel _methodChannel = const MethodChannel(BarcodeFindFunctionNames.methodsChannelName);

  StreamSubscription<dynamic>? _viewEventsSubscription;

  final BarcodeFindView _barcodeFindView;

  _BarcodeFindViewController(this._barcodeFindView) {
    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    _viewEventsSubscription = BarcodePluginEvents.barcodeFindEventStream.listen((event) {
      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;
      switch (eventName) {
        case BarcodeFindViewUiListener._onFinishButtonTappedEventName:
          _handleOnFinishButtonTapped(eventJSON);
          break;
      }
    });
  }

  void _handleOnFinishButtonTapped(Map<String, dynamic> json) {
    var foundItemsData = List.from(json['foundItems']);
    var foundItems = foundItemsData
        .map((e) =>
            _barcodeFindView._barcodeFind.itemsToFind.firstWhere((element) => element.searchOptions.barcodeData == e))
        .toSet();
    _barcodeFindView._barcodeFindViewUiListener?.didTapFinishButton(foundItems);
  }

  Future<void> updateView() {
    return _methodChannel.invokeMethod(BarcodeFindFunctionNames.updateFindView, jsonEncode(_barcodeFindView.toMap()));
  }

  Future<void> widgetPaused() {
    return _methodChannel.invokeMethod(BarcodeFindFunctionNames.barcodeFindViewOnPause);
  }

  Future<void> widgetResumed() {
    return _methodChannel.invokeMethod(BarcodeFindFunctionNames.barcodeFindViewOnResume);
  }

  Future<void> stopSearching() {
    return _methodChannel.invokeMethod(BarcodeFindFunctionNames.barcodeFindViewStopSearching);
  }

  Future<void> startSearching() {
    return _methodChannel.invokeMethod(BarcodeFindFunctionNames.barcodeFindViewStartSearching);
  }

  Future<void> pauseSearching() {
    return _methodChannel.invokeMethod(BarcodeFindFunctionNames.barcodeFindViewPauseSearching);
  }

  void setUiListener(BarcodeFindViewUiListener? listener) {
    var methodToInvoke = listener != null
        ? BarcodeFindFunctionNames.registerBarcodeFindViewListener
        : BarcodeFindFunctionNames.unregisterBarcodeFindViewListener;

    _methodChannel.invokeMethod(methodToInvoke).then((value) => null, onError: _onError);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }

  void dispose() {
    _viewEventsSubscription?.cancel();
    _viewEventsSubscription = null;
  }
}

class _BarcodeFindViewState extends State<BarcodeFindView> {
  _BarcodeFindViewState();

  @override
  Widget build(BuildContext context) {
    const viewType = 'com.scandit.BarcodeFindView';

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
            creationParams: {'BarcodeFindView': jsonEncode(widget.toMap())},
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
        creationParams: {'BarcodeFindView': jsonEncode(widget.toMap())},
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
