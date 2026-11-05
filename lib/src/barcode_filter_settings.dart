/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../scandit_flutter_datacapture_barcode.dart';

/// These settings are used to select barcodes that will be filtered out in the view. Any barcode that matches any of the provided settings will be covered by a colored layer.
///
/// Added in version 6.17.0
class BarcodeFilterSettings implements Serializable {
  /// When set to *true*, EAN 13 barcodes will be excluded.
  ///
  /// Added in version 6.17.0
  bool excludeEan13 = false;

  /// When set to *true*, UPC-A barcodes will be excluded.
  ///
  /// Added in version 6.17.0
  bool excludeUpca = false;

  /// A regular expression to be matched against `ByteData`.
  ///
  /// Added in version 6.17.0
  String excludedCodesRegex = '';

  /// A map of excluded symbol counts, indexed by [Symbology]. Each [Symbology] will have assigned a set of all the character counts for the barcode’s `ByteData` that will be matched.
  ///
  /// Added in version 6.17.0
  Map<Symbology, Set<int>> excludedSymbolCounts = {};

  /// A set of [Symbology] to exclude. If an excluded [Symbology] is not part of the set of active symbologies in the mode, this setting will have no effect on that Symbology.
  ///
  /// Added in version 6.17.0
  Set<Symbology> excludedSymbologies = {};

  /// Added in version 8.3.0
  BarcodeFilterSettings()
      : excludeEan13 = false,
        excludeUpca = false,
        excludedCodesRegex = '',
        excludedSymbolCounts = {},
        excludedSymbologies = {};

  BarcodeFilterSettings._(this.excludeEan13, this.excludeUpca, this.excludedCodesRegex, this.excludedSymbolCounts,
      this.excludedSymbologies);

  factory BarcodeFilterSettings.fromJSON(Map<String, dynamic> json) {
    var excludeEan13 = json['excludeEan13'] as bool;
    var excludeUpca = json['excludeUpca'] as bool;
    var excludedCodesRegex = json['excludedCodesRegex'] as String;
    var excludedSymbolCounts = (json['excludedSymbolCounts'] as Map<String, dynamic>).map((key, value) =>
        MapEntry<Symbology, Set<int>>(SymbologySerializer.fromJSON(key), List<int>.from(value).toSet()));
    var excludedSymbologies =
        (json['excludedSymbologies'] as List<dynamic>).map((e) => SymbologySerializer.fromJSON(e.toString())).toSet();

    return BarcodeFilterSettings._(
        excludeEan13, excludeUpca, excludedCodesRegex, excludedSymbolCounts, excludedSymbologies);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "excludeEan13": excludeEan13,
      "excludeUpca": excludeUpca,
      "excludedCodesRegex": excludedCodesRegex,
      "excludedSymbolCounts": excludedSymbolCounts,
      "excludedSymbologies": excludedSymbologies.map((e) => e.toString()).toList()
    };
  }
}
