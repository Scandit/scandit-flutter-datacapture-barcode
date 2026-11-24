/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

/// An enumeration of composite code presets.
///
/// Added in version 6.7.0
enum CompositeType {
  /// Composite Code A
  ///
  /// Added in version 6.7.0
  a('A'),
  /// Composite Code B
  ///
  /// Added in version 6.7.0
  b('B'),
  /// Composite Code C
  ///
  /// Added in version 6.7.0
  c('C');

  const CompositeType(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension CompositeTypeSerializer on CompositeType {
  static CompositeType fromJSON(String jsonValue) {
    return CompositeType.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
