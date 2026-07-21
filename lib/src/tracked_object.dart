/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class TrackedObject {
  final Quadrilateral _location;
  final int _identifier;
  final String? _data;

  TrackedObject._(this._location, this._identifier, this._data);

  Quadrilateral get location => _location;
  int get identifier => _identifier;
  String? get data => _data;

  factory TrackedObject.fromJSON(Map<String, dynamic> json) {
    return TrackedObject._(
      Quadrilateral.fromJSON(json['location']),
      int.parse(json['identifier']),
      json['data'],
    );
  }
}
