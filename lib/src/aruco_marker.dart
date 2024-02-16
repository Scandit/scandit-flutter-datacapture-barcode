/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:typed_data';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class ArucoMarker implements Serializable {
  final int _markerSize;

  final Uint8List _markerData;

  ArucoMarker._(this._markerSize, this._markerData);

  factory ArucoMarker.create(int markerSize, Uint8List markerData) {
    return ArucoMarker._(markerSize, markerData);
  }

  int get size {
    return _markerSize;
  }

  Uint8List get data {
    return _markerData;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'markerSize': size,
      'markerData': base64Encode(data),
    };
  }
}
