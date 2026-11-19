/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import '../scandit_flutter_datacapture_barcode.dart';

class TrackedBarcode {
  final Barcode _barcode;
  Barcode get barcode => _barcode;

  // Not final: patched in place by updateLocationFromJSON when a repeat advanced-overlay event
  // carries only {identifier, location} for a TrackedBarcode whose full JSON has already been
  // emitted once, so the same TrackedBarcode instance a widget builder already holds can be
  // refreshed to the current-frame location.
  Quadrilateral _location;
  Quadrilateral get location => _location;

  final int _identifier;
  int get identifier => _identifier;

  int? sessionFrameSequenceId;

  TrackedBarcode._(this._barcode, this._location, this._identifier, this.sessionFrameSequenceId);

  factory TrackedBarcode.fromJSON(Map<String, dynamic> json, {int? sessionFrameSequenceId}) {
    var barcode = Barcode.fromJSON(json['barcode']);
    var location = Quadrilateral.fromJSON(json['location']);
    var identifier = int.parse(json['identifier'] as String);

    return TrackedBarcode._(barcode, location, identifier, sessionFrameSequenceId);
  }

  /// Patches this instance's location in place from a repeat advanced-overlay event payload.
  /// Keeps the same TrackedBarcode object identity that callers may already hold (e.g. a
  /// previously-built overlay widget), refreshed to the current-frame location.
  void updateLocationFromJSON(Map<String, dynamic> json) {
    _location = Quadrilateral.fromJSON(json);
  }
}
