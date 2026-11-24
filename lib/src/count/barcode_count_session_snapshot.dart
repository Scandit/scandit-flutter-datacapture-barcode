/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/cluster.dart';

/// An immutable copy of a `BarcodeCountSession` taken at the moment the user
/// tapped the list or exit button.
///
/// Unlike `BarcodeCountSession` this snapshot carries no controller and
/// cannot be reset or queried for a spatial map - it is a plain data
/// container.
///
/// Immutable copy of a [BarcodeCountSession] captured at a specific point in time. Provided to button-tap delegate callbacks on [BarcodeCountViewUiListener] so the host app can inspect the session state on the main thread without violating the requirement that [BarcodeCountSession] only be accessed inside didScan().
///
/// The snapshot mirrors the public read-only state of the session at construction time. The SDK does not mutate the snapshot afterwards; subsequent scans do not affect any previously delivered snapshot.
///
/// Added in version 8.7.0
class BarcodeCountSessionSnapshot {
  final List<Barcode> _recognizedBarcodes;

  /// A list of the barcodes that were recognized when the snapshot was taken. This mirrors [BarcodeCountSession.recognizedBarcodes] semantics — both currently tracked and cleared barcodes are included.
  ///
  /// Added in version 8.7.0
  List<Barcode> get recognizedBarcodes => _recognizedBarcodes;

  final List<Barcode> _additionalBarcodes;

  /// The additional barcodes injected with [BarcodeCount.setAdditionalBarcodes] at the time of the snapshot.
  ///
  /// Added in version 8.7.0
  List<Barcode> get additionalBarcodes => _additionalBarcodes;

  final List<Cluster> _recognizedClusters;

  /// A list containing the clusters that were recognized when the snapshot was taken.
  ///
  /// Added in version 8.7.0
  List<Cluster> get recognizedClusters => _recognizedClusters;

  final int _frameSequenceId;

  /// The identifier of the frame sequence at the time of the snapshot.
  ///
  /// Added in version 8.7.0
  int get frameSequenceId => _frameSequenceId;

  BarcodeCountSessionSnapshot._(
    this._recognizedBarcodes,
    this._additionalBarcodes,
    this._recognizedClusters,
    this._frameSequenceId,
  );

  /// Creates a [BarcodeCountSessionSnapshot] from a decoded native session JSON object.
  ///
  /// Every key is optional: a payload carrying no keys at all is a valid empty
  /// snapshot, which is what native emits before any frame has been processed.
  factory BarcodeCountSessionSnapshot.fromJSON(Map<String, dynamic> json) {
    final frameSequenceId = (json['frameSequenceId'] as num?)?.toInt() ?? 0;
    final recognizedBarcodesJson = (json['recognizedBarcodes'] ?? []) as List<dynamic>;
    final recognizedClustersJson = (json['recognizedClusters'] ?? []) as List<dynamic>;
    final hasClusters = recognizedClustersJson.isNotEmpty;

    final List<Barcode> recognizedBarcodes;
    final List<Cluster> recognizedClusters;

    if (hasClusters) {
      final Map<String, Barcode> barcodeMap = {};
      recognizedBarcodes = [];
      for (final barcodeJson in recognizedBarcodesJson) {
        final barcode = Barcode.fromJSON(barcodeJson as Map<String, dynamic>);
        final identifier = barcodeJson['identifier'];
        if (identifier != null) {
          barcodeMap[identifier as String] = barcode;
        }
        recognizedBarcodes.add(barcode);
      }
      recognizedClusters = recognizedClustersJson.cast<Map<String, dynamic>>().map((e) {
        e['_barcodeMap'] = barcodeMap;
        return Cluster.fromJSON(e);
      }).toList();
    } else {
      recognizedBarcodes = recognizedBarcodesJson.map((e) => Barcode.fromJSON(e as Map<String, dynamic>)).toList();
      recognizedClusters = [];
    }

    final additionalBarcodes = ((json['additionalBarcodes'] ?? []) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((e) => Barcode.fromJSON(e))
        .toList();

    return BarcodeCountSessionSnapshot._(recognizedBarcodes, additionalBarcodes, recognizedClusters, frameSequenceId);
  }
}
