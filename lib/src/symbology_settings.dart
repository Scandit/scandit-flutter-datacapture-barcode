/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'symbology.dart';

/// An enumeration of possible checksum algorithms. The enumeration only lists optional checksum algorithms; mandatory checksums that can’t be changed are not listed here. Use the values below to set optional checksums ([SymbologySettings.checksums]) for a symbology. The exact implementation chosen depends on the symbology *and* checksum algorithm. Only a subset of algorithms is supported for each symbology. Check the symbology documentation to see which checksums are supported.
///
/// Added in version 6.7.0
enum Checksum {
  /// Checksum is calculated using modulo of 10.
  ///
  /// Added in version 6.7.0
  mod10('mod10'),
  /// Checksum is calculated using modulo of 11.
  ///
  /// Added in version 6.7.0
  mod11('mod11'),
  /// Checksum is calculated using modulo of 16.
  ///
  /// Added in version 6.7.0
  mod16('mod16'),
  /// Checksum is calculated using modulo of 43.
  ///
  /// Added in version 6.7.0
  mod43('mod43'),
  /// Checksum is calculated using modulo of 47.
  ///
  /// Added in version 6.7.0
  mod47('mod47'),
  /// Checksum is calculated using modulo of 103.
  ///
  /// Added in version 6.7.0
  mod103('mod103'),
  /// Checksum is calculated using two checksums, one using modulo of 10 and one using modulo of 11.
  ///
  /// Added in version 6.7.0
  mod10AndMod11('mod1110'),
  /// Checksum is calculated using two different modulo of 10 checksums.
  ///
  /// Added in version 6.7.0
  mod10AndMod10('mod1010');

  const Checksum(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension ChecksumDeserializer on Checksum {
  static Checksum fromJSON(String jsonValue) {
    return Checksum.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

/// Settings specific to a particular barcode symbology ([Symbology]).
///
/// Learn more on how to use symbology settings in our [Configure Barcode Symbologies](https://docs.scandit.com/sdks/flutter/barcode-capture/configure-barcode-symbologies) guide.
///
/// Added in version 6.7.0
class SymbologySettings implements Serializable {
  final Symbology _symbology;
  final Set<String> _extensions;
  /// By default decoding of all symbologies is disabled. To enable decoding of a symbology, set this property to *true*. It is advised to only enable symbologies that are required by the application as every enabled symbology adds processing overhead.
  ///
  /// This property only enables decoding of dark codes on bright background. If color-inverted (bright on dark) codes for this symbology are required, enable them by changing the [SymbologySettings.isColorInvertedEnabled] property.
  ///
  /// Added in version 6.7.0
  bool isEnabled;
  /// Determines whether decoding of color-inverted (bright on dark) codes for this symbology is enabled. By default, decoding of color inverted codes is disabled. Currently, the [SymbologySettings.isEnabled] property will also have to be set to *true* for bright on dark codes to be scanned, though this may change in a future release.
  ///
  /// Added in version 6.7.0
  bool isColorInvertedEnabled;
  /// Sets of optional checksums to be used for this symbology. The code is accepted if any of the checksums matches in addition to any mandatory checksum of the symbology.
  ///
  /// Added in version 6.7.0
  Set<Checksum> checksums;
  /// This property determines the active symbol counts of the symbology, e.g. the supported length of barcodes to be decoded. Change this property to include symbol counts that are not enabled by default, or to optimize decoding performance for a certain number of symbols.
  ///
  /// The mapping from characters to symbols is symbology-specific. For some symbologies, the start and end characters are included, others include checksums characters in the symbol counts.
  ///
  /// The active symbol count setting is ignored for fixed-size barcodes (the EAN and UPC family of codes) as well as 2d codes. For other symbologies, refer to [Symbology Properties](https://docs.scandit.com/symbology-properties).
  ///
  /// When changing the active symbol count, the provided active symbol count values are intersected with the supported active symbol count values of the symbology. Values that are not part of the supported symbol count range are ignored.
  ///
  /// Added in version 6.7.0
  Set<int> activeSymbolCounts;

  /// The set of enabled extensions of this symbology. Extensions allow to configure features that are specific to a small number of symbologies. For example, there is an extension to configure how to treat the leading zero for UPC-A codes. For a list of supported extensions, refer to [Symbology Properties](https://docs.scandit.com/symbology-properties).
  ///
  /// Added in version 6.7.0
  Set<String> get enabledExtensions => _extensions;

  /// The symbology that this symbology settings affect.
  ///
  /// Added in version 6.7.0
  Symbology get symbology => _symbology;

  SymbologySettings._(this._symbology, this._extensions, this.checksums, this.activeSymbolCounts,
      {required this.isEnabled, required this.isColorInvertedEnabled});

  SymbologySettings.fromJSON(Symbology symbology, Map<String, dynamic> json)
      : this._(
            symbology,
            (json['extensions'] as List).toSet().cast<String>(),
            // ignore: unnecessary_lambdas
            (json['checksums'] as List).map((e) => ChecksumDeserializer.fromJSON(e)).toSet().cast<Checksum>(),
            (json['activeSymbolCounts'] as List).toSet().cast<int>(),
            isEnabled: json['enabled'] as bool,
            isColorInvertedEnabled: json['colorInvertedEnabled'] as bool);

  /// Activates/Deactivates a custom extension for the symbology.
  ///
  /// Added in version 6.7.0
  void setExtensionEnabled(String extension, {required bool enabled}) {
    var included = _extensions.contains(extension);
    if (enabled && included == false) {
      _extensions.add(extension);
    } else if (!enabled && included == true) {
      _extensions.remove(extension);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'extensions': _extensions.toList(),
      'enabled': isEnabled,
      'colorInvertedEnabled': isColorInvertedEnabled,
      'checksums': checksums.map((e) => e.toString()).toList(),
      'activeSymbolCounts': activeSymbolCounts.toList()
    };
  }
}
