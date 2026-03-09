/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';

class BarcodeIdentifier implements Serializable {
  final String _identifier;

  BarcodeIdentifier._(this._identifier);

  BarcodeIdentifier() : this._(generateIdentifier());

  factory BarcodeIdentifier.fromJSON(String identifier) {
    return BarcodeIdentifier._(identifier);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'identifier': _identifier};
  }
}
