/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

/// interface implemented by the different kinds of components that can be used to define a [ScanItemDefinition].
///
/// Added in version 8.1.0
abstract class ScanComponentDefinition<T> {
  /// The unique identifier for this scanned item. May be either [BarcodeIdentifier] or [TextIdentifier]
  ///
  /// Added in version 8.1.0
  T get identifier;
  /// The expected location of the code.
  ///
  /// Added in version 8.1.0
  Quadrilateral? location;
  /// Whether the code is optional in the [ScanItemDefinition].
  ///
  /// Added in version 8.1.0
  bool get optional;
  /// Whether the code is optional in the [ScanItemDefinition].
  ///
  /// Added in version 8.1.0
  set optional(bool value);
}
