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

class ScannedItem {
  final ScanItemIdentifier? _definitionIdentifier;

  final ScannedItemIdentifier? _identifier;

  final List<ScannedComponent> _components;

  ScannedItem._(this._definitionIdentifier, this._identifier, this._components);

  ScanItemIdentifier? get definitionIdentifier => _definitionIdentifier;

  ScannedItemIdentifier? get identifier => _identifier;

  List<ScannedComponent> get components => _components;

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
