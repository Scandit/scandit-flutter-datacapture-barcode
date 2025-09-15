/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_feedback_delegate.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_listener.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_session.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_settings.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_view_ui_listener.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

import '../barcode.dart';
import '../barcode_plugin_events.dart';

import 'spark_scan_view_settings.dart';
import 'spark_scan_defaults.dart';
import 'spark_scan_function_names.dart';
import 'spark_scan_view_state.dart';

class SparkScan extends DataCaptureMode {
  bool _enabled = true;
  bool _isInCallback = false;
  SparkScanSettings _settings;
  final List<SparkScanListener> _listeners = [];

  _SparkScanViewController? _controller;

  SparkScan._(this._settings);

  SparkScan({SparkScanSettings? settings}) : this._(settings ?? SparkScanSettings());

  @Deprecated('Use constructor SparkScan({SparkScanSettings? settings}) instead.')
  SparkScan.withSettings(SparkScanSettings settings) : this._(settings);

  @override
  bool get isEnabled => _enabled;

  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    if (_isInCallback) {
      return;
    }
    _controller?.setModeEnabledState(newValue);
  }

  Future<void> applySettings(SparkScanSettings settings) {
    _settings = settings;
    return _didChange();
  }

  void addListener(SparkScanListener listener) {
    if (_listeners.isEmpty) {
      _controller?.subscribeSparkScanListener();
    }
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void removeListener(SparkScanListener listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _controller?.unsubscribeSparkScanListener();
    }
  }

  Future<void> _didChange() {
    return _controller?.updateSparkScanMode() ?? Future.value();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'sparkScan',
      'enabled': _enabled,
      'settings': _settings.toMap(),
      'hasListeners': _listeners.isNotEmpty
    };
  }
}

// ignore: must_be_immutable
class SparkScanView extends StatefulWidget implements Serializable {
  final Widget _child;
  final SparkScan _sparkScan;
  SparkScanViewSettings _settings;
  SparkScanViewUiListener? _uiListener;
  // ignore: deprecated_member_use_from_same_package
  ExtendedSparkScanViewUiListener? _extendedUiListener;
  SparkScanFeedbackDelegate? _feedbackDelegate;

  bool _viewWasCreated = false;
  // set from the state
  _SparkScanViewController? _controller;

  SparkScanView._(this._child, this._sparkScan, this._settings) : super();

  SparkScanView.forContext(
      Widget child, DataCaptureContext dataCaptureContext, SparkScan sparkScan, SparkScanViewSettings? settings)
      // we require the DCContext only to make sure the user created/initialized it
      : this._(child, sparkScan, settings ?? SparkScanViewSettings());

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

  bool _labelCaptureButtonVisible = SparkScanDefaults.sparkScanViewDefaults.labelCaptureButtonVisible;

  bool get labelCaptureButtonVisible {
    return _labelCaptureButtonVisible;
  }

  set labelCaptureButtonVisible(bool newValue) {
    _labelCaptureButtonVisible = newValue;
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
      _controller?.subscribeUiListeners();
    } else {
      _controller?.unsubscribeUiListeners();
    }
    _uiListener = listener;
    _update();
  }

  // ignore: deprecated_member_use_from_same_package
  void setExtendedListener(ExtendedSparkScanViewUiListener? listener) {
    if (listener != null) {
      _controller?.subscribeUiListeners();
    } else {
      _controller?.unsubscribeUiListeners();
    }
    _extendedUiListener = listener;
    _update();
  }

  SparkScanFeedbackDelegate? get feedbackDelegate => _feedbackDelegate;

  set feedbackDelegate(SparkScanFeedbackDelegate? newValue) {
    _feedbackDelegate = newValue;
    if (newValue != null) {
      _controller?.subscribeToFeedbackDelegateEvents();
    } else {
      _controller?.unsubscribeFromFeedbackDelegateEvents();
    }
    _controller?.setFeedbackDelegate(newValue);
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
    return _controller?.startScanning() ?? Future.value(null);
  }

  Future<void> pauseScanning() {
    return _controller?.pauseScanning() ?? Future.value(null);
  }

  Future<void> showToast(String text) {
    return _controller?.showToast(text) ?? Future.value(null);
  }

  Future<void> _update() {
    return _controller?.updateView() ?? Future.value(null);
  }

  Future<void> _bringViewToFront() {
    return _controller?._bringViewToFront() ?? Future.value(null);
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
      _controller?.updateView();
      return;
    }

    newValue.base64String.then((base64EncodedImage) {
      _triggerButtonImage = base64EncodedImage;
      return _controller?.updateView() ?? Future.value(null);
    });
  }

  Future<void> setTriggerButtonImage(Uint8List image) {
    _triggerButtonImage = base64Encode(image);
    return _controller?.updateView() ?? Future.value(null);
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
        'labelCaptureButtonVisible': labelCaptureButtonVisible,
        'targetModeButtonVisible': targetModeButtonVisible,
        'toolbarIconActiveTintColor': toolbarIconActiveTintColor?.jsonValue,
        'toolbarIconInactiveTintColor': toolbarIconInactiveTintColor?.jsonValue,
        'zoomSwitchControlVisible': zoomSwitchControlVisible,
        'previewSizeControlVisible': previewSizeControlVisible,
        'cameraSwitchButtonVisible': cameraSwitchButtonVisible,
        'triggerButtonImage': _triggerButtonImage,
        'triggerButtonVisible': triggerButtonVisible,
        'previewCloseControlVisible': previewCloseControlVisible,
        'triggerButtonCollapsedColor': triggerButtonCollapsedColor?.jsonValue,
        'triggerButtonExpandedColor': triggerButtonExpandedColor?.jsonValue,
        'triggerButtonAnimationColor': triggerButtonAnimationColor?.jsonValue,
        'triggerButtonTintColor': triggerButtonTintColor?.jsonValue,
        'hasFeedbackDelegate': _feedbackDelegate != null,
        'hasUiListener': _uiListener != null,
        'hasExtendedUiListener': _extendedUiListener != null,
        'viewId': _controller?._viewId ?? 0,
      },
      'SparkScan': _sparkScan.toMap(),
    };
  }
}

class _SparkScanViewState extends State<SparkScanView> {
  late Widget platformView;
  final int _viewId = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();
  late _SparkScanViewController _controller;
  bool _isRouteActive = true;

  _SparkScanViewState();

  @override
  void initState() {
    super.initState();
    // initialize controller in initState to avoid multiple instances of the
    // controller in the same view
    _controller = _SparkScanViewController._(widget, _viewId);
    // initialize controller in View and Mode
    widget._controller = _controller;
    widget._sparkScan._controller = _controller;
    _initializePlatformView();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkRouteStatus();
  }

  void _checkRouteStatus() {
    // Detect route changes and manage native view visibility accordingly.
    // When the user navigates to another screen, this route becomes non-current
    // and we hide the native SparkScanView. When navigating back, the route
    // becomes current again and we show the native view to sync visibility
    // between the Dart widget and the underlying native platform view.
    final route = ModalRoute.of(context);
    final wasActive = _isRouteActive;
    _isRouteActive = route?.isCurrent == true;

    if (wasActive != _isRouteActive) {
      if (_isRouteActive) {
        _controller.showView();
      } else {
        _controller.hideView();
      }
    }
  }

  void _initializePlatformView() {
    const viewType = 'com.scandit.SparkScanView';

    if (Platform.isAndroid) {
      platformView = PlatformViewLink(
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
            ..addOnPlatformViewCreatedListener((id) {
              widget._viewWasCreated = true;
            })
            ..create();
        },
      );
    } else {
      platformView = UiKitView(
        viewType: viewType,
        hitTestBehavior: PlatformViewHitTestBehavior.translucent,
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
        creationParams: {'SparkScanView': jsonEncode(widget.toMap())},
        creationParamsCodec: const StandardMessageCodec(),
        layoutDirection: TextDirection.ltr,
        onPlatformViewCreated: (id) {
          widget._viewWasCreated = true;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    widget._bringViewToFront();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkRouteStatus();
    });
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: platformView,
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
    // cleanup controller
    _controller.dispose();
    widget._controller = null;
    widget._sparkScan._controller = null;
    super.dispose();
  }
}

class _SparkScanViewController extends BaseController {
  StreamSubscription<dynamic>? _sparkScanViewSubscription;
  StreamSubscription<dynamic>? _sparkScanDelegateFeedbackSubscription;
  StreamSubscription<dynamic>? _sparkScanListenerSubscription;
  final SparkScanView view;
  final int _viewId;

  _SparkScanViewController._(this.view, this._viewId) : super(SparkScanFunctionNames.methodsChannelName) {
    _initialize();
  }

  void _initialize() {
    if (view._sparkScan._listeners.isNotEmpty) {
      subscribeSparkScanListener();
    }

    if (view._feedbackDelegate != null) {
      subscribeToFeedbackDelegateEvents();
    }

    if (view._uiListener != null || view._extendedUiListener != null) {
      subscribeUiListeners();
    }
  }

  void subscribeUiListeners() {
    if (_sparkScanViewSubscription != null) return;
    _sparkScanViewSubscription = BarcodePluginEvents.sparkScanEventStream.listen((event) {
      var json = jsonDecode(event);
      final viewId = json['viewId'] as int;
      if (viewId != _viewId) return;

      var eventName = json['event'] as String;

      if (eventName == 'SparkScanViewUiListener.barcodeCountButtonTapped') {
        view._uiListener?.didTapBarcodeCountButton(view);
        view._extendedUiListener?.didTapBarcodeCountButton(view);
      } else if (eventName == 'SparkScanViewUiListener.barcodeFindButtonTapped') {
        view._uiListener?.didTapBarcodeFindButton(view);
        view._extendedUiListener?.didTapBarcodeFindButton(view);
      } else if (eventName == 'SparkScanViewUiListener.didChangeViewState') {
        final stateJson = json['state'] as String;
        final newState = SparkScanViewStateSerializer.fromJSON(stateJson);
        view._uiListener?.didChangeViewState(newState);
        view._extendedUiListener?.didChangeViewState(newState);
      } else if (eventName == 'SparkScanViewUiListener.labelCaptureButtonTapped') {
        view._extendedUiListener?.didTapLabelCaptureButton(view);
      }
    });
  }

  void unsubscribeUiListeners() {
    _sparkScanViewSubscription?.cancel();
    _sparkScanViewSubscription = null;
  }

  Future<void> startScanning() {
    return methodChannel.invokeMethod(SparkScanFunctionNames.startScanning, {'viewId': _viewId}).onError(onError);
  }

  Future<void> updateView() {
    if (!view._viewWasCreated) return Future.value();

    final updateArgs = {
      'viewId': _viewId,
      'updateJson': jsonEncode(view.toMap()),
    };
    return methodChannel.invokeMethod(SparkScanFunctionNames.updateView, updateArgs).onError(onError);
  }

  Future<void> pauseScanning() {
    return methodChannel.invokeMethod(SparkScanFunctionNames.pauseScanning, {'viewId': _viewId}).onError(onError);
  }

  Future<void> showToast(String text) {
    return methodChannel
        .invokeMethod(SparkScanFunctionNames.showToast, {'viewId': _viewId, 'text': text}).onError(onError);
  }

  void subscribeToFeedbackDelegateEvents() {
    if (_sparkScanDelegateFeedbackSubscription != null) return;
    _sparkScanDelegateFeedbackSubscription = BarcodePluginEvents.sparkScanEventStream.listen((event) {
      var json = jsonDecode(event);

      final viewId = json['viewId'] as int;
      if (viewId != _viewId) return;

      final eventName = json['event'] as String;
      if (eventName != 'SparkScanFeedbackDelegate.feedbackForBarcode') return;
      var barcode = Barcode.fromJSON(jsonDecode(json['barcode']));
      var feedback = view._feedbackDelegate?.feedbackForBarcode(barcode);
      String? feedbackJson;
      if (feedback != null) {
        feedbackJson = jsonEncode(feedback.toMap());
      }
      methodChannel.invokeMethod(SparkScanFunctionNames.submitFeedbackForBarcode,
          {'viewId': _viewId, 'feedbackJson': feedbackJson}).onError(onError);
    });
  }

  void unsubscribeFromFeedbackDelegateEvents() {
    _sparkScanDelegateFeedbackSubscription?.cancel();
    _sparkScanDelegateFeedbackSubscription = null;
  }

  Future<void> _bringViewToFront() {
    if (Platform.isIOS) {
      return methodChannel.invokeMethod(SparkScanFunctionNames.bringViewToFront, {'viewId': _viewId}).onError(onError);
    }
    return Future.value();
  }

  void setModeEnabledState(bool newValue) {
    methodChannel.invokeMethod(SparkScanFunctionNames.setModeEnabledState, {
      'viewId': _viewId,
      'enabled': newValue,
    }).then((value) => null, onError: onError);
  }

  void subscribeSparkScanListener() {
    _setupModeListenerSubscription();
    methodChannel.invokeMethod(SparkScanFunctionNames.addSparkScanListener, {'viewId': _viewId}).onError(onError);
  }

  void _setupModeListenerSubscription() {
    if (_sparkScanListenerSubscription != null) return;
    _sparkScanListenerSubscription = BarcodePluginEvents.sparkScanEventStream.listen((event) async {
      if (view._sparkScan._listeners.isEmpty) return;

      var json = jsonDecode(event);
      final viewId = json['viewId'] as int;
      if (viewId != _viewId) return;

      final eventName = json['event'] as String;

      if (eventName == 'SparkScanListener.didScan') {
        var session = SparkScanSession.fromJSON(json, _viewId);
        await _notifyListenersOfDidScan(session);
        methodChannel.invokeMethod(SparkScanFunctionNames.sparkScanFinishDidScan,
                {'viewId': _viewId, 'enabled': view._sparkScan.isEnabled})
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: (error) => log(error));
      } else if (eventName == 'SparkScanListener.didUpdateSession') {
        var session = SparkScanSession.fromJSON(json, _viewId);
        await _notifyListenersOfDidUpateSession(session);
        methodChannel.invokeMethod(SparkScanFunctionNames.sparkScanFinishDidUpdateSession,
                {'viewId': _viewId, 'enabled': view._sparkScan.isEnabled})
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: (error) => log(error));
      }
    });
  }

  Future<void> _notifyListenersOfDidScan(SparkScanSession session) async {
    view._sparkScan._isInCallback = true;
    for (var listener in view._sparkScan._listeners) {
      await listener.didScan(view._sparkScan, session, () => _getLastFrameData(session));
    }
    view._sparkScan._isInCallback = false;
  }

  Future<void> _notifyListenersOfDidUpateSession(SparkScanSession session) async {
    view._sparkScan._isInCallback = true;
    for (var listener in view._sparkScan._listeners) {
      await listener.didUpdateSession(view._sparkScan, session, () => _getLastFrameData(session));
    }
    view._sparkScan._isInCallback = false;
  }

  Future<FrameData> _getLastFrameData(SparkScanSession session) {
    return methodChannel
        .invokeMethod(SparkScanFunctionNames.getLastFrameData, session.frameId)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: onError);
  }

  void unsubscribeSparkScanListener() {
    _sparkScanListenerSubscription?.cancel();
    _sparkScanListenerSubscription = null;
    methodChannel.invokeMethod(
        SparkScanFunctionNames.removeSparkScanListener, {'viewId': _viewId}).then((value) => null, onError: onError);
  }

  Future<void> updateSparkScanMode() {
    return methodChannel.invokeMethod(SparkScanFunctionNames.updateSparkScanMode,
        {'viewId': _viewId, 'updateJson': jsonEncode(view._sparkScan.toMap())}).onError(onError);
  }

  @override
  void dispose() {
    unsubscribeSparkScanListener();
    unsubscribeFromFeedbackDelegateEvents();
    unsubscribeUiListeners();
    super.dispose();
  }

  void setFeedbackDelegate(SparkScanFeedbackDelegate? newValue) {
    if (newValue == null) {
      methodChannel.invokeMethod('unregisterSparkScanFeedbackDelegateForEvents', {'viewId': _viewId});
    } else {
      methodChannel.invokeMethod('registerSparkScanFeedbackDelegateForEvents', {'viewId': _viewId});
    }
  }

  void showView() {
    methodChannel.invokeMethod('showSparkScanView', {
      'viewId': _viewId,
    }).onError(onError);
  }

  void hideView() {
    methodChannel.invokeMethod('hideSparkScanView', {
      'viewId': _viewId,
    }).onError(onError);
  }
}
