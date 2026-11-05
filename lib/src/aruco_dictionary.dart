/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'aruco_dictionary_preset.dart';
import 'aruco_marker.dart';

/// Added in version 6.22.0
class ArucoDictionary implements Serializable {
  final ArucoDictionaryPreset? _preset;
  final int? _markerSize;
  final List<ArucoMarker>? _markers;

  ArucoDictionary._(this._preset, this._markerSize, this._markers);

  factory ArucoDictionary.fromPreset(ArucoDictionaryPreset preset) {
    return ArucoDictionary._(preset, null, null);
  }

  /// Constructs an [ArucoDictionary] using custom data.
  ///
  /// - *markerSize* is the length of the side of the barcode. For a 5 by 5 marker it will be 5.
  ///
  /// Added in version 6.22.0
  factory ArucoDictionary.createWithMarkers(int markerSize, List<ArucoMarker> markers) {
    return ArucoDictionary._(null, markerSize, markers);
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{};
    if (_preset != null) {
      json['preset'] = _preset.toString();
    }

    if (_markerSize != null && _markers != null) {
      json['markerSize'] = _markerSize;
      json['markers'] = _markers.map((e) => e.toMap()).toList();
    }

    return json;
  }
}
