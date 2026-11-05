/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:typed_data';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart' show buildArucoMarker;

/// Added in version 6.22.0
class ArucoMarker implements Serializable {
  final int _markerSize;

  final Uint8List _markerData;

  ArucoMarker._(this._markerSize, this._markerData);

  /// Constructs an ArUco marker definition. Used to create a custom [ArucoDictionary].
  ///
  /// - *markerSize* is the length of the side of the barcode. For a 5 by 5 marker it will be 5.
  /// - *markerData* is the data used to build the marker. It needs to contain only the values 0 or 1 as 8-bit values. The order is row major. For a 5 by 5 marker it needs to contain 25 bytes.
  ///
  /// ```dart
  /// Uint8List data = Uint8List.fromList([1, 1, 0, .... 1, 1]); // Contains 25 values
  /// ArucoMarker marker = ArucoMarker.create(5, data);
  /// ```
  ///
  /// Added in version 6.22.0
  factory ArucoMarker.create(int markerSize, Uint8List markerData) {
    return ArucoMarker._(markerSize, markerData);
  }

  /// The size of the ArucoMarker.
  ///
  /// Added in version 6.22.0
  int get size {
    return _markerSize;
  }

  /// The data of the ArucoMarker.
  ///
  /// Added in version 6.22.0
  Uint8List get data {
    return _markerData;
  }

  @override
  Map<String, dynamic> toMap() {
    return buildArucoMarker(
      markerSize: size,
      markerData: base64Encode(data),
    );
  }
}
