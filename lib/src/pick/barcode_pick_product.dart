/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

/// Represents a product to be picked.
///
/// Added in version 6.22.0
class BarcodePickProduct {
  final String _identifier;
  final int _quantityToPick;

  /// Constructs a [BarcodePickProduct].
  ///
  /// - *identifier* The unique identifier for this product.
  /// - *quantityToPick* How many of this product need to be picked.
  ///
  /// Added in version 6.22.0
  const BarcodePickProduct(this._identifier, this._quantityToPick);

  /// The unique identifier for this product.
  ///
  /// Added in version 6.22.0
  String get identifier {
    return _identifier;
  }

  /// How many of this product need to be picked.
  ///
  /// Added in version 6.22.0
  int get quantityToPick {
    return _quantityToPick;
  }
}
