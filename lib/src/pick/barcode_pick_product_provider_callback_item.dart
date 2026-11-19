/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodePickProductProviderCallbackItem implements Serializable {
  final String _itemData;
  final String? _productIdentifier;

  const BarcodePickProductProviderCallbackItem(this._itemData, this._productIdentifier);

  String get itemData {
    return _itemData;
  }

  String? get productIdentifier {
    return _productIdentifier;
  }

  @override
  Map<String, dynamic> toMap() {
    return {'itemData': itemData, 'productIdentifier': productIdentifier};
  }
}
