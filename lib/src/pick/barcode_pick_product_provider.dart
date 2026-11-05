/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show BarcodePickAsyncMapperProductProviderCallbackOnProductIdentifierForItems;
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/logging/logging_method_channel.dart';

import '../barcode_plugin_events.dart';
import 'barcode_pick_product.dart';
import 'barcode_pick_product_provider_callback_item.dart';

/// Base interface to which each product provider needs to conform to.
///
/// This interface might change in the future and should only be used through Scandit-provided implementations: [[BarcodePickAsyncMapperProductProvider]].
///
/// Added in version 6.22.0
abstract class BarcodePickProductProvider with PrivateBarcodePickProductProvider implements Serializable {}

mixin PrivateBarcodePickProductProvider {
  late _BarcodePickAsyncMapperProductProviderController _controller;

  void subscribeEvents() {
    _controller.subsribeForEvents();
  }

  void unsubscribeEvents() {
    _controller.unsubscribeFromEvents();
  }

  void setViewId(int viewId) {
    _controller._viewId = viewId;
  }
}

/// A callback to be provided to a [BarcodePickAsyncMapperProductProvider] object. This callback allows to retrieve asynchronously product identifiers for the given itemsData ( i.e. the scanned codes ).
///
/// Added in version 6.22.0
abstract class BarcodePickAsyncMapperProductProviderCallback {
  static const String _onProductIdentifierForItems =
      "BarcodePickAsyncMapperProductProviderCallback.onProductIdentifierForItems";

  /// From this callback async operations can be fired to retrieve the product identifiers for the provided itemsData. Once retrieved, *callback.onData* should be invoked with a list of [BarcodePickProductProviderCallbackItem], consisting each of an itemData string and its product identifier. The product identifier can be null if not found.
  ///
  /// Added in version 6.22.0
  void productIdentifierForItems(List<String> itemsData, BarcodePickProductProviderCallback callback);
}

/// Usage example:
///
/// ```dart
/// var products = [
///   BarcodePickProduct("780846124122", 2),
///   BarcodePickProduct("750865926478", 1),
///   BarcodePickProduct("984579832123", 4),
/// ].toSet();
///
/// var productProvider = BarcodePickAsyncMapperProductProvider(products, this)
///
/// ...
///
/// @override
/// void productIdentifierForItems(List<String> itemsData, BarcodePickProductProviderCallback callback) {
///   myDb.findAndMapProductsForItemsData(items).then((value) => {
///     callback.onData(value);
///   });
/// }
/// ```
///
/// Use your preferred way to retrieve the initial list of products to pick and to handle the async retrieval of products from itemsData. In this snippet we’re using a hardcoded set of products and a fictitious myDb object for simplicity’s sake.
///
/// Added in version 6.22.0
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

  /// Creates a new instance with the given set of [BarcodePickProduct] and callback to map items to products asynchronously.
  ///
  /// Added in version 6.22.0
  BarcodePickAsyncMapperProductProvider(
      Set<BarcodePickProduct> productsToPick, BarcodePickAsyncMapperProductProviderCallback callback)
      : this._(productsToPick, callback);

  /// Replaces the products database to the newly provided list. This will reset scanning and all the previous picking progress will be lost.
  ///
  /// Added in version 8.5.0
  Future<void> updateProductList(Set<BarcodePickProduct> products) {
    _productsToPick
      ..clear()
      ..addEntries(products.map((p) => MapEntry(p.identifier, p.quantityToPick)));
    return _controller.updateProductList(_productsToPick);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "products": _productsToPick,
    };
  }
}

class _BarcodePickAsyncMapperProductProviderController {
  final BarcodePickAsyncMapperProductProvider _provider;
  late final BarcodeMethodHandler barcodeMethodHandler = _getMethodHandler();
  StreamSubscription<dynamic>? _providerEventsSubscription;
  int _viewId = 0;

  _BarcodePickAsyncMapperProductProviderController(this._provider);

  void subsribeForEvents() {
    _providerEventsSubscription = BarcodePluginEvents.barcodePickEventStream.asFlutterEvents().listen((event) {
      // Filter events by viewId
      final viewId = event.payload['viewId'] as int?;
      if (viewId != null && viewId != _viewId) return;

      if (event.isEvent(BarcodePickAsyncMapperProductProviderCallback._onProductIdentifierForItems)) {
        _provider._callback
            .productIdentifierForItems(_itemsDataTolerantly(event.payload), BarcodePickProductProviderCallback._(this));
      }
    });
  }

  // Validated tolerantly on purpose: this event is emitted through EventForResult with
  // INFINITE_TIMEOUT_MILLIS (`EventForResult.kt:43`, unbounded `future.get()` at :82-83), so a
  // throw here would block the native thread forever waiting for an ack rather than surface the
  // bad payload. Log it and fall back to the pre-migration read instead.
  List<String> _itemsDataTolerantly(Map<String, dynamic> payload) {
    try {
      return BarcodePickAsyncMapperProductProviderCallbackOnProductIdentifierForItems.fromJson(payload).itemsData;
    } catch (error) {
      dev.log('BarcodePick onProductIdentifierForItems payload failed schema validation: $error');
      return (payload['itemsData'] as List<dynamic>).map((e) => e.toString()).toList();
    }
  }

  Future<void> updateProductList(Map<String, int> productsToPick) {
    if (_viewId == 0) {
      // View not yet attached; the next view mount will pick up the products map via toMap().
      return Future.value();
    }
    return barcodeMethodHandler.updateProductList(viewId: _viewId, productsJson: jsonEncode(productsToPick));
  }

  void finishOnProductIdentifierForItems(List<BarcodePickProductProviderCallbackItem> data) {
    var result = data.map((e) => e.toMap()).toList();
    barcodeMethodHandler.finishOnProductIdentifierForItems(viewId: _viewId, itemsJson: jsonEncode(result));
  }

  void unsubscribeFromEvents() {
    _providerEventsSubscription?.cancel();
    _providerEventsSubscription = null;
  }

  BarcodeMethodHandler _getMethodHandler() {
    return BarcodeMethodHandler(const LoggingMethodChannel(BarcodeFunctionNames.methodsChannelName));
  }
}

/// Callback to notify that products for the given itemsData have been retrieved.
///
/// Added in version 6.22.0
class BarcodePickProductProviderCallback {
  final _BarcodePickAsyncMapperProductProviderController _controller;

  BarcodePickProductProviderCallback._(this._controller);
  /// The function to call in order to notify that products for the given scanned items have been retrieved. Each entry in the *data* list contains the scanned code and the (nullable) identifier of its corresponding product.
  ///
  /// Added in version 6.22.0
  void onData(List<BarcodePickProductProviderCallbackItem> data) {
    _controller.finishOnProductIdentifierForItems(data);
  }
}
