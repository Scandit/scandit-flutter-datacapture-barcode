/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'scan_component_definition.dart';
import 'scan_item_identifier.dart';
import 'scanned_item.dart';

class ScanItemDefinition implements Serializable {
  final ScanItemIdentifier _identifier;
  final List<ScanComponentDefinition> _components;

  void Function(ScannedItem)? onScan;

  ScanItemDefinition(this._identifier, this._components);

  ScanItemDefinition.fromComponents(this._components) : _identifier = ScanItemIdentifier();

  ScanItemIdentifier get identifier => _identifier;

  List<ScanComponentDefinition> get components => _components;

  @override
  Map<String, dynamic> toMap() {
    return {
      'identifier': _identifier.toMap()['identifier'],
      'components': _components.whereType<Serializable>().map((c) => c.toMap()).toList(),
    };
  }
}
