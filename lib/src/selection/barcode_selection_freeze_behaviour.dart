/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

/// Enum used to specify how freezing of the frame preview should be handled. Freezing the preview helps the user select multiple codes which might be difficult to do on a live preview where the codes constantly move around a bit.
///
/// Added in version 6.10.0
enum BarcodeSelectionFreezeBehavior {
  /// The frame preview can only be frozen manually by double tapping anywhere on the screen.
  ///
  /// Added in version 6.10.0
  manual('manual'),
  /// The frame preview is automatically frozen when all barcodes in view are recognized. It can also be frozen manually by double tapping anywhere on the screen.
  ///
  /// This setting is still in beta and may not yet work reliably in all situations.
  ///
  /// Added in version 6.10.0
  manualAndAutomatic('manualAndAutomatic');

  const BarcodeSelectionFreezeBehavior(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeSelectionFreezeBehaviorSerializer on BarcodeSelectionFreezeBehavior {
  static BarcodeSelectionFreezeBehavior fromJSON(String jsonValue) {
    return BarcodeSelectionFreezeBehavior.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
