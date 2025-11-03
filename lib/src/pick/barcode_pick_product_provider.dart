/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode_plugin_events.dart';
import 'barcode_pick_function_names.dart';
import 'barcode_pick_product.dart';
import 'barcode_pick_product_provider_callback_item.dart';

abstract class BarcodePickProductProvider with PrivateBarcodePickProductProvider implements Serializable {}

mixin PrivateBarcodePickProductProvider {
  late _BarcodePickAsyncMapperProductProviderController _controller;

  void subscribeEvents() {
    _controller.subsribeForEvents();
  }

  void unsubscribeEvents() {
    _controller.unsubscribeFromEvents();
  }
}

abstract class BarcodePickAsyncMapperProductProviderCallback {
  static const String _onProductIdentifierForItems =
      "BarcodePickAsyncMapperProductProviderCallback.onProductIdentifierForItems";

  void productIdentifierForItems(List<String> itemsData, BarcodePickProductProviderCallback callback);
}

class BarcodePickAsyncMapperProductProvider
    with PrivateBarcodePickProductProvider
    implements BarcodePickProductProvider {
  final Map<String, int> _productsToPick = {};

  BarcodePickAsyncMapperProductProviderCallback _callback;

  BarcodePickAsyncMapperProductProvider._(Set<BarcodePickProduct> productsToPick, this._callback) {
    _controller = _BarcodePickAsyncMapperProductProviderController(this);
    for (var product in productsToPick) {
      _productsToPick[product.identifier] = product.quantityToPick;
    }
  }

  BarcodePickAsyncMapperProductProvider(
      Set<BarcodePickProduct> productsToPick, BarcodePickAsyncMapperProductProviderCallback callback)
      : this._(productsToPick, callback);

  @override
  Map<String, dynamic> toMap() {
    return {
      "products": _productsToPick,
    };
  }
}

class _BarcodePickAsyncMapperProductProviderController {
  final BarcodePickAsyncMapperProductProvider _provider;
  StreamSubscription<dynamic>? _providerEventsSubscription;
  final MethodChannel _methodChannel = MethodChannel(BarcodePickFunctionNames.methodsChannelName);

  _BarcodePickAsyncMapperProductProviderController(this._provider);

  void subsribeForEvents() {
    _providerEventsSubscription = BarcodePluginEvents.barcodePickEventStream.listen((event) {
      var eventJSON = jsonDecode(event) as Map<String, dynamic>;
      var eventName = eventJSON['event'] as String;

      if (eventName == BarcodePickAsyncMapperProductProviderCallback._onProductIdentifierForItems) {
        _provider._callback.productIdentifierForItems(
            (eventJSON['itemsData'] as List<dynamic>).map((e) => e.toString()).toList(),
            BarcodePickProductProviderCallback._(this));
      }
    });
  }

  void finishOnProductIdentifierForItems(List<BarcodePickProductProviderCallbackItem> data) {
    var result = data.map((e) => e.toMap()).toList();
    _methodChannel.invokeMethod(BarcodePickFunctionNames.finishOnProductIdentifierForItems, jsonEncode(result));
  }

  void unsubscribeFromEvents() {
    _providerEventsSubscription?.cancel();
    _providerEventsSubscription = null;
  }
}

class BarcodePickProductProviderCallback {
  final _BarcodePickAsyncMapperProductProviderController _controller;

  BarcodePickProductProviderCallback._(this._controller);
  void onData(List<BarcodePickProductProviderCallbackItem> data) {
    _controller.finishOnProductIdentifierForItems(data);
  }
}
