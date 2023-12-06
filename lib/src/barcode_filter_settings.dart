/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../scandit_flutter_datacapture_barcode.dart';

class BarcodeFilterSettings implements Serializable {
  bool excludeEan13 = false;

  bool excludeUpca = false;

  String excludedCodesRegex = '';

  Map<Symbology, Set<int>> excludedSymbolCounts = {};

  Set<Symbology> excludedSymbologies = {};

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
      "excludedSymbologies": excludedSymbologies.map((e) => e.jsonValue).toList()
    };
  }
}
