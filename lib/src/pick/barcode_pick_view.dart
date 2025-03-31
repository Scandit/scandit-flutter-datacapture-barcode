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

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode_plugin_events.dart';
import 'barcode_pick.dart';
import 'barcode_pick_function_names.dart';
import 'barcode_pick_view_settings.dart';

abstract class BarcodePickViewListener {
  static const _didStartScanning = 'BarcodePickViewListener.didStartScanning';
  static const _didFreezeScanning = 'BarcodePickViewListener.didFreezeScanning';
  static const _didPauseScanning = 'BarcodePickViewListener.didPauseScanning';
  static const _didStopScanning = 'BarcodePickViewListener.didStopScanning';

  void didStartScanning(BarcodePickView view);
  void didFreezeScanning(BarcodePickView view);
  void didPauseScanning(BarcodePickView view);
  void didStopScanning(BarcodePickView view);
}

abstract class BarcodePickViewUiListener {
  static const _didTapFinishButton = 'BarcodePickViewUiListener.didTapFinishButton';

  void didTapFinishButton(BarcodePickView view);
}

abstract class BarcodePickActionListener {
  static const _didPick = 'BarcodePickActionListener.didPick';
  static const _didUnpick = 'BarcodePickActionListener.didUnpick';

  void didPick(String itemData, BarcodePickActionCallback callback);
  void didUnpick(String itemData, BarcodePickActionCallback callback);
}

class BarcodePickActionCallback {
  final _BarcodePickViewController _controller;
  final String _itemData;

  BarcodePickActionCallback._(this._controller, this._itemData);

  Future<void> didFinish(bool result) {
    return _controller.finishPickAction(_itemData, result);
  }
}

// ignore: must_be_immutable
class BarcodePickView extends StatefulWidget implements Serializable {
  // We require that to exist doesn't mean it must be used here.
  // ignore: unused_field
  DataCaptureContext _dataCaptureContext;
  final BarcodePick _barcodePick;
  final BarcodePickViewSettings _barcodPickViewSettings;
  final CameraSettings? _cameraSettings;
  final List<BarcodePickActionListener> _actionListeners = [];
  final List<BarcodePickViewListener> _viewListeners = [];
  BarcodePickViewUiListener? _uiListener;
  bool _isViewStarted = false;

  late _BarcodePickViewController _controller;

  BarcodePickView._(this._dataCaptureContext, this._barcodePick, this._barcodPickViewSettings, this._cameraSettings)
      : super() {
    _controller = _BarcodePickViewController(this);
    _barcodePick.productProvider.subscribeEvents();
  }

  factory BarcodePickView.forModeWithViewSettings(
      DataCaptureContext dataCaptureContext, BarcodePick barcodePick, BarcodePickViewSettings viewSettings) {
    return BarcodePickView._(dataCaptureContext, barcodePick, viewSettings, null);
  }

  factory BarcodePickView.forModeWithViewSettingsAndCameraSettings(DataCaptureContext dataCaptureContext,
      BarcodePick barcodePick, BarcodePickViewSettings viewSettings, CameraSettings cameraSettings) {
    return BarcodePickView._(dataCaptureContext, barcodePick, viewSettings, cameraSettings);
  }

  @override
  State<StatefulWidget> createState() => _BarcodePickViewState();

  Future<void> start() {
    _isViewStarted = true;
    return _controller.start();
  }

  Future<void> freeze() {
    return _controller.freeze();
  }

  Future<void> stop() {
    _isViewStarted = false;
    return _controller.stop();
  }

  Future<void> release() {
    return _controller.release();
  }

  @Deprecated(
      'There is no longer a need to manually call the pause function. This function will be removed in future SDK versions.')
  Future<void> pause() {
    return Future.value(null);
  }

  @Deprecated(
      'There is no longer a need to manually call the resume function. This function will be removed in future SDK versions.')
  Future<void> resume() {
    return Future.value(null);
  }

  void addActionListener(BarcodePickActionListener listener) {
    if (_actionListeners.isEmpty) {
      _controller.addActionListener();
    }
    if (_actionListeners.contains(listener)) {
      return;
    }
    _actionListeners.add(listener);
  }

  void removeActionListener(BarcodePickActionListener listener) {
    _actionListeners.remove(listener);
    if (_actionListeners.isEmpty) {
      _controller.removeActionListener();
    }
  }

  void addListener(BarcodePickViewListener listener) {
    if (_viewListeners.isEmpty) {
      _controller.addViewListener();
    }
    if (_viewListeners.contains(listener)) {
      return;
    }
    _viewListeners.add(listener);
  }

  void removeListener(BarcodePickViewListener listener) {
    _viewListeners.remove(listener);
    if (_viewListeners.isEmpty) {
      _controller.removeViewListener();
    }
  }

  BarcodePickViewUiListener? get uiListener {
    return _uiListener;
  }

  set uiListener(BarcodePickViewUiListener? newValue) {
    _uiListener = newValue;
    _controller.addRemoveUiListener(newValue != null);
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'View': {
        'viewSettings': _barcodPickViewSettings.toMap(),
        'cameraSettings': _cameraSettings?.toMap(),
        'hasActionListeners': _actionListeners.isNotEmpty,
        'hasViewListeners': _viewListeners.isNotEmpty,
        'hasViewUiListener': uiListener != null,
        'isStarted': _isViewStarted,
      },
      'BarcodePick': _barcodePick.toMap()
    };

    return json;
  }
}

class _BarcodePickViewController {
  final MethodChannel _methodChannel = const MethodChannel(BarcodePickFunctionNames.methodsChannelName);

  StreamSubscription<dynamic>? _viewEventsSubscription;

  final BarcodePickView _view;

  _BarcodePickViewController(this._view) {
    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    _viewEventsSubscription = BarcodePluginEvents.barcodePickEventStream.listen((event) {
      var eventJSON = jsonDecode(event) as Map<String, dynamic>;
      var eventName = eventJSON['event'] as String;
      switch (eventName) {
        case BarcodePickActionListener._didPick:
          _handleDidPick(eventJSON);
          break;
        case BarcodePickActionListener._didUnpick:
          _handleDidUnpick(eventJSON);
          break;
        case BarcodePickViewListener._didFreezeScanning:
          _notifyDidFreezeScanning();
          break;
        case BarcodePickViewListener._didPauseScanning:
          _notifyDidPauseScanning();
          break;
        case BarcodePickViewListener._didStartScanning:
          _notifyDidStartScanning();
          break;
        case BarcodePickViewListener._didStopScanning:
          _notifyDidStopScanning();
          break;
        case BarcodePickViewUiListener._didTapFinishButton:
          _view.uiListener?.didTapFinishButton(_view);
          break;
      }
    });
  }

  Future<void> start() {
    return _methodChannel.invokeMethod(BarcodePickFunctionNames.startPickView);
  }

  Future<void> stop() {
    return _methodChannel.invokeMethod(BarcodePickFunctionNames.stopPickView);
  }

  Future<void> freeze() {
    return _methodChannel.invokeMethod(BarcodePickFunctionNames.freezePickView);
  }

  Future<void> release() {
    return _methodChannel.invokeMethod(BarcodePickFunctionNames.releasePickView);
  }

  void addRemoveUiListener(bool add) {
    _methodChannel
        .invokeMethod(add ? BarcodePickFunctionNames.addViewUiListener : BarcodePickFunctionNames.removeViewUiListener)
        .onError(_onError);
  }

  void addViewListener() {
    _methodChannel.invokeMethod(BarcodePickFunctionNames.addViewListener).onError(_onError);
  }

  void removeViewListener() {
    _methodChannel.invokeMethod(BarcodePickFunctionNames.removeViewListener).onError(_onError);
  }

  void addActionListener() {
    _methodChannel.invokeMethod(BarcodePickFunctionNames.addActionListener).onError(_onError);
  }

  void removeActionListener() {
    _methodChannel.invokeMethod(BarcodePickFunctionNames.removeActionListener).onError(_onError);
  }

  void _handleDidPick(Map<String, dynamic> eventJson) {
    var itemData = eventJson['itemData'] as String;
    for (var listener in _view._actionListeners) {
      listener.didPick(itemData, BarcodePickActionCallback._(this, itemData));
    }
  }

  void _handleDidUnpick(Map<String, dynamic> eventJson) {
    var itemData = eventJson['itemData'] as String;
    for (var listener in _view._actionListeners) {
      listener.didUnpick(itemData, BarcodePickActionCallback._(this, itemData));
    }
  }

  Future<void> finishPickAction(String itemData, bool result) {
    return _methodChannel.invokeMethod(
        BarcodePickFunctionNames.finishPickAction, jsonEncode({'itemData': itemData, 'result': result}));
  }

  void _notifyDidFreezeScanning() {
    for (var listener in _view._viewListeners) {
      listener.didFreezeScanning(_view);
    }
  }

  void _notifyDidPauseScanning() {
    for (var listener in _view._viewListeners) {
      listener.didPauseScanning(_view);
    }
  }

  void _notifyDidStartScanning() {
    for (var listener in _view._viewListeners) {
      listener.didStartScanning(_view);
    }
  }

  void _notifyDidStopScanning() {
    for (var listener in _view._viewListeners) {
      listener.didStopScanning(_view);
    }
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }

  void dispose() {
    _viewEventsSubscription?.cancel();
    _viewEventsSubscription = null;
    _view._barcodePick.productProvider.unsubscribeEvents();
  }
}

class _BarcodePickViewState extends State<BarcodePickView> {
  _BarcodePickViewState();

  @override
  Widget build(BuildContext context) {
    const viewType = 'com.scandit.BarcodePickView';

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
            creationParams: {'BarcodePickView': jsonEncode(widget.toMap())},
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
          return view;
        },
      );
    } else {
      return UiKitView(
        viewType: viewType,
        creationParams: {'BarcodePickView': jsonEncode(widget.toMap())},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {},
      );
    }
  }

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }
}
