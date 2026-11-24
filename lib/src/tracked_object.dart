/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

/// A barcode or a cluster tracked over the course of multiple frames.
///
/// Added in version 7.3.0
class TrackedObject {
  final Quadrilateral _location;
  final int _identifier;
  final String? _data;

  TrackedObject._(this._location, this._identifier, this._data);

  /// The location of the code. The coordinates are in image-space, meaning that the coordinates correspond to actual pixels in the image. For display, the coordinates need first to be converted into screen-space using the data capture view.
  ///
  /// The meaning of the values of [Quadrilateral.topLeft] is such that the top left point corresponds to the top left corner of the barcode, independent of how the code is oriented in the image. Same for the other corners.
  ///
  /// Added in version 7.3.0
  Quadrilateral get location => _location;
  /// The unique identifier for the tracked object. The identifier is unique for each object. The same identifier may be reused once the object is lost for another object.
  ///
  /// Added in version 7.3.0
  int get identifier => _identifier;
  /// The data associated with this object.
  ///
  /// Added in version 7.3.0
  String? get data => _data;

  factory TrackedObject.fromJSON(Map<String, dynamic> json) {
    return TrackedObject._(
      Quadrilateral.fromJSON(json['location']),
      int.parse(json['identifier']),
      json['data'],
    );
  }
}
