/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'scanned_component_identifier.dart';

abstract class ScannedComponent<T> {
  ScannedComponentIdentifier get identifier;
  T get definitionIdentifier;
  Quadrilateral get location;
}
