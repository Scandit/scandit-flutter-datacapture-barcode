/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

/// A container class consisting of an *itemData* (i.e. the data of a scanned code) and a *productIdentifier* (i.e. the string identifier of the product of which *itemData* consists of)
///
/// Added in version 6.22.0
class BarcodePickProductProviderCallbackItem implements Serializable {
  final String _itemData;
  final String? _productIdentifier;

  /// Constructs a new instance containing the provided itemData and nullable productIdentifier.
  ///
  /// Added in version 6.22.0
  const BarcodePickProductProviderCallbackItem(this._itemData, this._productIdentifier);

  /// Returns the itemData provided on construction.
  ///
  /// Added in version 6.22.0
  String get itemData {
    return _itemData;
  }

  /// Returns the productIdentifier provided on construction. May be *null*.
  ///
  /// Added in version 6.22.0
  String? get productIdentifier {
    return _productIdentifier;
  }

  @override
  Map<String, dynamic> toMap() {
    return {'itemData': itemData, 'productIdentifier': productIdentifier};
  }
}
