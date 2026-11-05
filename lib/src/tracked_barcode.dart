/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import '../scandit_flutter_datacapture_barcode.dart';

/// A barcode tracked over the course of multiple frames.
///
/// The state of a [TrackedBarcode] can be observed using a [BarcodeBatchListener].
///
/// The BarcodeBatchListener.didUpdateSession() callback will be invoked every time a new frame is processed and at least one of the following events took place:
///
/// 1. A track is established.
/// 2. A track location has changed.
/// 3. A track is lost and can no longer be tracked.
///
/// Added in version 6.7.0
class TrackedBarcode {
  final Barcode _barcode;
  /// The barcode associated to this track.
  ///
  /// Added in version 6.7.0
  Barcode get barcode => _barcode;

  // Not final: patched in place by updateLocationFromJSON when a repeat advanced-overlay event
  // carries only {identifier, location} for a TrackedBarcode whose full JSON has already been
  // emitted once, so the same TrackedBarcode instance a widget builder already holds can be
  // refreshed to the current-frame location.
  Quadrilateral _location;
  /// The location of the code. The coordinates are in image-space, meaning that the coordinates correspond to actual pixels in the image. For display, the coordinates need first to be converted into screen-space using the data capture view. See the Coordinate Conversion Guide for details and examples.
  ///
  /// The meaning of the values of [Quadrilateral.topLeft] is such that the top left point corresponds to the top left corner of the barcode, independent of how the code is oriented in the image. Same for the other corners.
  ///
  /// Using this property requires the MatrixScan AR add-on. In case the feature is not licensed, a quadrilateral with all corners set to 0, 0 is returned.
  ///
  /// Added in version 6.7.0
  Quadrilateral get location => _location;

  final int _identifier;
  /// The unique identifier for the tracked barcode. The identifier is unique for each barcode. The same identifier may be reused once the barcode is lost for another barcode.
  ///
  /// Added in version 6.7.0
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
