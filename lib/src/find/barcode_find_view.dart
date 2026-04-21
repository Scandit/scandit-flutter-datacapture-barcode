/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_constants.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_feedback.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_item.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_listener.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_settings.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_transformer.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_view_ui_listener.dart';
import 'package:scandit_flutter_datacapture_core/experimental.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

import 'barcode_find_view_settings.dart';

// ignore: must_be_immutable
class BarcodeFindView extends StatefulWidget implements Serializable {
  // We require that to exist doesn't mean it must be used here.
  // ignore: unused_field
  final DataCaptureContext _dataCaptureContext;
  final BarcodeFind _barcodeFind;
  final BarcodeFindViewSettings? _barcodeFindViewSettings;
  final CameraSettings? _cameraSettings;
  var _startSearching = false;
  int _viewId = -1;

  _BarcodeFindViewController? _controller;

  bool _isInitialized = false;

  BarcodeFindView._(this._dataCaptureContext, this._barcodeFind, this._barcodeFindViewSettings, this._cameraSettings)
      : super();

  factory BarcodeFindView.forMode(DataCaptureContext dataCaptureContext, BarcodeFind barcodeFind) {
    return BarcodeFindView._(dataCaptureContext, barcodeFind, null, null);
  }

  factory BarcodeFindView.forModeWithViewSettings(
    DataCaptureContext dataCaptureContext,
    BarcodeFind barcodeFind,
    BarcodeFindViewSettings viewSettings,
  ) {
    return BarcodeFindView._(dataCaptureContext, barcodeFind, viewSettings, null);
  }

  factory BarcodeFindView.forModeWithViewSettingsAndCameraSettings(
    DataCaptureContext dataCaptureContext,
    BarcodeFind barcodeFind,
    BarcodeFindViewSettings viewSettings,
    CameraSettings cameraSettings,
  ) {
    return BarcodeFindView._(dataCaptureContext, barcodeFind, viewSettings, cameraSettings);
  }

  @override
  State<StatefulWidget> createState() => _BarcodeFindViewState();

  Future<void> stopSearching() {
    _startSearching = false;
    return _controller?.stopViewSearching() ?? Future.value();
  }

  Future<void> startSearching() {
    _startSearching = true;
    return _controller?.startViewSearching() ?? Future.value();
  }

  Future<void> pauseSearching() {
    _startSearching = false;
    return _controller?.pauseViewSearching() ?? Future.value();
  }

  BarcodeFindViewUiListener? _barcodeFindViewUiListener;

  BarcodeFindViewUiListener? get uiListener => _barcodeFindViewUiListener;

  set uiListener(BarcodeFindViewUiListener? newValue) {
    _barcodeFindViewUiListener = newValue;
    _controller?.setUiListener(newValue);
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
    return _controller?.updateView() ?? Future.value();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'View': {
        'viewId': _viewId,
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
        'hasListener': _barcodeFindViewUiListener != null,
      },
      'BarcodeFind': _barcodeFind.toMap(),
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

class BarcodeFind extends DataCaptureMode {
  BarcodeFindFeedback _feedback = BarcodeFindFeedback.defaultFeedback;
  bool _enabled = true;
  BarcodeFindSettings _settings;
  final List<BarcodeFindListener> _listeners = [];

  BarcodeFindTransformer? _barcodeTransformer;

  _BarcodeFindViewController? _controller;

  Set<BarcodeFindItem> _itemsToFind = {};

  BarcodeFind._(this._settings) {
    _feedback.addListener(_updateFeedbackHandler);
  }

  void _updateFeedbackHandler() {
    _controller?.updateFeedback();
  }

  BarcodeFind(BarcodeFindSettings settings) : this._(settings);

  static CameraSettings createRecommendedCameraSettings() {
    var defaults = BarcodeFindDefaults.cameraSettingsDefaults;
    return CameraSettings(
      defaults.preferredResolution,
      defaults.zoomFactor,
      defaults.focusRange,
      defaults.focusGestureStrategy,
      defaults.zoomGestureZoomFactor,
      shouldPreferSmoothAutoFocus: defaults.shouldPreferSmoothAutoFocus,
      properties: defaults.properties,
    );
  }

  BarcodeFindFeedback get feedback => _feedback;

  set feedback(BarcodeFindFeedback newValue) {
    // Remove old listener
    _feedback.removeListener(_updateFeedbackHandler);
    _feedback = newValue;
    // Add new listener
    _feedback.addListener(_updateFeedbackHandler);
    // Update feedback
    _controller?.updateFeedback();
  }

  Future<void> applySettings(BarcodeFindSettings settings) {
    _settings = settings;
    return _didChange();
  }

  void addListener(BarcodeFindListener listener) {
    _checkAndSubscribeListeners();
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void _checkAndSubscribeListeners() {
    if (_listeners.isEmpty && _listeners.isEmpty) {
      _controller?.subscribeModeListeners();
    }
  }

  void removeListener(BarcodeFindListener listener) {
    _listeners.remove(listener);
    _checkAndUnsubscribeListeners();
  }

  void _checkAndUnsubscribeListeners() {
    if (_listeners.isEmpty && _listeners.isEmpty) {
      _controller?.unsubscribeModeListeners();
    }
  }

  Future<void> setItemList(Set<BarcodeFindItem> items) {
    _itemsToFind = items;
    return _controller?.setItemList(items) ?? Future.value();
  }

  Future<void> start() {
    return _controller?.modeStart() ?? Future.value();
  }

  Future<void> pause() {
    return _controller?.modePause() ?? Future.value();
  }

  Future<void> stop() {
    return _controller?.modeStop() ?? Future.value();
  }

  Future<void> _didChange() {
    return _controller?.updateMode() ?? Future.value();
  }

  Future<void> setBarcodeTransformer(BarcodeFindTransformer barcodeTransformer) {
    _barcodeTransformer = barcodeTransformer;
    return _controller?.setBarcodeTransformer() ?? Future.value();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'barcodeFind',
      'feedback': _feedback.toMap(),
      'settings': _settings.toMap(),
      'itemsToFind': jsonEncode(_itemsToFind.map((e) => e.toMap()).toList()),
      'hasBarcodeTransformer': _barcodeTransformer != null,
      'hasListeners': _listeners.isNotEmpty,
    };

    return json;
  }

  @override
  bool get isEnabled => _enabled;

  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    _controller?.setModeEnabledState(newValue);
  }
}

class _BarcodeFindViewController extends BaseController {
  StreamSubscription<dynamic>? _viewEventsSubscription;

  final BarcodeFindView view;

  _BarcodeFindViewController(this.view) : super(BarcodeFindConstants.methodsChannelName) {
    initialize();
  }

  void initialize() {
    if (view.uiListener != null) {
      subscribeToViewEvents();
    }

    if (view._barcodeFind._listeners.isNotEmpty) {
      subscribeModeListenersEvents();
    }

    if (view._barcodeFind._barcodeTransformer != null) {
      subscribeBarcodeTransformerEvents();
    }
  }

  void subscribeToViewEvents() {
    if (_viewEventsSubscription != null) {
      return;
    }

    _viewEventsSubscription = BarcodePluginEvents.barcodeFindEventStream.listen((event) {
      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;
      switch (eventName) {
        case BarcodeFindConstants.onFinishButtonTappedEventName:
          _handleOnFinishButtonTapped(eventJSON);
          break;
      }
    });
  }

  void unsubscribeFromViewEvents() {
    _viewEventsSubscription?.cancel();
    _viewEventsSubscription = null;
  }

  void _handleOnFinishButtonTapped(Map<String, dynamic> json) {
    var foundItemsData = List.from(json['foundItems']);
    var foundItems = foundItemsData
        .map((e) => view._barcodeFind._itemsToFind.firstWhere((element) => element.searchOptions.barcodeData == e))
        .toSet();
    view._barcodeFindViewUiListener?.didTapFinishButton(foundItems);
  }

  Future<void> updateView() {
    return methodChannel.invokeMethod(BarcodeFindConstants.updateFindView, {
      'viewId': view._viewId,
      'barcodeFindViewJson': jsonEncode(view.toMap()),
    });
  }

  Future<void> stopViewSearching() {
    return methodChannel.invokeMethod(BarcodeFindConstants.barcodeFindViewStopSearching, {'viewId': view._viewId});
  }

  Future<void> setItemList(Set<BarcodeFindItem> items) {
    return methodChannel.invokeMethod(BarcodeFindConstants.barcodeFindSetItemList, {
      'viewId': view._viewId,
      'itemsJson': jsonEncode(items.map((e) => e.toMap()).toList()),
    });
  }

  Future<void> startViewSearching() {
    return methodChannel.invokeMethod(BarcodeFindConstants.barcodeFindViewStartSearching, {'viewId': view._viewId});
  }

  Future<void> pauseViewSearching() {
    return methodChannel.invokeMethod(BarcodeFindConstants.barcodeFindViewPauseSearching);
  }

  void setUiListener(BarcodeFindViewUiListener? listener) {
    var methodToInvoke = listener != null
        ? BarcodeFindConstants.registerBarcodeFindViewListener
        : BarcodeFindConstants.unregisterBarcodeFindViewListener;

    if (listener != null) {
      subscribeToViewEvents();
    } else {
      unsubscribeFromViewEvents();
    }

    methodChannel.invokeMethod(methodToInvoke, {'viewId': view._viewId}).then((value) => null, onError: onError);
  }

  // Mode

  StreamSubscription<dynamic>? _modeEventsSubscription;
  StreamSubscription<dynamic>? _barcodeTransformerSubscription;

  Future<void> updateMode() {
    return methodChannel.invokeMethod(BarcodeFindConstants.updateFindMode, {
      'viewId': view._viewId,
      'barcodeFindJson': jsonEncode(view._barcodeFind.toMap()),
    }).then((value) => null, onError: onError);
  }

  Future<void> modeStart() {
    return methodChannel.invokeMethod(
        BarcodeFindConstants.barcodeFindModeStart, {'viewId': view._viewId}).then((value) => null, onError: onError);
  }

  Future<void> modePause() {
    return methodChannel.invokeMethod(
        BarcodeFindConstants.barcodeFindModePause, {'viewId': view._viewId}).then((value) => null, onError: onError);
  }

  Future<void> modeStop() {
    return methodChannel.invokeMethod(
        BarcodeFindConstants.barcodeFindModeStop, {'viewId': view._viewId}).then((value) => null, onError: onError);
  }

  void subscribeModeListeners() {
    methodChannel
        .invokeMethod(BarcodeFindConstants.registerBarcodeFindListener, {'viewId': view._viewId})
        .then((value) => subscribeModeListenersEvents())
        .onError(onError);
  }

  void subscribeModeListenersEvents() {
    if (_modeEventsSubscription != null) {
      return;
    }

    _modeEventsSubscription = BarcodePluginEvents.barcodeFindEventStream.listen((event) {
      var eventJSON = jsonDecode(event) as Map<String, dynamic>;
      var eventName = eventJSON['event'] as String;
      if (eventName == BarcodeFindConstants.onTransformBarcodeData) {
        // handled separately
        return;
      }

      if (eventName == BarcodeFindConstants.onSearchStartedEvent) {
        for (var listener in view._barcodeFind._listeners) {
          listener.didStartSearch();
        }
        return;
      }

      Set<BarcodeFindItem> foundItems = <BarcodeFindItem>{};

      if (eventJSON.containsKey('foundItems')) {
        var foundItemsData = List.from(eventJSON['foundItems']);
        foundItems = foundItemsData
            .map((e) => view._barcodeFind._itemsToFind.firstWhere((element) => element.searchOptions.barcodeData == e))
            .toSet();
      }

      for (var listener in view._barcodeFind._listeners) {
        if (eventName == BarcodeFindConstants.onSearchPausedEvent) {
          listener.didPauseSearch(foundItems);
        } else if (eventName == BarcodeFindConstants.onSearchStoppedEvent) {
          listener.didStopSearch(foundItems);
        }
      }
    });
  }

  void setModeEnabledState(bool newValue) {
    methodChannel.invokeMethod(BarcodeFindConstants.setModeEnabledState,
        {'viewId': view._viewId, 'enabled': newValue}).then((value) => null, onError: onError);
  }

  Future<void> updateFeedback() {
    return methodChannel.invokeMethod(BarcodeFindConstants.updateFeedback, {
      'viewId': view._viewId,
      'feedbackJson': jsonEncode(view._barcodeFind.feedback.toMap()),
    });
  }

  void unsubscribeModeListeners() {
    _modeEventsSubscription?.cancel();
    _modeEventsSubscription = null;
    methodChannel.invokeMethod(BarcodeFindConstants.unregisterBarcodeFindListener, {'viewId': view._viewId}).then(
        (value) => null,
        onError: onError);
  }

  Future<void> setBarcodeTransformer() {
    return methodChannel.invokeMethod(BarcodeFindConstants.setBarcodeTransformer, {'viewId': view._viewId}).then(
        (value) => subscribeBarcodeTransformerEvents(),
        onError: onError);
  }

  void subscribeBarcodeTransformerEvents() {
    if (_barcodeTransformerSubscription != null) {
      return;
    }

    _barcodeTransformerSubscription = BarcodePluginEvents.barcodeFindEventStream.listen((event) {
      var eventJSON = jsonDecode(event) as Map<String, dynamic>;
      var eventName = eventJSON['event'] as String;
      if (eventName == BarcodeFindConstants.onTransformBarcodeData) {
        var data = eventJSON['data'] as String?;
        var result = view._barcodeFind._barcodeTransformer?.transformBarcodeData(data);
        methodChannel.invokeMethod(BarcodeFindConstants.submitBarcodeTransformerResult, {
          'viewId': view._viewId,
          'transformedBarcode': result,
        }).onError(onError);
      }
    });
  }

  @override
  void dispose() {
    unsubscribeModeListeners();
    unsubscribeFromViewEvents();
    _barcodeTransformerSubscription?.cancel();
    _barcodeTransformerSubscription = null;
    super.dispose();
  }
}

class _BarcodeFindViewState extends State<BarcodeFindView> implements CameraOwner {
  _BarcodeFindViewState();

  final _viewId = Random().nextInt(0x7FFFFFFF);
  bool _isRouteActive = true;

  late _BarcodeFindViewController _controller;

  @override
  String get id => 'barcode-find-view-$_viewId';

  @override
  void initState() {
    super.initState();
    widget._viewId = _viewId;

    _controller = _BarcodeFindViewController(widget);

    widget._controller = _controller;
    widget._barcodeFind._controller = _controller;
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
        CameraOwnershipHelper.requestOwnership(CameraPosition.worldFacing, this);
      } else {
        CameraOwnershipHelper.releaseOwnership(CameraPosition.worldFacing, this);
      }
    }
  }

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
    _controller.dispose();
    super.dispose();
  }
}
