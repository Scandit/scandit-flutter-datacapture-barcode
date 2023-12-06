/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import '../../scandit_flutter_datacapture_barcode.dart';

class TrackedBarcode {
  final Barcode _barcode;
  Barcode get barcode => _barcode;

  final Quadrilateral _location;
  Quadrilateral get location => _location;

  final int _identifier;
  int get identifier => _identifier;

  int? sessionFrameSequenceId;

  bool _shouldAnimateFromPreviousToNextState = false;
  bool get shouldAnimateFromPreviousToNextState => _shouldAnimateFromPreviousToNextState;

  TrackedBarcode._(this._barcode, this._location, this._identifier, this.sessionFrameSequenceId,
      {required bool shouldAnimateFromPreviousToNextState}) {
    _shouldAnimateFromPreviousToNextState = shouldAnimateFromPreviousToNextState;
  }

  TrackedBarcode.fromJSON(Map<String, dynamic> json, {int? sessionFrameSequenceId})
      : this._(Barcode.fromJSON(json['barcode']), Quadrilateral.fromJSON(json['location']),
            int.parse(json['identifier'] as String), sessionFrameSequenceId,
            shouldAnimateFromPreviousToNextState: json['shouldAnimateFromPreviousToNextState'] as bool);
}
