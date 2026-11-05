/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';

/// A unique identifier for scanned components in the item-based scanning APIs. This identifier is automatically generated as a UUID and is used to distinguish between different scanned components within the system.
///
/// Added in version 8.1.0
class ScannedComponentIdentifier implements Serializable {
  final String _identifier;

  ScannedComponentIdentifier._(this._identifier);

  /// Creates a new scanned component identifier with an automatically generated UUID.
  ///
  /// Added in version 8.1.0
  ScannedComponentIdentifier() : this._(generateIdentifier());

  factory ScannedComponentIdentifier.fromJSON(String definitionId) {
    return ScannedComponentIdentifier._(definitionId);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'identifier': _identifier};
  }
}
