/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_state.dart';

/// This class encapsulates a style request for an highlight. It provides the item data, the product identifier if already mapped and the state.
///
/// Added in version 7.3.0
class BarcodePickViewHighlightStyleRequest {
  final String _itemData;
  final String? _productIdentifier;
  final BarcodePickState _state;

  BarcodePickViewHighlightStyleRequest._(this._itemData, this._productIdentifier, this._state);

  Map<String, dynamic> toMap() {
    return {'itemData': itemData, 'productIdentifier': productIdentifier, 'state': state.toString()};
  }

  /// The barcode data.
  ///
  /// Added in version 7.3.0
  String get itemData => _itemData;

  /// The item data that was provided during the mapping, if available.
  ///
  /// Added in version 7.3.0
  String? get productIdentifier => _productIdentifier;

  /// The state of the the scanned item.
  ///
  /// Added in version 7.3.0
  BarcodePickState get state => _state;

  factory BarcodePickViewHighlightStyleRequest.fromJSON(Map<String, dynamic> json) {
    return BarcodePickViewHighlightStyleRequest._(
      json['itemData'] as String,
      json['productIdentifier'] as String?,
      BarcodePickStateDeserializer.fromJSON(json['state'] as String),
    );
  }
}
