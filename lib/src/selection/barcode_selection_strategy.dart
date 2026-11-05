/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

/// The interface for all barcode selection strategies. These strategies are used to configure [BarcodeSelectionAimerSelection].
///
/// Added in version 6.10.0
abstract class BarcodeSelectionStrategy implements Serializable {
  final String _type;

  BarcodeSelectionStrategy._(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

/// Barcodes are selected automatically when aiming at them as soon as the intention is understood by our internal algorithms.
///
/// Added in version 6.10.0
class BarcodeSelectionAutoSelectionStrategy extends BarcodeSelectionStrategy {
  /// Creates a new [BarcodeSelectionAutoSelectionStrategy] instance.
  ///
  /// Added in version 6.10.0
  BarcodeSelectionAutoSelectionStrategy() : super._('autoSelectionStrategy');
}

/// Barcodes are selected when aiming at them and tapping anywhere on the screen.
///
/// Added in version 6.10.0
class BarcodeSelectionManualSelectionStrategy extends BarcodeSelectionStrategy {
  /// Creates a new [BarcodeSelectionManualSelectionStrategy] instance.
  ///
  /// Added in version 6.10.0
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
