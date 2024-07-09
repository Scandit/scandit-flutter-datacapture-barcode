/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_feedback.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_item.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_find_settings.dart';

abstract class BarcodeFindListener {
  static const String _onSearchStartedEvent = 'BarcodeFindListener.onSearchStarted';
  static const String _onSearchPausedEvent = 'BarcodeFindListener.onSearchPaused';
  static const String _onSearchStoppedEvent = 'BarcodeFindListener.onSearchStopped';

  void didStartSearch();
  void didPauseSearch(Set<BarcodeFindItem> foundItems);
  void didStopSearch(Set<BarcodeFindItem> foundItems);
}

class BarcodeFind extends DataCaptureMode with PrivateBarcodeFind {
  BarcodeFindFeedback _feedback = BarcodeFindFeedback.defaultFeedback;
  bool _enabled = true;
  BarcodeFindSettings _settings;
  final List<BarcodeFindListener> _listeners = [];

  late _BarcodeFindController _controller;

  BarcodeFind._(this._settings) {
    _controller = _BarcodeFindController.forBarcodeFind(this);
    // No need to add the mode to the context
  }

  BarcodeFind(BarcodeFindSettings settings) : this._(settings);

  static CameraSettings get recommendedCameraSettings => _recommendedCameraSettings();

  static CameraSettings _recommendedCameraSettings() {
    var defaults = BarcodeFindDefaults.cameraSettingsDefaults;
    return CameraSettings(defaults.preferredResolution, defaults.zoomFactor, defaults.focusRange,
        defaults.focusGestureStrategy, defaults.zoomGestureZoomFactor,
        shouldPreferSmoothAutoFocus: defaults.shouldPreferSmoothAutoFocus, properties: defaults.properties);
  }

  BarcodeFindFeedback get feedback => _feedback;

  set feedback(BarcodeFindFeedback newValue) {
    _feedback = newValue;
    _didChange();
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
      _controller.subscribeListeners();
    }
  }

  void removeListener(BarcodeFindListener listener) {
    _listeners.remove(listener);
    _checkAndUnsubscribeListeners();
  }

  void _checkAndUnsubscribeListeners() {
    if (_listeners.isEmpty && _listeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  Future<void> setItemList(Set<BarcodeFindItem> items) {
    itemsToFind = items;
    return _didChange();
  }

  Future<void> start() {
    return _controller.start();
  }

  Future<void> pause() {
    return _controller.pause();
  }

  Future<void> stop() {
    return _controller.stop();
  }

  Future<void> _didChange() {
    return _controller.updateMode();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'barcodeFind',
      'feedback': _feedback.toMap(),
      'settings': _settings.toMap(),
      'itemsToFind': jsonEncode(itemsToFind.map((e) => e.toMap()).toList()),
    };

    return json;
  }

  @override
  bool get isEnabled => _enabled;

  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    _controller.setModeEnabledState(newValue);
  }
}

mixin PrivateBarcodeFind {
  Set<BarcodeFindItem> itemsToFind = {};
}

class _BarcodeFindController {
  final BarcodeFind _barcodeFind;
  final MethodChannel _methodChannel = MethodChannel(BarcodeFindFunctionNames.methodsChannelName);
  StreamSubscription<dynamic>? _streamSubscription;

  _BarcodeFindController.forBarcodeFind(this._barcodeFind);

  Future<void> updateMode() {
    return _methodChannel
        .invokeMethod(BarcodeFindFunctionNames.updateFindMode, jsonEncode(_barcodeFind.toMap()))
        .then((value) => null, onError: _onError);
  }

  Future<void> start() {
    return _methodChannel
        .invokeMethod(BarcodeFindFunctionNames.barcodeFindModeStart)
        .then((value) => null, onError: _onError);
  }

  Future<void> pause() {
    return _methodChannel
        .invokeMethod(BarcodeFindFunctionNames.barcodeFindModePause)
        .then((value) => null, onError: _onError);
  }

  Future<void> stop() {
    return _methodChannel
        .invokeMethod(BarcodeFindFunctionNames.barcodeFindModeStop)
        .then((value) => null, onError: _onError);
  }

  void subscribeListeners() {
    _methodChannel
        .invokeMethod(BarcodeFindFunctionNames.registerBarcodeFindListener)
        .then((value) => _setupBarcodeCountSubscription())
        .onError(_onError);
  }

  void _setupBarcodeCountSubscription() {
    _streamSubscription = BarcodePluginEvents.barcodeFindEventStream.listen((event) {
      var eventJSON = jsonDecode(event) as Map<String, dynamic>;
      var eventName = eventJSON['event'] as String;
      if (eventName == BarcodeFindListener._onSearchStartedEvent) {
        for (var listener in _barcodeFind._listeners) {
          listener.didStartSearch();
        }
        return;
      }

      Set<BarcodeFindItem> foundItems = <BarcodeFindItem>{};

      if (eventJSON.containsKey('foundItems')) {
        var foundItemsData = List.from(eventJSON['foundItems']);
        foundItems = foundItemsData
            .map((e) => _barcodeFind.itemsToFind.firstWhere((element) => element.searchOptions.barcodeData == e))
            .toSet();
      }

      for (var listener in _barcodeFind._listeners) {
        if (eventName == BarcodeFindListener._onSearchPausedEvent) {
          listener.didPauseSearch(foundItems);
        } else if (eventName == BarcodeFindListener._onSearchStoppedEvent) {
          listener.didStopSearch(foundItems);
        }
      }
    });
  }

  void setModeEnabledState(bool newValue) {
    _methodChannel
        .invokeMethod(BarcodeFindFunctionNames.setModeEnabledState, newValue)
        .then((value) => null, onError: _onError);
  }

  void unsubscribeListeners() {
    _streamSubscription?.cancel();
    _methodChannel
        .invokeMethod(BarcodeFindFunctionNames.unregisterBarcodeFindListener)
        .then((value) => null, onError: _onError);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    print(error);

    if (stackTrace != null) {
      print(stackTrace);
    }

    throw error;
  }
}
