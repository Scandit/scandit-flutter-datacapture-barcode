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

import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_action_listener.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/internal/barcode_pick_consts.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_listener.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_product_provider.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_scanning_listener.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_scanning_session.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_session.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_settings.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_view_listener.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_view_settings.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_view_ui_listener.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/ui/barcode_pick_view_highlight_style.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/ui/barcode_pick_view_highlight_style_request.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/map_helper.dart';

class BarcodePickActionCallback {
  final _BarcodePickViewController _controller;
  final String _itemData;

  BarcodePickActionCallback._(this._controller, this._itemData);

  Future<void> didFinish(bool result) {
    return _controller.finishPickAction(_itemData, result);
  }
}

class BarcodePick implements Serializable {
  _BarcodePickViewController? _controller;
  final BarcodePickProductProvider _productProvider;

  final BarcodePickSettings _settings;
  // ignore: unused_field
  final DataCaptureContext _dataCaptureContext;

  BarcodePick._(this._dataCaptureContext, this._settings, this._productProvider);

  BarcodePick(
    DataCaptureContext dataCaptureContext,
    BarcodePickSettings settings,
    BarcodePickProductProvider productProvider,
  ) : this._(dataCaptureContext, settings, productProvider);

  final List<BarcodePickScanningListener> _scanningListeners = [];
  final List<BarcodePickListener> _listeners = [];
  static CameraSettings get recommendedCameraSettings => _recommendedCameraSettings();

  static CameraSettings _recommendedCameraSettings() {
    var defaults = BarcodePickDefaults.cameraSettingsDefaults;
    return CameraSettings(
      defaults.preferredResolution,
      defaults.zoomFactor,
      defaults.focusRange,
      defaults.focusGestureStrategy,
      defaults.zoomGestureZoomFactor,
      properties: defaults.properties,
      shouldPreferSmoothAutoFocus: defaults.shouldPreferSmoothAutoFocus,
    );
  }

  void addScanningListener(BarcodePickScanningListener listener) {
    _checkAndSubscribeListeners();
    if (_scanningListeners.contains(listener)) {
      return;
    }
    _scanningListeners.add(listener);
  }

  void _checkAndSubscribeListeners() {
    if (_scanningListeners.isEmpty) {
      _controller?.subscribeScanningListener();
    }
  }

  void removeScanningListener(BarcodePickScanningListener listener) {
    _scanningListeners.remove(listener);
    _checkAndUnsubscribeListeners();
  }

  void _checkAndUnsubscribeListeners() {
    if (_scanningListeners.isEmpty) {
      _controller?.unsubscribeScanningListener();
    }
  }

  void addListener(BarcodePickListener listener) {
    _checkAndSubscribeNativeListener();
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void _checkAndSubscribeNativeListener() {
    if (_listeners.isEmpty) {
      _controller?.subscribeBarcodePickListener();
    }
  }

  void removeListener(BarcodePickListener listener) {
    _listeners.remove(listener);
    _checkAndUnsubscribeNativeListener();
  }

  void _checkAndUnsubscribeNativeListener() {
    if (_listeners.isEmpty) {
      _controller?.unsubscribeBarcodePickListener();
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'barcodePick',
      'settings': _settings.toMap(),
      'ProductProvider': _productProvider.toMap(),
      'hasListeners': _listeners.isNotEmpty,
      'hasScanningListeners': _scanningListeners.isNotEmpty,
    };
  }

  void _dispose() {
    _productProvider.unsubscribeEvents();
    _controller?.unsubscribeBarcodePickListener();
    _listeners.clear();
    _scanningListeners.clear();
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

  _BarcodePickViewController? _controller;

  BarcodePickView._(this._dataCaptureContext, this._barcodePick, this._barcodPickViewSettings, this._cameraSettings)
      : super();

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
    return _controller?.start() ?? Future.value(null);
  }

  Future<void> freeze() {
    return _controller?.freeze() ?? Future.value(null);
  }

  Future<void> stop() {
    _isViewStarted = false;
    return _controller?.stop() ?? Future.value(null);
  }

  Future<void> release() {
    return _controller?.release() ?? Future.value(null);
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
      _controller?.addActionListener();
    }
    if (_actionListeners.contains(listener)) {
      return;
    }
    _actionListeners.add(listener);
  }

  void removeActionListener(BarcodePickActionListener listener) {
    _actionListeners.remove(listener);
    if (_actionListeners.isEmpty) {
      _controller?.removeActionListener();
    }
  }

  void addListener(BarcodePickViewListener listener) {
    if (_viewListeners.isEmpty) {
      _controller?.addViewListener();
    }
    if (_viewListeners.contains(listener)) {
      return;
    }
    _viewListeners.add(listener);
  }

  void removeListener(BarcodePickViewListener listener) {
    _viewListeners.remove(listener);
    if (_viewListeners.isEmpty) {
      _controller?.removeViewListener();
    }
  }

  BarcodePickViewUiListener? get uiListener {
    return _uiListener;
  }

  set uiListener(BarcodePickViewUiListener? newValue) {
    _uiListener = newValue;
    _controller?.addRemoveUiListener(newValue != null);
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

class _BarcodePickViewState extends State<BarcodePickView> {
  _BarcodePickViewState();

  late _BarcodePickViewController _controller;

  @override
  void initState() {
    super.initState();
    // initialize controller in initState to avoid multiple instances of the
    // controller in the same view
    _controller = _BarcodePickViewController(widget);
    widget._controller = _controller;
    widget._barcodePick._controller = _controller;
    widget._barcodePick._productProvider.subscribeEvents();
  }

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
    _controller.dispose();
    super.dispose();
  }
}

class _BarcodePickViewController {
  final MethodChannel channel = const MethodChannel(BarcodePickFunctionNames.methodsChannelName);

  StreamSubscription<dynamic>? viewEventsSubscription;

  final BarcodePickView view;

  _BarcodePickViewController(this.view) {
    _initialize();
  }

  void _initialize() {
    subscribeToEvents();

    if (view._barcodePick._listeners.isNotEmpty) {
      subscribeBarcodePickListener();
    }

    if (view._barcodePick._scanningListeners.isNotEmpty) {
      subscribeScanningListener();
    }
  }

  void subscribeToEvents() {
    viewEventsSubscription = BarcodePluginEvents.barcodePickEventStream.listen((event) {
      var eventJSON = jsonDecode(event) as Map<String, dynamic>;
      var eventName = eventJSON['event'] as String;
      switch (eventName) {
        case BarcodePickEventNames.actionDidPick:
          handleDidPick(eventJSON);
          break;
        case BarcodePickEventNames.actionDidUnpick:
          handleDidUnpick(eventJSON);
          break;
        case BarcodePickEventNames.viewDidFreezeScanning:
          notifyDidFreezeScanning();
          break;
        case BarcodePickEventNames.viewDidPauseScanning:
          notifyDidPauseScanning();
          break;
        case BarcodePickEventNames.viewDidStartScanning:
          notifyDidStartScanning();
          break;
        case BarcodePickEventNames.viewDidStopScanning:
          notifyDidStopScanning();
          break;
        case BarcodePickEventNames.viewUiDidTapFinishButton:
          view.uiListener?.didTapFinishButton(view);
          break;
        case BarcodePickEventNames.viewForRequest:
          handleViewForRequest(eventJSON);
          break;
        case BarcodePickEventNames.styleForRequest:
          handleStyleForRequest(eventJSON);
          break;
      }
    });
  }

  Future<void> handleViewForRequest(Map<String, dynamic> json) async {
    final requestId = num.parse(json['requestId']);
    final customView = view._barcodPickViewSettings.highlightStyle as BarcodePickViewHighlightStyleCustomView?;
    final response = await customView?.asyncCustomViewProvider
        ?.customViewForRequest(BarcodePickViewHighlightStyleRequest.fromJSON(json));
    channel.invokeMethod(
        BarcodePickFunctionNames.finishViewForRequest, {'requestId': requestId, 'response': response?.toMap()});
  }

  Future<void> handleStyleForRequest(Map<String, dynamic> json) async {
    final requestId = num.parse(json['requestId']);
    final dotWithIcons = view._barcodPickViewSettings.highlightStyle as BarcodePickViewHighlightStyleDotWithIcons?;
    final response =
        await dotWithIcons?.asyncStyleProvider?.styleForRequest(BarcodePickViewHighlightStyleRequest.fromJSON(json));
    channel.invokeMethod(BarcodePickFunctionNames.finishStyleForRequest,
        {'requestId': requestId, 'response': jsonEncodeOrNull(response)});
  }

  Future<void> start() {
    return channel.invokeMethod(BarcodePickFunctionNames.startPickView);
  }

  Future<void> stop() {
    return channel.invokeMethod(BarcodePickFunctionNames.stopPickView);
  }

  Future<void> freeze() {
    return channel.invokeMethod(BarcodePickFunctionNames.freezePickView);
  }

  Future<void> release() {
    return channel.invokeMethod(BarcodePickFunctionNames.releasePickView);
  }

  void addRemoveUiListener(bool add) {
    channel
        .invokeMethod(add ? BarcodePickFunctionNames.addViewUiListener : BarcodePickFunctionNames.removeViewUiListener)
        .onError(onError);
  }

  void addViewListener() {
    channel.invokeMethod(BarcodePickFunctionNames.addViewListener).onError(onError);
  }

  void removeViewListener() {
    channel.invokeMethod(BarcodePickFunctionNames.removeViewListener).onError(onError);
  }

  void addActionListener() {
    channel.invokeMethod(BarcodePickFunctionNames.addActionListener).onError(onError);
  }

  void removeActionListener() {
    channel.invokeMethod(BarcodePickFunctionNames.removeActionListener).onError(onError);
  }

  void handleDidPick(Map<String, dynamic> eventJson) {
    var itemData = eventJson['itemData'] as String;
    for (var listener in view._actionListeners) {
      listener.didPick(itemData, BarcodePickActionCallback._(this, itemData));
    }
  }

  void handleDidUnpick(Map<String, dynamic> eventJson) {
    var itemData = eventJson['itemData'] as String;
    for (var listener in view._actionListeners) {
      listener.didUnpick(itemData, BarcodePickActionCallback._(this, itemData));
    }
  }

  Future<void> finishPickAction(String itemData, bool result) {
    return channel.invokeMethod(
        BarcodePickFunctionNames.finishPickAction, jsonEncode({'itemData': itemData, 'result': result}));
  }

  void notifyDidFreezeScanning() {
    for (var listener in view._viewListeners) {
      listener.didFreezeScanning(view);
    }
  }

  void notifyDidPauseScanning() {
    for (var listener in view._viewListeners) {
      listener.didPauseScanning(view);
    }
  }

  void notifyDidStartScanning() {
    for (var listener in view._viewListeners) {
      listener.didStartScanning(view);
    }
  }

  void notifyDidStopScanning() {
    for (var listener in view._viewListeners) {
      listener.didStopScanning(view);
    }
  }

  // Mode Listeners

  StreamSubscription<dynamic>? subscriptionScanningListener;

  StreamSubscription<dynamic>? subscriptionBarcodePickListener;
  void subscribeScanningListener() {
    channel
        .invokeMethod(BarcodePickFunctionNames.addScanningListener)
        .then((value) => setupBarcodePickScanningListenerSubscription())
        .onError(onError);
  }

  void unsubscribeScanningListener() {
    subscriptionScanningListener?.cancel();
    subscriptionScanningListener = null;
    channel.invokeMethod(BarcodePickFunctionNames.removeScanningListener).onError(onError);
  }

  void setupBarcodePickScanningListenerSubscription() {
    if (subscriptionScanningListener != null) return;
    subscriptionScanningListener = BarcodePluginEvents.barcodePickEventStream.listen((event) {
      if (view._barcodePick._scanningListeners.isEmpty) return;

      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;

      if (eventName != BarcodePickEventNames.didCompleteScanningSession &&
          eventName != BarcodePickEventNames.didUpdateScanningSession) {
        return;
      }

      var session = BarcodePickScanningSession.fromJSON(jsonDecode(eventJSON['session']));

      if (eventName == BarcodePickEventNames.didCompleteScanningSession) {
        for (var listener in view._barcodePick._scanningListeners) {
          listener.didCompleteScanningSession(view._barcodePick, session);
        }
      } else if (eventName == BarcodePickEventNames.didUpdateScanningSession) {
        for (var listener in view._barcodePick._scanningListeners) {
          listener.didUpdateScanningSession(view._barcodePick, session);
        }
      }
    });
  }

  void subscribeBarcodePickListener() {
    channel
        .invokeMethod(BarcodePickFunctionNames.addBarcodePickListener)
        .then((value) => setupBarcodePickListenerSubscription())
        .onError(onError);
  }

  void unsubscribeBarcodePickListener() {
    subscriptionBarcodePickListener?.cancel();
    subscriptionBarcodePickListener = null;
    channel.invokeMethod(BarcodePickFunctionNames.removeBarcodePickListener).onError(onError);
  }

  void setupBarcodePickListenerSubscription() {
    if (subscriptionBarcodePickListener != null) return;
    subscriptionBarcodePickListener = BarcodePluginEvents.barcodePickEventStream.listen((event) {
      if (view._barcodePick._listeners.isEmpty) return;

      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;

      if (eventName != BarcodePickEventNames.didUpdateSession) {
        return;
      }

      var session = BarcodePickSession.fromJSON(jsonDecode(eventJSON['session']));

      for (var listener in view._barcodePick._listeners) {
        listener.didUpdateSession(view._barcodePick, session);
      }
    });
  }

  void onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }

  void dispose() {
    viewEventsSubscription?.cancel();
    viewEventsSubscription = null;
    subscriptionScanningListener?.cancel();
    subscriptionScanningListener = null;
    subscriptionBarcodePickListener?.cancel();
    subscriptionBarcodePickListener = null;
    view._barcodePick._dispose();
  }
}
