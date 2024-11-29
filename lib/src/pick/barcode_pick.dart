/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_function_names.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode_plugin_events.dart';
import 'barcode_pick_defaults.dart';
import 'barcode_pick_product_provider.dart';
import 'barcode_pick_scanning_session.dart';
import 'barcode_pick_settings.dart';

abstract class BarcodePickScanningListener {
  static const _didUpdateScanningSession = "BarcodePickScanningListener.didUpdateScanningSession";
  static const _didCompleteScanningSession = "BarcodePickScanningListener.didCompleteScanningSession";

  void didUpdateScanningSession(BarcodePick barcodePick, BarcodePickScanningSession session);
  void didCompleteScanningSession(BarcodePick barcodePick, BarcodePickScanningSession session);
}

class BarcodePick with PrivateBarcodePick implements Serializable {
  late _BarcodePickController _controller;
  final BarcodePickSettings _settings;
  // ignore: unused_field
  final DataCaptureContext _dataCaptureContext;

  BarcodePick._(this._dataCaptureContext, this._settings, BarcodePickProductProvider productProvider) {
    this.productProvider = productProvider;
    _controller = _BarcodePickController(this);
  }

  BarcodePick(
    DataCaptureContext dataCaptureContext,
    BarcodePickSettings settings,
    BarcodePickProductProvider productProvider,
  ) : this._(dataCaptureContext, settings, productProvider);

  final List<BarcodePickScanningListener> _listeners = [];

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
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void _checkAndSubscribeListeners() {
    if (_listeners.isEmpty) {
      _controller.subscribeListeners();
    }
  }

  void removeScanningListener(BarcodePickScanningListener listener) {
    _listeners.remove(listener);
    _checkAndUnsubscribeListeners();
  }

  void _checkAndUnsubscribeListeners() {
    if (_listeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'barcodePick',
      'settings': _settings.toMap(),
      'ProductProvider': productProvider.toMap(),
    };
  }
}

mixin PrivateBarcodePick {
  late BarcodePickProductProvider productProvider;
}

class _BarcodePickController {
  final BarcodePick barcodePick;

  final MethodChannel _methodChannel = const MethodChannel(BarcodePickFunctionNames.methodsChannelName);
  StreamSubscription<dynamic>? _subscription;

  _BarcodePickController(this.barcodePick);

  void subscribeListeners() {
    _methodChannel
        .invokeMethod(BarcodePickFunctionNames.addScanningListener)
        .then((value) => _setupBarcodePickSubscription(), onError: _onError);
  }

  void _setupBarcodePickSubscription() {
    _subscription = BarcodePluginEvents.barcodePickEventStream.listen((event) {
      if (barcodePick._listeners.isEmpty) return;

      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;

      if (eventName != BarcodePickScanningListener._didCompleteScanningSession &&
          eventName != BarcodePickScanningListener._didUpdateScanningSession) return;

      var session = BarcodePickScanningSession.fromJSON(jsonDecode(eventJSON['session']));

      if (eventName == BarcodePickScanningListener._didCompleteScanningSession) {
        for (var listener in barcodePick._listeners) {
          listener.didCompleteScanningSession(barcodePick, session);
        }
      } else if (eventName == BarcodePickScanningListener._didUpdateScanningSession) {
        for (var listener in barcodePick._listeners) {
          listener.didUpdateScanningSession(barcodePick, session);
        }
      }
    });
  }

  void unsubscribeListeners() {
    _subscription?.cancel();
    _methodChannel
        .invokeMethod(BarcodePickFunctionNames.removeScanningListener)
        .then((value) => null, onError: _onError);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }
}
