/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';

class TextIdentifier implements Serializable {
  final String _identifier;

  TextIdentifier._(this._identifier);

  TextIdentifier() : this._(generateIdentifier());

  factory TextIdentifier.fromJSON(String definitionId) {
    return TextIdentifier._(definitionId);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'identifier': _identifier};
  }
}
