// ignore_for_file: deprecated_member_use_from_same_package

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
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode.dart';
import '../barcode_plugin_events.dart';

import 'spark_scan.dart';
import 'spark_scan_barcode_feedback.dart';
import 'spark_scan_view_feedback.dart';
import 'spark_scan_view_settings.dart';
import 'spark_scan_defaults.dart';
import 'spark_scan_function_names.dart';

abstract class SparkScanViewUiListener {
  static const String _didTapFastFindButtonEventName = 'SparkScanViewUiListener.fastFindButtonTapped';
  static const String _didTapBarcodeFindButtonEventName = 'SparkScanViewUiListener.barcodeFindButtonTapped';
  static const String _didTapBarcodeCountButtonEventName = 'SparkScanViewUiListener.barcodeCountButtonTapped';

  void didTapFastFindButton(SparkScanView view);

  void didTapBarcodeCountButton(SparkScanView view);
}

abstract class SparkScanFeedbackDelegate {
  static const String _onFeedbackForBarcode = 'SparkScanFeedbackDelegate.feedbackForBarcode';

  SparkScanBarcodeFeedback? feedbackForBarcode(Barcode barcode);
}

@Deprecated('Replaced by SparkScanPreviewBehavior because accurate workflow have been simplified.')
enum SparkScanScanningPrecision {
  defaultPrecision('default'),
  accurate('accurate');

  const SparkScanScanningPrecision(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension SparkScanScanningPrecisionDeserializer on SparkScanScanningPrecision {
  static SparkScanScanningPrecision fromJSON(String jsonValue) {
    return SparkScanScanningPrecision.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

enum SparkScanPreviewBehavior {
  defaultBehaviour('default'),
  persistent('accurate');

  const SparkScanPreviewBehavior(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension SparkScanPreviewBehaviorDeserializer on SparkScanPreviewBehavior {
  static SparkScanPreviewBehavior fromJSON(String jsonValue) {
    return SparkScanPreviewBehavior.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

// ignore: must_be_immutable
class SparkScanView extends StatefulWidget implements Serializable {
  final Widget _child;
  final DataCaptureContext _dataCaptureContext;
  final SparkScan _sparkScan;
  SparkScanViewSettings _settings;
  SparkScanViewUiListener? _uiListener;
  SparkScanFeedbackDelegate? _feedbackDelegate;

  late _SparkScanViewController _controller;

  SparkScanView._(this._child, this._dataCaptureContext, this._sparkScan, this._settings) : super() {
    _dataCaptureContext.initialize();
    _controller = _SparkScanViewController._(this);
  }

  SparkScanView.forContext(
      Widget child, DataCaptureContext dataCaptureContext, SparkScan sparkScan, SparkScanViewSettings? settings)
      : this._(child, dataCaptureContext, sparkScan, settings ?? SparkScanViewSettings());

  @override
  State<StatefulWidget> createState() {
    return _SparkScanViewState();
  }

  static Brush get defaultBrush {
    return SparkScanDefaults.sparkScanViewDefaults.defaultBrush;
  }

  static bool get hardwareTriggerSupported {
    return SparkScanDefaults.sparkScanViewDefaults.hardwareTriggerSupported;
  }

  Brush _brush = SparkScanDefaults.sparkScanViewDefaults.defaultBrush;

  @Deprecated(
      'The brush is now specified for each detected barcode. See the type SparkScanBarcodeFeedback and the feedbackDelegate property.')
  Brush get brush => _brush;

  @Deprecated(
      'The brush is now specified for each detected barcode. See the type SparkScanBarcodeFeedback and the feedbackDelegate property.')
  set brush(Brush newValue) {
    _brush = newValue;
    _update();
  }

  bool _shouldShowScanAreaGuides = false;

  @Deprecated('This property is deprecated as it\'s no longer needed.')
  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  @Deprecated('This property is deprecated as it\'s no longer needed.')
  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _update();
  }

  bool _torchButtonVisible = SparkScanDefaults.sparkScanViewDefaults.torchButtonVisible;

  bool get torchButtonVisible {
    return _torchButtonVisible;
  }

  set torchButtonVisible(bool newValue) {
    _torchButtonVisible = newValue;
    _update();
  }

  bool _scanningBehaviorButtonVisible = SparkScanDefaults.sparkScanViewDefaults.scanningBehaviorButtonVisible;

  bool get scanningBehaviorButtonVisible {
    return _scanningBehaviorButtonVisible;
  }

  set scanningBehaviorButtonVisible(bool newValue) {
    _scanningBehaviorButtonVisible = newValue;
    _update();
  }

  bool _handModeButtonVisible = SparkScanDefaults.sparkScanViewDefaults.handModeButtonVisible;

  bool get handModeButtonVisible {
    return _handModeButtonVisible;
  }

  set handModeButtonVisible(bool newValue) {
    _handModeButtonVisible = newValue;
    _update();
  }

  String? _stopCapturingText = SparkScanDefaults.sparkScanViewDefaults.stopCapturingText;

  String? get stopCapturingText {
    return _stopCapturingText;
  }

  set stopCapturingText(String? newValue) {
    _stopCapturingText = newValue;
    _update();
  }

  String? _startCapturingText = SparkScanDefaults.sparkScanViewDefaults.startCapturingText;

  String? get startCapturingText {
    return _startCapturingText;
  }

  set startCapturingText(String? newValue) {
    _startCapturingText = newValue;
    _update();
  }

  String? _resumeCapturingText = SparkScanDefaults.sparkScanViewDefaults.resumeCapturingText;

  String? get resumeCapturingText {
    return _resumeCapturingText;
  }

  set resumeCapturingText(String? newValue) {
    _resumeCapturingText = newValue;
    _update();
  }

  String? _scanningCapturingText = SparkScanDefaults.sparkScanViewDefaults.scanningCapturingText;

  String? get scanningCapturingText {
    return _scanningCapturingText;
  }

  set scanningCapturingText(String? newValue) {
    _scanningCapturingText = newValue;
    _update();
  }

  Color? _captureButtonBackgroundColor = SparkScanDefaults.sparkScanViewDefaults.captureButtonBackgroundColor;

  Color? get captureButtonBackgroundColor {
    return _captureButtonBackgroundColor;
  }

  set captureButtonBackgroundColor(Color? newValue) {
    _captureButtonBackgroundColor = newValue;
    _update();
  }

  Color? _captureButtonActiveBackgroundColor =
      SparkScanDefaults.sparkScanViewDefaults.captureButtonActiveBackgroundColor;

  Color? get captureButtonActiveBackgroundColor {
    return _captureButtonActiveBackgroundColor;
  }

  set captureButtonActiveBackgroundColor(Color? newValue) {
    _captureButtonActiveBackgroundColor = newValue;
    _update();
  }

  Color? _captureButtonTintColor = SparkScanDefaults.sparkScanViewDefaults.captureButtonTintColor;

  Color? get captureButtonTintColor {
    return _captureButtonTintColor;
  }

  set captureButtonTintColor(Color? newValue) {
    _captureButtonTintColor = newValue;
    _update();
  }

  Color? _toolbarBackgroundColor = SparkScanDefaults.sparkScanViewDefaults.toolbarBackgroundColor;

  Color? get toolbarBackgroundColor {
    return _toolbarBackgroundColor;
  }

  set toolbarBackgroundColor(Color? newValue) {
    _toolbarBackgroundColor = newValue;
    _update();
  }

  Color? _toolbarIconActiveTintColor = SparkScanDefaults.sparkScanViewDefaults.toolbarIconActiveTintColor;

  Color? get toolbarIconActiveTintColor {
    return _toolbarIconActiveTintColor;
  }

  set toolbarIconActiveTintColor(Color? newValue) {
    _toolbarIconActiveTintColor = newValue;
    _update();
  }

  Color? _toolbarIconInactiveTintColor = SparkScanDefaults.sparkScanViewDefaults.toolbarIconInactiveTintColor;

  Color? get toolbarIconInactiveTintColor {
    return _toolbarIconInactiveTintColor;
  }

  set toolbarIconInactiveTintColor(Color? newValue) {
    _toolbarIconInactiveTintColor = newValue;
    _update();
  }

  bool _barcodeCountButtonVisible = SparkScanDefaults.sparkScanViewDefaults.barcodeCountButtonVisible;

  bool get barcodeCountButtonVisible {
    return _barcodeCountButtonVisible;
  }

  set barcodeCountButtonVisible(bool newValue) {
    _barcodeCountButtonVisible = newValue;
    _update();
  }

  bool _fastFindButtonVisible = false;

  @Deprecated('This property was renamed. Use the property `barcodeFindButtonVisible` instead.')
  bool get fastFindButtonVisible {
    return _fastFindButtonVisible;
  }

  @Deprecated('This property was renamed. Use the property `barcodeFindButtonVisible` instead.')
  set fastFindButtonVisible(bool newValue) {
    // NOOP
  }

  bool _barcodeFindButtonVisible = SparkScanDefaults.sparkScanViewDefaults.barcodeFindButtonVisible;

  bool get barcodeFindButtonVisible {
    return _barcodeFindButtonVisible;
  }

  set barcodeFindButtonVisible(bool newValue) {
    _barcodeFindButtonVisible = newValue;
    _update();
  }

  bool _targetModeButtonVisible = SparkScanDefaults.sparkScanViewDefaults.targetModeButtonVisible;

  bool get targetModeButtonVisible {
    return _targetModeButtonVisible;
  }

  set targetModeButtonVisible(bool newValue) {
    _targetModeButtonVisible = newValue;
    _update();
  }

  String? _targetModeHintText = SparkScanDefaults.sparkScanViewDefaults.targetModeHintText;

  String? get targetModeHintText {
    return _targetModeHintText;
  }

  set targetModeHintText(String? newValue) {
    _targetModeHintText = newValue;
    _update();
  }

  bool _shouldShowTargetModeHint = false;

  @Deprecated('shouldShowTargetModeHint is deprecated. Unused.')
  bool get shouldShowTargetModeHint {
    return _shouldShowTargetModeHint;
  }

  @Deprecated('shouldShowTargetModeHint is deprecated. Unused. Setting this will have no effect.')
  set shouldShowTargetModeHint(bool newValue) {
    _shouldShowTargetModeHint = false;
  }

  bool _soundModeButtonVisible = SparkScanDefaults.sparkScanViewDefaults.soundModeButtonVisible;

  @Deprecated('This property is deprecated as sound mode button will be removed in the future.')
  bool get soundModeButtonVisible {
    return _soundModeButtonVisible;
  }

  @Deprecated('This property is deprecated as sound mode button will be removed in the future.')
  set soundModeButtonVisible(bool newValue) {
    _soundModeButtonVisible = newValue;
    _update();
  }

  bool _hapticModeButtonVisible = SparkScanDefaults.sparkScanViewDefaults.hapticModeButtonVisible;

  @Deprecated('This property is deprecated as haptic mode button will be removed in the future.')
  bool get hapticModeButtonVisible {
    return _hapticModeButtonVisible;
  }

  @Deprecated('This property is deprecated as haptic mode button will be removed in the future.')
  set hapticModeButtonVisible(bool newValue) {
    _hapticModeButtonVisible = newValue;
    _update();
  }

  bool _zoomSwitchControlVisible = SparkScanDefaults.sparkScanViewDefaults.zoomSwitchControlVisible;

  bool get zoomSwitchControlVisible {
    return _zoomSwitchControlVisible;
  }

  set zoomSwitchControlVisible(bool newValue) {
    _zoomSwitchControlVisible = newValue;
    _update();
  }

  void setListener(SparkScanViewUiListener? listener) {
    if (listener != null) {
      _controller.subscribeUiListeners();
    } else {
      _controller.unsubscribeListeners();
    }
    _uiListener = listener;
  }

  SparkScanFeedbackDelegate? get feedbackDelegate => _feedbackDelegate;

  set feedbackDelegate(SparkScanFeedbackDelegate? newValue) {
    if (newValue != null) {
      _controller.addFeedbackDelegate();
    } else {
      _controller.removeFeedbackDelegate();
    }
    _feedbackDelegate = newValue;
  }

  bool _previewSizeControlVisible = SparkScanDefaults.sparkScanViewDefaults.previewSizeControlVisible;

  bool get previewSizeControlVisible => _previewSizeControlVisible;

  set previewSizeControlVisible(bool newValue) {
    _previewSizeControlVisible = newValue;
    _update();
  }

  bool _cameraSwitchButtonVisible = SparkScanDefaults.sparkScanViewDefaults.cameraSwitchButtonVisible;

  bool get cameraSwitchButtonVisible {
    return _cameraSwitchButtonVisible;
  }

  set cameraSwitchButtonVisible(bool newValue) {
    _cameraSwitchButtonVisible = newValue;
    _update();
  }

  void onPause() {
    _controller.onPause();
  }

  Future<void> startScanning() {
    return _controller.startScanning();
  }

  Future<void> pauseScanning() {
    return _controller.pauseScanning();
  }

  @Deprecated('Use property feedbackDelegate instead.')
  Future<void> emitFeedback(SparkScanViewFeedback feedback) {
    return _controller.emitFeedback(feedback);
  }

  Future<void> showToast(String text) {
    return _controller.showToast(text);
  }

  Future<void> _update() {
    return _controller.updateView();
  }

  Future<void> _bringViewToFront() {
    return _controller._bringViewToFront();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'SparkScanView': {
        'viewSettings': _settings.toMap(),
        'brush': brush.toMap(),
        'shouldShowScanAreaGuides': shouldShowScanAreaGuides,
        'torchButtonVisible': torchButtonVisible,
        'scanningBehaviorButtonVisible': scanningBehaviorButtonVisible,
        'handModeButtonVisible': handModeButtonVisible,
        'stopCapturingText': stopCapturingText,
        'startCapturingText': startCapturingText,
        'resumeCapturingText': resumeCapturingText,
        'scanningCapturingText': scanningCapturingText,
        'captureButtonBackgroundColor': captureButtonBackgroundColor?.jsonValue,
        'captureButtonActiveBackgroundColor': captureButtonActiveBackgroundColor?.jsonValue,
        'toolbarBackgroundColor': toolbarBackgroundColor?.jsonValue,
        'barcodeCountButtonVisible': barcodeCountButtonVisible,
        'barcodeFindButtonVisible': barcodeFindButtonVisible,
        'targetModeButtonVisible': targetModeButtonVisible,
        'toolbarIconActiveTintColor': toolbarIconActiveTintColor?.jsonValue,
        'toolbarIconInactiveTintColor': toolbarIconInactiveTintColor?.jsonValue,
        'soundModeButtonVisible': soundModeButtonVisible,
        'hapticModeButtonVisible': hapticModeButtonVisible,
        'captureButtonTintColor': captureButtonTintColor?.jsonValue,
        'zoomSwitchControlVisible': zoomSwitchControlVisible,
        'targetModeHintText': targetModeHintText,
        'previewSizeControlVisible': previewSizeControlVisible,
        'hasFeedbackDelegate': _feedbackDelegate != null,
        'cameraSwitchButtonVisible': cameraSwitchButtonVisible,
      },
      'SparkScan': _sparkScan.toMap(),
    };
  }
}

class _SparkScanViewState extends State<SparkScanView> {
  late Widget sparkScanView;

  _SparkScanViewState();

  @override
  Widget build(BuildContext context) {
    const viewType = 'com.scandit.SparkScanView';

    if (Platform.isAndroid) {
      sparkScanView = PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.translucent,
          );
        },
        onCreatePlatformView: (params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: {'SparkScanView': jsonEncode(widget.toMap())},
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
        },
      );
    } else {
      sparkScanView = UiKitView(
        viewType: viewType,
        hitTestBehavior: PlatformViewHitTestBehavior.translucent,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
        creationParams: {'SparkScanView': jsonEncode(widget.toMap())},
        creationParamsCodec: const StandardMessageCodec(),
        layoutDirection: TextDirection.ltr,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: sparkScanView,
        ),
        Positioned.fill(
          child: widget._child,
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(SparkScanView oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget._bringViewToFront();
  }

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }
}

class _SparkScanViewController {
  final MethodChannel _methodChannel = MethodChannel(SparkScanFunctionNames.methodsChannelName);
  StreamSubscription<dynamic>? _sparkScanViewSubscription;
  StreamSubscription<dynamic>? _sparkScanDelegateFeedbackSubscription;
  final SparkScanView _sparkScanView;

  _SparkScanViewController._(this._sparkScanView);

  void subscribeUiListeners() {
    _methodChannel
        .invokeMethod(SparkScanFunctionNames.addSparkScanViewUiListener)
        .then((value) => _setupBarcodeCaptureSubscription(), onError: _onError);
  }

  void _setupBarcodeCaptureSubscription() {
    if (_sparkScanViewSubscription != null) return;
    _sparkScanViewSubscription = BarcodePluginEvents.sparkScanEventStream.listen((event) {
      var json = jsonDecode(event);
      var eventName = json['event'] as String;

      if (eventName == SparkScanViewUiListener._didTapBarcodeCountButtonEventName) {
        _sparkScanView._uiListener?.didTapBarcodeCountButton(_sparkScanView);
      } else if (eventName == SparkScanViewUiListener._didTapFastFindButtonEventName) {
        _sparkScanView._uiListener?.didTapFastFindButton(_sparkScanView);
      } else if (eventName == SparkScanViewUiListener._didTapBarcodeFindButtonEventName) {
        _sparkScanView._uiListener?.didTapFastFindButton(_sparkScanView);
      }
    });
  }

  void unsubscribeListeners() {
    _sparkScanViewSubscription?.cancel();
    _methodChannel
        .invokeMethod(SparkScanFunctionNames.removeSparkScanViewUiListener)
        .then((value) => null, onError: _onError);
    _sparkScanViewSubscription = null;
  }

  Future<void> startScanning() {
    return _methodChannel.invokeMethod(SparkScanFunctionNames.startScanning).onError(_onError);
  }

  Future<void> updateView() {
    return _methodChannel
        .invokeMethod(SparkScanFunctionNames.updateView, jsonEncode(_sparkScanView.toMap()))
        .onError(_onError);
  }

  Future<void> pauseScanning() {
    return _methodChannel.invokeMethod(SparkScanFunctionNames.pauseScanning).onError(_onError);
  }

  Future<void> emitFeedback(SparkScanViewFeedback feedback) {
    // NOOP
    return Future.value(null);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    print(error);

    if (stackTrace != null) {
      print(stackTrace);
    }

    throw error;
  }

  Future<void> showToast(String text) {
    return _methodChannel.invokeMethod(SparkScanFunctionNames.showToast, text).onError(_onError);
  }

  void onPause() {
    _methodChannel.invokeMethod(SparkScanFunctionNames.onWidgetPaused).onError(_onError);
  }

  void addFeedbackDelegate() {
    _methodChannel.invokeMethod(SparkScanFunctionNames.addFeedbackDelegate).onError(_onError);
    if (_sparkScanDelegateFeedbackSubscription != null) return;
    _sparkScanDelegateFeedbackSubscription = BarcodePluginEvents.sparkScanEventStream.listen((event) {
      var json = jsonDecode(event);
      var eventName = json['event'] as String;
      if (eventName != SparkScanFeedbackDelegate._onFeedbackForBarcode) return;
      var barcode = Barcode.fromJSON(jsonDecode(json['barcode']));
      var feedback = this._sparkScanView._feedbackDelegate?.feedbackForBarcode(barcode);
      String? feedbackJson = null;
      if (feedback != null) {
        feedbackJson = jsonEncode(feedback.toMap());
      }
      _methodChannel.invokeMethod(SparkScanFunctionNames.submitFeedbackForBarcode, feedbackJson).onError(_onError);
    });
  }

  void removeFeedbackDelegate() {
    _methodChannel.invokeMethod(SparkScanFunctionNames.removeFeedbackDelegate).onError(_onError);
  }

  Future<void> _bringViewToFront() {
    if (Platform.isIOS) {
      return _methodChannel.invokeMethod(SparkScanFunctionNames.bringViewToFront).onError(_onError);
    }
    return Future.value();
  }

  void dispose() {
    _sparkScanDelegateFeedbackSubscription?.cancel();
    _sparkScanDelegateFeedbackSubscription = null;
    _sparkScanViewSubscription?.cancel();
    _sparkScanViewSubscription = null;
  }
}
