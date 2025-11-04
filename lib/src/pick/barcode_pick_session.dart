/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/tracked_object.dart';

class BarcodePickSession {
  final Set<String> _trackedItems;
  final Set<String> _addedItems;
  final Set<TrackedObject> _trackedObjects;
  final Set<TrackedObject> _addedObjects;

  BarcodePickSession._(this._trackedItems, this._addedItems, this._trackedObjects, this._addedObjects);

  Set<String> get trackedItems {
    return _trackedItems;
  }

  Set<String> get addedItems {
    return _addedItems;
  }

  Set<TrackedObject> get trackedObjects {
    return _trackedObjects;
  }

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
