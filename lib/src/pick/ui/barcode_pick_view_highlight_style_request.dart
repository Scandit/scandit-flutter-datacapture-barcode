/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_state.dart';

class BarcodePickViewHighlightStyleRequest {
  final String _itemData;
  final String? _productIdentifier;
  final BarcodePickState _state;

  BarcodePickViewHighlightStyleRequest._(this._itemData, this._productIdentifier, this._state);

  Map<String, dynamic> toMap() {
    return {'itemData': itemData, 'productIdentifier': productIdentifier, 'state': state.toString()};
  }

  String get itemData => _itemData;

  String? get productIdentifier => _productIdentifier;

  BarcodePickState get state => _state;

  factory BarcodePickViewHighlightStyleRequest.fromJSON(Map<String, dynamic> json) {
    return BarcodePickViewHighlightStyleRequest._(
      json['itemData'] as String,
      json['productIdentifier'] as String?,
      BarcodePickStateDeserializer.fromJSON(json['state'] as String),
    );
  }
}
