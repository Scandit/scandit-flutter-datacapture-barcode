/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'symbology.dart';

class BarcodeInfo implements Serializable {
  late Symbology _symbology;
  Symbology get symbology => _symbology;

  late String _data;
  String get data => _data;

  late Quadrilateral _location;
  Quadrilateral get location => _location;

  BarcodeInfo._({required Symbology symbology, required String data, required Quadrilateral location}) {
    _symbology = symbology;
    _data = data;
    _location = location;
  }

  factory BarcodeInfo.create(Symbology symbology, String data, [Quadrilateral? location]) {
    return BarcodeInfo._(
        symbology: symbology,
        data: data,
        location:
            location ?? Quadrilateral(const Point(0, 0), const Point(0, 0), const Point(0, 0), const Point(0, 0)));
  }

  factory BarcodeInfo.fromJSON(Map<String, dynamic> json) {
    var symbology = SymbologySerializer.fromJSON(json['symbology'] as String);
    var data = json['data'] as String;
    var location = Quadrilateral.fromJSON(json['location']);
    return BarcodeInfo._(symbology: symbology, data: data, location: location);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'symbology': symbology.toString(), 'data': data, 'location': location.toMap()};
  }
}
