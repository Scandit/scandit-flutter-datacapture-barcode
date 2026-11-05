/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/tracked_object.dart';

/// The BarcodePick session holds the current state of a running [BarcodePick].
///
/// Added in version 7.3.0
class BarcodePickSession {
  final Set<String> _trackedItems;
  final Set<String> _addedItems;
  final Set<TrackedObject> _trackedObjects;
  final Set<TrackedObject> _addedObjects;

  BarcodePickSession._(this._trackedItems, this._addedItems, this._trackedObjects, this._addedObjects);

  /// A set containing the data of all the barcodes that are currently tracked on screen.
  ///
  /// Added in version 7.3.0
  Set<String> get trackedItems {
    return _trackedItems;
  }

  /// A set containing the data of the barcodes that were scanned in the last frame.
  ///
  /// Added in version 7.3.0
  Set<String> get addedItems {
    return _addedItems;
  }

  /// A set containing all of the objects that are currently tracked on screen.
  ///
  /// Added in version 7.3.0
  Set<TrackedObject> get trackedObjects {
    return _trackedObjects;
  }

  /// A set containing all of the objects that were scanned in the last frame.
  ///
  /// Added in version 7.3.0
  Set<TrackedObject> get addedObjects {
    return _addedObjects;
  }

  factory BarcodePickSession.fromJSON(Map<String, dynamic> json) {
    return BarcodePickSession._(
      (json['trackedItems'] as List<dynamic>).whereType<String>().toSet(),
      (json['addedItems'] as List<dynamic>).whereType<String>().toSet(),
      (json['trackedObjects'] as List<dynamic>)
          .map((obj) => TrackedObject.fromJSON(obj as Map<String, dynamic>))
          .toSet(),
      (json['addedObjects'] as List<dynamic>).map((obj) => TrackedObject.fromJSON(obj as Map<String, dynamic>)).toSet(),
    );
  }
}
