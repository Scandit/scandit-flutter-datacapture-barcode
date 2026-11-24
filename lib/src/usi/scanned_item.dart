/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/usi/scanned_item_identifier.dart';

import 'barcode_identifier.dart';
import 'scan_item_identifier.dart';
import 'scanned_barcode.dart';
import 'scanned_component.dart';
import 'scanned_text.dart';
import 'text_identifier.dart';

/// A scanned item in the item-based scanning APIs that represents a collection of related scan components. A scanned item can contain multiple barcode and text components that are logically grouped together.
///
/// This class provides access to all the individual [ScannedComponent] objects that make up the item, as well as convenient methods to retrieve specific components by their identifiers.
///
/// Added in version 8.1.0
class ScannedItem {
  final ScanItemIdentifier? _definitionIdentifier;

  final ScannedItemIdentifier? _identifier;

  final List<ScannedComponent> _components;

  ScannedItem._(this._definitionIdentifier, this._identifier, this._components);

  /// The unique identifier corresponding to the [ScanItemDefinition] for this item. May be *null* if item is located but not defined.
  ///
  /// Added in version 8.1.0
  ScanItemIdentifier? get definitionIdentifier => _definitionIdentifier;

  /// The unique identifier for this scanned item. May be *null* if the item doesn’t have a specific identifier.
  ///
  /// Added in version 8.1.0
  ScannedItemIdentifier? get identifier => _identifier;

  /// An array of all scan components that make up this item. Components can be either [ScannedBarcode] or [ScannedText] objects.
  ///
  /// Added in version 8.1.0
  List<ScannedComponent> get components => _components;

  /// Retrieves a specific barcode component from this item by its identifier.
  ///
  /// Param BarcodeIdentifier identifierThe identifier associated with the barcode definition of the barcode component to retrieve.ReturnsThe [ScannedBarcode] with the given identifier, or *null* if no such barcode exists in this item.
  ///
  /// Added in version 8.1.0
  ScannedBarcode? barcodeForIdentifier(BarcodeIdentifier identifier) {
    try {
      final component = _components.firstWhere(
        (c) =>
            c.definitionIdentifier is BarcodeIdentifier &&
            c.definitionIdentifier.toMap()['identifier'] == identifier.toMap()['identifier'],
      );
      return component is ScannedBarcode ? component : null;
    } catch (e) {
      return null;
    }
  }

  /// Retrieves a specific text component from this item by its identifier.
  ///
  /// Param TextIdentifier identifierThe identifier associated with the text definition of the text component to retrieve.ReturnsThe [ScannedText] with the given identifier, or *null* if no such text exists in this item.
  ///
  /// Added in version 8.1.0
  ScannedText? textForIdentifier(TextIdentifier identifier) {
    try {
      final component = _components.firstWhere(
        (c) =>
            c.definitionIdentifier is TextIdentifier &&
            c.definitionIdentifier.toMap()['identifier'] == identifier.toMap()['identifier'],
      );
      return component is ScannedText ? component : null;
    } catch (e) {
      return null;
    }
  }

  factory ScannedItem.fromJSON(Map<String, dynamic> json) {
    // The identifier of the scanned item
    final identifier = json['identifier'] != null ? ScannedItemIdentifier.fromJSON(json['identifier'] as String) : null;
    // The identifier of the scan item definition, the one used when setting up the scan item definition
    final definitionIdentifier =
        json['definitionId'] != null ? ScanItemIdentifier.fromJSON(json['definitionId'] as String) : null;
    final components = (json['components'] as List).map<ScannedComponent>((componentJson) {
      if (componentJson['type'] == 'barcode') {
        return ScannedBarcode.fromJSON(componentJson);
      } else if (componentJson['type'] == 'text') {
        return ScannedText.fromJSON(componentJson);
      } else {
        throw ArgumentError('Invalid component type: ${componentJson['type']}');
      }
    }).toList();
    return ScannedItem._(definitionIdentifier, identifier, components);
  }
}
