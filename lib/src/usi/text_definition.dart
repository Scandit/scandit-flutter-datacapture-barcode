/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'scan_component_definition.dart';
import 'scan_component_text_semantic_type.dart';
import 'text_identifier.dart';

class TextDefinition implements ScanComponentDefinition<TextIdentifier>, Serializable {
  final TextIdentifier _identifier;
  int _mandatoryInstances = 1;

  @override
  Quadrilateral? location;

  bool _optional = false;

  @override
  set optional(bool value) {
    _optional = value;
    _mandatoryInstances = value ? 0 : 1;
  }

  @override
  bool get optional => _optional;

  ScanComponentTextSemanticType? semantics;
  String? _hiddenProperties;
  List<String> valueRegexes = [];
  List<String> anchorRegexes = [];

  TextDefinition(this._identifier);

  static TextDefinitionBuilder builder(TextIdentifier identifier) {
    return TextDefinitionBuilder(identifier);
  }

  @override
  TextIdentifier get identifier => _identifier;

  String get hiddenProperties => _hiddenProperties ?? '';

  set hiddenProperties(String value) {
    _hiddenProperties = value;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'text',
      'identifier': _identifier.toMap()['identifier'],
      if (location != null) 'location': location!.toMap(),
      'optional': optional,
      'mandatoryInstances': _mandatoryInstances,
      if (semantics != null) 'semanticType': semantics.toString(),
      if (hiddenProperties.isNotEmpty) 'hiddenProperties': hiddenProperties,
      'valueRegexes': valueRegexes,
      'anchorRegexes': anchorRegexes,
    };
  }
}

class TextDefinitionBuilder {
  final TextDefinition _textDefinition;

  TextDefinitionBuilder(TextIdentifier identifier) : _textDefinition = TextDefinition(identifier);

  TextDefinitionBuilder setOptional(bool optional) {
    _textDefinition.optional = optional;
    return this;
  }

  TextDefinitionBuilder setSemantics(ScanComponentTextSemanticType semantics) {
    _textDefinition.semantics = semantics;
    return this;
  }

  TextDefinitionBuilder setLocation(Quadrilateral? location) {
    _textDefinition.location = location;
    return this;
  }

  TextDefinitionBuilder setHiddenProperties(String hiddenProperties) {
    _textDefinition.hiddenProperties = hiddenProperties;
    return this;
  }

  TextDefinitionBuilder setValueRegexes(List<String> valueRegexes) {
    _textDefinition.valueRegexes = valueRegexes;
    return this;
  }

  TextDefinitionBuilder setAnchorRegexes(List<String> anchorRegexes) {
    _textDefinition.anchorRegexes = anchorRegexes;
    return this;
  }

  TextDefinition build() {
    return _textDefinition;
  }
}
