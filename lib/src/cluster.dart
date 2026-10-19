/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode.dart';

class Cluster extends Serializable {
  final String _identifier;
  final List<Barcode> _barcodes;

  Cluster._(this._identifier, this._barcodes);

  List<Barcode> get barcodes => _barcodes;

  /// Creates a Cluster from JSON.
  ///
  /// Supports two JSON formats:
  /// 1. From BarcodeCountSession: `{"barcodeIdentifiers": ["0", "2"], "identifier": "0", "_barcodeMap": {...}}`
  ///    - Uses `_barcodeMap` to resolve identifiers to actual barcodes
  /// 2. From didTapCluster event: `{"barcodes": [<full barcode json>, ...]}`
  ///    - Contains full barcode data directly
  factory Cluster.fromJSON(Map<String, dynamic> json) {
    final clusterId = (json['identifier'] ?? '') as String;

    // Format 1: Full barcode data from didTapCluster event
    if (json.containsKey('barcodes')) {
      final barcodesData = json['barcodes'] as List<dynamic>;
      final barcodes = barcodesData.map((item) => Barcode.fromJSON(item as Map<String, dynamic>)).toList();
      return Cluster._(clusterId, barcodes);
    }

    // Format 2: Barcode identifiers from session - uses _barcodeMap
    final barcodeMap = json['_barcodeMap'] as Map<String, Barcode>?;
    if (json.containsKey('barcodeIdentifiers') && barcodeMap != null) {
      final barcodeIdentifiers = (json['barcodeIdentifiers'] as List<dynamic>).cast<String>();
      final barcodes =
          barcodeIdentifiers.where((id) => barcodeMap.containsKey(id)).map((id) => barcodeMap[id]!).toList();
      return Cluster._(clusterId, barcodes);
    }

    // Fallback: empty cluster
    return Cluster._(clusterId, []);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'identifier': _identifier,
      'barcodes': _barcodes.map((e) => e.toMap()).toList(),
    };
  }
}
