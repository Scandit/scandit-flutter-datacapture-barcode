/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

abstract class ScanComponentDefinition<T> {
  T get identifier;
  Quadrilateral? location;
  bool get optional;
  set optional(bool value);
}
