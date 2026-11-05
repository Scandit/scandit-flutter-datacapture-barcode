/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'scanned_component_identifier.dart';

/// A protocol that defines the common interface for scanned components in the item-based scanning APIs. Scanned components represent individual scan results such as barcodes or text that have been detected and localized in the camera frame.
///
/// Added in version 8.1.0
abstract class ScannedComponent<T> {
  /// The unique identifier identifying this instance of the component.
  ///
  /// Added in version 8.1.0
  ScannedComponentIdentifier get identifier;
  /// The identifier corresponding to this component’s definition. The type of the identifier depends on the specific component type (e.g., [BarcodeIdentifier] for barcode components, [TextIdentifier] for text components).
  ///
  /// Added in version 8.1.0
  T get definitionIdentifier;
  /// The location of the component. The quadrilateral represents the four corner points of the detected component’s bounding area.
  ///
  /// Added in version 8.1.0
  Quadrilateral get location;
}
