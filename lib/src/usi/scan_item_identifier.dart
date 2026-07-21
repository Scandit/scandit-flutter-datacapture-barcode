/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';

class ScanItemIdentifier implements Serializable {
  final String _identifier;

  ScanItemIdentifier._(this._identifier);

  ScanItemIdentifier() : this._(generateIdentifier());

  factory ScanItemIdentifier.fromJSON(String definitionId) {
    return ScanItemIdentifier._(definitionId);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'identifier': _identifier};
  }
}
