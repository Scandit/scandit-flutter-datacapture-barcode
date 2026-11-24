/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'scan_component_definition.dart';
import 'scan_component_text_semantic_type.dart';
import 'text_identifier.dart';

/// A class that holds the definition for a text expected to be scanned as part of a certain [ScanItemDefinition].
///
/// Added in version 8.1.0
class TextDefinition implements ScanComponentDefinition<TextIdentifier>, Serializable {
  final TextIdentifier _identifier;
  int _mandatoryInstances = 1;

  /// The expected location of the text.
  ///
  /// Added in version 8.1.0
  @override
  Quadrilateral? location;

  bool _optional = false;

  /// Whether the text is optional.
  ///
  /// Added in version 8.1.0
  @override
  set optional(bool value) {
    _optional = value;
    _mandatoryInstances = value ? 0 : 1;
  }

  /// Whether the text is optional.
  ///
  /// Added in version 8.1.0
  @override
  bool get optional => _optional;

  /// A semantic type to be applied to the text definition.
  ///
  /// Added in version 8.1.0
  ScanComponentTextSemanticType? semantics;
  String? _hiddenProperties;
  /// A list of value regex to use when searching for the text.
  ///
  /// Added in version 8.1.0
  List<String> valueRegexes = [];
  /// A list of anchor regexes to use when searching for the text.
  ///
  /// Added in version 8.1.0
  List<String> anchorRegexes = [];

  /// A constructor that receives the identifier for the text definition.
  ///
  /// Added in version 8.1.0
  TextDefinition(this._identifier);

  /// Creates a builder object that can be used to fluently create a TextDefinition instance.
  ///
  /// Added in version 8.1.0
  static TextDefinitionBuilder builder(TextIdentifier identifier) {
    return TextDefinitionBuilder(identifier);
  }

  /// The unique identifier for this component.
  ///
  /// Added in version 8.1.0
  @override
  TextIdentifier get identifier => _identifier;

  /// A list of hidden properties to set on the text definition.
  ///
  /// Added in version 8.1.0
  String get hiddenProperties => _hiddenProperties ?? '';

  /// A list of hidden properties to set on the text definition.
  ///
  /// Added in version 8.1.0
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

/// A fluent builder class for creating [TextDefinition] objects with a convenient, chainable interface. This builder provides methods to add various field types and configure their properties in a structured manner.
///
/// Added in version 8.1.0
class TextDefinitionBuilder {
  final TextDefinition _textDefinition;

  /// Creates a new builder for the given identifier.
  ///
  /// Added in version 8.1.0
  TextDefinitionBuilder(TextIdentifier identifier) : _textDefinition = TextDefinition(identifier);

  /// Sets whether the text component is optional in the item definition. Returns the builder for configuring the rest of the properties.
  ///
  /// Added in version 8.1.0
  TextDefinitionBuilder setOptional(bool optional) {
    _textDefinition.optional = optional;
    return this;
  }

  /// Sets a predefined semantics type for the text. Returns the builder for configuring the rest of the properties.
  ///
  /// Added in version 8.1.0
  TextDefinitionBuilder setSemantics(ScanComponentTextSemanticType semantics) {
    _textDefinition.semantics = semantics;
    return this;
  }

  /// Sets an expected location for the text. Returns the builder for configuring the rest of the properties.
  ///
  /// Added in version 8.1.0
  TextDefinitionBuilder setLocation(Quadrilateral? location) {
    _textDefinition.location = location;
    return this;
  }

  /// Sets the hidden properties for the component. Returns the builder for configuring the rest of the properties.
  ///
  /// Added in version 8.1.0
  TextDefinitionBuilder setHiddenProperties(String hiddenProperties) {
    _textDefinition.hiddenProperties = hiddenProperties;
    return this;
  }

  /// Sets the value regexes for the text. Returns the builder for configuring the rest of the properties.
  ///
  /// Added in version 8.1.0
  TextDefinitionBuilder setValueRegexes(List<String> valueRegexes) {
    _textDefinition.valueRegexes = valueRegexes;
    return this;
  }

  /// Sets the anchor regexes for the text. Returns the builder for configuring the rest of the properties.
  ///
  /// Added in version 8.1.0
  TextDefinitionBuilder setAnchorRegexes(List<String> anchorRegexes) {
    _textDefinition.anchorRegexes = anchorRegexes;
    return this;
  }

  /// Builds the [TextDefinition] object.
  ///
  /// Added in version 8.1.0
  TextDefinition build() {
    return _textDefinition;
  }
}
