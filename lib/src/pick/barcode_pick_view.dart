/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
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
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';

import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show
        BarcodePickActionListenerDidPick,
        BarcodePickActionListenerDidUnpick,
        BarcodePickListenerDidUpdateSession,
        buildBarcodePickView,
        BarcodePickScanningListenerDidCompleteScanningSession,
        BarcodePickScanningListenerDidUpdateScanningSession,
        BarcodePickViewHighlightStyleAsyncProviderStyleForRequest,
        BarcodePickViewHighlightStyleCustomViewProviderViewForRequest,
        BarcodePickViewListenerDidFreezeScanning,
        BarcodePickViewListenerDidPauseScanning,
        BarcodePickViewListenerDidStartScanning,
        BarcodePickViewListenerDidStopScanning,
        BarcodePickViewUiListenerDidTapFinishButton;
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_action.dart';
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
import 'package:scandit_flutter_datacapture_core/experimental.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/map_helper.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

/// Used by the user to confirm actions.
///
/// Added in version 6.22.0
class BarcodePickActionCallback {
  final _BarcodePickViewController _controller;
  final String _itemData;

  BarcodePickActionCallback._(this._controller, this._itemData);

  /// Invoke this method to provide the result of the action.
  ///
  /// - *response* If *true* the action is confirmed.
  ///
  /// Added in version 6.22.0
  Future<void> didFinish(bool result) {
    return _controller.finishPickAction(_itemData, result);
  }
}

/// Capture mode that implements barcode pick.
///
/// Added in version 6.22.0
class BarcodePick implements Serializable {
  _BarcodePickViewController? _controller;
  final BarcodePickProductProvider _productProvider;

  final BarcodePickSettings _settings;
  // ignore: unused_field
  final DataCaptureContext _dataCaptureContext;

  BarcodePick._(this._dataCaptureContext, this._settings, this._productProvider);

  /// Constructs a new [BarcodePick] instance:
  ///
  /// - *dataCaptureContext* A [DataCaptureContext]
  /// - *settings* An instance of [BarcodePickSettings] used to configure the mode.
  /// - *productProvider* The product provider responsible for retrieving and mapping products. Available product provider types: [[BarcodePickAsyncMapperProductProvider]]
  ///
  /// Added in version 6.22.0
  BarcodePick(
    DataCaptureContext dataCaptureContext,
    BarcodePickSettings settings,
    BarcodePickProductProvider productProvider,
  ) : this._(dataCaptureContext, settings, productProvider);

  final List<BarcodePickScanningListener> _scanningListeners = [];
  final List<BarcodePickListener> _listeners = [];

  /// Returns the recommended camera settings to use with the mode.
  ///
  /// Added in version 7.6.0
  static CameraSettings createRecommendedCameraSettings() {
    var defaults = BarcodePickDefaults.cameraSettingsDefaults;
    return CameraSettings(
      defaults.preferredResolution,
      defaults.zoomFactor,
      defaults.focusRange,
      defaults.focusGestureStrategy,
      defaults.zoomGestureZoomFactor,
      properties: defaults.properties,
      shouldPreferSmoothAutoFocus: defaults.shouldPreferSmoothAutoFocus,
      torchLevel: defaults.torchLevel,
      macroMode: defaults.macroMode,
      adaptiveExposure: defaults.adaptiveExposure,
    );
  }

  /// Adds a scanning listener to this [BarcodePick] instance.
  ///
  /// Added in version 6.22.0
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

  /// Removes the scanning listener from this [BarcodePick] instance.
  ///
  /// Added in version 6.22.0
  void removeScanningListener(BarcodePickScanningListener listener) {
    _scanningListeners.remove(listener);
    _checkAndUnsubscribeListeners();
  }

  void _checkAndUnsubscribeListeners() {
    if (_scanningListeners.isEmpty) {
      _controller?.unsubscribeScanningListener();
    }
  }

  /// Adds a listener to this [BarcodePick] instance.
  ///
  /// Added in version 7.3.0
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

  /// Removes the listener from this [BarcodePick] instance.
  ///
  /// Added in version 7.3.0
  void removeListener(BarcodePickListener listener) {
    _listeners.remove(listener);
    _checkAndUnsubscribeNativeListener();
  }

  void _checkAndUnsubscribeNativeListener() {
    if (_listeners.isEmpty) {
      _controller?.unsubscribeBarcodePickListener();
    }
  }

  /// Added in version 8.5.0
  Future<BarcodePickAction> selectItemWithData(String data) async {
    final controller = _controller;
    if (controller == null) {
      return BarcodePickAction.none;
    }
    return controller.selectItemWithData(data);
  }

  /// Added in version 8.5.0
  Future<void> confirmActionForItemWithData(String data) async {
    return _controller?.confirmActionForItemWithData(data) ?? Future.value();
  }

  /// Added in version 8.5.0
  Future<void> cancelActionForItemWithData(String data) async {
    return _controller?.cancelActionForItemWithData(data) ?? Future.value();
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

/// BarcodePickView.
///
/// Added in version 6.22.0
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
  int _viewId = 0;

  _BarcodePickViewController? _controller;

  BarcodePickView._(this._dataCaptureContext, this._barcodePick, this._barcodPickViewSettings, this._cameraSettings)
      : super();

  factory BarcodePickView.forModeWithViewSettings(
    DataCaptureContext dataCaptureContext,
    BarcodePick barcodePick,
    BarcodePickViewSettings viewSettings,
  ) {
    return BarcodePickView._(dataCaptureContext, barcodePick, viewSettings, null);
  }

  /// Initializes a BarcodePickView
  ///
  /// Added in version 6.22.0
  factory BarcodePickView.forModeWithViewSettingsAndCameraSettings(
    DataCaptureContext dataCaptureContext,
    BarcodePick barcodePick,
    BarcodePickViewSettings viewSettings,
    CameraSettings cameraSettings,
  ) {
    return BarcodePickView._(dataCaptureContext, barcodePick, viewSettings, cameraSettings);
  }

  /// Implemented from [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html). Called by the Flutter framework.
  ///
  /// Added in version 6.22.0
  @override
  State<StatefulWidget> createState() => _BarcodePickViewState();

  /// Starts the camera and the scanning process. Can be stopped by calling [BarcodePickView.stop].
  ///
  /// Added in version 6.22.0
  Future<void> start() {
    _isViewStarted = true;
    return _controller?.start() ?? Future.value(null);
  }

  /// Resets the picking flow. This will clear all picked items and restore the initial state.
  ///
  /// Added in version 8.2.0
  Future<void> reset() {
    return _controller?.reset() ?? Future.value(null);
  }

  /// Freezes the camera and the highlights position to make the selection easier. The scanning can be started again using [BarcodePickView.start].
  ///
  /// Added in version 6.22.0
  Future<void> freeze() {
    return _controller?.freeze() ?? Future.value(null);
  }

  /// Pauses the camera and the scanning process. It can be started again using [BarcodePickView.start].
  ///
  /// Added in version 6.24.0
  Future<void> stop() {
    _isViewStarted = false;
    return _controller?.stop() ?? Future.value(null);
  }

  /// Stops the camera and the scanning process. After this call the view should not be used anymore.
  ///
  /// For instance, this method could be called in the Widget’s *dispose* function to release the scanning objects.
  ///
  /// Added in version 6.22.0
  Future<void> release() {
    return _controller?.release() ?? Future.value(null);
  }

  /// Adds a [BarcodePickActionListener] to the mode. User actions will be notified to the listener.
  ///
  /// Added in version 6.22.0
  void addActionListener(BarcodePickActionListener listener) {
    if (_actionListeners.isEmpty) {
      _controller?.addActionListener();
    }
    if (_actionListeners.contains(listener)) {
      return;
    }
    _actionListeners.add(listener);
  }

  /// Removes a [BarcodePickActionListener].
  ///
  /// Added in version 6.22.0
  void removeActionListener(BarcodePickActionListener listener) {
    _actionListeners.remove(listener);
    if (_actionListeners.isEmpty) {
      _controller?.removeActionListener();
    }
  }

  /// Adds a [BarcodePickViewListener] to the mode. User actions will be notified to the listener.
  ///
  /// Added in version 6.22.0
  void addListener(BarcodePickViewListener listener) {
    if (_viewListeners.isEmpty) {
      _controller?.addViewListener();
    }
    if (_viewListeners.contains(listener)) {
      return;
    }
    _viewListeners.add(listener);
  }

  /// Removes a [BarcodePickViewListener].
  ///
  /// Added in version 6.22.0
  void removeListener(BarcodePickViewListener listener) {
    _viewListeners.remove(listener);
    if (_viewListeners.isEmpty) {
      _controller?.removeViewListener();
    }
  }

  /// Sets the listener which is called whenever the finish button is tapped from the view.
  ///
  /// Added in version 6.22.0
  BarcodePickViewUiListener? get uiListener {
    return _uiListener;
  }

  /// Sets the listener which is called whenever the finish button is tapped from the view.
  ///
  /// Added in version 6.22.0
  set uiListener(BarcodePickViewUiListener? newValue) {
    _uiListener = newValue;
    _controller?.addRemoveUiListener(newValue != null);
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'View': buildBarcodePickView(
        viewSettings: _barcodPickViewSettings.toMap(),
        cameraSettings: _cameraSettings?.toMap(),
        hasActionListeners: _actionListeners.isNotEmpty,
        hasViewListeners: _viewListeners.isNotEmpty,
        hasViewUiListener: uiListener != null,
        isStarted: _isViewStarted,
        viewId: _viewId,
      ),
      'BarcodePick': _barcodePick.toMap(),
    };

    return json;
  }
}

// ignore: experimental_member_use
class _BarcodePickViewState extends State<BarcodePickView> implements CameraOwner {
  final int _viewId = Random().nextInt(0x7FFFFFFF);

  late _BarcodePickViewController _controller;
  bool _isRouteActive = true;

  @override
  String get id => 'barcode-pick-view-$_viewId';

  _BarcodePickViewState();

  @override
  void initState() {
    super.initState();
    // initialize controller in initState to avoid multiple instances of the
    // controller in the same view
    widget._viewId = _viewId;
    _controller = _BarcodePickViewController(widget);
    widget._controller = _controller;
    widget._barcodePick._controller = _controller;
    widget._barcodePick._productProvider.subscribeEvents();
    widget._barcodePick._productProvider.setViewId(_viewId);
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

class _BarcodePickViewController extends BaseController {
  StreamSubscription<dynamic>? viewEventsSubscription;
  late final BarcodeMethodHandler barcodeMethodHandler;

  final BarcodePickView view;

  _BarcodePickViewController(this.view) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
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

    if (view._actionListeners.isNotEmpty) {
      addActionListener();
    }

    if (view._viewListeners.isNotEmpty) {
      addViewListener();
    }

    if (view._uiListener != null) {
      addRemoveUiListener(true);
    }
  }

  void subscribeToEvents() {
    if (viewEventsSubscription != null) return;

    viewEventsSubscription = BarcodePluginEvents.barcodePickEventStream.forView(view._viewId).listen((event) {
      if (event.isEvent(BarcodePickEventNames.actionDidPick)) {
        handleDidPick(event.payload);
      } else if (event.isEvent(BarcodePickEventNames.actionDidUnpick)) {
        handleDidUnpick(event.payload);
      } else if (event.isEvent(BarcodePickEventNames.viewDidFreezeScanning)) {
        BarcodePickViewListenerDidFreezeScanning.fromJson(event.payload);
        notifyDidFreezeScanning();
      } else if (event.isEvent(BarcodePickEventNames.viewDidPauseScanning)) {
        BarcodePickViewListenerDidPauseScanning.fromJson(event.payload);
        notifyDidPauseScanning();
      } else if (event.isEvent(BarcodePickEventNames.viewDidStartScanning)) {
        BarcodePickViewListenerDidStartScanning.fromJson(event.payload);
        notifyDidStartScanning();
      } else if (event.isEvent(BarcodePickEventNames.viewDidStopScanning)) {
        BarcodePickViewListenerDidStopScanning.fromJson(event.payload);
        notifyDidStopScanning();
      } else if (event.isEvent(BarcodePickEventNames.viewUiDidTapFinishButton)) {
        BarcodePickViewUiListenerDidTapFinishButton.fromJson(event.payload);
        view.uiListener?.didTapFinishButton(view);
      } else if (event.isEvent(BarcodePickEventNames.viewForRequest)) {
        handleViewForRequest(event.payload);
      } else if (event.isEvent(BarcodePickEventNames.styleForRequest)) {
        handleStyleForRequest(event.payload);
      }
    });
  }

  Future<void> handleViewForRequest(Map<String, dynamic> json) async {
    final payload = BarcodePickViewHighlightStyleCustomViewProviderViewForRequest.fromJson(json);
    final highlightStyle = view._barcodPickViewSettings.highlightStyle;
    // `is` rather than `as ...?`: a style that exposes no custom-view provider must degrade to
    // "no provider" (and still ack below), not throw an unhandled async TypeError.
    BarcodePickViewHighlightStyleCustomViewProvider? customViewProvider;
    if (highlightStyle is BarcodePickViewHighlightStyleCustomView) {
      customViewProvider = highlightStyle.asyncCustomViewProvider;
    }
    final response = await customViewProvider?.customViewForRequest(
      BarcodePickViewHighlightStyleRequest.fromJSON(jsonDecode(payload.request) as Map<String, dynamic>),
    );
    await barcodeMethodHandler.finishBarcodePickViewHighlightStyleCustomViewProviderViewForRequest(
      viewId: view._viewId,
      requestId: payload.requestId,
      responseJson: response != null ? jsonEncode(response.toMap()) : null,
    );
  }

  Future<void> handleStyleForRequest(Map<String, dynamic> json) async {
    final payload = BarcodePickViewHighlightStyleAsyncProviderStyleForRequest.fromJson(json);
    final highlightStyle = view._barcodPickViewSettings.highlightStyle;
    // Both DotWithIcons and RectangularWithIcons expose an async style provider, and they are
    // unrelated types — so resolve with `is` from either, mirroring the TS handler. Casting to
    // DotWithIcons alone threw a TypeError for a RectangularWithIcons style; that was unreachable
    // only because this handler used to die on `num.parse(json['requestId'])` before reaching it.
    BarcodePickViewHighlightStyleAsyncProvider? asyncStyleProvider;
    if (highlightStyle is BarcodePickViewHighlightStyleDotWithIcons) {
      asyncStyleProvider = highlightStyle.asyncStyleProvider;
    } else if (highlightStyle is BarcodePickViewHighlightStyleRectangularWithIcons) {
      asyncStyleProvider = highlightStyle.asyncStyleProvider;
    }
    final response = await asyncStyleProvider?.styleForRequest(
      BarcodePickViewHighlightStyleRequest.fromJSON(jsonDecode(payload.request) as Map<String, dynamic>),
    );

    await barcodeMethodHandler.finishBarcodePickViewHighlightStyleAsyncProviderStyleForRequest(
      viewId: view._viewId,
      requestId: payload.requestId,
      responseJson: jsonEncodeOrNull(response),
    );
  }

  Future<void> start() {
    return barcodeMethodHandler.pickViewStart(viewId: view._viewId);
  }

  Future<void> stop() {
    return barcodeMethodHandler.pickViewStop(viewId: view._viewId);
  }

  Future<void> freeze() {
    return barcodeMethodHandler.pickViewFreeze(viewId: view._viewId);
  }

  Future<void> reset() {
    return barcodeMethodHandler.pickViewReset(viewId: view._viewId);
  }

  Future<void> release() {
    return barcodeMethodHandler.pickViewRelease(viewId: view._viewId);
  }

  Future<BarcodePickAction> selectItemWithData(String data) async {
    final result = await barcodeMethodHandler.selectItemWithData(viewId: view._viewId, data: data);
    return BarcodePickAction.fromJSON(result);
  }

  Future<void> confirmActionForItemWithData(String data) {
    return barcodeMethodHandler.confirmActionForItemWithData(viewId: view._viewId, data: data);
  }

  Future<void> cancelActionForItemWithData(String data) {
    return barcodeMethodHandler.cancelActionForItemWithData(viewId: view._viewId, data: data);
  }

  void addRemoveUiListener(bool add) {
    if (add) {
      barcodeMethodHandler.registerBarcodePickViewUiListener(viewId: view._viewId).onError(onError);
    } else {
      barcodeMethodHandler.unregisterBarcodePickViewUiListener(viewId: view._viewId).onError(onError);
    }
  }

  void addViewListener() {
    barcodeMethodHandler.addPickViewListener(viewId: view._viewId).onError(onError);
  }

  void removeViewListener() {
    barcodeMethodHandler.removePickViewListener(viewId: view._viewId).onError(onError);
  }

  void addActionListener() {
    barcodeMethodHandler.addPickActionListener(viewId: view._viewId).onError(onError);
  }

  void removeActionListener() {
    barcodeMethodHandler.removePickActionListener(viewId: view._viewId).onError(onError);
  }

  // Session payloads validate tolerantly, matching BarcodeCount: the pre-migration handlers
  // read `session` and tolerated anything else on the map, so a payload that fails validation
  // is logged and its session passed through rather than thrown. Every other pick event on the
  // Flutter side validates strictly.
  String _sessionJsonTolerantly(Map<String, dynamic> payload, String Function(Object?) extract, String event) {
    try {
      return extract(payload);
    } catch (error) {
      dev.log('BarcodePick $event payload failed schema validation: $error');
      return payload['session'] as String;
    }
  }

  void handleDidPick(Map<String, dynamic> eventJson) {
    var itemData = BarcodePickActionListenerDidPick.fromJson(eventJson).itemData;
    for (var listener in view._actionListeners.toList()) {
      listener.didPick(itemData, BarcodePickActionCallback._(this, itemData));
    }
  }

  void handleDidUnpick(Map<String, dynamic> eventJson) {
    var itemData = BarcodePickActionListenerDidUnpick.fromJson(eventJson).itemData;
    for (var listener in view._actionListeners.toList()) {
      listener.didUnpick(itemData, BarcodePickActionCallback._(this, itemData));
    }
  }

  Future<void> finishPickAction(String itemData, bool result) {
    return barcodeMethodHandler.finishPickAction(viewId: view._viewId, itemData: itemData, actionResult: result);
  }

  void notifyDidFreezeScanning() {
    for (var listener in view._viewListeners.toList()) {
      listener.didFreezeScanning(view);
    }
  }

  void notifyDidPauseScanning() {
    for (var listener in view._viewListeners.toList()) {
      listener.didPauseScanning(view);
    }
  }

  void notifyDidStartScanning() {
    for (var listener in view._viewListeners.toList()) {
      listener.didStartScanning(view);
    }
  }

  void notifyDidStopScanning() {
    for (var listener in view._viewListeners.toList()) {
      listener.didStopScanning(view);
    }
  }

  // Mode Listeners

  StreamSubscription<dynamic>? subscriptionScanningListener;

  StreamSubscription<dynamic>? subscriptionBarcodePickListener;
  void subscribeScanningListener() {
    barcodeMethodHandler
        .addBarcodePickScanningListener(viewId: view._viewId)
        .then((value) => setupBarcodePickScanningListenerSubscription())
        .onError(onError);
  }

  void unsubscribeScanningListener() {
    subscriptionScanningListener?.cancel();
    subscriptionScanningListener = null;
    barcodeMethodHandler.removeBarcodePickScanningListener(viewId: view._viewId).onError(onError);
  }

  void setupBarcodePickScanningListenerSubscription() {
    if (subscriptionScanningListener != null) return;
    subscriptionScanningListener = BarcodePluginEvents.barcodePickEventStream.asFlutterEvents().listen((event) {
      if (view._barcodePick._scanningListeners.isEmpty) return;

      if (!event.isEvent(BarcodePickEventNames.didCompleteScanningSession) &&
          !event.isEvent(BarcodePickEventNames.didUpdateScanningSession)) {
        return;
      }

      final isCompleteSession = event.isEvent(BarcodePickEventNames.didCompleteScanningSession);
      final sessionJson = _sessionJsonTolerantly(
        event.payload,
        isCompleteSession
            ? (raw) => BarcodePickScanningListenerDidCompleteScanningSession.fromJson(raw).session
            : (raw) => BarcodePickScanningListenerDidUpdateScanningSession.fromJson(raw).session,
        isCompleteSession ? 'didCompleteScanningSession' : 'didUpdateScanningSession',
      );
      var session = BarcodePickScanningSession.fromJSON(jsonDecode(sessionJson));

      if (event.isEvent(BarcodePickEventNames.didCompleteScanningSession)) {
        for (var listener in view._barcodePick._scanningListeners.toList()) {
          listener.didCompleteScanningSession(view._barcodePick, session);
        }
      } else if (event.isEvent(BarcodePickEventNames.didUpdateScanningSession)) {
        for (var listener in view._barcodePick._scanningListeners.toList()) {
          listener.didUpdateScanningSession(view._barcodePick, session);
        }
      }
    });
  }

  void subscribeBarcodePickListener() {
    barcodeMethodHandler
        .addBarcodePickListener(viewId: view._viewId)
        .then((value) => setupBarcodePickListenerSubscription())
        .onError(onError);
  }

  void unsubscribeBarcodePickListener() {
    subscriptionBarcodePickListener?.cancel();
    subscriptionBarcodePickListener = null;
    barcodeMethodHandler.removeBarcodePickListener(viewId: view._viewId).onError(onError);
  }

  void setupBarcodePickListenerSubscription() {
    if (subscriptionBarcodePickListener != null) return;
    subscriptionBarcodePickListener = BarcodePluginEvents.barcodePickEventStream.asFlutterEvents().listen((event) {
      if (view._barcodePick._listeners.isEmpty) return;

      if (!event.isEvent(BarcodePickEventNames.didUpdateSession)) {
        return;
      }

      final sessionJson = _sessionJsonTolerantly(
        event.payload,
        (raw) => BarcodePickListenerDidUpdateSession.fromJson(raw).session,
        'didUpdateSession',
      );
      var session = BarcodePickSession.fromJSON(jsonDecode(sessionJson));

      for (var listener in view._barcodePick._listeners.toList()) {
        listener.didUpdateSession(view._barcodePick, session);
      }
    });
  }

  @override
  void dispose() {
    viewEventsSubscription?.cancel();
    viewEventsSubscription = null;
    unsubscribeScanningListener();
    unsubscribeBarcodePickListener();
    view._barcodePick._dispose();
    super.dispose();
  }
}
