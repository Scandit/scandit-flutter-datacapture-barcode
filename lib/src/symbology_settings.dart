/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'symbology.dart';

enum Checksum {
  mod10,
  mod11,
  mod16,
  mod43,
  mod47,
  mod103,
  mod10AndMod11,
  mod10AndMod10,
}

extension ChecksumDeserializer on Checksum {
  static Checksum fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'mod10':
        return Checksum.mod10;
      case 'mod11':
        return Checksum.mod11;
      case 'mod16':
        return Checksum.mod16;
      case 'mod43':
        return Checksum.mod43;
      case 'mod47':
        return Checksum.mod47;
      case 'mod103':
        return Checksum.mod103;
      case 'mod1110':
        return Checksum.mod10AndMod11;
      case 'mod1010':
        return Checksum.mod10AndMod10;
      default:
        throw Exception("Missing Checksum for name '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case Checksum.mod10:
        return 'mod10';
      case Checksum.mod11:
        return 'mod11';
      case Checksum.mod16:
        return 'mod16';
      case Checksum.mod43:
        return 'mod43';
      case Checksum.mod47:
        return 'mod47';
      case Checksum.mod103:
        return 'mod103';
      case Checksum.mod10AndMod11:
        return 'mod1110';
      case Checksum.mod10AndMod10:
        return 'mod1010';
      default:
        throw Exception("Missing name for checksum '$this'");
    }
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
      'checksums': checksums.map((e) => e.jsonValue).toList(),
      'activeSymbolCounts': activeSymbolCounts.toList()
    };
  }
}
