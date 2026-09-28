/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';

class ScannedComponentIdentifier implements Serializable {
  final String _identifier;

  ScannedComponentIdentifier._(this._identifier);

  ScannedComponentIdentifier() : this._(generateIdentifier());

  factory ScannedComponentIdentifier.fromJSON(String definitionId) {
    return ScannedComponentIdentifier._(definitionId);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'identifier': _identifier};
  }
}
