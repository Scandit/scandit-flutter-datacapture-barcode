/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:typed_data';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'symbology.dart';

class StructuredAppendData implements Serializable {
  final bool _isComplete;
  bool get isComplete => _isComplete;

  final String _barcodeSetId;
  String get barcodeSetId => _barcodeSetId;

  final int _scannedSegmentCount;
  int get scannedSegmentCount => _scannedSegmentCount;

  final int _totalSegmentCount;
  int get totalSegmentCount => _totalSegmentCount;

  final List<EncodingRange> _encodingRanges;
  List<EncodingRange> get encodingRanges => _encodingRanges;

  final String? _completeData;
  String? get completeData => _completeData;

  final Uint8List _rawCompleteData;
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
