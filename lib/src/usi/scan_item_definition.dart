/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'scan_component_definition.dart';
import 'scan_item_identifier.dart';
import 'scanned_item.dart';

/// A definition for a target scan item in the item-based scanning APIs that represents a collection of related scan components. A scan item definition can contain multiple barcode and text components that are logically grouped together.
///
/// Added in version 8.1.0
class ScanItemDefinition implements Serializable {
  final ScanItemIdentifier _identifier;
  final List<ScanComponentDefinition> _components;

  void Function(ScannedItem)? onScan;

  /// A constructor that requires a list of [ScannedComponent] objects that make up the item. It uses default identifier.
  ///
  /// Added in version 8.3.0
  ScanItemDefinition(this._identifier, this._components);

  ScanItemDefinition.fromComponents(this._components) : _identifier = ScanItemIdentifier();

  /// The unique identifier for this scanned item.
  ///
  /// Added in version 8.1.0
  ScanItemIdentifier get identifier => _identifier;

  /// An array of all scan components that make up this item. Components can be either [ScannedBarcode] or [ScannedText] objects.
  ///
  /// Added in version 8.1.0
  List<ScanComponentDefinition> get components => _components;

  @override
  Map<String, dynamic> toMap() {
    return {
      'identifier': _identifier.toMap()['identifier'],
      'components': _components.whereType<Serializable>().map((c) => c.toMap()).toList(),
    };
  }
}
