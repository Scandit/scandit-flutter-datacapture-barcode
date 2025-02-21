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
import 'spark_scan_view_settings.dart';
import 'spark_scan_defaults.dart';
import 'spark_scan_function_names.dart';
import 'spark_scan_view_state.dart';

abstract class SparkScanViewUiListener {
  static const String _didTapBarcodeFindButtonEventName = 'SparkScanViewUiListener.barcodeFindButtonTapped';
  static const String _didTapBarcodeCountButtonEventName = 'SparkScanViewUiListener.barcodeCountButtonTapped';
  static const String _didChangeViewStateEventName = 'SparkScanViewUiListener.didChangeViewState';

  void didTapBarcodeFindButton(SparkScanView view);

  void didTapBarcodeCountButton(SparkScanView view);

  void didChangeViewState(SparkScanViewState newState);
}

abstract class SparkScanFeedbackDelegate {
  static const String _onFeedbackForBarcode = 'SparkScanFeedbackDelegate.feedbackForBarcode';

  SparkScanBarcodeFeedback? feedbackForBarcode(Barcode barcode);
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

  @Deprecated('The torch button has been moved to the mini preview. Use property `torchControlVisible` instead.')
  bool get torchButtonVisible {
    return false;
  }

  @Deprecated('The torch button has been moved to the mini preview. Use property `torchControlVisible` instead.')
  set torchButtonVisible(bool newValue) {
    // Do nothing
  }

  bool _torchControlVisible = SparkScanDefaults.sparkScanViewDefaults.torchControlVisible;

  bool get torchControlVisible {
    return _torchControlVisible;
  }

  set torchControlVisible(bool newValue) {
    _torchControlVisible = newValue;
    _update();
  }

  bool _previewCloseControlVisible = SparkScanDefaults.sparkScanViewDefaults.previewCloseControlVisible;

  bool get previewCloseControlVisible {
    return _previewCloseControlVisible;
  }

  set previewCloseControlVisible(bool newValue) {
    _previewCloseControlVisible = newValue;
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

  @Deprecated('The trigger button no longer displays text.')
  String? get stopCapturingText {
    return null;
  }

  @Deprecated('The trigger button no longer displays text.')
  set stopCapturingText(String? newValue) {
    // Do nothing
  }

  @Deprecated('The trigger button no longer displays text.')
  String? get startCapturingText {
    return null;
  }

  @Deprecated('The trigger button no longer displays text.')
  set startCapturingText(String? newValue) {
    // Do nothing
  }

  @Deprecated('The trigger button no longer displays text.')
  String? get resumeCapturingText {
    return null;
  }

  @Deprecated('The trigger button no longer displays text.')
  set resumeCapturingText(String? newValue) {
    // Do nothing
  }

  @Deprecated('The trigger button no longer displays text.')
  String? get scanningCapturingText {
    return null;
  }

  @Deprecated('The trigger button no longer displays text.')
  set scanningCapturingText(String? newValue) {
    // Do nothing
  }

  @Deprecated('Use property `triggerButtonCollapsedColor` and property `triggerButtonExpandedColor` instead.')
  Color? get captureButtonBackgroundColor {
    return null;
  }

  @Deprecated('Use property `triggerButtonCollapsedColor` and property `triggerButtonExpandedColor` instead.')
  set captureButtonBackgroundColor(Color? newValue) {
    // Do nothing
  }

  @Deprecated('This property is not relevant anymore.')
  Color? get captureButtonActiveBackgroundColor {
    return null;
  }

  @Deprecated('This property is not relevant anymore.')
  set captureButtonActiveBackgroundColor(Color? newValue) {
    // Do nothing
  }

  @Deprecated('Use property `triggerButtonTintColor` instead.')
  Color? get captureButtonTintColor {
    return null;
  }

  @Deprecated('Use property `triggerButtonTintColor` instead.')
  set captureButtonTintColor(Color? newValue) {
    // Do nothing
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

  Color? _triggerButtonCollapsedColor = SparkScanDefaults.sparkScanViewDefaults.triggerButtonCollapsedColor;

  Color? get triggerButtonCollapsedColor {
    return _triggerButtonCollapsedColor;
  }

  set triggerButtonCollapsedColor(Color? newValue) {
    _triggerButtonCollapsedColor = newValue;
    _update();
  }

  Color? _triggerButtonExpandedColor = SparkScanDefaults.sparkScanViewDefaults.triggerButtonExpandedColor;

  Color? get triggerButtonExpandedColor {
    return _triggerButtonExpandedColor;
  }

  set triggerButtonExpandedColor(Color? newValue) {
    _triggerButtonExpandedColor = newValue;
    _update();
  }

  Color? _triggerButtonAnimationColor = SparkScanDefaults.sparkScanViewDefaults.triggerButtonAnimationColor;

  Color? get triggerButtonAnimationColor {
    return _triggerButtonAnimationColor;
  }

  set triggerButtonAnimationColor(Color? newValue) {
    _triggerButtonAnimationColor = newValue;
    _update();
  }

  Color? _triggerButtonTintColor = SparkScanDefaults.sparkScanViewDefaults.triggerButtonTintColor;

  Color? get triggerButtonTintColor {
    return _triggerButtonTintColor;
  }

  set triggerButtonTintColor(Color? newValue) {
    _triggerButtonTintColor = newValue;
    _update();
  }

  bool _triggerButtonVisible = SparkScanDefaults.sparkScanViewDefaults.triggerButtonVisible;

  bool get triggerButtonVisible {
    return _triggerButtonVisible;
  }

  set triggerButtonVisible(bool newValue) {
    _triggerButtonVisible = newValue;
    _update();
  }

  @Deprecated(
      'There is no longer a need to manually call the onPause function. This function will be removed in future SDK versions.')
  Future<void> onPause() {
    return Future.value(null);
  }

  Future<void> startScanning() {
    return _controller.startScanning();
  }

  Future<void> pauseScanning() {
    return _controller.pauseScanning();
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

  String? _triggerButtonImage = SparkScanDefaults.sparkScanViewDefaults.triggerButtonImage;

  Image? get triggerButtonImage {
    var base64EncodedImage = _triggerButtonImage;
    if (base64EncodedImage == null) return null;
    // Remove whitespaces to avoid errors when decoding
    final normalized = base64EncodedImage.replaceAll(RegExp(r'\s+'), '');
    return Image.memory(base64Decode(normalized));
  }

  set triggerButtonImage(Image? newValue) {
    if (newValue == null) {
      _triggerButtonImage = null;
      _controller.updateView();
      return;
    }

    newValue.base64String.then((base64EncodedImage) {
      _triggerButtonImage = base64EncodedImage;
      return _controller.updateView();
    });
  }

  Future<void> setTriggerButtonImage(Uint8List image) {
    _triggerButtonImage = base64Encode(image);
    return _controller.updateView();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'SparkScanView': {
        'viewSettings': _settings.toMap(),
        'torchControlVisible': torchControlVisible,
        'scanningBehaviorButtonVisible': scanningBehaviorButtonVisible,
        'toolbarBackgroundColor': toolbarBackgroundColor?.jsonValue,
        'barcodeCountButtonVisible': barcodeCountButtonVisible,
        'barcodeFindButtonVisible': barcodeFindButtonVisible,
        'targetModeButtonVisible': targetModeButtonVisible,
        'toolbarIconActiveTintColor': toolbarIconActiveTintColor?.jsonValue,
        'toolbarIconInactiveTintColor': toolbarIconInactiveTintColor?.jsonValue,
        'zoomSwitchControlVisible': zoomSwitchControlVisible,
        'previewSizeControlVisible': previewSizeControlVisible,
        'hasFeedbackDelegate': _feedbackDelegate != null,
        'cameraSwitchButtonVisible': cameraSwitchButtonVisible,
        'triggerButtonImage': _triggerButtonImage,
        'triggerButtonVisible': triggerButtonVisible,
        'previewCloseControlVisible': previewCloseControlVisible,
        'triggerButtonCollapsedColor': triggerButtonCollapsedColor?.jsonValue,
        'triggerButtonExpandedColor': triggerButtonExpandedColor?.jsonValue,
        'triggerButtonAnimationColor': triggerButtonAnimationColor?.jsonValue,
        'triggerButtonTintColor': triggerButtonTintColor?.jsonValue,
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
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
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
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
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
  final MethodChannel _methodChannel = const MethodChannel(SparkScanFunctionNames.methodsChannelName);
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
      } else if (eventName == SparkScanViewUiListener._didTapBarcodeFindButtonEventName) {
        _sparkScanView._uiListener?.didTapBarcodeFindButton(_sparkScanView);
      } else if (eventName == SparkScanViewUiListener._didChangeViewStateEventName) {
        final stateJson = json['state'] as String;
        final newState = SparkScanViewStateSerializer.fromJSON(stateJson);
        _sparkScanView._uiListener?.didChangeViewState(newState);
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
    final viewProps = _sparkScanView.toMap()['SparkScanView'];
    return _methodChannel.invokeMethod(SparkScanFunctionNames.updateView, jsonEncode(viewProps)).onError(_onError);
  }

  Future<void> pauseScanning() {
    return _methodChannel.invokeMethod(SparkScanFunctionNames.pauseScanning).onError(_onError);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }

  Future<void> showToast(String text) {
    return _methodChannel.invokeMethod(SparkScanFunctionNames.showToast, text).onError(_onError);
  }

  void addFeedbackDelegate() {
    _methodChannel.invokeMethod(SparkScanFunctionNames.addFeedbackDelegate).onError(_onError);
    if (_sparkScanDelegateFeedbackSubscription != null) return;
    _sparkScanDelegateFeedbackSubscription = BarcodePluginEvents.sparkScanEventStream.listen((event) {
      var json = jsonDecode(event);
      var eventName = json['event'] as String;
      if (eventName != SparkScanFeedbackDelegate._onFeedbackForBarcode) return;
      var barcode = Barcode.fromJSON(jsonDecode(json['barcode']));
      var feedback = _sparkScanView._feedbackDelegate?.feedbackForBarcode(barcode);
      String? feedbackJson;
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
