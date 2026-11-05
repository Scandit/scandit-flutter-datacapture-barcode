/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:typed_data';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'symbology.dart';

/// Structured append data associated with a barcode. returns the structured append data associated with this barcode. In structured append mode data is encoded across multiple 1D or 2D barcodes where each barcode contains only one segment of the complete data. Once all segment-containing barcodes are scanned the complete data can be read out.
///
/// Only a few symbologies (pdf417, microPdf417, QR, DataMatrix, Aztec, DotCode, MaxiCode) can use this mode, and each has a different set of limitations, like included metadata or the maximum number of barcodes that can form a set.
///
/// Added in version 6.25.0
class StructuredAppendData implements Serializable {
  final bool _isComplete;
  /// Whether all the barcodes in this set have been scanned.
  ///
  /// Added in version 6.25.0
  bool get isComplete => _isComplete;

  final String _barcodeSetId;
  /// The id of the barcode set.
  ///
  /// Added in version 6.25.0
  String get barcodeSetId => _barcodeSetId;

  final int _scannedSegmentCount;
  /// How many barcodes in the set have been scanned.
  ///
  /// Added in version 6.25.0
  int get scannedSegmentCount => _scannedSegmentCount;

  final int _totalSegmentCount;
  /// How many barcodes belong to the set. Depending on the symbology this might not be available and reported as 0.
  ///
  /// Added in version 6.25.0
  int get totalSegmentCount => _totalSegmentCount;

  final List<EncodingRange> _encodingRanges;
  /// Array of encoding ranges. Each entry of the returned encoding array points into bytes of [StructuredAppendData.rawCompleteData] and indicates what encoding is used for these bytes. This information can then be used to convert the bytes to unicode, or other representations. For most codes, a single encoding range covers the whole data, but certain 2d symbologies, such as [Symbology.qr] allow to switch the encoding in the middle of the code.
  ///
  /// The returned encoding ranges are sorted from lowest to highest index. Each byte in [StructuredAppendData.rawCompleteData] is contained in exactly one range, e.g. there are no holes or overlapping ranges.
  ///
  /// The encoding ranges array is only available when all of the barcodes/segments belonging to the set have been scanned and empty otherwise.
  ///
  /// Added in version 6.25.0
  List<EncodingRange> get encodingRanges => _encodingRanges;

  final String? _completeData;
  /// String representation of the complete data. The complete data is only available when all of the barcodes/segments belonging to the set have been scanned.
  ///
  /// Added in version 6.25.0
  String? get completeData => _completeData;

  final Uint8List _rawCompleteData;
  /// The raw data contained in all of the scanned barcodes. The raw data is only available when all of the barcodes/segments belonging to the set have been scanned.
  ///
  /// Use this property instead of [StructuredAppendData.completeData] if you are relying on binary-encoded data that cannot be represented as unicode strings.
  ///
  /// Unlike [StructuredAppendData.completeData] which returns the data in Unicode representation, the [StructuredAppendData.rawCompleteData] returns the data with the encoding that was used in the barcode. See [StructuredAppendData.encodingRanges] for more information.
  ///
  /// Added in version 6.25.0
  Uint8List get rawCompleteData => _rawCompleteData;

  StructuredAppendData._(
    this._isComplete,
    this._barcodeSetId,
    this._scannedSegmentCount,
    this._totalSegmentCount,
    this._encodingRanges,
    this._completeData,
    this._rawCompleteData,
  );

  factory StructuredAppendData.fromJSON(Map<String, dynamic> json) {
    final completeDataEncodings = json['completeDataEncodings'] as List;
    var base64EncodedRawData = json['completeDataRaw'];
    var rawData = Uint8List(0);
    if (base64EncodedRawData != null) {
      rawData = base64Decode(base64EncodedRawData);
    }

    return StructuredAppendData._(
      json['complete'],
      json['barcodeSetId'],
      json['scannedSegmentCount'],
      json['totalSegmentCount'],
      completeDataEncodings.map((e) => EncodingRange.fromJSON(e as Map<String, dynamic>)).toList(),
      json['completeDataUtf8String'] as String?,
      rawData,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'complete': isComplete,
      'barcodeSetId': barcodeSetId,
      'scannedSegmentCount': scannedSegmentCount,
      'totalSegmentCount': totalSegmentCount,
      'completeDataEncodings': encodingRanges.map((e) => e.toMap()).toList(),
      'completeDataUtf8String': completeData,
      'completeDataRaw': rawCompleteData
    };
  }
}
