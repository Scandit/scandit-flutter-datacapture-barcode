/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

/// An enumeration of the presets available to simplify configuring symbologies.
///
/// Added in version 8.3.0
enum CapturePreset {
  /// Automatically enables and optimizes symbologies most used in the Transport vertical. This includes [Symbology.code128], [Symbology.qr], [Symbology.code39], [Symbology.dataMatrix], [Symbology.ean13Upca], [Symbology.interleavedTwoOfFive], [Symbology.aztec], [Symbology.ean8], [Symbology.pdf417], [Symbology.upce].
  ///
  /// Added in version 8.3.0
  transport('transport'),
  /// Automatically enables and optimizes symbologies most used in the Logistics vertical. This includes [Symbology.code128], [Symbology.qr], [Symbology.code39], [Symbology.dataMatrix], [Symbology.ean13Upca], [Symbology.interleavedTwoOfFive], [Symbology.codabar], [Symbology.ean8], [Symbology.pdf417], [Symbology.upce].
  ///
  /// Added in version 8.3.0
  logistics('logistics'),
  /// Automatically enables and optimizes symbologies most used in the Retail vertical. This includes [Symbology.ean13Upca], [Symbology.code128], [Symbology.qr], [Symbology.code39], [Symbology.ean8], [Symbology.dataMatrix], [Symbology.interleavedTwoOfFive], [Symbology.upce], [Symbology.gs1Databar], [Symbology.gs1DatabarExpanded].
  ///
  /// Added in version 8.3.0
  retail('retail'),
  /// Automatically enables and optimizes symbologies most used in the Healthcare vertical. This includes [Symbology.code128], [Symbology.dataMatrix], [Symbology.qr], [Symbology.ean13Upca], [Symbology.code39], [Symbology.microPdf417], [Symbology.interleavedTwoOfFive], [Symbology.msiPlessey], [Symbology.ean8].
  ///
  /// Added in version 8.3.0
  healthcare('healthcare'),
  /// Automatically enables and optimizes symbologies most used in the Manufacturing vertical. This includes [Symbology.code128], [Symbology.dataMatrix], [Symbology.code39], [Symbology.qr], [Symbology.ean13Upca], [Symbology.interleavedTwoOfFive], [Symbology.pdf417], [Symbology.upce], [Symbology.ean8].
  ///
  /// Added in version 8.3.0
  manufacturing('manufacturing');

  const CapturePreset(this._name);

  @override
  String toString() => _name;

  final String _name;

  static CapturePreset fromJSON(String jsonValue) {
    return CapturePreset.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
