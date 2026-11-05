/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';

/// A unique identifier for scan item definitions in the item-based scanning APIs. This identifier is automatically generated as a UUID and is used to distinguish between different scan item definitions within the system.
///
/// Added in version 8.1.0
class ScanItemIdentifier implements Serializable {
  final String _identifier;

  ScanItemIdentifier._(this._identifier);

  /// Creates a new scan item identifier with an automatically generated UUID.
  ///
  /// Added in version 8.1.0
  ScanItemIdentifier() : this._(generateIdentifier());

  factory ScanItemIdentifier.fromJSON(String definitionId) {
    return ScanItemIdentifier._(definitionId);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'identifier': _identifier};
  }
}
