/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

abstract class BarcodeSelectionStrategy implements Serializable {
  final String _type;

  BarcodeSelectionStrategy._(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

class BarcodeSelectionAutoSelectionStrategy extends BarcodeSelectionStrategy {
  BarcodeSelectionAutoSelectionStrategy() : super._('autoSelectionStrategy');
}

class BarcodeSelectionManualSelectionStrategy extends BarcodeSelectionStrategy {
  BarcodeSelectionManualSelectionStrategy() : super._('manualSelectionStrategy');
}

extension BarcodeSelectionStrategyDeserializer on BarcodeSelectionStrategy {
  static BarcodeSelectionStrategy fromJSON(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'autoSelectionStrategy':
        return BarcodeSelectionAutoSelectionStrategy();
      case 'manualSelectionStrategy':
      default:
        return BarcodeSelectionManualSelectionStrategy();
    }
  }
}
