/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'symbology.dart';

enum Checksum {
  mod10('mod10'),
  mod11('mod11'),
  mod16('mod16'),
  mod43('mod43'),
  mod47('mod47'),
  mod103('mod103'),
  mod10AndMod11('mod1110'),
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

class SymbologySettings implements Serializable {
  final Symbology _symbology;
  final Set<String> _extensions;
  bool isEnabled;
  bool isColorInvertedEnabled;
  Set<Checksum> checksums;
  Set<int> activeSymbolCounts;

  Set<String> get enabledExtensions => _extensions;

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
