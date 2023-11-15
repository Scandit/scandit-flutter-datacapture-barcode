/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum CompositeType {
  a('A'),
  b('B'),
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
