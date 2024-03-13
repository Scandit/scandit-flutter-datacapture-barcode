/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

class BarcodePickProduct {
  final String _identifier;
  final int _quantityToPick;

  const BarcodePickProduct(this._identifier, this._quantityToPick);

  String get identifier {
    return _identifier;
  }

  int get quantityToPick {
    return _quantityToPick;
  }
}
