/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum CompositeType { a, b, c }

extension CompositeTypeSerializer on CompositeType {
  static CompositeType fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'A':
        return CompositeType.a;
      case 'B':
        return CompositeType.b;
      case 'C':
        return CompositeType.c;
      default:
        throw Exception("Missing CompositeType for name '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case CompositeType.a:
        return 'A';
      case CompositeType.b:
        return 'B';
      case CompositeType.c:
        return 'C';
      default:
        throw Exception("Missing name for enum '$this'");
    }
  }
}
