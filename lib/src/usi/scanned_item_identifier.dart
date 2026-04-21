/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';

class ScannedItemIdentifier implements Serializable {
  final String _identifier;

  ScannedItemIdentifier._(this._identifier);

  ScannedItemIdentifier() : this._(generateIdentifier());

  factory ScannedItemIdentifier.fromJSON(String identifier) {
    return ScannedItemIdentifier._(identifier);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'identifier': _identifier};
  }
}
